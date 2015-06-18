//
//  ContentItems.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentItems : NSObject

@property (nonatomic, strong) NSString* ContentID;
@property (nonatomic, strong) NSString* MimeType;
@property (nonatomic, strong) NSString* DocumentID;
@property (nonatomic, strong) NSString* CommentID;

@property (nonatomic, strong) NSString* LastChangedTime;
@property (nonatomic) BOOL IsLocalFile;

@property (nonatomic, strong) NSMutableDictionary* Properties;

@end
