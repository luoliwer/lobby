//
//  DateHomeController.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/10/10.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "DateHomeController.h"
#import "FDCalendar.h"
#import "DateCustCell.h"
#import "PublicAppointmentView.h"
#import "PrivateAppointmentView.h"
#import "CommonAlertView.h"
#import "ListView.h"
#import "CommonUtils.h"
#import "Branch.h"
#import "DateInfo.h"
#import "CustomIndicatorView.h"
#import "AppDelegate.h"
#import "Public.h"

typedef enum : NSInteger {
    DateQueyTypeAuto,
    DateQueyTypeManual,
} DateQueyType; //通过设置查询方式 来更改对应查询条件显示

@interface DateHomeController ()<FDCalendarDelegate,UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    FDCalendar* startCalendar;
    FDCalendar* endCalendar;
    NSDate *_beginDate;
    NSDate *_endDate;
    
    ListView *_listView;
    //分页变量
    NSInteger currentPage;
    NSInteger totalPages;
    NSInteger perpageNum;
    
    NSMutableArray *_dates;
    
    NSArray *_dateTypes;
    NSArray *_statusTypes;
    
    NSDictionary *_dateTypeDic;
    NSDictionary *_statusTypeDic;
    
    //查询条件变量
    NSString *_dqdh;
    NSString *_jgdh;
    NSString *_czgn;
    NSString *_ywlxjh;
    NSString *_ywztjh;
    NSString *_qssj;
    NSString *_jzsj;
    NSString *_cxym;
    
    //是否展示动画效果
    BOOL _showAnimation;
    BOOL _needReloadDates;//是否需要重新加载数据
}

@property (nonatomic, assign) DateQueyType queryType;

@property (weak, nonatomic) IBOutlet UILabel *leftDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightWeekLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *handleTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UITableView *datesListTable;

//控件约束变量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTypeBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleTypeBtnWidthContraint;

@end

NSString *HasNewDatesNotification = @"HasNewDates";

@implementation DateHomeController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDates:) name:@"DatesQuery" object:nil];
        //设置默认的值
        _dates = [[NSMutableArray alloc] init];
        [self initQueryCondition];
    }
    
    return self;
}

- (void)loadDates:(NSNotification *)t
{
    [self clearDataAndCatchDatesFirst:YES queryType:[NSNumber numberWithInteger:DateQueyTypeAuto]];
}

- (void)initQueryCondition
{
    _dateTypes = @[@{@"11,13,14":@"全部"},
                   @{@"11":@"对公预约"},
                   @{@"13":@"对私人民币预约"},
                   @{@"14":@"对私外币预约"}
                   ];
    _statusTypes = @[@{@"1,2,4,6,7,8,9":@"全部"},
                    @{@"1":@"未受理"}
                    ];
    _showAnimation = YES;
    
    perpageNum = 10;
    currentPage = 1;
    
    //初始化时间
    _endDate = [NSDate date];
    NSTimeInterval inteval = [_endDate timeIntervalSince1970];
    _beginDate = [NSDate dateWithTimeIntervalSince1970:(inteval - 7*24*3600)];
    
    //设置状态选择
    _statusTypeDic = _statusTypes[1];
    _dateTypeDic = _dateTypes[0];
    
    _handleTypeBtnWidthContraint.constant = 80;
    _handleTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    _handleTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 20);
    
    _dateTypeBtnWidthConstraint.constant = 70;
    _dateTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    _dateTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 20);
}

- (void)initControl
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [dateFormatter stringFromDate:_endDate];
    NSString *beginDateStr = [dateFormatter stringFromDate:_beginDate];
    _leftDateLabel.text = beginDateStr;
    _rightDateLabel.text = endDateStr;
    //初始化星期
    _rightWeekLabel.text =  [FDCalendar getWeekday:_endDate];
    _leftWeekLabel.text = [FDCalendar getWeekday:_beginDate];
    
    NSString *value = [[_dateTypeDic allValues] firstObject];
    [_dateTypeBtn setTitle:value forState:UIControlStateNormal];
    NSString *statusValue = [[_statusTypeDic allValues] firstObject];
    [_handleTypeBtn setTitle:statusValue forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控件中的显示值
    [self initControl];
    
    //添加手势处理
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    [self initTimer];
}

