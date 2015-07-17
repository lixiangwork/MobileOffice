//
//  ChangePassword.m
//  MobileOffice
//
//  Created by MacAir2 on 15/7/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ChangePassword.h"

@interface ChangePassword ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF2;

- (IBAction)changPasswordButtonClicked:(id)sender;

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAciton
- (IBAction)changPasswordButtonClicked:(id)sender {
    
    NSDictionary *userDic = [[User sharedUser] getUserGlobalDic];
    
    if (_oldPasswordTF.text.length <= 0) {
        [self showHudOnlyMsg:@"请输入当前密码"];
        return;
    }
    else if (![_oldPasswordTF.text isEqualToString:userDic[uPassword]]) {
        [self showHudOnlyMsg:@"当前密码错误"];
        return;
    }
    else if (_passwordTF1.text.length <= 0) {
        [self showHudOnlyMsg:@"请输入新密码"];
        return;
    }
    else if (_passwordTF2.text.length <= 0) {
        [self showHudOnlyMsg:@"请再次输入新密码"];
        return;
    }
    else if (![_passwordTF2.text isEqualToString:_passwordTF1.text]) {
        [self showHudOnlyMsg:@"再次输入的密码不一致"];
        return;
    }
    else {
        [self changePasswordWithUserName:userDic[uUserName] andPassword:_passwordTF1.text];
    }
}

#pragma mark - 
- (void)backToPreviousViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changePasswordWithUserName:(NSString *)userName andPassword:(NSString *)password{
    
    [[CloudService sharedInstance] addUserWithUserName:userName andPassword:password withBlock:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            if (isSuccess) {
                [self showHudOnlyMsg:@"密码修改成功, 请重新登陆"];
                [self performSelector:@selector(backToPreviousViewController) withObject:nil afterDelay:2];
            }
            else {
                [self showHudOnlyMsg:@"密码修改失败，请重试或联系客服，谢谢！"];
            }
        }
        else {
            [self showHudOnlyMsg:@"网络错误"];
        }
    }];
}


@end
