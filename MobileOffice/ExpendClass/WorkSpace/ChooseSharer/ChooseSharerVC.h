//
//  ChooseSharerVC.h
//  MobileOffice
//
//  Created by MacAir2 on 15/6/19.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ContactsVC.h"
#import "ContentItems.h"

@protocol ChooseSharerVCDelegate <NSObject>

- (void)chooseSharerVCSharedSuccess:(NSString *)shares;

@end

@interface ChooseSharerVC : ContactsVC

@property (assign, nonatomic) id<ChooseSharerVCDelegate>delegate;

@property (strong, nonatomic) ContentItems *cItem;

@end