//初始化定时器，开始是停止执行
- (void)initTimer
{
    //获取代理
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //获取代理中的定时器，并初始化
    delegate.dateTimer = [NSTimer scheduledTimerWithTimeInterval:[GlobleData sharedInstance].timeInterval target:self selector:@selector(loadSechue:) userInfo:@{@"loadType":[NSNumber numberWithInteger:DateQueyTypeAuto]} repeats:YES];
    //默认其开始时不执行，停止定时器
    [delegate.dateTimer setFireDate:[NSDate distantFuture]];
}

/*
 *  启动定时器
 */
- (void)startTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.dateTimer) {
        [delegate.dateTimer setFireDate:[NSDate distantPast]];
    }
}

/*
 *  停止定时器
 */
- (void)stopTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.dateTimer) {
        [delegate.dateTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)loadSechue:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    NSNumber *typeNumber = userInfo[@"loadType"];
    
    _datesListTable.userInteractionEnabled = NO;
    
    [self initQueryCondition];
    
    [self initControl];
    
    [self clearDataAndCatchDatesFirst:NO queryType:typeNumber];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_needReloadDates) {
        
        [self showAnimation:YES];
        //初始化控件显示的值
        [self initControl];
        //调接口
        [self clearDataAndCatchDatesFirst:NO queryType:[NSNumber numberWithInteger:DateQueyTypeAuto]];
    } else {
        //停止定时器
        [self stopTimer];
        //间隔时间后开始定时器
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:[GlobleData sharedInstance].timeInterval];
    }
    
    _needReloadDates = YES;
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _needReloadDates = YES;
    
    //初始化查询条件
    [self initQueryCondition];
}

#pragma mark -- 日期选择事件
- (IBAction)startDateAction:(id)sender
{
    if (_listView) {
        [_listView removeFromSuperview];
    }
    if(!startCalendar){
        startCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] ]];
        startCalendar.delegate=self;
        [startCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        startCalendar.hidden=NO;
    }
}

- (IBAction)endDateAction:(id)sender
{
    if (_listView) {
        [_listView removeFromSuperview];
    }
    if(!endCalendar){
        endCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
        endCalendar.delegate=self;
        [endCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        endCalendar.hidden=NO;
    }
}

#pragma mark -- 条件查询预约
- (IBAction)search:(UIButton *)sender
{
    //按钮不可用
    sender.userInteractionEnabled = NO;
    //停止定时器
    [self stopTimer];
    //刷新时间间隔后 定时器打开 执行循环功能
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:[GlobleData sharedInstance].timeInterval];
    _showAnimation = YES;
    [self showAnimation:_showAnimation];
    //清空原数组
    [self clearDataAndCatchDatesFirst:NO queryType:[NSNumber numberWithInteger:DateQueyTypeManual]];
}

#pragma mark -- 加载数据动画展示
- (void)showAnimation:(BOOL)show
{
    if (show) {
        CustomIndicatorView *indicatorView = [CustomIndicatorView sharedView];
        [indicatorView showInView:self.view];
        [indicatorView startAnimating];
    }
}

- (void)stopAnimation
{
    if ([[CustomIndicatorView sharedView] isAnimating]) {
        [[CustomIndicatorView sharedView] stopAnimating];
    }
}

