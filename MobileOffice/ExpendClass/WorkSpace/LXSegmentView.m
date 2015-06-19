//
//  LXSegmentView.m
//  LXSegmentViewDemo
//
//  Created by MacAir2 on 15/6/2.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "LXSegmentView.h"

@implementation LXSegmentView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _tabBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 42)];
        [self addSubview:_tabBgImageView];
        
        //
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.tag = 1;
        [_button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button1 setFrame:CGRectMake(0, 0, frame.size.width/3, 40)];
        [_button1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        _button1.selected = YES;
        [self addSubview:_button1];
        
        //
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.tag = 2;
        [_button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button2 setFrame:CGRectMake(frame.size.width/3, 0, frame.size.width/3, 40)];
        [_button2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self addSubview:_button2];
        
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button3.tag = 3;
        [_button3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button3 setFrame:CGRectMake((frame.size.width*2)/3, 0, frame.size.width/3, 40)];
        [_button3.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self addSubview:_button3];

        
        _tabButtonSeclectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, frame.size.width/3, 4)];
        [self addSubview:_tabButtonSeclectImageView];
        
        ///
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, frame.size.width, frame.size.height-42)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
        _mainScrollView.contentSize = CGSizeMake(frame.size.width*3, frame.size.height-42);
        _mainScrollView.delegate = self;
        [self addSubview:_mainScrollView];
        
        ///
        _currentIndex = 0;


    }
    
    return self;
}

#pragma mark - set
- (void)setTabButtonColor:(UIColor *)tabButtonColor{
    
    if (_tabButtonColor != tabButtonColor) {
        _tabButtonColor = tabButtonColor;
        
        [_button1 setTitleColor:_tabButtonColor forState:UIControlStateNormal];
        [_button2 setTitleColor:_tabButtonColor forState:UIControlStateNormal];
        [_button3 setTitleColor:_tabButtonColor forState:UIControlStateNormal];
    }
}

- (void)setTabButtonSelectCorlor:(UIColor *)tabButtonSelectCorlor
{
    if (_tabButtonSelectCorlor != tabButtonSelectCorlor) {
        _tabButtonSelectCorlor = tabButtonSelectCorlor;
        
        [_button1 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateSelected];
        [_button2 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateSelected];
        [_button3 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateSelected];
        
        [_button1 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateHighlighted];
        [_button2 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateHighlighted];
        [_button3 setTitleColor:_tabButtonSelectCorlor forState:UIControlStateHighlighted];
    }
}

- (void)setTabButton1Title:(NSString *)title1 andButton2Title:(NSString *)title2 andButton3Title:(NSString *)title3{
    [_button1 setTitle:title1 forState:UIControlStateNormal];
    [_button1 setTitle:title1 forState:UIControlStateSelected];
    
    [_button2 setTitle:title2 forState:UIControlStateNormal];
    [_button2 setTitle:title2 forState:UIControlStateSelected];
    
    [_button3 setTitle:title3 forState:UIControlStateNormal];
    [_button3 setTitle:title3 forState:UIControlStateSelected];
    
}

#pragma mark srocllTabButton

- (void)scrolltabButtonSeclectImageViewAndSelectButtonForIndex:(NSInteger)buttonIndex
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        
        [_tabButtonSeclectImageView removeFromSuperview];
        
        
        _tabButtonSeclectImageView.frame = CGRectMake(buttonIndex * (self.frame.size.width/3), 38, self.frame.size.width/3, 4);
        
        [self addSubview:_tabButtonSeclectImageView];
    }];
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]){
            
            if (btn.tag == (buttonIndex+1)) {
                btn.selected = YES;
            }
            else{
                btn.selected = NO;
            }
        }
        
    }
    //
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button
{
    _currentIndex = button.tag-1;//button.frame.origin.x/(self.frame.size.width/3);
    
    NSLog(@"_currentIndex:%li",(long)_currentIndex);
    NSLog(@"tag:%li",(long)button.tag);
    
    [self scrolltabButtonSeclectImageViewAndSelectButtonForIndex:_currentIndex];
    
    [_mainScrollView scrollRectToVisible:CGRectMake(_currentIndex*self.frame.size.width, 0, self.frame.size.width, _mainScrollView.frame.size.height) animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(lxSegmentViewTurnTabWithCurrentIndex:)]) {
        [self.delegate lxSegmentViewTurnTabWithCurrentIndex:_currentIndex];
    }
}

#pragma mark - UIScrollView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    _currentIndex = scrollView.contentOffset.x/320;
//
//    [self scrolltabButtonSeclectImageViewAndSelectButtonForIndex:_currentIndex];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x/self.frame.size.width;
    
    [self scrolltabButtonSeclectImageViewAndSelectButtonForIndex:_currentIndex];
    
    if ([self.delegate respondsToSelector:@selector(lxSegmentViewTurnTabWithCurrentIndex:)]) {
        [self.delegate lxSegmentViewTurnTabWithCurrentIndex:_currentIndex];
    }

}

@end
