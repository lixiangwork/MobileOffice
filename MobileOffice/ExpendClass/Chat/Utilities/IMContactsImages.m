//
//  IMContactsImages.m
//  MobileOffice
//
//  Created by 李祥 on 15/8/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "IMContactsImages.h"
#import "AppCore.h"

@implementation IMContactsImages

+ (IMContactsImages *)sharedInstance {
    static IMContactsImages *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc ] init];
    });
    
    return _sharedManager;
}

- (NSString *)getDocumentIDForTheContact:(NSString *)userName {
    NSData *data = [[NSData alloc]initWithContentsOfFile:ContactsPath];
    NSMutableArray *_contactsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *documentID = @"";
    
    for (ContentItems *item in _contactsArray) {
        
        NSString *user = item.Properties[@"ymUserName"];
        if ([user isEqualToString:userName]) {
            documentID = item.DocumentID;
        }
    }
    
    return documentID;
}

@end
