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
    NSString *time = [_contentItem.Properties objectForKey:@"news_createtime"];
    _noticeTimeLable.text = time.length > 19 ? [time substringToIndex:19] : time;
    _noticeBriefLable.text = [_contentItem.Properties objectForKey:@"news_detail"];
}

@end
