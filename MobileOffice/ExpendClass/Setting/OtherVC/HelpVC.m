//
//  HelpVC.m
//  MobileOffice
//
//  Created by houjing on 15/6/19.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *helpWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
}

- (void)initUI{
    
    [super initUI];
    
    self.helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.helpWebView.delegate = self;
    
    NSURLRequest *helpRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hao123.com"]]];
    
    [self.helpWebView loadRequest:helpRequest];
    
    [self.view addSubview:self.helpWebView];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    view.tag = 108;
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-16, kScreenHeight/2-64-16, 32, 32)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    //self.activityIndicatorView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
    
    [view addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityIndicatorView stopAnimating];
    
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self.activityIndicatorView stopAnimating];
    
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
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
