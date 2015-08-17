//
//  IMContactsImages.h
//  MobileOffice
//
//  Created by 李祥 on 15/8/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMContactsImages : NSObject

+ (IMContactsImages *)sharedInstance;

- (NSString *)getDocumentIDForTheContact:(NSString *)userName;

@end
