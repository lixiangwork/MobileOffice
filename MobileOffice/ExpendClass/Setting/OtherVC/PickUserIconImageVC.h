//
//  PickUserIconImageVC.h
//  MobileOffice
//
//  Created by MacAir2 on 15/7/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseVC.h"

@protocol PickUserIconImageVCDelegate <NSObject>

- (void)pickUserIconImageVCSelectedOneImage:(UIImage *)image;

@end

@interface PickUserIconImageVC : BaseVC

@property (nonatomic, strong) id<PickUserIconImageVCDelegate> delegate;

@end
