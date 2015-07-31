//
//  LocalFileVCCell.m
//  MobileOffice
//
//  Created by houjing on 15/6/11.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "LocalFileVCCell.h"

@implementation LocalFileVCCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString* thefileName = [_fileName pathExtension];
    
    if ([thefileName isEqualToString:@"doc"] || [thefileName isEqualToString:@"docx"]) {
        _iconImageView.image = [UIImage imageNamed:@"doc.png"];
    }
    else if ([thefileName isEqualToString:@"xls"] || [thefileName isEqualToString:@"xlsx"]) {
        _iconImageView.image = [UIImage imageNamed:@"xls.png"];
    }
    else if ([thefileName isEqualToString:@"ppt"] || [thefileName isEqualToString:@"pptx"]) {
        _iconImageView.image = [UIImage imageNamed:@"ppt.png"];
    }
    else if ([thefileName isEqualToString:@"png"] || [thefileName isEqualToString:@"JPG"] ||  [thefileName isEqualToString:@"jpg"] || [thefileName isEqualToString:@"jpeg"]) {
        _iconImageView.image = [UIImage imageNamed:@"img.png"];
    }
    else if ([thefileName isEqualToString:@"pdf"]) {
        _iconImageView.image = [UIImage imageNamed:@"pdf.png"];
    }
    else if ([thefileName isEqualToString:@"txt"]){
        
        _iconImageView.image = [UIImage imageNamed:@"txt.png"];
    }
    else{
        _iconImageView.image = [UIImage imageNamed:@"unknow.png"];
    }

    _titleLabel.text = _fileName;
}

@end
