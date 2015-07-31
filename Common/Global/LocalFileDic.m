//
//  LocalFileDic.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "LocalFileDic.h"
#import "AppCore.h"

@implementation LocalFileDic

+ (LocalFileDic *)sharedInstance {
    static LocalFileDic *sharedLocalFile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocalFile = [[self alloc] init];
    });
    return sharedLocalFile;
}

- (void)initLocalFileGlobalDic {
    NSDictionary *userDic = [self getLocalFileGlobalDic];
    if (!userDic) {
        userDic = [[NSDictionary alloc] init];
        [self setLocalFileGlobalDic:userDic];
        
        NSLog(@"LocalFileDic ready");
    }

}

- (NSDictionary *)getLocalFileGlobalDic {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:LocalFileGlobalKey];
}

- (void)setLocalFileGlobalDic:(NSDictionary *)localFileDic {
    [[NSUserDefaults standardUserDefaults] setValue:localFileDic forKey:LocalFileGlobalKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


@end
