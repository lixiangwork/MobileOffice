//
//  SetingsThree.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsThreeCell.h"
#import "IMUIHelper.h"
#import "IMXMPPManager.h"

@implementation SetingsThreeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType= UITableViewCellAccessoryNone;
        
        _switch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-81, 8, 51, 31)];
        [_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switch];
        
    }
    return self;
    
}

- (void)layoutThatContentItems:(SetingsItem *)sItem
{
    [super layoutThatContentItems:sItem];
    
    [_switch setOn:sItem.isSwitchOn];
}


-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:[[User sharedUser] getUserGlobalDic]];

    
    if ([self.item.titleName isEqualToString:@"记住密码"]) {
        
        [userDic setObject:(isButtonOn ? @"1" : @"0")  forKey:uRemenberPassword];
        
    }
    else if ([self.item.titleName isEqualToString:@"自动登录"]){
        [userDic setObject:(isButtonOn ? @"1" : @"0")  forKey:uAotoLogin];
    }
    else if ([self.item.titleName isEqualToString:@"开启聊天"]) {
        
        
        [userDic setObject:(isButtonOn ? @"1" : @"0")  forKey:uOpenIM];
        
        if (isButtonOn) {
            [UIFactory showConfirm:@"是否重新登录以开启聊天" tag:1000 delegate:self];
        }
        else {
            [[IMXMPPManager sharedManager] disconnect];
            [IMUIHelper showTextMessage:@"聊天与服务器断开链接"];
        }
        
        
        
    }
    else if ([self.item.titleName isEqualToString:@"消息提示音"]) {
        [userDic setObject:(isButtonOn ? @"1" : @"0")  forKey:uOpenIMBeep];;
    }
    
    [[User sharedUser] setUserGlobalDic:userDic];
}



#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000 ) {
        if (buttonIndex == 1) {//确定
            if ([self.delegate respondsToSelector:@selector(SettingsThreeCellOpenIM)]) {
                [self.delegate SettingsThreeCellOpenIM];
            }
        }
        else {
            [_switch setOn:NO];
            
            NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:[[User sharedUser] getUserGlobalDic]];
            
            [userDic setObject:@"0" forKey:uOpenIM];
            
             [[User sharedUser] setUserGlobalDic:userDic];
        }
    }
}

@end
