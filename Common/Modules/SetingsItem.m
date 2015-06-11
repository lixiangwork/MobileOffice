//
//  SetingsItem.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsItem.h"

@implementation SetingsItem

- (id)initWithIconImgName:(NSString *)imgName andTitleName:(NSString *)titleName andIsSwitchOn:(BOOL)isSwitchOn
{
    if ([super init]) {
        self.iconImgName = imgName;
        self.titleName = titleName;
        self.isSwitchOn = isSwitchOn;
    }
    return self;

}

@end
