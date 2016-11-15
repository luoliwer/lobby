//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FDCalendarDelegate;
@protocol FDCalendarDelegate <NSObject>

- (void)refreshWithData:(NSString *)selectdate weekDay:(NSString *)weekDay;

@end

@interface FDCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;
@property (weak, nonatomic) id<FDCalendarDelegate> delegate;

/*
 显示日历
    clickControl:触发显示日历的空间  （如：点击开始日期按钮）
    mainView  日历view 的父视图
 */
-(void) showCalendarWithClickControl:(UIControl*) clickControl inView:(UIView*) mainView;
+(NSString *)getWeekday:(NSDate *)date;
+(int) compareWithDate:(NSString*) dateStr anthorDate:(NSString*) anthorDay;
@end
