//
//  CloudService.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "CloudService.h"
#import "AppCore.h"

@implementation CloudService

+ (CloudService *)sharedInstance{
    static CloudService *sharedCloudService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCloudService = [[self alloc] init];
    });
    return sharedCloudService;
}

- (void)testUser:(NSString *)username andPassword:(NSString *)password withBlock:(void (^)(BOOL isSuccess, NSString *nickName, NSError *error))block{
    
    AFHTTPRequestOperation *opration = [CloudOperation testUser:username andPassWord:password];
    [opration start];
    
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        //NSLog(@"responseStr:%@",responseStr);
        
        if ([[XMLParser sharedInstance] parsedUserWithXMLString:responseStr]) {
            UserItems *item = [[XMLParser sharedInstance].parserResultArray objectAtIndex:0];
            if (block) {
                block(YES,item.userDescription, nil);
            }

        }
        else{
            if (block) {
                block(NO,nil,nil);
            }

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,nil,error);
        }
    }];
}

- (void)getAllContentTypeInfo:(NSString *)contentType withBlock:(void (^)(NSArray *results, NSError *error))block{
    
    AFHTTPRequestOperation *opration = [CloudOperation getAllContentTypeInfo:contentType userName:@"docadmin" password:@"passw0rd"];
    [opration start];
    
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        [[XMLParser sharedInstance] parsedContentWithXMLString:responseStr];
        
        if (block) {
            block([XMLParser sharedInstance].parserResultArray, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)insertContentWithPropertyList:(NSArray*)propertyList andContentType:(NSString*)contentType andSourceFileName:(NSString*)fileName andInputstream:(NSData*)inputStream withBlock:(void (^)(NSString *contentID, NSError *error))block {
    
    AFHTTPRequestOperation *opration = [CloudOperation insertContent:@"docadmin" password:@"passw0rd" andPropertyList:propertyList andFolder:@"FALSE" andContentType:contentType andSourceFileName:fileName andFileType:@"FILE" andInputstream:inputStream];
    [opration start];
    
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        NSString *theContentID = [[XMLParser sharedInstance] parsedInsertXMLString:responseStr];
        NSLog(@"contentID:%@",theContentID);
        
        if (block) {
            block(theContentID, nil);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end





