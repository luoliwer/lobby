//
//  LoginManager.h
//  libCibForNonByod
//
//  Created by 陈宇劢 on 15/10/21.
//  Copyright © 2015年 cib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (void)loginWithUsername:(NSString *)username
              andPassword:(NSString *)password
                onSuccess:(void(^)(NSString* responseCode, NSString* responseInfo))success
                onFailure:(void(^)(NSString* responseCode, NSString* responseInfo))failure;

@end
