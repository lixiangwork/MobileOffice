//
//  HelpVC.m
//  MobileOffice
//
//  Created by houjing on 15/6/19.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()<UITextViewDelegate,UIWebViewDelegate>

//@property (nonatomic, strong) UIWebView *helpWebView;
//@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UITextView *helpTextView;
@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
}

- (void)initUI{
    
    [super initUI];
    
    self.helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.helpTextView.delegate = self;
    self.helpTextView.textColor = [UIColor blackColor];
    self.helpTextView.font = [UIFont systemFontOfSize:17];
    self.helpTextView.editable = NO;
    
    [self.view addSubview:self.helpTextView];
    
    NSString *helpStr = @"1. 我的文档：列表中显示的为上传的文档，分享及被分享的文档。右上角为处理列表，显示已经处理过的文档列表。点击可进入文档详情页面，下拉可刷新列表。\n\n2. 文档详情：未处理与已处理文档详情。查看：如果文档未下载，则下载并打开文档；如果文档已下载，则直接打开文档。（需要安装office应用，如WPS）评论：跳转到所有评论列表，点击发表评论，可对文档进行评论。归档： 可选择将该文档标记为已处理。分享：将文档分享给其他人。删除：可删除已下载到本地的文件和云端文件。\n\n3.文件上传：相机获取上传：可直接拍照上传照片 相册获取上传：从相册中选择图片上传。\n\n4.本地文件：可点击打开本地txt、pdf、word、excel、ppt、png、jpg等格式文件。\n\n5.即使通讯：可与在线联系人进行即时通讯。点击左上方按钮或自屏幕边缘向右滑动可滑出联系人列表，点击最近对话或联系人进入通讯页面。\n\n6.设置：可修改密码，退出当前账号重新登录，选择是否记住密码，是否打开消息提示音及是否自动登录。";
    
    self.helpTextView.text = helpStr;
    
//    self.helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
//    self.helpWebView.delegate = self;
//    
//    NSURLRequest *helpRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hao123.com"]]];
//    
//    [self.helpWebView loadRequest:helpRequest];
//    
//    [self.view addSubview:self.helpWebView];
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    return YES;
}

//#pragma mark - UIWebView Delegate
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
//    view.tag = 108;
//    view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:view];
//    
//    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-16, kScreenHeight/2-64-16, 32, 32)];
//    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    //self.activityIndicatorView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
//    
//    [view addSubview:self.activityIndicatorView];
//    
//    [self.activityIndicatorView startAnimating];
//    
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    [self.activityIndicatorView stopAnimating];
//    
//    UIView *view = (UIView *)[self.view viewWithTag:108];
//    [view removeFromSuperview];
//}
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    
//    [self.activityIndicatorView stopAnimating];
//    
//    UIView *view = (UIView *)[self.view viewWithTag:108];
//    [view removeFromSuperview];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
