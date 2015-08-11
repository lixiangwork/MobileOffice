//
//  JLPinyinSortModel.h
//  JLPinyinSort
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface JLPinyinSortModel : NSObject

@property (nonatomic, strong) NSMutableArray* unsortedArray;
@property (nonatomic, strong) NSMutableArray* sections;
@property (nonatomic, strong) NSMutableArray* items;

- (void)sort;

@end
