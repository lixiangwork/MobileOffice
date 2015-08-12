//
//  IMChatVC.h
//  MobileOffice
//
//  Created by 李祥 on 15/7/31.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseVC.h"

@class XMPPJID;
@class XMPPMessageArchiving_Contact_CoreDataObject;


@interface IMChatVC : BaseVC

+ (XMPPJID *)currentBuddyJid;
+ (void)setCurrentBuddyJid:(XMPPJID *)jid;

- (instancetype)initWithBuddyJID:(XMPPJID *)buddyJID buddyName:(NSString *)buddyName;

@end
