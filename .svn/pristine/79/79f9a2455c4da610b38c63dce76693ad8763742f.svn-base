//
//  FDCalendarItem.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceWidth 260
#define Weekdays1 @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]
#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]
#define CollectionViewHorizonMargin 23
#define CollectionViewVerticalMargin 15
#define itemWidth (DeviceWidth - CollectionViewHorizonMargin * 2) / 7
#define itemHeight itemWidth

@protocol FDCalendarItemDelegate;
@interface FDCalendarCell : UICollectionViewCell

- (UILabel *)dayLabel;
- (UILabel *)chineseDayLabel;

@end
@interface FDCalendarItem : UIView

@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) id<FDCalendarItemDelegate> delegate;

- (NSDate *)nextMonthDate;
- (NSDate *)previousMonthDate;

@end

@protocol FDCalendarItemDelegate <NSObject>

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date;

@end
