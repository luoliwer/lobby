//
//  QueueInfoEntity.h
//  SmartHall
//
//  Created by YangChao on 22/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//  队列信息实体类

#import <Foundation/Foundation.h>

@interface Queue : NSObject

@property (nonatomic, copy) NSString *queueID;
@property (nonatomic, copy) NSString *queueName;
@property (nonatomic, copy) NSString *queueNum;
@property (nonatomic, copy) NSString *waitTime;

@end
