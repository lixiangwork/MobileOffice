//
//  TreeNodeSecondLevel.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-17.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "TreeNodeSecondLevel.h"

@implementation TreeNodeSecondLevel

-(id)initWithFirstLevelTitle:(NSString *)flTitle andsecondLevelTitle:(NSString *)slTitle
{
    if ([super init]) {
        self.firstLevelTitle = flTitle;
        self.secondLevelTitle = slTitle;
    }
    return self;

}

//- (BOOL )isEqual:(id)object
//{
//   // [super isEqual:object];
//    
//    return YES;
//}

@end
