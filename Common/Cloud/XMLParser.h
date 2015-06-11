//
//  XMLParser.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentItems.h"
#import "UserItems.h"

@interface XMLParser : NSObject

@property (nonatomic, strong) NSMutableArray *parserResultArray;

+ (XMLParser *)sharedInstance;

- (void)parsedContentWithXMLString:(NSString *)xmlString;

- (BOOL)parsedUserWithXMLString:(NSString *)xmlString;

- (BOOL)ifReplaySuccessFromData:(NSData *)data;

- (NSString *)parsedInsertXMLString:(NSString *)xmlString;


@end
