//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"

#define Weekdays @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]

//#define viewWidth 260
//#define viewHeight 255

static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0];
        self.date = date;
        
        [self setupTitleBar];
//        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        [self setCurrentDate:self.date];
    }
    self.layer.cornerRadius=10.0;
    
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[[UIColor colorWithRed:167/255.0 green:170/255.0 blue:171/255.0 alpha:1.0] CGColor];
    
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerView)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

- (UIView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 0)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.clipsToBounds = YES;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 32, 20)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 52, 10, 32, 20)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(selectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:okButton];
        
        [_datePickerView addSubview:self.datePicker];
    }
    
    [self addSubview:_datePickerView];
    
    return _datePickerView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        CGRect frame = _datePicker.frame;
        frame.origin = CGPointMake(0, 32);
        _datePicker.frame = frame;
    }
    
    return _datePicker;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"yyyy年 MM月"];
    }
    NSString* date1=[dateFormattor stringFromDate:date];
    return date1;
}

// 设置上层的titleBar
- (void)setupTitleBar {
    
    UIColor *backgroundColor =[UIColor colorWithRed:36/255.0 green:52/255.0 blue:78/255.0 alpha:1.0];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 48)];
    titleView.backgroundColor=backgroundColor;
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 32, 32)];
    [leftButton setImage:[UIImage imageNamed:@"btnPopLeft"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 37, 10, 32, 32)];
    [rightButton setImage:[UIImage imageNamed:@"btnPopRight"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 48)];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleButton.center = titleView.center;
    [titleButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
    
    titleView.layer.cornerRadius=10.0;
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 48-10, DeviceWidth, 10)];
    tempView.backgroundColor=backgroundColor;
    [titleView addSubview:tempView];
    
}


// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 48, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
//    self.scrollView.backgroundColor=[UIColor colorWithRed:167/255.0 green:170/255.0 blue:171/255.0 alpha:1.0];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x > self.scrollView.frame.size.width) {
        [self setNextMonthDate];
    } else {
        [self setPreviousMonthDate];
    }
}

- (void)showDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.4;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 250);
    }];
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setCurrentDate:[self.centerCalendarItem nextMonthDate]];
}

- (void)showDatePicker {
    [self showDatePickerView];
}

// 选择当前日期
- (void)selectCurrentDate {
    [self setCurrentDate:self.datePicker.date];
    [self hideDatePickerView];
}

- (void)cancelSelectCurrentDate {
    [self hideDatePickerView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCalendarItems];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - FDCalendarItemDelegate
- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    
   [self setCurrentDate:self.date];
    
    //选择日期的回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshWithData:weekDay:)]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:1];
        NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:self.date];
        long week =firstComponents.weekday-1;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];

        NSString* selectDate=[formatter stringFromDate:self.date];
        NSString* weekString = @"";
        switch (week) {
            case 0:
                weekString=@"星期日";
                break;
            case 1:
                weekString=@"星期一";
                break;
            case 2:
                weekString=@"星期二";
                break;
            case 3:
                weekString=@"星期三";
                break;
            case 4:
                weekString=@"星期四";
                break;
            case 5:
                weekString=@"星期五";
                break;
            case 6:
                weekString=@"星期六";
                break;
            default:
                break;
        }
        
        
        
        [self.delegate refreshWithData:selectDate weekDay:weekString];
        
    }
}
+(NSString *)getWeekday:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    long week =firstComponents.weekday-1;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString* selectDate=[formatter stringFromDate:self.date];
    NSString* weekString = @"";
    switch (week) {
        case 0:
            weekString=@"星期日";
            break;
        case 1:
            weekString=@"星期一";
            break;
        case 2:
            weekString=@"星期二";
            break;
        case 3:
            weekString=@"星期三";
            break;
        case 4:
            weekString=@"星期四";
            break;
        case 5:
            weekString=@"星期五";
            break;
        case 6:
            weekString=@"星期六";
            break;
        default:
            break;
    }
    return weekString;
}
-(void) showCalendarWithClickControl:(UIControl*) clickControl inView:(UIView*) mainView{
    CGPoint ponit =clickControl.frame.origin;
    CGPoint toPoint = [mainView convertPoint:ponit fromView:clickControl.superview];
    CGRect frame = self.frame;
    CGFloat x = toPoint.x+clickControl.frame.size.width-self.frame.size.width;
    frame.origin.x= x < 0 ? 10 : x;
    frame.origin.y = toPoint.y+clickControl.frame.size.height+2;
    self.frame = frame;
    [mainView addSubview:self];
}
+(int) compareWithDate:(NSString*) dateStr anthorDate:(NSString*) anthorDayStr{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDate* oneDate = [dateFomatter dateFromString:dateStr];
    NSDate* anthorDate =[dateFomatter dateFromString:anthorDayStr];
    
   NSComparisonResult result =  [oneDate compare:anthorDate];
    if(result== NSOrderedDescending){
        return 1;
    }else if(result==NSOrderedAscending){
        return -1;
    }else{
        return 0;
    }
    
}
@end
