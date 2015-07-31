//
//  ChatVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ChatVC.h"
#import "AppCore.h"
#import "User.h"

@interface ChatVC ()

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [[[User sharedUser] getUserGlobalDic] objectForKey:uNickName];
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
