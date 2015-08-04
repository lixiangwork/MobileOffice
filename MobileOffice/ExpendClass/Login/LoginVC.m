//
//  LoginVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/25.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "LoginVC.h"
#import "User.h"
#import "CloudService.h"

#import "WorkSpaceVC.h"
#import "IMMainMessageC.h"
#import "IMContactsC.h"
#import "IIViewDeckController.h"
#import "ContactsVC.h"
#import "FileUploadVC.h"
#import "SettingVC.h"

@interface LoginVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *remenberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *aotoLoginBtn;

- (IBAction)remenberPasswordBtnClicked:(id)sender;
- (IBAction)aotoLoginBtnClicked:(id)sender;
- (IBAction)loginBtnClicked:(id)sender;

///
@property (strong, nonatomic) NSMutableDictionary *userGlobalDic;

///viewControllers


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"移动办公";
    
    _userGlobalDic = [[NSMutableDictionary alloc] initWithDictionary:[[User sharedUser] getUserGlobalDic]];
    
    if ([[_userGlobalDic objectForKey:uAotoLogin] boolValue]) {
        [self performSelector:@selector(loginAchieve) withObject:nil afterDelay:0.3];
    }
    
}

- (void)initUI{
    [super initUI];
    
    [_remenberPasswordBtn setImage:[UIImage imageNamed:@"login_uncheck.png"] forState:UIControlStateNormal];
    [_remenberPasswordBtn setImage:[UIImage imageNamed:@"login_check.png"] forState:UIControlStateSelected];
    
    [_aotoLoginBtn setImage:[UIImage imageNamed:@"login_uncheck.png"] forState:UIControlStateNormal];
    [_aotoLoginBtn setImage:[UIImage imageNamed:@"login_check.png"] forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _userGlobalDic = [[NSMutableDictionary alloc] initWithDictionary:[[User sharedUser] getUserGlobalDic]];
    _remenberPasswordBtn.selected = [[_userGlobalDic objectForKey:uRemenberPassword] boolValue];
    _aotoLoginBtn.selected = [[_userGlobalDic objectForKey:uAotoLogin] boolValue];
    
    _userNameTF.text = [_userGlobalDic objectForKey:uUserName];
    
    if (_remenberPasswordBtn.selected) {
        _passwordTF.text = [_userGlobalDic objectForKey:uPassword];
    }
    else {
        _passwordTF.text = @"";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_userNameTF isFirstResponder]) {
        [_userNameTF resignFirstResponder];
    }
    else if ([_passwordTF isFirstResponder]){
        [_passwordTF resignFirstResponder];
    }
}

#pragma mark - myself
- (void)gotoNextViewController{
    LOG_SELF_METHOD;
    
    WorkSpaceVC *workSpaceVC = [[WorkSpaceVC alloc] initWithNibName:@"WorkSpaceVC" bundle:nil];
    UINavigationController *workSpaceNav = [[UINavigationController alloc] initWithRootViewController:workSpaceVC];
    
    FileUploadVC *fileUploadVC = [[FileUploadVC alloc] initWithNibName:@"FileUploadVC" bundle:nil];
    UINavigationController *fileUploadNav = [[UINavigationController alloc] initWithRootViewController:fileUploadVC];
    
    ///////////chat
    IMMainMessageC *chatVC = [[IMMainMessageC alloc] init];
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    IMContactsC *imContactsC = [[IMContactsC alloc] init];
    UINavigationController *imContactsNav = [[UINavigationController alloc] initWithRootViewController:imContactsC];
    
    IIViewDeckController *viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:chatNav leftViewController:imContactsNav];
    ///////////
    
    ContactsVC *contactsVC = [[ContactsVC alloc] initWithNibName:@"ContactsVC" bundle:nil];
    UINavigationController *contactsNav = [[UINavigationController alloc] initWithRootViewController:contactsVC];
    
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    UITabBarController *myTabBarController = [[UITabBarController alloc] init];
    myTabBarController.viewControllers = @[workSpaceNav, fileUploadNav, viewDeckController, contactsNav, settingNav];
    
    workSpaceNav.tabBarItem.title = @"我的文档";
    workSpaceNav.tabBarItem.image = [UIImage imageNamed:@"tabbarItem_workSpace.png"];
    
    fileUploadNav.tabBarItem.title = @"文件上传";
    fileUploadNav.tabBarItem.image = [UIImage imageNamed:@"tabbarItem_fileUpload.png"];
    
    viewDeckController.tabBarItem.title = @"即时通讯";
    viewDeckController.tabBarItem.image = [UIImage imageNamed:@"tabbarItem_jishitong.png"];
    
    contactsNav.tabBarItem.title = @"通讯录";
    contactsNav.tabBarItem.image = [UIImage imageNamed:@"tabbarItem_txl.png"];
    
    settingNav.tabBarItem.title = @"设置";
    settingNav.tabBarItem.image = [UIImage imageNamed:@"tabbarItem_setting.png"];
    
    myTabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:myTabBarController animated:YES completion:nil];
    
}

- (void)loginAchieve{
    
    if (_userNameTF.text == nil || [_userNameTF.text isEqualToString:@""]) {
        
        [UIFactory showAlert:@"用户名不能为空"];
    }
    else if(_passwordTF.text == nil || [_passwordTF.text isEqualToString:@""]){
        
        [UIFactory showAlert:@"密码不能为空"];
    }
    else if (!_remenberPasswordBtn.selected && _aotoLoginBtn.selected) {
        
        [UIFactory showAlert:@"请选择记住密码"];
    }
    else {
        [self showHudWithMsg:@"登陆中..."];
        [[CloudService sharedInstance] testUser:_userNameTF.text andPassword:_passwordTF.text withBlock:^(BOOL isSuccess, NSString *nickName, NSError *error) {
            [self hideHud];
            
            if (!error) {
                NSLog(@"nickName:%@",nickName);
                if (isSuccess) {
                    [_userGlobalDic setObject:_userNameTF.text forKey:uUserName];
                    [_userGlobalDic setObject:_passwordTF.text forKey:uPassword];
                    if (nickName) {
                        [_userGlobalDic setObject:nickName forKey:uNickName];
                    }
                    [[User sharedUser] setUserGlobalDic:_userGlobalDic];
                    [self gotoNextViewController];
                }
                else{
                    [UIFactory showAlert:@"用户名不存在或密码错误"];
                }
            }
            else{
                [UIFactory showAlert:@"网络错误"];
            }
        }];

    }
}

#pragma mark - IBAction
- (IBAction)remenberPasswordBtnClicked:(id)sender {
    
    _remenberPasswordBtn.selected = !_remenberPasswordBtn.selected;
    
    [_userGlobalDic setObject:(_remenberPasswordBtn.selected ? @"1" : @"0") forKey:uRemenberPassword];
    [[User sharedUser] setUserGlobalDic:_userGlobalDic];
    
}

- (IBAction)aotoLoginBtnClicked:(id)sender {
    
    _aotoLoginBtn.selected = !_aotoLoginBtn.selected;
    
    [_userGlobalDic setObject:(_aotoLoginBtn.selected ? @"1" : @"0") forKey:uAotoLogin];
    [[User sharedUser] setUserGlobalDic:_userGlobalDic];

}

- (IBAction)loginBtnClicked:(id)sender {
    
    [_userNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    
    [self loginAchieve];
   

}

#pragma mark - textField delegate
-(void) slideFrame:(BOOL)up
{
    const int movementDistance = (isRetina ? 130 : 100); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self slideFrame:YES ];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self slideFrame:NO ];
}


@end
