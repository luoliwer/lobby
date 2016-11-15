//
//  DateInfo.h
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/10/12.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateInfo : NSObject

@property (nonatomic, copy) NSString *dateNO;//预约编号
@property (nonatomic, copy) NSString *cardType;//证件类型
@property (nonatomic, copy) NSString *cardNum;//证件号码
@property (nonatomic, copy) NSString *businessType;//业务类型
@property (nonatomic, copy) NSString *dateStatus;//预约状态
@property (nonatomic, copy) NSString *handleStatus;//操作状态
@property (nonatomic, copy) NSString *custName;//操作状态
@property (nonatomic, copy) NSString *phoneNum;//客户手机
@property (nonatomic, copy) NSString *dateArea;//预约地区
@property (nonatomic, copy) NSString *dateBranch;//预约机构
@property (nonatomic, copy) NSString *accountShot;//账户代号
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *dateTime;//预约时间

@end
