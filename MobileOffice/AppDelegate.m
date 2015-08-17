//
//  AppDelegate.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/15.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "AppCore.h"
#import "User.h"
#import <PgySDK/PgyManager.h>

#import <AFNetworkReachabilityManager.h>
#import "IMCache.h"
#import "IMDataBaseManager.h"
#include <sys/xattr.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark -
- (void)setNavAndTabBg{
    
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(0, 190, 156)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    //[[UITabBar appearance] setBarTintColor:RGBCOLOR(80, 99, 114)];
    [[UITabBar appearance] setSelectedImageTintColor:RGBCOLOR(0, 190, 156)];
    
}

- (void)configAppCapabilities
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark - getDataFromNet
- (void)getContentData{
    [[CloudService sharedInstance] getAllContentTypeInfo:@"MobileConstacts" withBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            if (results.count != 0) {
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:results];
                [data writeToFile:ContactsPath atomically:NO];
                
                
            }
        }
        else{
           // [UIFactory showAlert:@"网络错误"];
        }
    }];
}



#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = RGBCOLOR(236, 236, 236);
    
    _loginVC = [[LoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    ////////////
    [self setNavAndTabBg];
    
    [self configAppCapabilities];
    
    ///初始化UserGlobalDic
    [[User sharedUser] initUserGlobalDic];
    
    //初始化LocalFileDic
    [[LocalFileDic sharedInstance] initLocalFileGlobalDic];
    
    ///
    NSURL *dbURLPath = [NSURL URLWithString:ContactsPath];
    [self addSkipBackupAttributeToItemAtURL:dbURLPath];
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:ContactsPath];
    if (!data) {
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        data = [NSKeyedArchiver archivedDataWithRootObject:mutArray];
        BOOL flag = [data writeToFile:ContactsPath atomically:NO];
        if (flag) {
            NSLog(@"通讯录已经保存到本地");
        }
        
    }

    [self getContentData];
    
    ////////
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //蒲公英
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"308bfce12f32238b4987963947a1e57a"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[IMDataBaseManager sharedManager] saveContext];
}

@end
