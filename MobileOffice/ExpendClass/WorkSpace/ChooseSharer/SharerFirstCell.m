//
//  SharerFirstCell.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SharerFirstCell.h"

@implementation SharerFirstCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheJiantouImageView:(UIImage *)jtImage
{
     [self.jiantouImageView setImage:jtImage];
}
- (IBAction)checkButtonClicked:(id)sender
{}

@end
