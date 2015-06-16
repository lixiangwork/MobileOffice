//
//  WSUploadCell.m
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "WSUploadCell.h"

@implementation WSUploadCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutThatContentItems:_contentItem];
}

- (void )layoutThatContentItems:(ContentItems *)cItem
{
    //NSLog(@"MimeType:%@",cItem.MimeType);
    
    if ( ([cItem.MimeType rangeOfString:@"msword"
                                          options:NSCaseInsensitiveSearch].location != NSNotFound)
         || ([cItem.MimeType rangeOfString:@"kswps"
                                           options:NSCaseInsensitiveSearch].location != NSNotFound)
         || ([cItem.MimeType rangeOfString:@"wordprocess"
                                           options:NSCaseInsensitiveSearch].location != NSNotFound) ) {
        
        _iconImageView.image = [UIImage imageNamed:@"doc.png"];
    }
    else if (([cItem.MimeType rangeOfString:@"excel"
                                              options:NSCaseInsensitiveSearch].location != NSNotFound)
             || ([cItem.MimeType rangeOfString:@"spreadsheet"
                                                options:NSCaseInsensitiveSearch].location != NSNotFound)) {
        
        _iconImageView.image = [UIImage imageNamed:@"xls.png"];
    }
    else if (([cItem.MimeType rangeOfString:@"ms-powerpoint"
                                              options:NSCaseInsensitiveSearch].location != NSNotFound)
             ||([cItem.MimeType rangeOfString:@"presentation"
                                                options:NSCaseInsensitiveSearch].location != NSNotFound)) {
        
        _iconImageView.image = [UIImage imageNamed:@"ppt.png"];
        
    }
    else if ([cItem.MimeType rangeOfString:@"image"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        _iconImageView.image = [UIImage imageNamed:@"img.png"];
    }
    else if ([cItem.MimeType  rangeOfString:@"pdf"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        _iconImageView.image = [UIImage imageNamed:@"pdf.png"];
    }
    else if ([cItem.MimeType rangeOfString:@"text"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound){
        
        _iconImageView.image = [UIImage imageNamed:@"txt.png"];
    }
    else{
        _iconImageView.image = [UIImage imageNamed:@"unknow.png"];
    }
    
    _titleLabel.text = [cItem.Properties objectForKey:@"zh_wzbt"];
    
    NSString *shareMens = [cItem.Properties objectForKey:@"shares"];
    //NSLog(@"share:%@",shareMens);
    
    NSArray *shareArr = [shareMens componentsSeparatedByString:@","];
    //NSLog(@"shareArr:%@",shareArr);

    _detailLabel.text = [NSString stringWithFormat:@"分享人数 %lu  评论次数 %@  来源于：共享",(unsigned long)shareArr.count, [cItem.Properties objectForKey:@"comment_num"]];
    
    NSString *timeStr;
    if ([cItem.LastChangedTime length] >= 19) {
        timeStr = [cItem.LastChangedTime substringToIndex:19];
    }
    else {
        timeStr = cItem.LastChangedTime;
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"更新于 %@",timeStr];
    
    
}


@end
