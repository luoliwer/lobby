//
//  InvokeManager.h
//  libCibForNonByod
//
//  Created by 陈宇劢 on 15/10/21.
//  Copyright © 2015年 cib. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kNoUriErrorCode = @"-1";
static NSString *kNoConnectionErrorCode = @"-2";
static NSString *kNoMethodErrorCode = @"-3";

@interface InvokeManager : NSObject

+ (void)invokeApi:(NSString *)uri
       withMethod:(NSString *)method
     andParameter:(NSDictionary *)parameter
        onSuccess:(void(^)(NSString* responseCode, NSString* responseInfo))success
        onFailure:(void(^)(NSString* responseCode, NSString* responseInfo))failure;

@end
