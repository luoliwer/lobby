//
//  NSString+Additions.h
//  IOSDuoduo
//
//  Created by 东邪 on 14-5-23.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Additions)

+(NSString *)documentPath;
+(NSString *)cachePath;
+(NSString *)formatCurDate;
+(NSString *)formatCurDay;
+(NSString *)getAppVer;
- (NSString*)removeAllSpace;
- (NSURL *) toURL;
- (BOOL) isEmail;
- (BOOL) isEmpty;
- (BOOL) isIdCard;
- (NSString *) escapeHTML;
- (NSString *) unescapeHTML;
- (NSString *) stringByRemovingHTML;
- (NSString *) MD5;
- (NSString * )URLEncode;
-(NSString *)trim;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

-(BOOL) isOlderVersionThan:(NSString*)otherVersion;
-(BOOL) isNewerVersionThan:(NSString*)otherVersion;

/*
 * 主要功能：通过文字内容，确定其显示宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;

/*
 * 主要功能：对返回的图片产品路径做可能的异常处理
 */
+ (NSString *)handleProductPictureURLException:(NSString *)productURL;

//时间格式 0150416101814
- (NSDate *)dateFromString;

/**
 *  检测是否包含string(iOS8以下可用)
 *
 *  @param substring 包含的string
 *
 *  @return 是否包含
 */
- (BOOL)containsSubstring:(NSString *)substring;
/**
 *  将多个字符串加分隔符组合成一个字符串
 *
 *  @param substrings     需要组合的字符串数组
 *  @param separateString 分隔符
 *
 *  @return 组合后的字符串
 */
+ (NSString *)stringWithComponents:(NSArray *)substrings separateString:(NSString *)separateString;
/**
 *  计算一个字符串的字节数
 *
 *  @return 字节数
 */
- (NSInteger)bytes;

@end
