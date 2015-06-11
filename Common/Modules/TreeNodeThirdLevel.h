//
//  TreeNodeThirdLevel.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-17.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNodeThirdLevel : NSObject

@property (strong, nonatomic) NSString *firstLevelTitle;
@property (strong, nonatomic) NSString *secondLevelTitle;
@property (strong, nonatomic) NSString *thirdLevelTitle;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userDescription;
@property (strong, nonatomic) NSString *phoneNum;

- (id)initWithFtitle:(NSString *)fTitle andStitle:(NSString *)fTitle andTtitle:(NSString *)tTitle andUserName:(NSString *)uname andDescription:(NSString *)des andPhoneNum:(NSString *)phone;

@end
