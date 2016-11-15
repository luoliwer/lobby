//
//  CommonUtils.m
//
//
//  Created by Yangchao on 15/7/14.
//  Copyright (c) 2015年 Yangchao. All rights reserved.
//

#import "CommonUtils.h"
#import "Branch.h"

@implementation CommonUtils

+ (instancetype)sharedInstance{
    static CommonUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        _currentBranch = [[Branch alloc] init];
        _callRuleGroupOfBranch = [NSArray array];
    }
    return self;
}

+ (NSDictionary *)praseJsonStringToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
