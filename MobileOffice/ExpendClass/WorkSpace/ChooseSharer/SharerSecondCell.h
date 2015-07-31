//
//  SharerSecondCell.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@class SharerSecondCell;

@protocol SharerSecondCellDelegate <NSObject>

@optional

- (void)SharerSecondCellCheckButtonClicked:(TreeViewNode *)node;

@end


@interface SharerSecondCell : UITableViewCell

@property (strong, nonatomic) TreeViewNode *node;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIImageView *jiantouImageView;

- (void)setTheJiantouImageView:(UIImage *)jtImage;
- (IBAction)checkButtonClicked:(id)sender;

//////////////
@property (nonatomic, assign) id<SharerSecondCellDelegate> delegate;

@end
