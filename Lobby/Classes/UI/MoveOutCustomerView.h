//
//  MoveOutCustomerView.h
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/25.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveOutCustomerView : UIView

@property (nonatomic, strong) void (^moveoutCustomer)(MoveOutCustomerView *moveOutView);

@end
