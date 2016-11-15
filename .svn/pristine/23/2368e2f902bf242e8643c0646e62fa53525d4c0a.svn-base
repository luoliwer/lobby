//
//  ComplianceChecks.h
//  ComplianceChecks
//
//  Created by water on 15/7/7.
//  Copyright (c) 2015年 water. All rights reserved.
//

#import <Foundation/Foundation.h>
#define COMLIANCECHECKS @"COMLIANCECHECKS"//合规性检查是否有问题  1有问题  0没有
#define KEY_MDMCERTEXIST @"KEY_MDMCERTEXIST" //mdm 服务是否运行 0没有
#define KEY_SYSTEMJAILBEROKEN @"KEY_SYSTEMJAILBEROKEN"// 系统是否越狱  1越狱
#define KEY_DEVICE_BLACK_APPLIST @"KEY_DEVICE_BLACK_APPLIST"//黑名单  返回数组列表
@interface ComplianceChecks : NSObject

//合规性检查
/*
 @param url: 服务器地址
 @param cibID: 业务服务器对应设备id

 返回值:
 NSMutableDictionary (key可能：COMLIANCECHECKS、KEY_MDMAPPEXIST、KEY_MDMCERTEXIST、KEY_SYSTEMJAILBEROKEN、KEY_DEVICE_BLACK_APPLIST)
 */

+(NSMutableDictionary *)checkPhoneComplianceWithUrl:(NSString *)url
                                              cibID:(NSString *)cibID
                                        isBackStage:(BOOL)backStage;


/*
 返回值:
    NSString  udid
 */

//udid
+(NSString *)returnUdidStr;
@end
