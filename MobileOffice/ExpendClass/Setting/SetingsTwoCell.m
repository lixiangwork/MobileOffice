//
//  SetingsTwoCell.m
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsTwoCell.h"

@implementation SetingsTwoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType= UITableViewCellAccessoryNone;
      
        [_titleLabel setTextColor:[UIColor redColor]];
        
    }
    return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
