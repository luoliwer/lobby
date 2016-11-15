//
//  BadPostController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "BadPostController.h"
#import "CommentTableViewCell.h"
#import "CommentDealView.h"
#import "MJRefresh.h"
#import "CommonAlertView.h"
#import "CommonUtils.h"
#import "Branch.h"
#import "AppDelegate.h"
#import "CommentCustomer.h"
#import "CustomIndicatorView.h"
#import <CIBBaseSDK/CIBBaseSDK.h>
#import "FDCalendar.h"

@interface BadPostController ()<FDCalendarDelegate,UIGestureRecognizerDelegate>

{
    UIView *stateChoiceView;
    UIControl *allViewControl;
    UIControl *undealViewControl;
    UIControl *rejectViewConrol;
    UIControl *hesitateViewControl;
    UIView *snapShot;//阴影区
    NSString *beginDate; //开始时间
    NSString *endDate; //结束时间
    NSMutableArray *commentCustomerArr;
    NSString *process_Status;
    
    NSInteger totalPages; //总的数据页数
    NSInteger currentpage; //当前页
    
    FDCalendar* startCalendar;
    FDCalendar* endCalendar;
    
    BOOL _showLoading;//第一次进入该页面的时候显示
    BOOL IscreateTimer; // 创建定时器
    NSInteger index; // 轮询次数
    
}
@end

@implementation BadPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.check.layer.cornerRadius = 1.0;
    self.check.clipsToBounds = YES;
    [self initDate];
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    
    self.rightWeekLabel.text =  [FDCalendar getWeekday:[NSDate date]];
    self.leftWeekLabel.text = [FDCalendar getWeekday:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]]];
    self.leftDateLabel.text = [self dateFormatterTransfer:beginDate];
    self.rightDateLabel.text = [self dateFormatterTransfer:endDate];
    height=height<width?height:width;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 74, 796, height - 74)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB(231, 234, 242, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self createStateChoiceView];
    
// 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(customerFresh)];
    UIImage *potrat = [UIImage imageNamed:@"potrat"];
    UIImage *left = [UIImage imageNamed:@"left"];
    UIImage *right = [UIImage imageNamed:@"right"];
    UIImage *updown = [UIImage imageNamed:@"updown"];
    [header setImages:@[potrat, left, updown, right] duration:0.5 forState:MJRefreshStatePulling];
    self.tableView.header = header;
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    // 监听处理是否成功，如果成功就删除该条信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCell) name:@"commentDealNotification" object:nil];
    
}
- (void)initDate{
    NSDate *enddate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    endDate = [dateFormatter stringFromDate:enddate];
    
    NSDate *begindate = [NSDate dateWithTimeIntervalSince1970:[enddate timeIntervalSince1970]];
    beginDate = [dateFormatter stringFromDate:begindate];
    ;
}

