//
//  CommonUtils.h
//
//
//  Created by Yangchao on 15/7/14.
//  Copyright (c) 2015年 Yangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COM_INSTANCE [CommonUtils sharedInstance]

@class Branch;
@interface CommonUtils : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) Branch *currentBranch;

@property (nonatomic, copy) NSString *noteId;

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, strong) NSArray *callRuleGroupOfBranch;

+ (NSDictionary *)praseJsonStringToDictionary:(NSString *)jsonString;

@end
