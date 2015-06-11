//
//  SetingsOneCell.h
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SetingsItem.h"
#import "AppCore.h"

@interface SetingsOneCell : BaseTableViewCell
{
    UIImageView *_iconImgView;
    UILabel *_titleLabel;
}

@property (strong, nonatomic) SetingsItem *item;

- (void)layoutThatContentItems:(SetingsItem *)sItem;

@end
