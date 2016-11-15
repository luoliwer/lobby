//
//  ChartView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/7.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "ChartView.h"

#define leftPadding 68
#define rightPadding 30
#define topPadding 72
#define bottomPadding 53

@interface ChartView ()
{
    NSArray *_numbers;
    CGPoint _currentPoint;
    NSInteger _currentTimeIndex;
    BOOL _showValue;
}
@end

@implementation ChartView

- (instancetype)init
{
    if (self = [super init]) {
        _currentTimeIndex = -1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _numbers = @[@"0", @"25", @"50", @"100"];
    
//    for (CALayer *layer in self.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
    //获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [self backgroundGradient:context rect:rect];
    
    //画线
    [self drawLine:context rect:rect];
    
    //画底部时间栏
    [self drawTimeX:context rect:rect];
    
    //画左侧数值栏
    [self drawNumY:context rect:rect];
    
    //根据数据画出相应的折线图
    [self drawChart:context rect:rect];
    
    //画指示线
    [self drawWarnLine:context rect:rect];
}

- (void)backgroundGradient:(CGContextRef)context rect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //颜色分量
    CGFloat components[] = {0.59, 0.82, 0.97, 1.0, 0.92, 0.97, 1.0, 1.0};

    //颜色位置
    CGFloat locations[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(leftPadding, 0), CGPointMake(leftPadding, rect.size.height - bottomPadding), kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//画线
- (void)drawLine:(CGContextRef)context rect:(CGRect)rect
{
    CGFloat height = (rect.size.height - topPadding - bottomPadding) / 3;
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColorFromRGB(0xbcbebf) CGColor]);
    
    //画虚线
    CGFloat lenghts[] = {10, 5};
    CGContextSetLineDash(context, 0.0, lenghts, 2);
    CGContextMoveToPoint(context, leftPadding, topPadding);
    CGContextAddLineToPoint(context, rect.size.width - rightPadding, topPadding);
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0.0, lenghts, 2);
    CGContextMoveToPoint(context, leftPadding, topPadding + height);
    CGContextAddLineToPoint(context, rect.size.width - rightPadding, topPadding + height);
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0.0, lenghts, 2);
    CGContextMoveToPoint(context, leftPadding, topPadding + 2 * height);
    CGContextAddLineToPoint(context, rect.size.width - rightPadding, topPadding + 2 * height);
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextMoveToPoint(context, leftPadding, topPadding + 3 * height);
    CGContextAddLineToPoint(context, rect.size.width - rightPadding, topPadding + 3 * height);
    CGContextStrokePath(context);
}

//画底部时间
- (void)drawTimeX:(CGContextRef)context rect:(CGRect)rect
{
    //线宽
    CGFloat width = (rect.size.width - leftPadding - rightPadding) / _bottomValues.count;
    
    int i = 0;
    for (NSString *item in _bottomValues) {
        UIColor *foreColor = UIColorFromRGB(0xa7aaab);
        if (_currentTimeIndex == i) {
            foreColor = UIColorFromRGB(0xafe9345);
        }
        NSDictionary *attribute = @{NSForegroundColorAttributeName:foreColor, NSFontAttributeName:K_FONT_13};
        CGPoint point = CGPointMake(leftPadding + width * i - 15, rect.size.height - 41);
        [item drawAtPoint:point withAttributes:attribute];
        
        i++;
    }
}

- (void)drawNumY:(CGContextRef)context rect:(CGRect)rect
{
    //线宽
    CGFloat height = (rect.size.height - topPadding - bottomPadding) / (_numbers.count - 1);
    
    NSInteger i = _numbers.count;
    for (NSString *item in _numbers) {
        UIColor *foreColor = UIColorFromRGB(0xa7aaab);
        NSDictionary *attribute = @{NSForegroundColorAttributeName:foreColor, NSFontAttributeName:K_FONT_13};
        CGPoint point = CGPointMake(30, topPadding + height * (i - 1) - 20);
        [item drawAtPoint:point withAttributes:attribute];
        
        i--;
    }
}

- (void)drawChart:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextSetStrokeColorWithColor(context, [UIColorFromRGB(0x96d1f9) CGColor]);
    CGContextSetLineWidth(context, 2);
    CGFloat width = (rect.size.width - leftPadding - rightPadding) / _bottomValues.count;
    
    CGFloat height = rect.size.height - bottomPadding;//显示的最低位置
    
    int i = 0;
    for (NSNumber *item in _ticketsNumbers) {
        int num = [item intValue];
        
        CGFloat pointY = height - (55.0 / 25) * num;
        if (num > 50) {
            pointY = height - (55.0 / 50) * (num - 50) - (55.0 / 25) * 50;
        }
        if (pointY < 35) {
            pointY = 35;
        }
        CGFloat pointX = width * i + leftPadding;
        if (i == 0) {
            CGContextMoveToPoint(context, pointX, pointY);
        } else {
            CGContextAddLineToPoint(context, pointX, pointY);
        }
        
        i++;
    }
    [[UIColor clearColor] setFill];
    CGContextAddLineToPoint(context, leftPadding + i * width, height - 20);
    CGContextDrawPath(context, kCGPathStroke);
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    //颜色分量
//    CGFloat components[] = {0.59, 0.82, 0.97, 1.0, 0.92, 0.97, 1.0, 1.0};
//    
//    //颜色位置
//    CGFloat locations[] = {0.0, 1.0};
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(leftPadding, height), CGPointMake(leftPadding, topPadding), kCGGradientDrawsAfterEndLocation);
    
}

