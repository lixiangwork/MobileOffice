//
//  DocumentItem.h
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentItem : NSObject

@property (nonatomic, strong) NSString* DocumentID;
@property (nonatomic, strong) NSString* SourceFileName;
@property (nonatomic, strong) NSString* InputStream;

@end
