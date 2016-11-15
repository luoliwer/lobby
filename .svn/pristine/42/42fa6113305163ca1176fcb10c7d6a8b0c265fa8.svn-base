//
//  CustomIndicatorView.h
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/5.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IndicatorViewAnimateStyleRotate,
} IndicatorViewAnimateStyle;

@interface CustomIndicatorView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) IndicatorViewAnimateStyle animateStyle;
@property (nonatomic, readonly) BOOL isAnimating;

+ (instancetype)sharedView;
- (void)showInView:(UIView *)view;
- (void)startAnimating;
- (void)stopAnimating;

@end
