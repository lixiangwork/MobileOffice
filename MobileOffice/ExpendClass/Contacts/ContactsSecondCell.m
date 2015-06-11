//
//  ContactsSecondCell.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-20.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "ContactsSecondCell.h"

@implementation ContactsSecondCell

- (void)awakeFromNib
{
    // Initialization code
    //[self.contentView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheJiantouView:(UIImage *)jtImage
{
    [self.jiantouView setImage:jtImage];
}

@end