// 开始加载时转动
- (void)startAnimateInView:(UIView *)view
{
    CustomIndicatorView *indicatorView = [CustomIndicatorView sharedView];
    [indicatorView startAnimating];
    [indicatorView showInView:view];
}
// 加载结束时停止转动
- (void)stopAnimate
{
    [[CustomIndicatorView sharedView] stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    index = 1;
    if (delegate.commentTimer) {
        IscreateTimer = NO;
        [delegate.commentTimer setFireDate:[NSDate distantPast]];
        
    } else {
        IscreateTimer = YES;
        [self performSelector:@selector(initTimer) withObject:nil afterDelay:0];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (IscreateTimer) {
        [self initData];
    }
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    height=height<width?height:width;
    CGRect rect = self.tableView.frame;
    rect.size.height=height-74;
    self.tableView.frame=rect;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _showLoading = NO;
    [self stopTimer];
}
- (void)initTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.commentTimer = [NSTimer scheduledTimerWithTimeInterval:[GlobleData sharedInstance].timeInterval target:self selector:@selector(changeTheshowLoading) userInfo:nil repeats:YES ];
    
}
- (void)changeTheshowLoading{
    if (index >1) {
        _showLoading = YES;
    }else{
        _showLoading = NO;
    }
    [self performSelector:@selector(checkAction:) withObject:nil afterDelay:0];
    index ++;
}

- (void)stopTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.commentTimer) {//定时器停止工作
        [delegate.commentTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)customerFresh
{
    //结束刷新
    _showLoading = YES;
    [self checkAction:nil];
}
- (void)endFresh
{
    [self.tableView.header endRefreshing];
}

- (void)invokeCommentData{
    self.check.userInteractionEnabled = NO;
    NSString *begin = beginDate;
    NSString *end = endDate;
    NSString *branchNO = COM_INSTANCE.currentBranch.branchNo;
    NSString *process = process_Status;
    NSString *currentPage = [NSString stringWithFormat:@"%ld",(long)currentpage];
    NSDictionary *paramDictionary = @{@"begin_date":begin,
                                      @"end_date":end,
                                      @"branch":branchNO,
                                      @"process_status":process,
                                      @"currentpage":currentPage,
                                      };

    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        // 加载失败，停止转动
        _showLoading = NO;
        self.check.userInteractionEnabled = YES;
        [self stopAnimate];
        [self endFresh];
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo){
        if ([responseCode isEqualToString:@"I00"])
        {
            // 加载成功，停止转动
            self.check.userInteractionEnabled = YES;
            _showLoading = NO;
            [self endFresh];
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            NSDictionary *result = [responseInfo valueForKey:@"result"];
            if (![resultCode isEqualToString:@"0"]) {
                if ([result isKindOfClass:[NSString class]]) {
                    [self stopAnimate];
                    [self showMessage:(NSString *)result];
                }
            }else{
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSArray *monitorInfoGroup = [result objectForKey:@"monitorInfoGroup"];
                    NSString *totalpage = [result objectForKey:@"totalpage"];
                    if ([totalpage isEqualToString:@"0"]) {
                        [self stopAnimate];
                        [self showMessage:@"后台无数据返回。"];
                        [_commentArr removeAllObjects];
                        [self.tableView reloadData];
                        return;
                    }
                    totalPages = [totalpage integerValue];
                    if (monitorInfoGroup.count > 0 ) {
                        currentpage ++;
                        for (NSDictionary *dic in monitorInfoGroup) {
                            CommentCustomer *customerInfo = [[CommentCustomer alloc] init];
                            customerInfo.access_stauts = [dic objectForKey:@"accessStatus"];
                            customerInfo.customer_name = [dic objectForKey:@"custinfoName"];
                            customerInfo.lastmoddate = [dic objectForKey:@"lastmoddate"];
                            customerInfo.not_satify_reason = [dic objectForKey:@"notSatifyRenson"];
                            customerInfo.process_end = [dic objectForKey:@"processEnd"];
                            customerInfo.process_status = [dic objectForKey:@"processStatus"];
                            customerInfo.teller_name = [dic objectForKey:@"tellerName"];
                            customerInfo.transfer_num = [dic objectForKey:@"transferNum"];
                            customerInfo.customer_tel = [dic objectForKey:@"custinfoTel"];
                            customerInfo.work_date = [dic objectForKey:@"workDate"];
                            customerInfo.queue_num = [dic objectForKey:@"queueNum"];
                            customerInfo.teller_num = [dic objectForKey:@"tellerno"];
                            customerInfo.remark = [dic objectForKey:@"note1"];
                            [commentCustomerArr addObject:customerInfo];
                        }
                        if (currentpage <= totalPages) {
                            [self invokeCommentData];
                        }
                        else {
                            [self stopAnimate];
                            NSArray *tempArr = [commentCustomerArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(CommentCustomer *obj1, CommentCustomer *obj2) {
                                return [obj2.work_date compare:obj1.work_date];
                            }];
                            commentCustomerArr = [NSMutableArray arrayWithArray:tempArr];
                            _commentArr = commentCustomerArr;
                            [self.tableView reloadData];
                        }
                    }
 
                }
            }
        }else{
            self.check.userInteractionEnabled = YES;
            _showLoading = NO;
            [self stopAnimate];
            [self endFresh];
            [self showMessage:@"出错啦！"];
        }
    };
        
    [InvokeManager invokeApi:@"ibpcpjk" withMethod:@"POST" andParameter:paramDictionary onSuccess:success onFailure:failure];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 100;
    }else{
        return 12;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.row % 2 == 0) {
        // 选中后立即取消选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        CommentDealView *view = (CommentDealView *)[[[NSBundle mainBundle] loadNibNamed:@"CommentDealView" owner:nil options:nil] firstObject];
        view.commentModel = [_commentArr objectAtIndex:indexPath.row / 2.0];
        CommonAlertView *baseView = [[CommonAlertView alloc] init];
//        baseView.backAlpah = 0.4;
        baseView.isAutoClose = YES;
        baseView.view = view;
        [baseView show];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArr.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIentifier];
    if (cell == nil) {
        if (indexPath.row % 2 == 0) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil].lastObject;
            CommentTableViewCell *transferCell = (CommentTableViewCell *)cell;
            transferCell.timeLabel.hidden = YES;
            CommentCustomer *customerInfo;
            customerInfo = [_commentArr objectAtIndex:indexPath.row / 2];
            if ([customerInfo.process_status isEqualToString:@"1"]) {
                transferCell.backGroundView.backgroundColor = UIColorFromRGB(0xD94B47);
                transferCell.stateImageView.image = [UIImage imageNamed:@"ic_Teller_untreated"];
                transferCell.stateLabel.text = @"未处理";
                
            }else if ([customerInfo.process_status isEqualToString:@"2"]){
                transferCell.backGroundView.backgroundColor = UIColorFromRGB(0x90d0f9);
                transferCell.stateImageView.image = [UIImage imageNamed:@"ic_Teller_handle"];
                transferCell.stateLabel.text = @"已处理";
                
            }else if([customerInfo.process_status isEqualToString:@"3"]){
                transferCell.backGroundView.backgroundColor = UIColorFromRGB(0xD94B47);
                transferCell.stateImageView.image = [UIImage imageNamed:@"ic_Teller_processing"];
                transferCell.stateLabel.text = @"处理中";
            }
            transferCell.guiyuanName.text = customerInfo.teller_name;
            transferCell.customerName.text = customerInfo.customer_name;
    
            if ([customerInfo.work_date isEqualToString:@""]) {
                transferCell.dateLabel.text = @"";
                transferCell.timeLabel.text = @"";
            }else{
                ;
                transferCell.dateLabel.text = [self dateFormatterTransfer:customerInfo.work_date];
            }
            transferCell.layer.cornerRadius = 5;
            transferCell.clipsToBounds = 5;
        }
        else{
            cell = [[NSBundle mainBundle] loadNibNamed:@"SeparatorLine" owner:nil options:nil].lastObject;
        }
        
    }
    if (indexPath.row % 2 != 0) {
        cell.selected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)stateChoice:(id)sender {

    stateChoiceView.hidden = !stateChoiceView.hidden;
    snapShot.hidden = !snapShot.hidden;
    if (stateChoiceView.hidden) {
        self.stateChoiceBtn.imageView.layer.transform = CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f);
    }else{
        self.stateChoiceBtn.imageView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    }
    
    [CATransaction commit];
}