#pragma mark --FDCalendarDelegate
- (void)refreshWithData:(NSString *)date weekDay:(NSString *)weekDay{
    
    NSDateFormatter *newmatter = [[NSDateFormatter alloc] init];
    [newmatter setDateFormat:@"yyyy-MM-dd"];
    
    //判断日期是否大于今天
    NSString *todayStr = [newmatter stringFromDate:[NSDate date]];
    
    NSComparisonResult compare = [FDCalendar compareWithDate:date anthorDate:todayStr];
    
    if (compare == NSOrderedDescending) {
        [self showAlert:@"查询日期不能大于今天"];
        return;
    }

    //设置时间间隔限制
    NSDate *end = [newmatter dateFromString:self.rightDateLabel.text];
    NSDate *start = [newmatter dateFromString:date];
    if ([end timeIntervalSince1970] - [start timeIntervalSince1970] > 30 * 24 * 3600) {
        [self showAlert:@"查询起始截止时间间隔不能超过30天"];
        return;
    }

    if(startCalendar && startCalendar.hidden == NO){
        
        //验证日期大小
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.rightDateLabel.text];
        if(compareResult == 1){
            [self showAlert:@"开始日期不能大于结束日期"];
            return;
        }
        
        //设置时间间隔限制
        NSDate *end = [newmatter dateFromString:self.rightDateLabel.text];
        NSDate *start = [newmatter dateFromString:date];
        if ([end timeIntervalSince1970] - [start timeIntervalSince1970] > 30 * 24 * 3600) {
            [self showAlert:@"查询起始截止时间间隔不能超过30天"];
            return;
        }
        
        self.leftDateLabel.text=date;
        self.leftWeekLabel.text=weekDay;
        [self performSelector:@selector(hideCalendar:) withObject:startCalendar afterDelay:0.2];
    }else if(endCalendar && endCalendar.hidden == NO){
        //验证日期大小
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.leftDateLabel.text];
        if(compareResult == -1){
            [self showAlert:@"开始日期不能大于结束日期"];
            return;
        }
        
        //设置时间间隔限制
        NSDate *end = [newmatter dateFromString:date];
        NSDate *start = [newmatter dateFromString:self.leftDateLabel.text];
        if ([end timeIntervalSince1970] - [start timeIntervalSince1970] > 30 * 24 * 3600) {
            [self showAlert:@"查询起始截止时间间隔不能超过30天"];
            return;
        }
        
        self.rightDateLabel.text=date;
        self.rightWeekLabel.text=weekDay;
        [self performSelector:@selector(hideCalendar:) withObject:endCalendar afterDelay:0.2];
    }
}
-(void) hideCalendar:(FDCalendar*) calendar{
    calendar.hidden=YES;
}
-(void) showAlert:(NSString *)msg {
    if (iOS8OrLater) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:nil];
    } else {
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Handling Touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL isExist = NO;
    if(startCalendar && startCalendar.hidden==NO){
        CGPoint p = [touch locationInView:self.view];
        CGRect rect = [startCalendar.superview convertRect:startCalendar.frame toView:self.view];
        if(CGRectContainsPoint(rect, p)){
            return NO;
        }
        isExist=YES;
    }
    
    if(endCalendar && endCalendar.hidden==NO){
        CGPoint p1 = [touch locationInView:self.view];
        CGRect rect1 = [endCalendar.superview convertRect:endCalendar.frame toView:self.view];
        if(CGRectContainsPoint(rect1, p1)){
            return NO;
        }
        isExist=YES;
    }
    if(isExist){
        if(startCalendar){
            startCalendar.hidden=YES;
        }
        if(endCalendar){
            endCalendar.hidden=YES;
        }
        return YES;
    }
    
    if (_listView) {
        
        CGPoint p = [touch locationInView:self.view];
        
        CGRect rectInList = _listView.frame;
        
        if (CGRectContainsPoint(rectInList, p)) {
            
        } else {
            [_listView removeFromSuperview];
        }
    }
    
    return NO;
}

// 将yyyyMMdd格式的日期转化成yyyy-MM-dd格式的日期
- (NSString *)dateFormatterTransfer:(NSString *)dateString{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDateFormatter *newmatter = [[NSDateFormatter alloc] init];
    [newmatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [newmatter stringFromDate:date];
    return dateStr;
    
}
// 将yyyy-MM-dd格式的日期转化成yyyyMMdd格式的日期
- (NSString *)dateTransfer:(NSString *)dateStr{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSDateFormatter *newmatter = [[NSDateFormatter alloc] init];
    [newmatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [newmatter stringFromDate:date];
    return dateString;
    
}

#pragma mark -- ListView 下拉框选择

- (IBAction)dateTypeListSelected:(UIButton *)sender
{
    //初始化
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }
    _listView = [[ListView alloc] init];
    
    __block NSInteger tag = sender.tag;

    __block DateHomeController *weakSelf = self;
    CGFloat x = CGRectGetMaxX(sender.frame);
    CGFloat y = CGRectGetMaxY(sender.frame);
    _listView.frame = CGRectMake(x, y + 5, 120, 200);
    
    NSString *selected = _dateTypeBtn.titleLabel.text;
    _listView.selectedValue = selected;
    _listView.listItems = _dateTypes;
    
    _listView.listViewSelectedValue = ^(NSDictionary *val) {
        [weakSelf selectedValueToButton:tag value:val];
    };
    
    [self.view addSubview:_listView];
}

- (IBAction)HandleTypelistSelected:(UIButton *)sender
{
    //初始化
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }
    _listView = [[ListView alloc] init];
    
    __block NSInteger tag = sender.tag;
    __block DateHomeController *weakSelf = self;
    CGFloat x = CGRectGetMaxX(sender.frame);
    CGFloat y = CGRectGetMaxY(sender.frame);
    _listView.frame = CGRectMake(x, y + 5, 70, 100);
    NSString *selected = _handleTypeBtn.titleLabel.text;
    _listView.selectedValue = selected;
    _listView.listItems = _statusTypes;
    
    _listView.listViewSelectedValue = ^(NSDictionary *val) {
        [weakSelf selectedValueToButton:tag value:val];
    };
    
    [self.view addSubview:_listView];
}

