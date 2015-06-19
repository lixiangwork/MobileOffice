//
//  SharerThirdCell.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@class SharerThirdCell;

@protocol SharerThirdCellDelegate <NSObject>

@optional

- (void)SharerThirdCellCheckButtonClicked;

@end


@interface SharerThirdCell : UITableViewCell

@property (strong, nonatomic) TreeViewNode *node;
@property (strong, nonatomic) NSMutableArray *allThirdLevelNodes;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)checkButtonClicked:(id)sender;

//////////////
@property (nonatomic, assign) id<SharerThirdCellDelegate> delegate;

@end
