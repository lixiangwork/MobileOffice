//
//  ContactsFirstCell.h
//  Word4S_OA
//
//  Created by MacAir2 on 14-6-20.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsFirstCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *jiantouView;

- (void)setTheJiantouView:(UIImage *)jtImage;

@end
