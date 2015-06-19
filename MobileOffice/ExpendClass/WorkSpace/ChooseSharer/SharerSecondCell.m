//
//  SharerSecondCell.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SharerSecondCell.h"

@implementation SharerSecondCell

- (void)awakeFromNib
{
    // Initialization code
    
     [self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
//     [self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];
    
    
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.node.isNodeSelected) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    }
    else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    }
    
}


- (IBAction)checkButtonClicked:(id)sender
{
    self.node.isNodeSelected = !self.node.isNodeSelected;
    
    for (TreeViewNode *n in self.node.nodeChildren) {
        n.isNodeSelected = self.node.isNodeSelected;
    }
    
    if (self.node.isNodeSelected) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    }
    else{
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    }

    
    if ([_delegate conformsToProtocol:@protocol(SharerSecondCellDelegate)] &&
        [_delegate respondsToSelector:@selector(SharerSecondCellCheckButtonClicked:)])
    {
        [_delegate SharerSecondCellCheckButtonClicked:self.node];
    }


}


@end