// 移除处理成功的cell
- (void)removeCell{
// 直接修改本地数据，不进行网络加载，提高性能
    NSMutableArray *tempArr = _commentArr;
    NSArray *array = [NSArray arrayWithArray:tempArr];
    if ([process_Status isEqualToString:@""]) {
    }else{
        for (CommentCustomer *model in array) {
            if (![model.process_status isEqualToString:process_Status]) {
                [tempArr removeObject:model];
                break;
            }
        }
    }
    
    _commentArr = tempArr;
    [self.tableView reloadData];
}

- (void)createStateChoiceView{
    stateChoiceView = [[UIView alloc] initWithFrame:CGRectMake(self.stateView.frame.origin.x + 12, self.stateView.frame.origin.y + 44, 90, 140)];
    stateChoiceView.layer.cornerRadius = 4;
    stateChoiceView.clipsToBounds = 4;
    stateChoiceView.backgroundColor = [UIColor whiteColor];
    
    snapShot = [self customSnapshoFromView:stateChoiceView];
    CGPoint center = stateChoiceView.center;
    snapShot.center = center;
    snapShot.alpha = 0.2;
    snapShot.hidden = YES;
    [self.view addSubview:snapShot];
    
    allViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 10, 90, 30)];
    [allViewControl addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [allViewControl addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    allLabel = [self creatstateLabel:allLabel andString:@"全部"];
    [allViewControl addSubview:allLabel];
    [stateChoiceView addSubview:allViewControl];
    
    undealViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 40, 90, 30)];
    [undealViewControl addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [undealViewControl addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *undealLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    undealLabel = [self creatstateLabel:undealLabel andString:@"未处理"];
    [undealViewControl addSubview:undealLabel];
    [stateChoiceView addSubview:undealViewControl];
    
    rejectViewConrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 70, 90, 30)];
    [rejectViewConrol addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [rejectViewConrol addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *rejectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    rejectLabel = [self creatstateLabel:rejectLabel andString:@"已处理"];
    [rejectViewConrol addSubview:rejectLabel];
    [stateChoiceView addSubview:rejectViewConrol];
    
    hesitateViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 100, 90, 30)];
    [hesitateViewControl addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [hesitateViewControl addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *hesitateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    hesitateLabel = [self creatstateLabel:hesitateLabel andString:@"处理中"];
    [hesitateViewControl addSubview:hesitateLabel];
    [stateChoiceView addSubview:hesitateViewControl];
    
    [self.view addSubview:stateChoiceView];
    stateChoiceView.hidden = YES;
}

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(5, 5);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    snapshot.layer.borderWidth = 0.5;
    snapShot.layer.shadowColor = UIColorFromRGB(0x333536).CGColor;
    snapshot.layer.borderColor = UIColorFromRGB(0xa7aaab).CGColor;
    
    return snapshot;
}

