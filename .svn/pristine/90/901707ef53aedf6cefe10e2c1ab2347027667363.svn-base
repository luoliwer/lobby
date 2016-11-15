//
//  LogoutView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/25.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "LogoutView.h"

@implementation LogoutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (IBAction)logout:(id)sender
{
    [self dismiss];
    _logoutEvent();
}

- (IBAction)cancel:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self.superview removeFromSuperview];
}
@end
