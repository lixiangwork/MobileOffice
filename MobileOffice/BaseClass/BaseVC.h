//
//  BaseVC.h
//  MobileOffice
//
//  Created by MacAir2 on 15/5/15.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCore.h"

@interface BaseVC : UIViewController

//导航栏返回按钮
@property (strong, nonatomic) UIButton *backButton;

/**
 *	@brief	初始化UI界面
 */
- (void)initUI;

/**
 *	@brief	导航栏返回按钮响应方法
 */
- (void)backButtonClicked:(id)sender;

/**
 *	@brief	MBProgressHUD
 */
-(void)showHud;
-(void)hideHud;
-(void)showHudOnlyMsg:(NSString*)msg;
-(void)showHudWithMsg:(NSString*)msg;

@end
