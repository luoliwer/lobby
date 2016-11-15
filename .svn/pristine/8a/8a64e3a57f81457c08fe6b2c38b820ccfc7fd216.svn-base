//
//  ModifyTapGestureView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/4/7.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockView.h"
#import "LockConfig.h"
#import "GlobleData.h"

// 进入此界面时的不同目的
typedef enum {
    LockViewTypeCheck,  // 检查手势密码
    LockViewTypeCreate, // 创建手势密码
    LockViewTypeModify, // 修改
    LockViewTypeClean,  // 清除
} LockViewType;
@interface ModifyTapGestureView : UIView<LockDelegate>

@property (nonatomic) LockViewType nLockViewType; // 此窗口的类型
@property (nonatomic, copy) void(^succeededBlock)();  // 操作成功时的回调
@property (nonatomic, copy) void(^failBlock)();  // 操作失败（Check、Modify、Clean时多次输入原手势失败）时的回调(注：操作失败时已自动清除原有手势)
@property (nonatomic, copy) void(^testTimesIsNilBlock)(); // 当尝试次数为空时的回调
@property (nonatomic, assign) BOOL isCreatingPsw; // 判断是不是正在修改手势密码
@property (nonatomic, assign) BOOL isModifyPsw; // 判断是不是进入的修改手势页面

- (id)initWithType:(LockViewType)type; // 直接指定方式打开
- (id)initWithType:(LockViewType)type user:(NSString *)user; // 直接指定方式打开，且当前用户为user

@end
