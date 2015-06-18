//
//  CommentCell.m
//  Word4S
//
//  Created by MacAir2 on 14-3-13.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _commenterImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 30, 30)];
        _commenterImgView.image = [UIImage imageNamed:@"comm_head.png"];
        [self.contentView addSubview:_commenterImgView];
        
        _commenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 21, 120, 20)];
        [_commenterLabel setBackgroundColor:[UIColor clearColor]];
        [_commenterLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_commenterLabel setTextColor:[UIColor darkGrayColor]];
        [self.contentView addSubview:_commenterLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 21, 150, 20)];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_timeLabel setTextColor:[UIColor darkGrayColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_contentLabel setNumberOfLines:0];
        [self.contentView addSubview:_contentLabel];
        
        _lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 300, 1)];
        _lineImgView.image = [UIImage imageNamed:@"documentCellSelectedBg.png"];
        [self.contentView addSubview:_lineImgView];
                                    

    }
    return self;
}

- (CGFloat )layoutThatContentItems:(CommentItems *)item
{
    _commenterLabel.text = item.commentor;
    _timeLabel.text = item.date;
    
    _contentLabel.text = item.content;
    _contentLabel.frame = [_contentLabel textRectForBounds:CGRectMake(48, 45, self.contentView.frame.size.width-58, MAXFLOAT) limitedToNumberOfLines:0];
    
    CGFloat height = _contentLabel.frame.size.height+30;

    if (height < 58) {
        height =  58.0f;
    }

    
   // _lineImgView.frame = CGRectMake(10, height-2, 300, 1);
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutThatContentItems:_cItem];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
