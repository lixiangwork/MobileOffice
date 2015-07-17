//
//  SetingsOneCell.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsOneCell.h"
#import "AppCore.h"

@implementation SetingsOneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-65, 4, 35, 35)];
        [self.contentView addSubview:_iconImgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 120, 21)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutThatContentItems:(SetingsItem *)sItem
{
    if (sItem.iconImg) {
        _iconImgView.image = sItem.iconImg;
    }
    
    
    _titleLabel.text = sItem.titleName;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutThatContentItems:_item];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
