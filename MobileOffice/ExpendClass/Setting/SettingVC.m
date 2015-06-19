//
//  SettingVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "SettingVC.h"
#import "SetingsOneCell.h"
#import "SetingsTwoCell.h"
#import "SetingsThreeCell.h"
#import "SetingsItem.h"
#import "AppCore.h"

#import "HelpVC.h"

@interface SettingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasouce delegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return 2;
    }
    else if (section == 3){
        return 3;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer1 = @"settingOneCell_identifer";
    static NSString *cellIdentifer2 = @"settingTwoCell_identifer";
    static NSString *cellIdentifer3 = @"settingThreeCell_identifer";
    
    UITableViewCell *cell = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer2];
            if (cell == nil) {
                cell = [[SetingsTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer2];
            }
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"退出登陆" andIsSwitchOn:NO];
            
            ((SetingsTwoCell *)cell).item = item;
            ((SetingsTwoCell *)cell).cellEdge = 10;

        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1];
            if (cell == nil) {
                cell = [[SetingsOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer1];
            }
            
            if (indexPath.row == 0) {
                SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"修改密码" andIsSwitchOn:NO];
                ((SetingsOneCell *)cell).item = item;
            }
            else{
                SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:@"comm_head.png" andTitleName:@"选择头像" andIsSwitchOn:NO];
                ((SetingsOneCell *)cell).item = item;
            }
            
            ((SetingsOneCell *)cell).cellEdge = 10;

        }
        
    }
    else if (indexPath.section == 1){
    
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer3];
        if (cell == nil) {
            cell = [[SetingsThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer3];
        }
        
        if (indexPath.row == 0) {
            
            BOOL isOn = [[[[User sharedUser] getUserGlobalDic] objectForKey:uRemenberPassword] boolValue];
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"记住密码" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).cellEdge = 10;
        }
        else{
            
            BOOL isOn = [[[[User sharedUser] getUserGlobalDic] objectForKey:uAotoLogin] boolValue];
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"自动登陆" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).cellEdge = 10;
            
        }
        
    }
    else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer3];
        if (cell == nil) {
            cell = [[SetingsThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer3];
        }
        
        if (indexPath.row == 0) {
            
            BOOL isOn = YES;
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"开启聊天" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).cellEdge = 10;
        }
        else{
            
            BOOL isOn = YES;
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"消息提示音" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).cellEdge = 10;
            
        }
    }
    else if (indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1];
        if (cell == nil) {
            cell = [[SetingsOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer1];
        }
        
        if (indexPath.row == 0) {
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"帮助" andIsSwitchOn:NO];
            ((SetingsOneCell *)cell).item = item;
            ((SetingsOneCell *)cell).cellEdge = 10;

        }
        else if (indexPath.row == 1){
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"关于我们" andIsSwitchOn:NO];
            ((SetingsOneCell *)cell).item = item;
            ((SetingsOneCell *)cell).cellEdge = 10;
        }
        else{
            SetingsItem *item = [[SetingsItem alloc] initWithIconImgName:nil andTitleName:@"移动办公Beta2版" andIsSwitchOn:NO];
            ((SetingsOneCell *)cell).item = item;
            ((SetingsOneCell *)cell).cellEdge = 10;

        }
        
    }
    
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号";
    }
    else if (section == 1){
        return @"安全";
    }
    else if (section == 2){
        return @"聊天";
    }
    else if (section == 3){
        return @"其它";
    }
    else{
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(indexPath.section == 3 && indexPath.row == 0){
        HelpVC *vc = [[HelpVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
