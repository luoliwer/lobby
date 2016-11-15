//
//  PhotoDisplayView.m
//  SmartHall
//
//  Created by YangChao on 30/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import "PhotoDisplayView.h"

static float viewWidth = 600;
static float viewHeight = 450;

@interface PhotoDisplayView ()
{
    DisplayBlock _hander;
    UILabel *_messageLb;
    UIImageView *_imageView;
    UIView *contentView;
}
@end

@implementation PhotoDisplayView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        self.layer.cornerRadius = 5;
        [self initView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initView
{
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, (SCREEN_HEIGHT - height) / 2, width, height)];
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    contentView.layer.cornerRadius = 4;
    [self addSubview:contentView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, width - 30, height - 95)];
    _imageView.layer.borderColor = [BorderColor CGColor];
    _imageView.layer.borderWidth = BorderWidth;
    _imageView.image = [UIImage imageNamed:@"defaultUserIcon"];
    [contentView addSubview:_imageView];
    
    _messageLb = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_imageView.frame), width - 30, 80)];
    _messageLb.backgroundColor = [UIColor clearColor];
    _messageLb.textColor = [UIColor whiteColor];
    _messageLb.textAlignment = NSTextAlignmentCenter;
    _messageLb.font = K_FONT_16;
    _messageLb.text = @"林小姐";
    [contentView addSubview:_messageLb];
    
    
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLb.text = message;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    contentView.frame = CGRectMake((SCREEN_WIDTH - viewWidth) / 2, (SCREEN_HEIGHT - viewHeight) / 2, viewWidth, viewHeight);
    _imageView.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, viewWidth - 30, viewHeight - 95);
    _messageLb.frame = CGRectMake(15, CGRectGetMaxY(_imageView.frame), viewWidth - 30, 80);
    _imageView.image = icon;
}

- (void)close:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)show{
    UIView *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    if (_hander) {
        _hander(self);
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [super setFrame:frame];
}

- (void)displayPhotoHandle:(DisplayBlock)display
{
    _hander = display;
    [self show];
}

@end
