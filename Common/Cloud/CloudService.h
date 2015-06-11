//
//  CloudService.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudService : NSObject

+ (CloudService *)sharedInstance;

- (void)testUser:(NSString *)username andPassword:(NSString *)password withBlock:(void (^)(BOOL isSuccess, NSString *nickName, NSError *error))block;

//////获得某文档类的所有文档
- (void)getAllContentTypeInfo:(NSString *)contentType withBlock:(void (^)(NSArray *results, NSError *error))block;

///上传文档
- (void)insertContentWithPropertyList:(NSArray*)propertyList andContentType:(NSString*)contentType andSourceFileName:(NSString*)fileName andInputstream:(NSData*)inputStream withBlock:(void (^)(NSString *contentID, NSError *error))block;


@end
