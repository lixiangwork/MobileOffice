//
//  BaseVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/15.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation BaseVC

- (void)initUI{
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    
    _backButton = [UIFactory createButtonWithRect:CGRectMake(15, 0, 54, 44) normal:@"nav_backButtonBg.png" highlight:nil selector:@selector(backButtonClicked:) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backButton];
    _backButton.hidden = self.navigationController.viewControllers.count == 1 ? YES : NO;
    
    ///hud
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBProgressHUD
- (void)showHud{
    //self.hud.mode = MBProgressHUDModeIndeterminate;
    //self.hud.labelText = @"";
    self.hud.dimBackground = YES;
    [self.hud show:YES];
}

-(void)showHudWithMsg:(NSString*)msg
{
    self.hud.dimBackground = YES;
    self.hud.labelText  = msg;
    [self.hud show:YES];
}

-(void)showHudOnlyMsg:(NSString*)msg
{
    self.hud.mode       = MBProgressHUDModeText;
    self.hud.labelText  = msg;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:2.0];
}

-(void)hideHud
{
    [self.hud hide:YES];
}

#pragma mark - backButtonClicked
- (void)backButtonClicked:(id)sender{
    
    LOG_SELF_METHOD;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
