//
//  User.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


+ (User *)sharedUser;

- (void)initUserGlobalDic;

- (NSDictionary *)getUserGlobalDic;

- (void)setUserGlobalDic:(NSDictionary *)userDic;



@end
