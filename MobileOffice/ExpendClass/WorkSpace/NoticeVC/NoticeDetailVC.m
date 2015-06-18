//
//  NoticeDetailVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/16.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "NoticeDetailVC.h"

@interface NoticeDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *noticeContentTextView;


@end

@implementation NoticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"公告";
    
    _noticeTitleLabel.text = [_contentItem.Properties objectForKey:@"news_title"];
    _noticeTimeLabel.text = [_contentItem.Properties objectForKey:@"news_createtime"];
    _noticeContentTextView.text = [_contentItem.Properties objectForKey:@"news_detail"];
    
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
