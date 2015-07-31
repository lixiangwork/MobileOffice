//
//  NoticeVCCell.m
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "NoticeVCCell.h"

@implementation NoticeVCCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _noticeTitleLabel.text = [_contentItem.Properties objectForKey:@"news_title"];
    _noticeTimeLable.text = [_contentItem.Properties objectForKey:@"news_createtime"];
    _noticeBriefLable.text = [_contentItem.Properties objectForKey:@"news_detail"];
}

@end
