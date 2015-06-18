//
//  FileDetailCell.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-5-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentItems.h"

@interface FileDetailCell : UITableViewCell

@property (strong, nonatomic) ContentItems *item;

@property (strong, nonatomic) IBOutlet UIImageView *iconImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleAndSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *createrLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


- (void )layoutThatContentItems:(ContentItems *)cItem;

@end
