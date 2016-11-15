//
//  LoginViewController.h
//  SmartHall
//
//  Created by YangChao on 21/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockViewController.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) LockViewController *lockVc; // 解锁界面
@end
