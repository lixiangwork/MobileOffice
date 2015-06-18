//
//  CommentCell.h
//  Word4S
//
//  Created by MacAir2 on 14-3-13.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItems.h"

@interface CommentCell : UITableViewCell
{
    UIImageView *_commenterImgView;
    UILabel *_commenterLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIImageView *_lineImgView;
}

@property (strong, nonatomic) CommentItems *cItem;

- (CGFloat )layoutThatContentItems:(CommentItems *)item;

@end