- (void)drawWarnLine:(CGContextRef)context rect:(CGRect)rect
{
    if (!_showValue) {
        return;
    }
    //划线
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColorFromRGB(0xfe9142) CGColor]);
    CGFloat y = _currentPoint.y + 60;
    if (y > rect.size.height - bottomPadding) {
        y = rect.size.height - bottomPadding - 5;
    }
    CGContextMoveToPoint(context, _currentPoint.x, _currentPoint.y - 60);
    CGContextAddLineToPoint(context, _currentPoint.x, y);
    CGContextDrawPath(context, kCGPathStroke);
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(_currentPoint.x - 1, _currentPoint.y - 60, 2, y - _currentPoint.y + 60);
//    
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
//                       (id)[UIColor redColor].CGColor,
//                       (id)[UIColor whiteColor].CGColor,nil];
//    [self.layer addSublayer:gradient];
    
    //小圆环
    CGFloat centx = _currentPoint.x;
    CGFloat centy = _currentPoint.y;
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColorFromRGB(0xfe9142) CGColor]);
    CGContextAddArc(context, centx, centy, 5, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //填充白色
    CGContextAddArc(context, centx, centy, 4, 0, 2 * M_PI, 0);
    [[UIColor whiteColor] set];
    CGContextDrawPath(context, kCGPathFill);
    
    //画蓝色视图
    CGFloat rowH = 25;
    CGFloat rowW = 40;
    CGFloat padding = 10;
    CGFloat arrowH = 5;
    CGContextSetStrokeColorWithColor(context, [RGB(234, 234, 234, 1.0) CGColor]);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextMoveToPoint(context, _currentPoint.x, _currentPoint.y - padding);
    CGContextAddLineToPoint(context, _currentPoint.x - arrowH, _currentPoint.y - padding - arrowH);
    CGContextAddLineToPoint(context, _currentPoint.x - rowW / 2, _currentPoint.y - padding - arrowH);
    CGContextAddLineToPoint(context, _currentPoint.x - rowW / 2, _currentPoint.y - rowH - padding);
    CGContextAddLineToPoint(context, _currentPoint.x + rowW / 2, _currentPoint.y - rowH - padding);
    CGContextAddLineToPoint(context, _currentPoint.x + rowW / 2, _currentPoint.y - padding - arrowH);
    CGContextAddLineToPoint(context, _currentPoint.x + arrowH, _currentPoint.y - padding - arrowH);
    CGContextClosePath(context);
    [RGB(0, 138, 246, 1.0) set];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    int num = [_ticketsNumbers[_currentTimeIndex] intValue];
    NSString *str = [NSString stringWithFormat:@"%d", num];
    NSDictionary *attribute = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:K_FONT_16};
    CGSize strSize = [str sizeWithAttributes:attribute];
    CGPoint startPoint = CGPointMake(_currentPoint.x - strSize.width / 2, _currentPoint.y - padding - (rowH - strSize.height + arrowH) / 2 - strSize.height);
    [str drawAtPoint:startPoint withAttributes:attribute];
}

- (void)setBottomValues:(NSArray *)bottomValues
{
    _bottomValues = bottomValues;
    
    [self setNeedsDisplay];
}

- (void)setTicketsNumbers:(NSArray *)ticketsNumbers
{
    _ticketsNumbers = ticketsNumbers;
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _showValue = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self confirmCenter:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self confirmCenter:touchPoint];
}

- (void)confirmCenter:(CGPoint)touchPoint
{
    CGFloat width = (self.frame.size.width - leftPadding - rightPadding) / _bottomValues.count;
    CGFloat height = self.frame.size.height - bottomPadding;//显示的最低位置
    if (touchPoint.x > leftPadding && touchPoint.x < _ticketsNumbers.count * width + leftPadding) {
        _currentTimeIndex = floor(((touchPoint.x - leftPadding) / width));
        
        CGFloat x = _currentTimeIndex * width + leftPadding;
        int num = [_ticketsNumbers[_currentTimeIndex] intValue];
        CGFloat y = height - (55.0 / 25) * num;
        if (num > 50) {
            y = height - (55.0 / 50) * (num - 50) - (55.0 / 25) * 50;
        }
        if (y < 35) {
            y = 35;
        }
        _currentPoint = CGPointMake(x, y);
        
        [self setNeedsDisplay];
    }
}

@end
