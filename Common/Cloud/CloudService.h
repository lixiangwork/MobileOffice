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

///sql
- (void)sqlSearch:(NSString *)contentType andCondition:(NSString *)condition withBlock:(void (^)(NSMutableArray *result, NSError *error))block;

- (void) SQLSearch2:(NSString*)contentType andCondition:(NSString*)condition andSize:(NSString *)size andOrderby:(NSString *)orderby andColumnlist:(NSString *)columnlist withBlock:(void (^)(NSMutableArray *result, NSError *error))block;

///获取文档附件
- (void)getDocumentInfo:(NSString *)documentID withBlock:(void (^)(NSMutableArray *result, NSError *error))block ;//andProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock ;


///更新评论
- (void) alterComment:(NSString*)ContentID andComment:(NSData*)comment andDocumentID:(NSString*)documentID andCommentID: (NSString*) commentID andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block;

///更新表里面的一个属性
-(void) alterContentProperty: (NSString*)ContentID andPropertyName:(NSString*)proName andPropertyType:(NSString*)proType andPropertyValue:(NSString*) proValue andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block;

//更新或导入文档，可以更新多个属性
- (void)alterContentProperties:(NSString*)ContentID andPropertyList:(NSArray *)propertyList andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block;

@end
