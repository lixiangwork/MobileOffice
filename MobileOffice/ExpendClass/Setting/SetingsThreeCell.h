//
//  SetingsThree.h
//  Word4S
//
//  Created by MacAir2 on 14-3-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "SetingsOneCell.h"

@protocol SettingsThreeCellDelegate <NSObject>

- (void)SettingsThreeCellOpenIM ;

@end

@interface SetingsThreeCell : SetingsOneCell<UIAlertViewDelegate>
{
    UISwitch *_switch;
}

@property (nonatomic, assign) id<SettingsThreeCellDelegate>delegate;

@end
