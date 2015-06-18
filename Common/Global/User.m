//
//  User.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "User.h"
#import "AppCore.h"

@implementation User

+ (User *)sharedUser{
    
    static User *sharedMyUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyUser = [[self alloc] init];
    });
    return sharedMyUser;
}

- (void)initUserGlobalDic{
    
    NSDictionary *userDic = [self getUserGlobalDic];
    if (!userDic) {
        userDic = @{uUserName:@"", uPassword:@"", uNickName:@"", uRemenberPassword:@"1", uAotoLogin:@"0"};
        [self setUserGlobalDic:userDic];
        
        NSLog(@"userDic ready");
    }
}

- (NSDictionary *)getUserGlobalDic{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:UserGlobalKey];
}

- (void)setUserGlobalDic:(NSDictionary *)userDic{
    [[NSUserDefaults standardUserDefaults] setValue:userDic forKey:UserGlobalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
