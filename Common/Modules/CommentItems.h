//
//  CommentItems.h
//  MobileOffice
//
//  Created by MacAir2 on 15/6/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItems : NSObject

@property(nonatomic, strong) NSString* date;
@property(nonatomic, strong) NSString* commentor;
@property(nonatomic, strong) NSString* content;

+(NSMutableArray*) handleComment:(NSString*) WholeString;

@end
