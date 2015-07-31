//
//  TreeNodeThirdLevel.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-17.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "TreeNodeThirdLevel.h"

@implementation TreeNodeThirdLevel

- (id)initWithFtitle:(NSString *)fTitle andStitle:(NSString *)sTitle andTtitle:(NSString *)tTitle andUserName:(NSString *)uname andDescription:(NSString *)des andPhoneNum:(NSString *)phone
{
    if ([super init]) {
        self.firstLevelTitle = fTitle;
        self.secondLevelTitle = sTitle;
        self.thirdLevelTitle = tTitle;
        self.userName = uname;
        self.userDescription = des;
        self.phoneNum = phone;
    }
    return self;

}

@end
