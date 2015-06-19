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
            block(NO,nil,error);
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

////sql
- (void)sqlSearch:(NSString *)contentType andCondition:(NSString *)condition withBlock:(void (^)(NSMutableArray *result, NSError *error))block {
    AFHTTPRequestOperation *operation = [CloudOperation sqlSearch:contentType andCondition:condition];
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        [[XMLParser sharedInstance] parsedContentWithXMLString:responseStr];
        NSLog(@"result:%@",[XMLParser sharedInstance].parserResultArray);
        
        if (block) {
            block([XMLParser sharedInstance].parserResultArray, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}

- (void) SQLSearch2:(NSString*)contentType andCondition:(NSString*)condition andSize:(NSString *)size andOrderby:(NSString *)orderby andColumnlist:(NSString *)columnlist withBlock:(void (^)(NSMutableArray *result, NSError *error))block {
    
    AFHTTPRequestOperation *operation = [CloudOperation SQLSearch2:contentType andCondition:condition andSize:size andOrderby:orderby andColumnlist:columnlist];
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        [[XMLParser sharedInstance] parsedContentWithXMLString:responseStr];
        NSLog(@"result:%@",[XMLParser sharedInstance].parserResultArray);
        
        if (block) {
            block([XMLParser sharedInstance].parserResultArray, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}

- (void)getDocumentInfo:(NSString *)documentID withBlock:(void (^)(NSMutableArray *result, NSError *error))block {//andProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock {
    
    AFHTTPRequestOperation *operation = [CloudOperation getDocumentInfo:documentID];
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        //NSLog(@"responseStr:%@",responseStr);
        
        [[XMLParser sharedInstance] parsedDocumentXMLString:responseStr];
        
        if (block) {
            block([XMLParser sharedInstance].parserResultArray, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    
    //[operation setDownloadProgressBlock:progressBlock];
}

///更新评论
-(void) alterComment:(NSString*)ContentID andComment:(NSData*)comment andDocumentID:(NSString*)documentID andCommentID: (NSString*) commentID andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block {
    
    AFHTTPRequestOperation *operation = [CloudOperation alterComment:ContentID andComment:comment andDocumentID:documentID andCommentID:commentID andContentType:contentType];
    
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        BOOL isSuccess = [[XMLParser sharedInstance] ifReplaySuccessFromXMLString:responseStr];
        
        if (block) {
            block(isSuccess, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}

///更新表里面的一个属性
-(void) alterContentProperty: (NSString*)ContentID andPropertyName:(NSString*)proName andPropertyType:(NSString*)proType andPropertyValue:(NSString*) proValue andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block {
    
    AFHTTPRequestOperation *operation = [CloudOperation alterContentProperty:ContentID andPropertyName:proName andPropertyType:proType andPropertyValue:proValue andContentType:contentType];
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        BOOL isSuccess = [[XMLParser sharedInstance] ifReplaySuccessFromXMLString:responseStr];
        
        if (block) {
            block(isSuccess, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}

//更新或导入文档，可以更新多个属性
- (void)alterContentProperties:(NSString*)ContentID andPropertyList:(NSArray *)propertyList andContentType:(NSString*)contentType withBlock:(void (^)(BOOL success, NSError *error))block{
    
    AFHTTPRequestOperation *operation = [CloudOperation alterContentProperties:ContentID andPropertyList:propertyList andContentType:contentType];
    
    [operation start];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = operation.responseString;
        NSLog(@"responseStr:%@",responseStr);
        
        BOOL isSuccess = [[XMLParser sharedInstance] ifReplaySuccessFromXMLString:responseStr];
        
        if (block) {
            block(isSuccess, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}

@end






