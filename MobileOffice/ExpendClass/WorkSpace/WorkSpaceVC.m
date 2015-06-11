//
//  WorkSpaceVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "WorkSpaceVC.h"
#import "LXSegmentView.h"

@interface WorkSpaceVC ()
@property (nonatomic, strong) LXSegmentView *mySegmentView;

@end

@implementation WorkSpaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的文档";
}

- (void)initUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mySegmentView = [[LXSegmentView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)];
    self.mySegmentView.tabBgImageView.image = [UIImage imageNamed:@"bg_tab_selected.png"];
    self.mySegmentView.tabButtonSeclectImageView.image = [UIImage imageNamed:@"select_flag.png"];
    self.mySegmentView.tabButtonColor = [UIColor blackColor];
    self.mySegmentView.tabButtonSelectCorlor = [UIColor redColor];
    [self.mySegmentView setTabButton1Title:@"我上传的" andButton2Title:@"我分享的" andButton3Title:@"分享给我的"];
    
    [self.view addSubview:self.mySegmentView];
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
