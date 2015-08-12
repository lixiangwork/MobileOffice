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

- (BOOL)isOpenIM {
    NSString *openIm = [[self getUserGlobalDic] objectForKey:uOpenIM];
    
    NSLog(@"openIM:%@",openIm);
    
    if ([openIm isEqualToString:@"1"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isOpenIMBeep {
    NSString *openImBeep = [[self getUserGlobalDic] objectForKey:uOpenIMBeep];
    
    if ([openImBeep isEqualToString:@"1"]) {
        return YES;
    }
    else {
        return NO;
    }

}

- (void)initUserGlobalDic{
    
    NSDictionary *userDic = [self getUserGlobalDic];
    if (!userDic) {
        userDic = @{uUserName:@"", uPassword:@"", uNickName:@"", uRemenberPassword:@"1", uAotoLogin:@"0",uOpenIM:@"1",uOpenIMBeep:@"1"};
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

#pragma mark - 用户头像本地化
//获取用户头像本地化路径
- (NSString *)getUserIcomImagePath {
    
    return [NSString stringWithFormat:@"%@/%@",DOCUMENT_FOLDER_DIR,UserIconImageName];
}
//保存图片
- (BOOL)saveImage:(UIImage *)currentImage {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.2);
    
    return [imageData writeToFile:[self getUserIcomImagePath] atomically:YES];
}
//读取图片
- (UIImage *)getLocalPersonImageWithPalceholderImage:(UIImage *)img{
    
    UIImage *image = [UIImage imageWithContentsOfFile:[self getUserIcomImagePath]];
    if (image) {
        return image;
    }
    
    return img;
}



@end
