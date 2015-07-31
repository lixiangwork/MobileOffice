//
//  SetingsItem.h
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetingsItem : NSObject

@property (strong, nonatomic) UIImage *iconImg;
@property (strong, nonatomic) NSString *titleName;
@property BOOL isSwitchOn;//(开关的状态，没有开关的单元随意设置)

- (id)initWithIconImg:(UIImage *)img andTitleName:(NSString *)titleName andIsSwitchOn:(BOOL)isSwitchOn;

@end
