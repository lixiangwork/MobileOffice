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

//#import "ImagePickerVC.h"
#import "PickUserIconImageVC.h"
#import "HelpVC.h"
#import "ChangePassword.h"
#import <PgySDK/PgyManager.h>

#import "IMXMPPManager.h"

@interface SettingVC ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PickUserIconImageVCDelegate, SettingsThreeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UIImage *personImage;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    //self.personImage = [UIImage imageNamed:@"comm_head.png"];
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
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"退出登陆" andIsSwitchOn:NO];
            
            ((SetingsTwoCell *)cell).item = item;
            ((SetingsTwoCell *)cell).cellEdge = 10;

        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1];
            if (cell == nil) {
                cell = [[SetingsOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer1];
            }
            
            if (indexPath.row == 0) {
                SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"修改密码" andIsSwitchOn:NO];
                ((SetingsOneCell *)cell).item = item;
            }
            else{
                SetingsItem *item = [[SetingsItem alloc] initWithIconImg:[[User sharedUser] getLocalPersonImageWithPalceholderImage:[UIImage imageNamed:@"comm_head.png"]] andTitleName:@"选择头像" andIsSwitchOn:NO];
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
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"记住密码" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).cellEdge = 10;
        }
        else{
            
            BOOL isOn = [[[[User sharedUser] getUserGlobalDic] objectForKey:uAotoLogin] boolValue];
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"自动登陆" andIsSwitchOn:isOn];
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
            
            BOOL isOn = [[User sharedUser] isOpenIM];
            
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"开启聊天" andIsSwitchOn:isOn];
            ((SetingsThreeCell *)cell).item = item;
            ((SetingsThreeCell *)cell).delegate = self;
            ((SetingsThreeCell *)cell).cellEdge = 10;
        }
        else{
            
            BOOL isOn = [[User sharedUser] isOpenIMBeep];
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"消息提示音" andIsSwitchOn:isOn];
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
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"帮助" andIsSwitchOn:NO];
            ((SetingsOneCell *)cell).item = item;
            ((SetingsOneCell *)cell).cellEdge = 10;

        }
        else if (indexPath.row == 1){
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"检查更新" andIsSwitchOn:NO];
            ((SetingsOneCell *)cell).item = item;
            ((SetingsOneCell *)cell).cellEdge = 10;
        }
        else{
            SetingsItem *item = [[SetingsItem alloc] initWithIconImg:nil andTitleName:@"移动办公Beta1.0.2版" andIsSwitchOn:NO];
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
    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 0) {//修改密码
            
            ChangePassword *vc = [[ChangePassword alloc] initWithNibName:@"ChangePassword" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if (indexPath.row == 1) {//选择头像
            [self changeImage];
        }
        else if (indexPath.row == 2) {
            [[IMXMPPManager sharedManager] disconnect];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else if(indexPath.section == 3 ){
        if (indexPath.row == 0) {//帮助
            HelpVC *vc = [[HelpVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1) {//检查更新
            [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
        }
        
    }
}

- (void)updateMethod:(id)infos {
    NSLog(@"infos:%@",infos);
    
    if (infos) {
        [[PgyManager sharedPgyManager] checkUpdate];
    }
    else {
        [UIFactory showAlert:@"当前为最新版本"];
    }
    
}


#pragma mark - ChangeImage
//用UIActionSheet控件来选择相片的来源
- (void)changeImage{
    
    UIActionSheet *imagesheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"默认图片",@"相片",@"拍照", nil];
    [imagesheet showFromRect:self.view.bounds inView:self.view animated:YES];
}



#pragma mark - UIActionSheet Delegate

//实现用UIActionSheet控件来选择相片来源的 Delegate方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            PickUserIconImageVC *vc = [[PickUserIconImageVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            [self localPhone];
            break;
        }
        case 2:
        {
            [self takePhone];
            break;
        }

        default:
            break;
    }
}

//从相册选择
- (void)localPhone{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
- (void)takePhone{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        NSLog(@"该设备没有摄像头");
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //本地化存储图片
    [[User sharedUser] saveImage:image];
    
    [self.tableView reloadData];
    
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PickUserIconImageVC delegate
- (void)pickUserIconImageVCSelectedOneImage:(UIImage *)image {
    //本地化存储图片
    [[User sharedUser] saveImage:image];
    
    [self.tableView reloadData];
}

#pragma mark - settingThreeCell delegate
- (void)SettingsThreeCellOpenIM {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