- (void)selectedValueToButton:(NSInteger)tag value:(NSDictionary *)val
{
    NSString *value = [[val allValues] firstObject];
    NSString *key = [[val allKeys] firstObject];
    if (tag == 101) {
        [_dateTypeBtn setTitle:value forState:UIControlStateNormal];
        _dateTypeDic = val;
        if ([key isEqualToString:@"11,13,14"]) {
            _statusTypes = @[@{@"1,2,4,6,7,8,9":@"全部"},
                             @{@"1":@"未受理"}
                             ];
        } else if ([key isEqualToString:@"11"]) {
            _statusTypes = @[@{@"1,2,4,6,7,8,9":@"全部"},
                             @{@"1":@"未受理"},
                             @{@"2":@"已受理"},
                             @{@"4":@"已作废"},
                             @{@"6":@"审核通过"},
                             @{@"7":@"审核不通过"},
                             @{@"8":@"审核不通过并修改"},
                             @{@"9":@"处理中"}
                             ];
        } else if ([key isEqualToString:@"13"] || [key isEqualToString:@"14"]) {
            _statusTypes = @[@{@"1,2,4,6,7,9":@"全部"},
                             @{@"1":@"未受理"},
                             @{@"2":@"提取完成"},
                             @{@"4":@"客户放弃"},
                             @{@"6":@"已备钞待提取"},
                             @{@"7":@"无法满足客户需求"},
                             @{@"9":@"正在备钞"}
                             ];
        } 
    } else if (tag == 102) {
        [_handleTypeBtn setTitle:value forState:UIControlStateNormal];
        _statusTypeDic = val;
    }
    
    //更改按钮的宽度
    [self changeButtonWidthWithTag:tag buttonTitle:value];
    //将下拉视图移除父视图
    [_listView removeFromSuperview];
}

//根据Tag值 来判断改变的按钮
//根据title 判断按钮的宽度 然后改变对应Button的约束
- (void)changeButtonWidthWithTag:(NSUInteger)tag buttonTitle:(NSString *)title
{
    CGSize contentSize = [Public sizeOfString:title withFont:K_FONT_15];
    CGFloat width = (contentSize.width < 40) ? contentSize.width + 30 : contentSize.width + 18;
    if (tag == 101) {//预约类型
        _dateTypeBtnWidthConstraint.constant = width;
        _dateTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width - 16, 0, 0);
        _dateTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
    } else if (tag == 102) {//处理状态类型
        _handleTypeBtnWidthContraint.constant = width;
        _handleTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width - 16, 0, 0);
        _handleTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
    }
}

#pragma mark -- UITableViewDataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dates.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"DateCell";
    DateCustCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DateCustCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DateInfo *date = _dates[indexPath.section];
    cell.date = date;
    
    cell.detailOrHandleEvent = ^(DateCustCell *someOneCell){
        if ([someOneCell.date.businessType isEqualToString:@"11"]) {
            PublicAppointmentView *publicView = (PublicAppointmentView *)[[[NSBundle mainBundle] loadNibNamed:@"PublicAppointmentView" owner:nil options:nil] firstObject];
            DateInfo *selectedDate = someOneCell.date;
            NSArray *pra = @[COM_INSTANCE.currentBranch.areaCode, COM_INSTANCE.currentBranch.branchCode, selectedDate.businessType, selectedDate.dateNO];
            publicView.pragrames = pra;
            
            CommonAlertView *baseView = [[CommonAlertView alloc] init];
            baseView.view = publicView;
            [baseView show];
        } else {
            PrivateAppointmentView *privateView = (PrivateAppointmentView *)[[[NSBundle mainBundle] loadNibNamed:@"PrivateAppointmentView" owner:nil options:nil] firstObject];
            DateInfo *selectedDate = someOneCell.date;
            NSArray *pra = @[COM_INSTANCE.currentBranch.areaCode, COM_INSTANCE.currentBranch.branchCode, selectedDate.dateNO];
            privateView.date = selectedDate;
            privateView.UpdateDatesInTableView = ^(DateInfo *d) {
                someOneCell.date = d;
            };
            privateView.pragrames = pra;
            CommonAlertView *baseView = [[CommonAlertView alloc] init];
            baseView.view = privateView;
            [baseView show];
        }
    };
    
    return cell;
}

