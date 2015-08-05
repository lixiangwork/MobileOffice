//
//  IMChatVC.m
//  MobileOffice
//
//  Created by 李祥 on 15/7/31.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "IMChatVC.h"

@interface IMChatVC ()

@end

@implementation IMChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIFactory createButtonWithRect:CGRectMake(15, 0, 54, 44) normal:@"nav_backButtonBg.png" highlight:nil selector:@selector(backButtonClicked:) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}
- (void)backButtonClicked:(id)sender{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
