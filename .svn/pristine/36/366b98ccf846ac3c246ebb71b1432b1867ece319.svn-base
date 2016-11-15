//
//  FingerWorkManager.m
//  baseSDK
//
//  Created by AveryChen on 14-9-17.
//  Copyright (c) 2014年 cib. All rights reserved.
//

#import "FingerWorkManager.h"
#import "SFHFKeychainUtils.h"
#import "CONST.h"

@interface FingerWorkManager()

/**
*  设置本地手势口令剩余可验证次数
*
*  @param fingerWorkRemainTestTimes 手势口令剩余可验证次数
*
*  @return 是否设置成功标识（YES/NO）
*/
+ (BOOL)setFingerWorkRemainTestTimes:(NSInteger)fingerWorkRemainTestTimes;

/**
 *  检查本地手势口令是否已达到失败次数上限
 *
 *  @return 是否达到上限标识（YES/NO）
 */
+ (BOOL)isFingerWorkRemainZeroTestTimes;

@end

@implementation FingerWorkManager

+(BOOL)isFingerWorkExisted{
    return [SFHFKeychainUtils getPasswordForUsername:LOGIN_FINGER_WORK andServiceName:LOGIN_SERVICE error:nil] != nil;
}

+ (BOOL)setFingerWork:(NSString *)fingerWorkString{
    BOOL isSetSucceeded =  [SFHFKeychainUtils storeUsername:LOGIN_FINGER_WORK andPassword:fingerWorkString forServiceName:LOGIN_SERVICE updateExisting:YES error:nil];
    if (isSetSucceeded) {//设置手势口令成功时，将剩余可验证次数置为最大可验证次数
        [FingerWorkManager setFingerWorkRemainTestTimes:MAX_FINGER_WORK_TEST_TIMES];
    }
    return isSetSucceeded;
}

+ (BOOL)verifyFingerWork:(NSString *)fingerWorkString{
    BOOL isVerifySucceeded = [[SFHFKeychainUtils getPasswordForUsername:LOGIN_FINGER_WORK andServiceName:LOGIN_SERVICE error:nil] isEqualToString:fingerWorkString];
    if (!isVerifySucceeded) {//验证手势口令不成功时，将剩余可验证次数减一
        NSInteger remainTestTimes = [FingerWorkManager getFingerWorkRemainTestTimes];
        remainTestTimes--;
        [FingerWorkManager setFingerWorkRemainTestTimes:remainTestTimes];
        if (remainTestTimes <= 0) {
            [self clearFingerWork];
        }
    }
    else {
        [FingerWorkManager setFingerWorkRemainTestTimes:MAX_FINGER_WORK_TEST_TIMES];
    }
    return isVerifySucceeded;
}

+ (BOOL)clearFingerWork{
    [FingerWorkManager setFingerWorkRemainTestTimes:0];
    return [SFHFKeychainUtils deleteItemForUsername:LOGIN_FINGER_WORK andServiceName:LOGIN_SERVICE error:nil];
}

+ (BOOL)setFingerWorkRemainTestTimes:(NSInteger)fingerWorkRemainTestTimes{
    return [SFHFKeychainUtils storeUsername:LOGIN_FINGER_WORK_TEST_TIMES andPassword:[NSString stringWithFormat: @"%ld", (long)fingerWorkRemainTestTimes] forServiceName:LOGIN_SERVICE updateExisting:YES error:nil];
}

+ (NSInteger)getFingerWorkRemainTestTimes{
    NSString *remainTimes = [SFHFKeychainUtils getPasswordForUsername:LOGIN_FINGER_WORK_TEST_TIMES andServiceName:LOGIN_SERVICE error:nil];
    if (remainTimes || ![remainTimes isEqualToString:@""]) {
        return [remainTimes intValue];
    } else {
        return 0;
    }
    
}

+ (BOOL)isFingerWorkRemainZeroTestTimes{
    return [FingerWorkManager getFingerWorkRemainTestTimes] == 0;
}

@end
