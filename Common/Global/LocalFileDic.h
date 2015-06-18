//
//  LocalFileDic.h
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalFileDic : NSObject

+ (LocalFileDic *)sharedInstance;

- (void)initLocalFileGlobalDic;

- (NSDictionary *)getLocalFileGlobalDic;

- (void)setLocalFileGlobalDic:(NSDictionary *)localFileDic;


@end
