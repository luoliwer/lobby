//
//  UIImage+Resizable.m
//  LCWeibo
//
//  Created by 罗冲 on 15-4-14.
//  Copyright (c) 2015年 companyName. All rights reserved.
//

#import "UIImage+Resizable.h"

@implementation UIImage (Resizable)

/**
 *  获得一个图片的中部可拉伸图片
 *
 *  @param name 图片名
 *
 *  @return 中部可拉伸图片
 */
+ (UIImage *)resizableImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

/**
 *  获得一个图片的中部可拉伸图片
 *
 *  @param name 图片名
 *
 *  @return 中部可拉伸图片
 */
- (UIImage *)resizableImage
{
    CGFloat w = self.size.width * 0.5;
    CGFloat h = self.size.height * 0.5;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

/**
 *  获得一个图片的指定拉伸位置的可拉伸图片
 *
 *  @param name 图片名
 *  @param x    横向位置比例
 *  @param y    纵向位置比例
 *
 *  @return 可拉伸图片
 */
+ (UIImage *)resizableImageNamed:(NSString *)name withX:(CGFloat)x andY:(CGFloat)y
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat t = image.size.height * y;
    CGFloat l = image.size.width * x;
    CGFloat b = image.size.height * (1 - y);
    CGFloat r = image.size.width * (1 - x);
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(t, l, b, r)];
}

/**
 *  转为指定拉伸位置的可拉伸图片
 *
 *  @param name 图片名
 *  @param x    横向位置比例
 *  @param y    纵向位置比例
 *
 *  @return 可拉伸图片
 */
- (UIImage *)resizableImageWithX:(CGFloat)x andY:(CGFloat)y
{
    CGFloat t = self.size.height * y;
    CGFloat l = self.size.width * x;
    CGFloat b = self.size.height * (1 - y);
    CGFloat r = self.size.width * (1 - x);
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(t, l, b, r)];
}
@end
