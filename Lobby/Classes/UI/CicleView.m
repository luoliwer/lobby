//
//  CicleView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/31.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "CicleView.h"

@implementation CicleView

- (void)drawRect:(CGRect)rect {
    
    //获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画圆
    [self drawCircle:rect context:context];
}

- (void)drawCircle:(CGRect)rect context:(CGContextRef)context
{
    CGRect newRect = rect;
    //画底层圆 灰色圆环
    CGContextSetLineWidth(context, _strokenWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [_backcolor CGColor]);
    CGFloat radius = MIN(newRect.size.width / 2, newRect.size.height / 2) - 5;
    CGContextAddArc(context, newRect.size.width / 2, newRect.size.height / 2, radius, -M_PI_2 + M_PI / 80, -M_PI_2 + 2 * M_PI - M_PI / 40, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画圆弧
    CGContextSetLineWidth(context, _arcWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [_frontcolor CGColor]);
    CGContextAddArc(context, newRect.size.width / 2, newRect.size.height / 2, radius, -M_PI_2, -M_PI_2 + 2 * M_PI * [_percentVal floatValue], 0);
    CGContextDrawPath(context, kCGPathStroke);
    //圆弧尾端的小圆环
    CGFloat centx = radius + radius * sinf(M_PI - 2 * M_PI * [_percentVal floatValue]) + 5;
    CGFloat centy = radius + radius * cosf(M_PI - 2 * M_PI * [_percentVal floatValue]) + 5;
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [_frontcolor CGColor]);
    CGContextAddArc(context, centx, centy, 4, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    //填充白色
    CGContextAddArc(context, centx, centy, 3, 0, 2 * M_PI, 0);
    [[UIColor whiteColor] set];
    CGContextDrawPath(context, kCGPathFill);
    
    NSDictionary *attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0x5a5a5a), NSFontAttributeName:K_FONT_20};
    NSString *string = [NSString stringWithFormat:@"%.0f%@", [_percentVal floatValue] * 100, @"%"];
    CGSize strSize = [string sizeWithAttributes:attribute];
    CGPoint startPoint = CGPointMake(self.bounds.size.width / 2 - strSize.width / 2, self.bounds.size.height / 2 - strSize.height / 2);
    [string drawAtPoint:startPoint withAttributes:attribute];
}

- (void)setBackcolor:(UIColor *)backcolor
{
    _backcolor = backcolor;
    
    [self setNeedsDisplay];
}

- (void)setFrontcolor:(UIColor *)frontcolor
{
    _frontcolor = frontcolor;
    [self setNeedsDisplay];
}

- (void)setStrokenWidth:(CGFloat)strokenWidth
{
    _strokenWidth = strokenWidth;
    [self setNeedsDisplay];
}

- (void)setArcWidth:(CGFloat)arcWidth
{
    _arcWidth = arcWidth;
    [self setNeedsDisplay];
}

- (void)setPercentVal:(NSString *)percentVal
{
    _percentVal = percentVal;
    
    [self setNeedsDisplay];
}

@end
