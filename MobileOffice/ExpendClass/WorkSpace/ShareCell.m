//
//  ShareCell.m
//  Word4S
//
//  Created by MacAir2 on 14-3-13.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "ShareCell.h"
#import "AppCore.h"

@implementation ShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _cellBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cellBg.image = [UIImage imageNamed:@"documentCellBg.png"];
        //[self.contentView addSubview:_cellBg];
        
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 80, 20)];
//        [_titleLabel setBackgroundColor:[UIColor clearColor]];
//        [_titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
//        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_contentLabel setNumberOfLines:0];
        [self.contentView addSubview:_contentLabel];
        
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineLabel.backgroundColor = RGBCOLOR(200, 200, 200);
        [self.contentView addSubview:_lineLabel];
        
    }
    return self;
}

- (CGFloat )layoutThatContentItems:(NSString *)sItem
{
    //NSArray *shareArr = [sItem componentsSeparatedByString:@","];
    
    //_titleLabel.text = [NSString stringWithFormat:@"已共享%i人:",shareArr.count];
    
    if ([sItem isEqualToString:@""] || sItem == nil) {
        sItem = @"暂无分享";
    }
    _contentLabel.text = sItem;
    _contentLabel.frame = [_contentLabel textRectForBounds:CGRectMake(15, 16, 290, MAXFLOAT) limitedToNumberOfLines:0];
    
    CGFloat height = _contentLabel.frame.size.height+16;
    
    if (height < 44) {
        height = 44.0f;
    }
    
    _cellBg.frame = CGRectMake(10, 8, 300, height-8);
    _lineLabel.frame = CGRectMake(10, height-1, self.frame.size.width, 1);
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutThatContentItems:_sharePeopers];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
