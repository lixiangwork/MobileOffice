//
//  TreeNodeSecondLevel.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-17.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNodeSecondLevel : NSObject

@property (strong, nonatomic) NSString *firstLevelTitle;
@property (strong, nonatomic) NSString *secondLevelTitle;
//@property (strong, nonatomic) NSString *imageName;

-(id)initWithFirstLevelTitle:(NSString *)flTitle andsecondLevelTitle:(NSString *)slTitle;


@end
