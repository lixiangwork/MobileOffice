//
//  FileDetailCell.m
//  Word4S_OA
//
//  Created by MacAir2 on 14-5-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "FileDetailCell.h"

@implementation FileDetailCell

- (void)awakeFromNib
{
    // Initialization code
    //self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self layoutThatContentItems:_item];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - myself

- (void )layoutThatContentItems:(ContentItems *)cItem
{
    if ( ([cItem.MimeType rangeOfString:@"msword"
                                options:NSCaseInsensitiveSearch].location != NSNotFound)
        || ([cItem.MimeType rangeOfString:@"kswps"
                                  options:NSCaseInsensitiveSearch].location != NSNotFound)
        || ([cItem.MimeType rangeOfString:@"wordprocess"
                                  options:NSCaseInsensitiveSearch].location != NSNotFound) ) {
        
        _iconImgView.image = [UIImage imageNamed:@"doc.png"];
    }
    else if (([cItem.MimeType rangeOfString:@"excel"
                                    options:NSCaseInsensitiveSearch].location != NSNotFound)
             || ([cItem.MimeType rangeOfString:@"spreadsheet"
                                       options:NSCaseInsensitiveSearch].location != NSNotFound)) {
        
        _iconImgView.image = [UIImage imageNamed:@"xls.png"];
    }
    else if (([cItem.MimeType rangeOfString:@"ms-powerpoint"
                                    options:NSCaseInsensitiveSearch].location != NSNotFound)
             ||([cItem.MimeType rangeOfString:@"presentation"
                                      options:NSCaseInsensitiveSearch].location != NSNotFound)) {
        
        _iconImgView.image = [UIImage imageNamed:@"ppt.png"];
        
    }
    else if ([cItem.MimeType rangeOfString:@"image"
                                   options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        _iconImgView.image = [UIImage imageNamed:@"img.png"];
    }
    else if ([cItem.MimeType  rangeOfString:@"pdf"
                                    options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        _iconImgView.image = [UIImage imageNamed:@"pdf.png"];
    }
    else if ([cItem.MimeType rangeOfString:@"text"
                                   options:NSCaseInsensitiveSearch].location != NSNotFound){
        
        _iconImgView.image = [UIImage imageNamed:@"txt.png"];
    }
    else{
        _iconImgView.image = [UIImage imageNamed:@"unknow.png"];
    }
    
    _timeLabel.text = [cItem.Properties objectForKey:@"zh_wzbt"];

    
    
    _titleAndSizeLabel.text = [NSString stringWithFormat:@"%@",[cItem.Properties objectForKey:@"zh_wzbt"]];

    NSString *timeStr;
    if ([cItem.LastChangedTime length] >= 19) {
        timeStr = [cItem.LastChangedTime substringToIndex:19];
    }
    else {
        timeStr = cItem.LastChangedTime;
    }
    _timeLabel.text = [NSString stringWithFormat:@"更新于 %@",timeStr];
    
    NSString *creater = [cItem.Properties objectForKey:@"creater"];
    if (!creater) {
        creater = @"无";
    }
    _createrLabel.text = [NSString stringWithFormat:@"创建者：%@",creater];
    
}


@end
