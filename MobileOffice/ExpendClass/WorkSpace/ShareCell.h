//
//  ShareCell.h
//  Word4S
//
//  Created by MacAir2 on 14-3-13.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCell : UITableViewCell
{
    UIImageView *_cellBg;
    //UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    UILabel *_lineLabel;
}

@property (strong, nonatomic) NSString *sharePeopers;

- (CGFloat )layoutThatContentItems:(NSString *)sItem;

@end
