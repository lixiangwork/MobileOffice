//
//  NoticeVCCell.h
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ContentItems.h"

@interface NoticeVCCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *noticeBriefLable;

@property (strong, nonatomic) ContentItems *contentItem;

@end
