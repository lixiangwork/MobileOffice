//
//  BaseTableViewCell.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFrame:(CGRect)frame
{
    CGRect rc = CGRectMake(frame.origin.x + self.cellEdge, frame.origin.y, frame.size.width - self.cellEdge * 2, frame.size.height);
    [super setFrame:rc];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
