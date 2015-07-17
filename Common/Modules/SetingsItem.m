//
//  SetingsItem.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsItem.h"

@implementation SetingsItem

- (id)initWithIconImg:(UIImage *)img andTitleName:(NSString *)titleName andIsSwitchOn:(BOOL)isSwitchOn {
    if ([super init]) {
        self.iconImg = img;
        self.titleName = titleName;
        self.isSwitchOn = isSwitchOn;
    }
    return self;

}

@end
