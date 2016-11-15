//
//  GlobleData.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-10.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface GlobleData : NSObject
    + (GlobleData *) sharedInstance;

@property (nonatomic, assign)BOOL isModify;

@property (nonatomic, strong)NSMutableArray *zjjsArray; //转介角色
@property (nonatomic, strong)NSMutableArray *jhaoArray; //叫号策略
@property (nonatomic, strong)NSMutableArray *clztArray; //差评处理状态
@property (nonatomic, strong)NSMutableArray *cljgArray; //差评处理结果
@property (nonatomic, strong)NSMutableArray *wtglArray; //差评问题归类
@property (nonatomic, strong)NSMutableArray *pjjgArray; //差评评价结果
@property (nonatomic, strong)NSMutableArray *zjmsArray; //转介处理状态
@property (nonatomic, strong)NSMutableArray *xslyArray; //转介线索来源


@property (nonatomic, assign)long timeInterval; //系统刷新时间间隔

@end
