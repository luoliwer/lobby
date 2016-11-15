//
//  ViewController.m
//  SwySplitControllerDemo
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 Swy. All rights reserved.
//

#import "SwySplitViewController.h"

@interface SwySplitViewController ()
{
    UIViewController *_masterController;
    UIViewController *_detailVc;
    
    BOOL _annimate;
}
@end

@implementation SwySplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化默认值
    _splitWidth = 0;
    _splitPosition = 208;
}

- (void)setControllers:(NSArray *)controllers
{
    _controllers = controllers;
    
    int i = 0;
    for (UIViewController *controller in _controllers) {
        
        [self addChildViewController:controller];
        
        if (i == 0) {
            
            _masterController = controller;
            [self.view addSubview:_masterController.view];
        }
        
        i++;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    
    if (_detailVc) {
        [_detailVc.view removeFromSuperview];
    }
    
    id controller = [self.controllers objectAtIndex:selectedIndex];
    _detailVc = controller;
    [self.view addSubview:_detailVc.view];
    
    [self layoutSubviews];
}

//设置左边宽度
- (void)setSplitPosition:(CGFloat)splitPosition
{
    _splitPosition = splitPosition;
    
    [self layoutSubviews];
}

- (void)setSplitWidth:(CGFloat)splitWidth
{
    _splitWidth = splitWidth;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGRect screen = [UIScreen mainScreen].bounds;
    
    _masterController.view.frame = CGRectMake(0, K_STATUS_BAR_HEIGHT, _splitPosition, screen.size.height - K_STATUS_BAR_HEIGHT);
    
    if (_annimate) {//动画展示
        _detailVc.view.frame = CGRectMake(_splitPosition + _splitWidth, screen.size.height, screen.size.width - _splitPosition - _splitWidth, screen.size.height - K_STATUS_BAR_HEIGHT);
        
        [UIView animateWithDuration:0.0 animations:^{
            _detailVc.view.frame = CGRectMake(_splitPosition + _splitWidth, K_STATUS_BAR_HEIGHT, screen.size.width - _splitPosition - _splitWidth, screen.size.height - K_STATUS_BAR_HEIGHT);
        }];
    } else {//第一次进入，不需要动画
        _detailVc.view.frame = CGRectMake(_splitPosition + _splitWidth, K_STATUS_BAR_HEIGHT, screen.size.width - _splitPosition - _splitWidth, screen.size.height - K_STATUS_BAR_HEIGHT);
        _annimate = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
