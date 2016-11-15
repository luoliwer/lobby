//
//  CustomIndicatorView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/5.
//  Copyright © 2016年 swy. All rights reserved.
//

static CGFloat width = 36;
static CGFloat height = 38;

#import "CustomIndicatorView.h"

@interface CustomIndicatorView ()
{
    UIImageView *_imageView;
    UIView *_containView;
}

@end

@implementation CustomIndicatorView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, width, height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"loading"]];
        [self addSubview:_imageView];
        
        [self performSelector:@selector(stopViewAnimating) withObject:nil afterDelay:AFN_TIMEOUT_SECONDS];
    }
    return self;
}

+ (instancetype)sharedView
{
    static CustomIndicatorView *sharedView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[CustomIndicatorView alloc] init];
    });
    return sharedView;
}

- (void)showInView:(UIView *)view
{
    if (self.superview == view) {
        [self removeFromSuperview];
    }
    
    _containView = view;
    [_containView addSubview:self];
    
    [_containView bringSubviewToFront:self];
    
    [self layoutSubviews];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageView.image = image;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = _containView.bounds.size.width;
    CGFloat h = _containView.bounds.size.height;
    self.frame = CGRectMake((w -self.bounds.size.width) / 2, (h -self.bounds.size.height) / 2, self.bounds.size.width, self.bounds.size.height);
    _imageView.frame = CGRectMake((self.frame.size.width - width) / 2, (self.frame.size.height - height) / 2, width, height);
}

- (void)startAnimating
{
    if (self.isAnimating) {
        [self stopAnimating];
        [self.layer removeAllAnimations];
    }
    _isAnimating = YES;
    if (_animateStyle == IndicatorViewAnimateStyleRotate) {
        
        [self rotate:0];
    }
}

- (void)stopAnimating
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
        self.alpha = 1;
        _isAnimating = NO;
        _containView = nil;
        [self removeFromSuperview];
    }];
}

//当接口未能访问成功时，AFN_TIMEOUT_SECONDS时间后，停止动画，并从父视图中移除。
- (void)stopViewAnimating
{
    if (_isAnimating) {
        [self.layer removeAllAnimations];
        self.alpha = 1;
        _isAnimating = NO;
        _containView = nil;
        [self removeFromSuperview];
    }
}

- (void)rotate:(CGFloat)startAngle
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 3;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    rotationAnimation.fromValue = @(startAngle);
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.toValue = @(M_PI * 2  + startAngle);
    [self.layer addAnimation:rotationAnimation forKey:@"keyFrameAnimation"];
}

@end
