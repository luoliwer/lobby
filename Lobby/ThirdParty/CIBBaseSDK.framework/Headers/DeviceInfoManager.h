//
//  DeviceInfoManager.h
//  libCibForNonByod
//
//  Created by 陈宇劢 on 15/10/21.
//  Copyright © 2015年 cib. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kDeviceIdKey = @"DeviceIdKey";

@interface DeviceInfoManager : NSObject

+ (NSString *)getDeviceId;

+ (NSString *)getDeviceType;

+ (NSString *)getSystemVersion;

@end
