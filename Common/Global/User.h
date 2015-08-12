//
//  User.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject


+ (User *)sharedUser;

- (BOOL)isOpenIM;

- (BOOL)isOpenIMBeep;

- (void)initUserGlobalDic;

- (NSDictionary *)getUserGlobalDic;

- (void)setUserGlobalDic:(NSDictionary *)userDic;

#pragma mark - 用户头像本地化
//获取用户头像本地化路径
- (NSString *)getUserIcomImagePath;
//保存图片
- (BOOL)saveImage:(UIImage *)currentImage ;
//读取图片
- (UIImage *)getLocalPersonImageWithPalceholderImage:(UIImage *)img;

@end
