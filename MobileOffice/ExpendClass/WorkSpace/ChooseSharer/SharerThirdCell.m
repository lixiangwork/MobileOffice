//
//  SharerThirdCell.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SharerThirdCell.h"
#import "TreeNodeThirdLevel.h"

@implementation SharerThirdCell

- (void)awakeFromNib
{
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    //[self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    //[self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    if (self.node.isNodeSelected) {
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
    }
    else{
         [self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    }
    
    //NSLog(@"%@",self.allThirdLevelNodes);
    
    for (TreeViewNode *node in self.allThirdLevelNodes) {

        TreeNodeThirdLevel *thirdlevel = (TreeNodeThirdLevel *)node.nodeObject;
        TreeNodeThirdLevel *selfthirdlevel = (TreeNodeThirdLevel *)self.node.nodeObject;
        if ([thirdlevel.thirdLevelTitle isEqualToString:selfthirdlevel.thirdLevelTitle]) {
            node.isNodeSelected = self.node.isNodeSelected;
        }
    }
    
    
}


@end