- (void)changebackgroundColor:(UIControl *)control{
    control.backgroundColor = UIColorFromRGB(0xe7eaf2);
}

- (UIControl *)changetheColorOfControlAndChoose:(UIControl *)control{
    
    self.stateChoiceBtn.imageView.layer.transform = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f);
    
    control.backgroundColor = UIColorFromRGB(0xe7eaf2);
    for (UILabel *stateLabel in control.subviews) {
        self.stateLabel.text = stateLabel.text;
    }
    for (UIControl *stateControl in stateChoiceView.subviews) {
        if (stateControl != control) {
            stateControl.backgroundColor = [UIColor whiteColor];
        }
    }
    stateChoiceView.hidden = YES;
    snapShot.hidden = YES;
    return control;
}

- (UILabel *)creatstateLabel:(UILabel *)label andString:(NSString *)string{
    label.text = string;
    label.textColor = UIColorFromRGB(0x5a5a5a);
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}


- (IBAction)checkAction:(id)sender {
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *begin = [dateFomatter dateFromString:self.leftDateLabel.text];
    NSDate *end = [dateFomatter dateFromString:self.rightDateLabel.text];
    if ([end timeIntervalSinceDate:begin] > 180*24*60*60) {
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"查询日期只能在180天范围内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        [self initData];
    }
}

- (IBAction)startDateAction:(id)sender {
    if(!startCalendar){
        startCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] ]];
        startCalendar.delegate=self;
        [startCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        startCalendar.hidden=NO;
    }
}

- (IBAction)endDateAction:(id)sender {
    if(!endCalendar){
        endCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
        endCalendar.delegate=self;
        [endCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        endCalendar.hidden=NO;
    }
}

- (IBAction)leftDateChoiceBtn:(id)sender {
    [self startDateAction:self.leftCalendatBtn];
}

- (IBAction)rightDateChoiceBtn:(id)sender {
    [self endDateAction:self.rightCalendarBtn];
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
    return NO;
}


#pragma mark --FDCalendarDelegate
- (void)refreshWithData:(NSString *)date weekDay:(NSString *)weekDay{
    if(startCalendar && startCalendar.hidden==NO){
        //验证日期大小
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.rightDateLabel.text];
        if(compareResult == 1){
            [self showAlert];
            return;
        }
        self.leftDateLabel.text=date;
        self.leftWeekLabel.text=weekDay;
        [self performSelector:@selector(hideCalendar:) withObject:startCalendar afterDelay:0.2];
    }else if(endCalendar && endCalendar.hidden==NO){
        //验证日期大小
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.leftDateLabel.text];
        if(compareResult == -1){
            [self showAlert];
            return;
        }
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *newmatter = [[NSDateFormatter alloc] init];
        [newmatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [newmatter stringFromDate:todayDate];
        int compareResult1 = [FDCalendar compareWithDate:date anthorDate:dateStr];
        if (compareResult1 == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"截止日期不能大于今天日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
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
-(void) showAlert{
    UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"开始日期不能大于结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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

- (void)initData{
    beginDate = [self dateTransfer:self.leftDateLabel.text];
    endDate = [self dateTransfer:self.rightDateLabel.text];
    if ([self.stateLabel.text isEqualToString:@"全部"]) {
        currentpage = 1;
        process_Status = @"";
        if (!_showLoading) {
            [self startAnimateInView:self.view];
            _showLoading = YES;
        }
        commentCustomerArr = nil;
        commentCustomerArr = [[NSMutableArray alloc] init];
        [self invokeCommentData];
    }else if ([self.stateLabel.text isEqualToString:@"未处理"]){
        currentpage = 1;
        process_Status = @"1";
        if (!_showLoading) {
            [self startAnimateInView:self.view];
            _showLoading = YES;
        }
        commentCustomerArr = nil;
        commentCustomerArr = [[NSMutableArray alloc] init];
        [self invokeCommentData];
    }else if ([self.stateLabel.text isEqualToString:@"已处理"]){
        currentpage = 1;
        process_Status = @"2";
        if (!_showLoading) {
            [self startAnimateInView:self.view];
            _showLoading = YES;
        }
        commentCustomerArr = nil;
        commentCustomerArr = [[NSMutableArray alloc] init];
        [self invokeCommentData];
    }else if ([self.stateLabel.text isEqualToString:@"处理中"]){
        currentpage = 1;
        process_Status = @"3";
        if (!_showLoading) {
            [self startAnimateInView:self.view];
            _showLoading = YES;
        }
        commentCustomerArr = nil;
        commentCustomerArr = [[NSMutableArray alloc] init];
        [self invokeCommentData];
    }
}
@end
