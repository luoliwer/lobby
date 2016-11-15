//
//  BaseAlertView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/23.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "CommonAlertView.h"
#import "SettingView.h"

@interface CommonAlertView ()
{
    
}
@end

@implementation CommonAlertView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.frame;
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self show];
    }
    return self;
}

- (void)setBackAlpah:(CGFloat)backAlpah
{
    _backAlpah = backAlpah;
    if (_backColor) {
        self.backgroundColor = [_backColor colorWithAlphaComponent:_backAlpah];
    } else {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:_backAlpah];
    }
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    
    self.backgroundColor = [_backColor colorWithAlphaComponent:_backAlpah];
}

- (void)setView:(UIView *)view
{
    CGFloat screenW = SCREEN_WIDTH;
    CGFloat screenH = SCREEN_HEIGHT;
    
    if (_view) {//移除原来的视图
        [UIView animateWithDuration:0.0 animations:^{
            _view.frame = CGRectMake((screenW - _view.frame.size.width) / 2, -screenH, _view.frame.size.width, _view.frame.size.width);
        } completion:^(BOOL finished) {
            [_view removeFromSuperview];
            _view = nil;
        }];
        
    }
    _view = view;
    
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    
    _view.frame = CGRectMake((screenW - width) / 2, screenH, width, height);
    
    [self addSubview:_view];
    
    [UIView animateWithDuration:0.0 animations:^{
        view.frame = CGRectMake((screenW - width) / 2, (screenH - height) / 2, width, height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    UIView *windowView = [UIApplication sharedApplication].keyWindow;

    [windowView addSubview:self];
}

- (void)close:(UIButton *)sender
{
//    if (_isAutoClose) {
        [self removeFromSuperview];
//    }
}

- (void)close
{
//    if (_isAutoClose) {
        [self removeFromSuperview];
//    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [super setFrame:frame];
}

@end
