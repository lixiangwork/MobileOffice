//
//  LXSegmentView.h
//  LXSegmentViewDemo
//
//  Created by MacAir2 on 15/6/2.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXSegmentViewDelegate <NSObject>

- (void) lxSegmentViewTurnTabWithCurrentIndex:(NSInteger)currentIndex;

@end

@interface LXSegmentView : UIView<UIScrollViewDelegate>

@property (assign, nonatomic) id<LXSegmentViewDelegate>delegate;

@property (strong, nonatomic) UIImageView *tabBgImageView;
@property (strong, nonatomic) UIColor *tabButtonColor;
@property (strong, nonatomic) UIColor *tabButtonSelectCorlor;
@property (strong, nonatomic) UIImageView *tabButtonSeclectImageView;

@property (nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) UIScrollView *mainScrollView;


@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;

- (void)setTabButton1Title:(NSString *)title1 andButton2Title:(NSString *)title2 andButton3Title:(NSString *)title3;

@end
