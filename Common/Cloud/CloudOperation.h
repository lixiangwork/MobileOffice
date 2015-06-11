//
//  CloudOperation.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppCore.h"
#import "PropertyItem.h"

@interface CloudOperation : NSObject

///登陆
+ (AFHTTPRequestOperation *)testUser:(NSString *)username andPassWord:(NSString *)password;

///获得某文档类的所有文档
+(AFHTTPRequestOperation *)getAllContentTypeInfo:(NSString *)contentType userName:(NSString *)uname password:(NSString *)password;

//导入文档
+(AFHTTPRequestOperation *) insertContent:(NSString*)uname password:(NSString*)password andPropertyList:(NSArray*)propertyList andFolder:(NSString*)Folder andContentType:(NSString*)contentType andSourceFileName:(NSString*)fileName andFileType:(NSString*) fileType andInputstream:(NSData*)inputStream;

@end