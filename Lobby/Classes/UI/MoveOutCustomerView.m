//
//  MoveOutCustomerView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/25.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "MoveOutCustomerView.h"

@implementation MoveOutCustomerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (IBAction)logout:(id)sender
{
    if (_moveoutCustomer) {
        _moveoutCustomer(self);
    }
    [self dismiss];
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
