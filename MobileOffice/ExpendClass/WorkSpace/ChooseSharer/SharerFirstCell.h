//
//  SharerFirstCell.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-25.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharerFirstCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIImageView *jiantouImageView;

- (void)setTheJiantouImageView:(UIImage *)jtImage;
- (IBAction)checkButtonClicked:(id)sender;

@end
