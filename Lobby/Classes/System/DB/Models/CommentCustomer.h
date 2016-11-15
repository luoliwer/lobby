//
//  CommentCustomer.h
//  Lobby
//
//  Created by CIB-MacMini on 16/4/18.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentCustomer : NSObject
@property(nonatomic,copy) NSString *teller_name; //柜员姓名
@property(nonatomic,copy) NSString *teller_num; //柜员编号
@property(nonatomic,copy) NSString *customer_name; //客户姓名
@property(nonatomic,copy) NSString *access_stauts; //评价结果
@property(nonatomic,copy) NSString *process_status; //处理状态
@property(nonatomic,copy) NSString *transfer_num; //转移次数
@property(nonatomic,copy) NSString *lastmoddate; //最后修改时间
@property(nonatomic,copy) NSString *process_end; //处理结果
@property(nonatomic,copy) NSString *not_satify_reason; //问题归类
@property(nonatomic,copy) NSString *work_date; //日期
@property(nonatomic,copy) NSString *queue_num; //排队号
@property(nonatomic,copy) NSString *customer_tel; //客户电话
@property(nonatomic,copy) NSString *remark; //备注


@end
