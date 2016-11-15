//
//  LockViewController.h
//  CIBSafeBrowser
//
//  Created by CIB-Mac mini on 14-12-31.
//  Copyright (c) 2014年 cib. All rights reserved.
//
//
//  解锁控件头文件，使用时包含它即可

#import <UIKit/UIKit.h>
#import "LockView.h"
#import "LockConfig.h"

// 进入此界面时的不同目的
typedef enum {
    LockViewTypeCheck,  // 检查手势密码
    LockViewTypeCreate, // 创建手势密码
    LockViewTypeModify, // 修改
    LockViewTypeClean,  // 清除
} LockViewType;

@interface LockViewController : BaseViewController <LockDelegate>


@property (nonatomic) LockViewType nLockViewType; // 此窗口的类型
@property (nonatomic, strong) NSMutableArray *usrIdMutableArr; //用户id数组
@property (nonatomic, strong) NSMutableArray *stringMutableArr; //用户手势密码数组，与用户id一一对应

@property (nonatomic, copy) void(^succeededBlock)();  // 操作成功时的回调
@property (nonatomic, copy) void(^failBlock)();  // 操作失败（Check、Modify、Clean时多次输入原手势失败）时的回调(注：操作失败时已自动清除原有手势)

- (id)initWithType:(LockViewType)type; // 直接指定方式打开
- (id)initWithType:(LockViewType)type user:(NSString *)user; // 直接指定方式打开，且当前用户为user
- (void)enterMainViewVc; // 手势设置成功后进入到主界面
@end
