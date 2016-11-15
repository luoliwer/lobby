//
//  TransferCheck.h
//  Lobby
//
//  Created by CIB-MacMini on 16/4/21.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferCheck : NSObject
@property(nonatomic,copy)NSString *busi_amount; //交易金额
@property(nonatomic,copy)NSString *clue_date; //线索生成日期
@property(nonatomic,copy)NSString *clue_id; //线索编号
@property(nonatomic,copy)NSString *clue_time; //线索生成时间
@property(nonatomic,copy)NSString *cluesource; //线索来源
@property(nonatomic,copy)NSString *cluetype; //线索类型
@property(nonatomic,copy)NSString *custinfo_name; //客户名称
@property(nonatomic,copy)NSString *lastusercode; //最后处理用户ID
@property(nonatomic,copy)NSString *marketingstatus; //处理状态
@property(nonatomic,copy)NSString *operateuser; //转介发起用户ID
@property(nonatomic,copy)NSString *operateuser_name; //转介发起用户名称
@property(nonatomic,copy)NSString *queue_num; //关联排队号
@property(nonatomic,copy)NSString *referral_bs_id; //转介业务类型ID
@property(nonatomic,copy)NSString *referral_bs_name; //转介业务类型名称
@property(nonatomic,copy)NSString *referraluser; //转介目标用户ID
@property(nonatomic,copy)NSString *referraluser_name; //转介目标用户名称
@property(nonatomic,copy)NSString *remark; //转介发起用户推荐备注
@property(nonatomic,copy)NSString *remark1; //转介目标用户处理备注
@property(nonatomic,copy)NSString *allTime; //把clue_date和clue_time拼接在一起，方便排序

@end
