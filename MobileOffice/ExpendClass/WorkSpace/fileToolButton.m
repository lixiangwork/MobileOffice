//
//  fileToolButton.m
//  MobileOffice
//
//  Created by MacAir2 on 15/6/18.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "fileToolButton.h"

#define KFont 12
#define KImageWith 24
#define KImageHeight 24
#define KTitleHeight 15
#define kTitleWith 64

@implementation fileToolButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //设置文字
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:KFont];
        //设置图片
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, KImageHeight+7, kTitleWith, KTitleHeight);
}

-(CGRect )imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(20, 7, KImageWith, KImageHeight);
    
}


@end
