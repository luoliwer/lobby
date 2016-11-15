//
//  Station.h
//  SmartHall
//
//  Created by YangChao on 26/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//  工位信息实体类

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, copy) NSString *stationNo;
@property (nonatomic, copy) NSString *currentQueueNum;
@property (nonatomic, copy) NSString *tellerName;
@property (nonatomic, copy) NSString *serverStatus;
@property (nonatomic, copy) NSString *currentCustName;
@property (nonatomic, copy) NSString *serverNum;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *tellerNum;
@property (nonatomic, copy) NSString *qmNum;//排队机编号
@property (nonatomic, copy) NSString *callRule;
@property (nonatomic, copy) NSString *callRuleID;
@property (nonatomic, copy) NSString *queueNum;

@end
