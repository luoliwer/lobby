//
//  LockView.m
//
//
//  Created by CIB-Mac mini on 14-12-31.
//  Copyright (c) 2014年 cib. All rights reserved.
//

#import "LockView.h"
#import "LockViewController.h"

#define kBaseCircleNumber 10000       // tag基数（请勿修改）
//#define kCircleMargin 0.0             // 圆点离屏幕左边距
//#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
//#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
//改动
#define kCircleDiameter 80.0            // 圆点直径
#define kCircleMargin 40.0            // 圆点直径
//改动
#define kCircleAlpha 1.0              // 圆点透明度
//改动
#define kLineWidth 7.0               // 线条宽
#define kLineColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8] // 线条色白色
#define kLineColorWrong [UIColor colorWithRed:255/255.0 green:11/255.0 blue:0.0 alpha:0.8] // 线条色红
//改动
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface LockView ()
{
    NSMutableArray* buttonArray;
    NSMutableArray* selectedButtonArray;
    NSMutableArray* wrongButtonArray;
    CGPoint nowPoint;
    NSTimer* timer;
    BOOL isWrongColor;
    BOOL isDrawing; // 正在画中
}

@end

@implementation LockView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (void)initCircles
{
    
    buttonArray = [NSMutableArray array];
    selectedButtonArray = [NSMutableArray array];
    
    
    // 初始化圆点
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 每个圆点位置
        int x = kCircleMargin * (i % 3) + kCircleDiameter * (i % 3);
        int y = kCircleMargin * (i / 3) + kCircleDiameter * (i / 3);
        
        [button setFrame:CGRectMake(x, y, kCircleDiameter, kCircleDiameter)];
        [button setBackgroundColor:[UIColor clearColor]];
        if ([GlobleData  sharedInstance].isModify) {
            [button setBackgroundImage:[UIImage imageNamed:@"ic_modify_normal"] forState:UIControlStateSelected];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateSelected];
        }
        button.userInteractionEnabled= NO;//禁止用户交互
        button.layer.cornerRadius = kCircleDiameter/2;
        button.layer.masksToBounds = kCircleDiameter/2;
        if ([GlobleData sharedInstance].isModify) {
            [button setBackgroundColor:UIColorFromRGB(0x5a5a5a)];
        }else{
            [button setBackgroundColor:UIColorFromRGB(0x013a57)];
        }
        
        button.alpha = 0.7;
        button.tag = i + kBaseCircleNumber; // tag从基数+1开始,
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  // 开始绘制手势
{
    isDrawing = NO;
    // 如果是错误色才重置(timer重置过了)
    if (isWrongColor) {
        [self clearColorAndSelectedButton];
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDrawing = YES;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  // 绘制手势结束
{
    [self endPosition];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event  // 取消绘制手势
{
    [self endPosition];
}


#pragma mark - 绘制连线
- (void)drawRect:(CGRect)rect
{
    if (selectedButtonArray.count > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if ([GlobleData sharedInstance].isModify) {
            isWrongColor ? [kLineColorWrong set] : [UIColorFromRGB(0xa7aaab) set]; // 正误线条色
        }else{
            isWrongColor ? [kLineColorWrong set] : [kLineColor set]; // 正误线条色
        }
        CGContextSetLineWidth(context, kLineWidth);
        

        // 画之前线
        CGPoint addLines[9];
        int count = 0;
        for (UIButton* button in selectedButtonArray) {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
            
            // 画中心圆
            // 改动
            CGRect circleRect = CGRectMake(button.center.x - 16,
                                           button.center.y - 16,
                                           32,
                                           32);
            CGContextSetFillColorWithColor(context, kLineColor.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
         //*/
        
        // 画当前线
        UIButton *lastButton = selectedButtonArray.lastObject;
        CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
        CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
        CGContextStrokePath(context);
    }
    
}

#pragma mark - 处理
// 当前手指位置
- (void)updateFingerPosition:(CGPoint)point{
    
    nowPoint = point;
    
    for (UIButton *thisbutton in buttonArray) {
        CGFloat xdiff =point.x-thisbutton.center.x;
        CGFloat ydiff=point.y - thisbutton.center.y;
        
        if (fabs(xdiff) < 36 &&fabs (ydiff) < 36) {
            // 未选中的才能加入
            if (!thisbutton.selected) {
                thisbutton.selected = YES;
                [selectedButtonArray addObject:thisbutton];
            }
        }
    }
    [self setNeedsDisplay];
    
//    [self addstring]; // 可以用来划完后自动解锁，不用松开手指
}

- (void)endPosition
{
    isDrawing = NO;
    
    UIButton *strbutton;
    NSString *string;// = @"";
    
    // 生成密码串
    NSMutableArray *selectedIndexs = [[NSMutableArray alloc] init];
    for (int i = 0; i < selectedButtonArray.count; i++) {
        strbutton = selectedButtonArray[i];
        //string= [string stringByAppendingFormat:@"%ld%@",strbutton.tag - kBaseCircleNumber, ARRAY_SEPARATOR];
        [selectedIndexs addObject:[NSNumber numberWithLong:(strbutton.tag - kBaseCircleNumber)]];  // 为了兼容老版本的string
    }
    
#ifdef LOCK_PWD_WITH_SEPARATOR
    string = [selectedIndexs componentsJoinedByString:@","];  // 为了兼容老版本的string（逗号分隔）
#else
    string = [selectedIndexs componentsJoinedByString:@""];
#endif
    
    [self clearColorAndSelectedButton]; // 清除到初始样式
    
    if ([self.delegate respondsToSelector:@selector(lockString:)]) {
        if (string && string.length>0) {
            [self.delegate lockString:string];
        }
    }
    
//    [self addstring]; // 委托上一界面去处理
}

// 清除至初始状态
- (void)clearColor
{
    if (isWrongColor) {
        // 重置颜色
        isWrongColor = NO;
        for (UIButton* button in buttonArray) {
            if ([GlobleData  sharedInstance].isModify) {
                [button setBackgroundImage:[UIImage imageNamed:@"ic_modify_normal"] forState:UIControlStateSelected];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateSelected];
            }
        }
        
    }
}

- (void)clearSelectedButton
{
    // 换到下次按时再弄
    for (UIButton *thisButton in buttonArray) {
        [thisButton setSelected:NO];
    }
    [selectedButtonArray removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)clearColorAndSelectedButton
{
    if (!isDrawing) {
        
        [self clearColor];
        [self clearSelectedButton];
    }
    
}

#pragma mark - 生成密码
-(void)addstring{
    
}

#pragma mark - 显示错误
- (void)showErrorCircles:(NSString *)string
{
    isWrongColor = YES;
    
#ifdef LOCK_PWD_WITH_SEPARATOR  // 兼容老版本的string（逗号分隔）
    NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    NSArray *arr = [string componentsSeparatedByString:@","];
    for (int i = 0; i < [arr count]; i++) {
        NSNumber *number = [NSNumber numberWithInt:((NSString *)arr[i]).intValue]; // 数字是0开始的
        [numbers addObject:number];
        [buttonArray[number.intValue] setSelected:YES];
        
        [selectedButtonArray addObject:buttonArray[number.intValue]];
    }
#else
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue]; // 数字是0开始的
        [numbers addObject:number];
        [buttonArray[number.intValue] setSelected:YES];
        
        [selectedButtonArray addObject:buttonArray[number.intValue]];
    }
#endif
    
    for (UIButton* button in buttonArray) {
        if (button.selected) {
            if ([GlobleData  sharedInstance].isModify) {
                [button setBackgroundImage:[UIImage imageNamed:@"ic_modify_wrong"] forState:UIControlStateSelected];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"wrong"] forState:UIControlStateSelected];
            }
        }
        
    }
    
    [self setNeedsDisplay];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(clearColorAndSelectedButton)
                                           userInfo:nil
                                            repeats:NO];
    
}


@end
