//
//  FileManager.h
//  libCibForNonByod
//
//  Created by 陈宇劢 on 15/10/21.
//  Copyright © 2015年 cib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (void)downloadImage:(NSString *)uri
        withParameter:(NSDictionary *)parameter
            onSuccess:(void(^)(NSDictionary *responseHeader, NSData *responseBody))success
            onFailure:(void(^)(NSString* responseCode, NSString* responseInfo))failure;

@end
