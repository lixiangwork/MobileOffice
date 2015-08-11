//
//  IMXMPPManager.m
//  IMModel
//
//  Created by jimneylee on 14-5-19.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "IMXMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPPMessage.h"
#import "XMPPMessage+XEP_0085.h"
#import "XMPPvCardTemp.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation IMXMPPManager

+ (instancetype)sharedManager
{
    static IMXMPPManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc ] init];
        // Setup the XMPP stream
        [_sharedManager setupStream];
    });
    
    return _sharedManager;
}

- (void)dealloc
{
	[self teardownStream];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [_xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [_xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_messageArchiving
{
    return [_xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	_xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		_xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	_xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	_xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    // 不用每次都重新创建数据库，否则会导致未读消息数丢失，good idea
	_xmppRosterStorage.autoRemovePreviousDatabaseFile = NO;
    _xmppRosterStorage.autoRecreateDatabaseFile = NO;
    
	_xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
	
	_xmppRoster.autoFetchRoster = YES;
	_xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	_xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	_xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
	
	_xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
	  
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	_xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Setup message archiving
    
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
	// Activate xmpp modules
    
	[_xmppReconnect         activate:_xmppStream];
	[_xmppRoster            activate:_xmppStream];
	[_xmppvCardTempModule   activate:_xmppStream];
	[_xmppvCardAvatarModule activate:_xmppStream];
	[_xmppCapabilities      activate:_xmppStream];
    [_xmppMessageArchiving  activate:_xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
    //	[xmppStream setHostName:@"talk.google.com"];
    //	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	_customCertEvaluation = YES;
}


- (void)teardownStream
{
	[_xmppStream removeDelegate:self];
	[_xmppRoster removeDelegate:self];
	[_xmppMessageArchiving removeDelegate:self];
    
	[_xmppReconnect         deactivate];
	[_xmppRoster            deactivate];
	[_xmppvCardTempModule   deactivate];
	[_xmppvCardAvatarModule deactivate];
	[_xmppCapabilities      deactivate];
	[_xmppMessageArchiving  deactivate];
    
	[_xmppStream disconnect];
	
	_xmppStream = nil;
	_xmppReconnect = nil;
    _xmppRoster = nil;
	_xmppRosterStorage = nil;
	_xmppvCardStorage = nil;
    _xmppvCardTempModule = nil;
	_xmppvCardAvatarModule = nil;
	_xmppCapabilities = nil;
	_xmppCapabilitiesStorage = nil;
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![_xmppStream isDisconnected]) {
		return YES;
	}
    
	NSError *error = nil;
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_USER_ID];
    
    //NSLog(@"userID:%@",userID);
    NSLog(@"hostName:%@",XMPP_HOST_NAME);
    
	if (userID == nil) {
		return NO;
	}
    
	//[_xmppStream setMyJID:[XMPPJID jidWithUser:userID domain:XMPP_DOMAIN resource:XMPP_RESOURCE]];
    [_xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@win-fvgme186idq",userID]]];
    [_xmppStream setHostName:XMPP_HOST_NAME];
    [_xmppStream setHostPort:5222];
    
    
	if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[_xmppStream disconnect];
}

- (void)connectThenLogin
{
    if ([_xmppStream isConnecting]) {
        return;
    }
	if ([_xmppStream isDisconnected]) {
        [self connect];
        _goToRegisterAfterConnected = NO;
	}
    else {
        [self doLogin];
    }
}

- (BOOL)doLogin
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_USER_ID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_PASSWORD];
    
    if (userID == nil || password == nil) {
        return NO;
    }
    
    NSError *error = nil;
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
        return NO;
	}
    
    return YES;
}

- (void)connectThenRegister
{
    if ([_xmppStream isDisconnected]) {
        [self connect];
        _goToRegisterAfterConnected = YES;
	}
    else {
        [self doRegister];
    }
}

- (BOOL)doRegister
{
	NSError *error = nil;
    
    if ([_xmppStream isConnected] && [_xmppStream supportsInBandRegistration])
    {
        NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:XMPP_USER_ID];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:XMPP_PASSWORD];
        
        if (userID == nil || password == nil) {
            return NO;
        }
        
        [_xmppStream setMyJID:[XMPPJID jidWithUser:userID domain:XMPP_DOMAIN resource:XMPP_RESOURCE]];
        if (![_xmppStream registerWithPassword:password error:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"can NOT regitster"
                                                                message:@"See console for error details."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            NSLog(@"Error connecting: %@", error);
            
            return NO;
        }
    }
    else {
        NSLog(@"!!!!([xmppStream isConnected] && [xmppStream supportsInBandRegistration])");
    }
    
	return YES;
}

- (void)sendChatMessage:(NSString *)plainMessage toJID:(XMPPJID *)jid
{
    if (plainMessage.length > 0 && jid.user.length > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:plainMessage];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:jid.full];
        
        [message addChild:body];
        
        XMPPMessage * xMessage = [XMPPMessage messageFromElement:message];
        [xMessage addActiveChatState];
        
        [[IMXMPPManager sharedManager].xmppStream sendElement:message];
    }
}

// TODO:设置nickname
- (void)updateNickName
{
    XMPPvCardTemp *myvCardTemp = [[self xmppvCardTempModule] myvCardTemp];
    if (myvCardTemp) {
        myvCardTemp.nickname = @"helloworld";
        [[self xmppvCardTempModule] updateMyvCardTemp:myvCardTemp];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	NSString *expectedCertName = [_xmppStream.myJID domain];
	if (expectedCertName)
	{
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
	
//	if (_customCertEvaluation)
//	{
//		[settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
//	}
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	// The delegate method should likely have code similar to this,
	// but will presumably perform some extra security code stuff.
	// For example, allowing a specific self-signed certificate that is known to the app.
	
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	_isXmppConnected = YES;
    
    if (_goToRegisterAfterConnected) {
        [self doRegister];
    }
    else {
        [self doLogin];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [self doLogin];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    self.myJID = self.xmppStream.myJID;
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody])
	{
#if 0
		XMPPUserCoreDataStorageObject *user = [_xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:_xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                                message:body
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
			[alertView show];
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
#endif
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!_isXmppConnected)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
    
//    [IMUIHelper showTextMessage:@"已断开链接"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
#if 0
	//<presence xmlns="jabber:client" id="XWyMu-52" to="aaa@192.168.0.84" type="subscribe" from="uuu@192.168.0.84"></presence>
	XMPPUserCoreDataStorageObject *user = [_xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:_xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
#endif
}

@end