#pragma mark -- 接口数据处理

- (void)clearDataAndCatchDatesFirst:(BOOL)isFirst queryType:(NSNumber *)type
{
    @synchronized (self) {
        [_dates removeAllObjects];
        [_datesListTable reloadData];
        currentPage = 1;
        
        [self allDates:isFirst queryType:type];
    }
}

- (void)allDates:(BOOL)isFist queryType:(NSNumber *)type
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    //调用数据接口
    _dqdh = COM_INSTANCE.currentBranch.areaCode;
    _jgdh = COM_INSTANCE.currentBranch.branchCode;
    _czgn = @"1";
    _ywlxjh = [[_dateTypeDic allKeys] firstObject];
    _ywztjh = [[_statusTypeDic allKeys] firstObject];
    if (isFist) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        _qssj = [dateFormatter stringFromDate:_beginDate];
        _jzsj = [dateFormatter stringFromDate:_endDate];
    } else {
        _qssj = [self.leftDateLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _jzsj = [self.rightDateLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    _cxym = [NSString stringWithFormat:@"%ld", (long)currentPage];
    
    [paramDic setObject:_dqdh forKey:@"dqdh"];
    [paramDic setObject:_jgdh forKey:@"jgdh"];
    [paramDic setObject:_czgn forKey:@"czgn"];
    [paramDic setObject:_ywlxjh forKey:@"ywlxjh"];
    [paramDic setObject:_ywztjh forKey:@"ywztjh"];
    [paramDic setObject:@"" forKey:@"zjlx"];
    [paramDic setObject:@"" forKey:@"zjhm"];
    [paramDic setObject:@"" forKey:@"sjhm"];
    [paramDic setObject:_qssj forKey:@"qssj"];
    [paramDic setObject:_jzsj forKey:@"jzsj"];
    [paramDic setObject:_cxym forKey:@"cxym"];
    
    __block DateHomeController *blockSelf = self;
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        _datesListTable.userInteractionEnabled = YES;
        
        if (_showAnimation) {
            [blockSelf stopAnimation];
        }
        
        _searchBtn.userInteractionEnabled = YES;
        
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [blockSelf showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        _datesListTable.userInteractionEnabled = YES;
        
        _searchBtn.userInteractionEnabled = YES;
        
        if (_showAnimation) {
            [blockSelf stopAnimation];
        }
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSDictionary *result = [responseInfo valueForKey:@"result"];
                NSArray *datesArray = [result valueForKey:@"bsInfoGroup"];
                NSString *totalpage = [result valueForKey:@"zym"];
                totalPages = [totalpage integerValue];
                
                if ([datesArray count] > 0) {
                    currentPage ++;
                    for (NSDictionary *dic in datesArray) {
                        DateInfo *date = [[DateInfo alloc] init];
                        date.dateNO = dic[@"yybh"];
                        date.cardType = dic[@"zjlx"];
                        date.cardNum = dic[@"zjhm"];
                        date.businessType = dic[@"ywlx"];
                        date.dateStatus = dic[@"yyzt"];
                        date.custName = dic[@"khmc"];
                        date.phoneNum = dic[@"yysj"];
                        date.dateArea = dic[@"yydq"];
                        date.dateBranch = dic[@"yyjg"];
                        date.accountShot = dic[@"zhdh"];
                        date.createTime = dic[@"cjsj"];
                        date.dateTime = dic[@"yysj"];
                        
                        [_dates addObject:date];
                    }
                    if (currentPage <= totalPages) {
                        [blockSelf allDates:NO queryType:type];
                    } else {
                        if (!self.topInWindow) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:HasNewDatesNotification object:nil];
                            _needReloadDates = NO;
                        }
                        //对返回数据排序
                        [_dates sortUsingComparator:^NSComparisonResult(DateInfo *obj1, DateInfo *obj2) {
                            return [obj2.dateNO compare:obj1.dateNO];
                        }];
                        
//                        if ([type integerValue] == DateQueyTypeAuto) {//如果是自动刷新
//                            
//                            [blockSelf initControl];
//                        }
                        
                        [_datesListTable reloadData];
                    }
                } else {
                    [_datesListTable reloadData];
                }
            }
        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
            
            if (_showAnimation) {
                [blockSelf stopAnimation];
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
    [InvokeManager invokeApi:@"otojcxx" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
