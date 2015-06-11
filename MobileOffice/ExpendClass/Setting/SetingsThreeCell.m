//
//  SetingsThree.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsThreeCell.h"

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
    else if ([self.item.titleName isEqualToString:@"自动登陆"]){
        [userDic setObject:(isButtonOn ? @"1" : @"0")  forKey:uAotoLogin];
    }
    
    [[User sharedUser] setUserGlobalDic:userDic];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
