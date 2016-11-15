//
//  TransferController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "TransferController.h"
#import "MasterChoseCell.h"
#import "AppDelegate.h"
#import "TransferCellTableViewCell.h"
#import "SeparatorLine.h"
#import "CommonAlertView.h"
#import "transferHandle.h"
#import "TransferNotificationView.h"
#import "RegisterView.h"
#import "TransferDetailView.h"
#import "FDCalendar.h"
#import "FDCalendarItem.h"
#import "MJRefresh.h"
#import "TransferCheck.h"
#import "CustomIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

@interface TransferController ()<UIGestureRecognizerDelegate,FDCalendarDelegate>
{
    UIView *calendarView;
    UIView *stateChoiceView;
    UIControl *allViewControl;
    UIControl *undealViewControl;
    UIControl *rejectViewConrol;
    UIControl *hesitateViewControl;
    UIControl *successViewConrol;
    UIView *snapShot;//阴影区
    NSMutableArray *transferCustomerArr;
    
    NSString *referralflag; //
    NSString *beginDate; //开始日期
    NSString *endDate; //结束日期
    NSString *marketingstatus; //状态选择
    NSInteger totalPages; //总的数据页数
    NSInteger currentpage; //当前页
    
    FDCalendar *startCalendar;
    FDCalendar *endCalendar;
}

@end

@implementation TransferController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    referralflag = @"2";
    self.checkBtn.layer.cornerRadius = 1.0;
    self.checkBtn.clipsToBounds = YES;
    [self initDate];
    self.weekLabel_R.text =  [FDCalendar getWeekday:[NSDate date]];
    self.weekLabel_L.text = [FDCalendar getWeekday:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]]];
    
    self.dateLabel_L.text = [self dateFormatterTransfer:beginDate];
    self.dateLabel_R.text = [self dateFormatterTransfer:endDate];
    self.stateLine_R.hidden = YES;
    self.partingLine_3 = [[UIView alloc] initWithFrame:CGRectMake(693, 17, 0.5, 15)];
    self.partingLine_3.backgroundColor = RGB(166, 167, 177, 1);
    [self.mennuView addSubview:self.partingLine_3];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 136, 796, self.view.frame.size.height + 100)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB(231, 234, 242, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.dateChoicebutton_L setImage:[UIImage imageNamed:@"btn_start_date_p"] forState:UIControlStateHighlighted];
    [self.dateChoicebutton_L addTarget:self action:@selector(popCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self.dateChoiceBtn_R setImage:[UIImage imageNamed:@"btn_start_date_p"] forState:UIControlStateHighlighted];
    [self.dateChoiceBtn_R addTarget:self action:@selector(popCalendar) forControlEvents:UIControlEventTouchUpInside];
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
    
//    // 上拉加载
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupReload)];
//    UIImage *downpotrat = [UIImage imageNamed:@"potrat"];
//    UIImage *downleft = [UIImage imageNamed:@"left"];
//    UIImage *downright = [UIImage imageNamed:@"right"];
//    UIImage *downupdown = [UIImage imageNamed:@"updown"];
//    [footer setImages:@[downpotrat, downleft, downupdown, downright] duration:0.5 forState:MJRefreshStatePulling];
//    self.tableView.footer = footer;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    // 监听转介处理后的操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTransferData) name:@"TransferNotificationCenter" object:nil];
}

- (void)customerFresh
{
    //结束刷新
    [self checkBtn:nil];
}
- (void)endFresh
{
    [self.tableView.header endRefreshing];
}

// 上拉加载
//- (void)pullupReload{
//    // 结束加载
//    [self performSelector:@selector(endReload) withObject:nil afterDelay:1.5];
//}
//- (void)endReload{
//    [self.tableView.footer endRefreshing];
//}

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


- (void)initDate{
    NSDate *enddate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    endDate = [dateFormatter stringFromDate:enddate];
    
    NSDate *begindate = [NSDate dateWithTimeIntervalSince1970:[enddate timeIntervalSince1970]];
    beginDate = [dateFormatter stringFromDate:begindate];
    ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

// 处理成功后，刷新数据
- (void)refreshTransferData{
    
// 直接修改本地数据，不进行网络加载，提高性能
    NSMutableArray *tempArr = _transferArr;
    NSArray *array = [NSArray arrayWithArray:tempArr];
    for (TransferCheck *model in array) {
        if (![model.marketingstatus isEqualToString:marketingstatus]) {
            [tempArr removeObject:model];
            break;
        }
    }
    _transferArr = tempArr;
    [self.tableView reloadData];
}

#pragma mark 调用网络接口，请求数据
- (void)invokeDatafromNet{
    self.checkBtn.userInteractionEnabled = NO;
    NSString *userid = COM_INSTANCE.userid;
    NSString *referra = referralflag;
    NSString *marketing = marketingstatus;
    NSString *begin = beginDate;
    NSString *end = endDate;
    NSDictionary *paragramDic = @{@"begin_date":begin,
                              @"end_date":end,
                              @"userid":userid,
                              @"referralflag":referra,
                              @"marketingstatus":marketing,
                              @"currentpage":[NSString stringWithFormat:@"%ld",(long)currentpage],
                                  @"clueid_tag":@""
                              };
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        // 加载失败，停止转动
        [self stopAnimate];
        [self endFresh];
        self.checkBtn.userInteractionEnabled = YES;
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo){
        if ([responseCode isEqualToString:@"I00"])
        {
            // 加载成功，停止转动
            self.checkBtn.userInteractionEnabled = YES;
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
                    NSArray *monitorInfoGroup = [result objectForKey:@"referralInfoGroup"];
                    NSString *totalpage = [result objectForKey:@"totalpage"];
                    if ([totalpage isEqualToString:@"0"]) {
                        [self stopAnimate];
                        [self showMessage:@"后台无数据返回。"];
                        [_transferArr removeAllObjects];
                        [self.tableView reloadData];
                        return;
                    }
                    totalPages = [totalpage integerValue];
                    if (monitorInfoGroup.count > 0 )
                    {
                        currentpage ++;
                        for (NSDictionary *dic in monitorInfoGroup) {
                            TransferCheck *customer = [[TransferCheck alloc] init];
                            customer.busi_amount = [dic objectForKey:@"busi_amount"];
                            customer.clue_date = [dic objectForKey:@"clue_date"];
                            customer.clue_id = [dic objectForKey:@"clue_id"];
                            customer.clue_time = [dic objectForKey:@"clue_time"];
                            customer.allTime = [NSString stringWithFormat:@"%@ %@",customer.clue_date,customer.clue_time];
                            customer.cluesource = [dic objectForKey:@"cluesource"];
                            customer.cluetype = [dic objectForKey:@"cluetype"];
                            customer.custinfo_name = [dic objectForKey:@"custinfo_name"];
                            customer.lastusercode = [dic objectForKey:@"lastusercode"];
                            customer.marketingstatus = [dic objectForKey:@"marketingstatus"];
                            customer.operateuser = [dic objectForKey:@"operateuser"];
                            customer.operateuser_name = [dic objectForKey:@"operateuser_name"];
                            customer.queue_num = [dic objectForKey:@"queue_num"];
                            customer.referral_bs_id = [dic objectForKey:@"referral_bs_id"];
                            customer.referral_bs_name = [dic objectForKey:@"referral_bs_name"];
                            customer.referraluser = [dic objectForKey:@"referraluser"];
                            customer.referraluser_name = [dic objectForKey:@"referraluser_name"];
                            customer.remark = [dic objectForKey:@"remark"];
                            customer.remark1 = [dic objectForKey:@"remark1"];
                            [transferCustomerArr addObject:customer];
                        }
                        
                        if (currentpage <= totalPages) {
                            [self invokeDatafromNet];
                        }
                        else {
                            [self stopAnimate];
                            NSArray *tempArr = [transferCustomerArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(TransferCheck *obj1, TransferCheck *obj2) {
                                return [obj2.allTime compare:obj1.allTime];
                            }];
                            transferCustomerArr = [NSMutableArray arrayWithArray:tempArr];
                            _transferArr = transferCustomerArr;
                            [self.tableView reloadData];
                            currentpage = 1;
                            
                        }
                    }
                }
                
            }
        }else{
            self.checkBtn.userInteractionEnabled = YES;
            [self stopAnimate];
            [self endFresh];
            [self showMessage:@"出错啦！"];
        }
    };
    [InvokeManager invokeApi:@"ibpzjck" withMethod:@"POST" andParameter:paragramDic onSuccess:success onFailure:failure];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 100;
    }else{
        return 12;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        // 选中后立即取消选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (self.stateLine_L.hidden) {
            TransferDetailView *view = (TransferDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"TransferDetailView" owner:nil options:nil] firstObject];
            CommonAlertView *baseView = [[CommonAlertView alloc] init];
            view.transferModel = [_transferArr objectAtIndex:indexPath.row / 2.0];
//            baseView.backAlpah = 0.4;
            baseView.view = view;
            [baseView show];
        }else{
            transferHandle *view = (transferHandle *)[[[NSBundle mainBundle] loadNibNamed:@"transferHandle" owner:nil options:nil] firstObject];
            view.checkModel = [_transferArr objectAtIndex:indexPath.row / 2.0];
            CommonAlertView *baseView = [[CommonAlertView alloc] init];
//            baseView.backAlpah = 0.4;
            baseView.isAutoClose = YES;
            baseView.view = view;
            [baseView show];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _transferArr.count * 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIentifier];
    if (cell == nil) {
        if (indexPath.row % 2 == 0) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TransferCellTableViewCell" owner:nil options:nil].lastObject;
            TransferCellTableViewCell *transferCell = (TransferCellTableViewCell *)cell;
            transferCell.backgroundView.backgroundColor = UIColorFromRGB(0xFE9142);
            TransferCheck *customerTrasfer;
            transferCell.index = indexPath.row / 2.0;
            customerTrasfer = [_transferArr objectAtIndex:indexPath.row / 2];
            if ([customerTrasfer.marketingstatus isEqualToString:@"1"]) {
                transferCell.stateImage.image = [UIImage imageNamed:@"ic_user_succeed"];
                transferCell.stateLabel.text = @"成功";
                transferCell.backView.backgroundColor = UIColorFromRGB(0x74cf8c);
            }else if ([customerTrasfer.marketingstatus isEqualToString:@"2"]){
                transferCell.stateImage.image = [UIImage imageNamed:@"ic_user_Rejected"];
                transferCell.stateLabel.text = @"拒绝";
                transferCell.backView.backgroundColor = UIColorFromRGB(0x74cf8c);
            }else if ([customerTrasfer.marketingstatus isEqualToString:@"4"]){
                transferCell.stateImage.image = [UIImage imageNamed:@"ic_user_hesitate"];
                transferCell.stateLabel.text = @"犹豫";
                transferCell.backView.backgroundColor = UIColorFromRGB(0x74cf8c);
            }else if ([customerTrasfer.marketingstatus isEqualToString:@"5"]){
                transferCell.stateImage.image = [UIImage imageNamed:@"ic_user_untreated"];
                transferCell.stateLabel.text = @"未处理";
                transferCell.backView.backgroundColor = UIColorFromRGB(0xfe9142);
            }
            if ([customerTrasfer.clue_date isEqualToString:@""]) {
                transferCell.dateLabel.text = @"";
            }else{
                transferCell.dateLabel.text = [self dateFormatterTransfer:customerTrasfer.clue_date];
            }
            if ([customerTrasfer.clue_time isEqualToString:@""]) {
                transferCell.timeLabel.text = @"";
            }else{
                transferCell.timeLabel.text = [self timeFormatterTransfer:customerTrasfer.clue_time];
            }
            
            transferCell.usernameLabel.text = customerTrasfer.custinfo_name;
            transferCell.productnameLabel.text = customerTrasfer.referral_bs_name;
            transferCell.layer.cornerRadius = 5;
            transferCell.clipsToBounds = 5;
        }
        else{
            cell = [[NSBundle mainBundle] loadNibNamed:@"SeparatorLine" owner:nil options:nil].lastObject;
            cell.selected = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return cell;
}
- (void)popCalendar{
    
}

// 点击查询按钮
- (IBAction)checkBtn:(id)sender {
//    TransferNotificationView *view = (TransferNotificationView *)[[[NSBundle mainBundle] loadNibNamed:@"TransferNotificationView" owner:nil options:nil] firstObject];
//    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
//    baseView.view = view;
//    [baseView show];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *begin = [dateFomatter dateFromString:self.dateLabel_L.text];
    NSDate *end = [dateFomatter dateFromString:self.dateLabel_R.text];
    if ([end timeIntervalSinceDate:begin] > 90*24*60*60) {
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"查询日期只能在90天范围内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        [self reloadDataFromNet];
    }
   
}

// 点击状态选择按钮
- (IBAction)stateChoice:(id)sender {
    stateChoiceView.hidden = !stateChoiceView.hidden;
    snapShot.hidden = !snapShot.hidden;
    if (stateChoiceView.hidden) {
         self.dealStateBtn.imageView.layer.transform = CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f);
    }else{
       self.dealStateBtn.imageView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    }
    
    [CATransaction commit];
    
}

// 点击接收转介
- (IBAction)receiveTransfer:(id)sender {
    [self startAnimateInView:self.view];
    referralflag = @"2";
    currentpage = 1;
    transferCustomerArr = nil;
    transferCustomerArr = [[NSMutableArray alloc] init];
    [_transferArr removeAllObjects];
    [self.tableView reloadData];
    [self invokeDatafromNet];
    self.stateLine_L.hidden = NO;
    [self.receiveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.stateLine_R.hidden = YES;
    [self.sendBtn setTitleColor:UIColorFromRGB(0x999898) forState:UIControlStateNormal];
}

// 点击发送转介
- (IBAction)sendTransfer:(id)sender {
    [self startAnimateInView:self.view];
    referralflag = @"1";
    currentpage = 1;
    transferCustomerArr = nil;
    transferCustomerArr = [[NSMutableArray alloc] init];
    [_transferArr removeAllObjects];
    [self.tableView reloadData];
    [self invokeDatafromNet];
    self.stateLine_R.hidden = NO;
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.stateLine_L.hidden = YES;
    [self.receiveBtn setTitleColor:UIColorFromRGB(0x999898) forState:UIControlStateNormal];
    
}

// 创建状态选择下拉列表
- (void)createStateChoiceView{
    stateChoiceView = [[UIView alloc] initWithFrame:CGRectMake(self.stateView.frame.origin.x + 12, self.stateView.frame.origin.y + 106, 90, 170)];
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
    rejectLabel = [self creatstateLabel:rejectLabel andString:@"拒绝"];
    [rejectViewConrol addSubview:rejectLabel];
    [stateChoiceView addSubview:rejectViewConrol];
    
    hesitateViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 100, 90, 30)];
    [hesitateViewControl addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [hesitateViewControl addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *hesitateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    hesitateLabel = [self creatstateLabel:hesitateLabel andString:@"犹豫"];
    [hesitateViewControl addSubview:hesitateLabel];
    [stateChoiceView addSubview:hesitateViewControl];
    
    successViewConrol = [[UIControl alloc] initWithFrame:CGRectMake(0, 130, 90, 30)];
    [successViewConrol addTarget:self action:@selector(changetheColorOfControlAndChoose:) forControlEvents:UIControlEventTouchUpInside];
    [successViewConrol addTarget:self action:@selector(changebackgroundColor:) forControlEvents:UIControlEventTouchDown];
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    successLabel = [self creatstateLabel:successLabel andString:@"成功"];
    [successViewConrol addSubview:successLabel];
    [stateChoiceView addSubview:successViewConrol];
    
    [self.view addSubview:stateChoiceView];
    stateChoiceView.hidden = YES;
}

- (UILabel *)creatstateLabel:(UILabel *)label andString:(NSString *)string{
    label.text = string;
    label.textColor = UIColorFromRGB(0x5a5a5a);
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}
- (void)changebackgroundColor:(UIControl *)control{
    control.backgroundColor = UIColorFromRGB(0xe7eaf2);
}

- (UIControl *)changetheColorOfControlAndChoose:(UIControl *)control{
    
    self.dealStateBtn.imageView.layer.transform = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f);
    
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
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self reloadDataFromNet];
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    height=height<width?height:width;
    CGRect rect = self.tableView.frame;
    rect.size.height=height-136;
    self.tableView.frame=rect;
}

- (IBAction)selectDateStart:(id)sender {
    if(!startCalendar){
        startCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] ]];
        startCalendar.delegate=self;
        [startCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        startCalendar.hidden=NO;
    }
}

- (IBAction)selectDataEnd:(id)sender  {
    if(!endCalendar){
        endCalendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
        endCalendar.delegate=self;
        [endCalendar showCalendarWithClickControl:sender inView:self.view];
    }else{
        endCalendar.hidden=NO;
    }
}

- (IBAction)leftBtn:(id)sender {
    [self selectDateStart:self.dateChoicebutton_L];
}

- (IBAction)rightBtn:(id)sender {
    [self selectDataEnd:self.dateChoiceBtn_R];
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
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.dateLabel_R.text];
        if(compareResult == 1){
            [self showAlert];
            return;
        }
        self.dateLabel_L.text=date;
        self.weekLabel_L.text=weekDay;
        [self performSelector:@selector(hideCalendar:) withObject:startCalendar afterDelay:0.2];
    }else if(endCalendar && endCalendar.hidden==NO){
        //验证日期大小
        int compareResult = [FDCalendar compareWithDate:date anthorDate:self.dateLabel_L.text];
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
        self.dateLabel_R.text=date;
        self.weekLabel_R.text=weekDay;
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
// 将HHmmss格式的时间转换成HH:mm格式的时间
- (NSString *)timeFormatterTransfer:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate *time = [formatter dateFromString:timeString];
    NSDateFormatter *timeMatter = [[NSDateFormatter alloc] init];
    [timeMatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [timeMatter stringFromDate:time];
    return timeStr;
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

- (void)reloadDataFromNet{
    beginDate = [self dateTransfer:self.dateLabel_L.text];
    endDate = [self dateTransfer:self.dateLabel_R.text];
    if ([self.stateLabel.text isEqualToString:@"全部"]) {
        currentpage = 1;
        marketingstatus = @"";
        transferCustomerArr = nil;
        transferCustomerArr = [[NSMutableArray alloc] init];
        [self startAnimateInView:self.view];
        [self invokeDatafromNet];
    }else if ([self.stateLabel.text isEqualToString:@"未处理"]){
        currentpage = 1;
        marketingstatus = @"5";
        transferCustomerArr = nil;
        transferCustomerArr = [[NSMutableArray alloc] init];
        [self startAnimateInView:self.view];
        [self invokeDatafromNet];
    }else if ([self.stateLabel.text isEqualToString:@"拒绝"]){
        currentpage = 1;
        marketingstatus = @"2";
        transferCustomerArr = nil;
        transferCustomerArr = [[NSMutableArray alloc] init];
        [self startAnimateInView:self.view];
        [self invokeDatafromNet];
    }else if ([self.stateLabel.text isEqualToString:@"犹豫"]){
        currentpage = 1;
        marketingstatus = @"4";
        transferCustomerArr = nil;
        transferCustomerArr = [[NSMutableArray alloc] init];
        [self startAnimateInView:self.view];
        [self invokeDatafromNet];
    }else if ([self.stateLabel.text isEqualToString:@"成功"]){
        currentpage = 1;
        marketingstatus = @"1";
        transferCustomerArr = nil;
        transferCustomerArr = [[NSMutableArray alloc] init];
        [self startAnimateInView:self.view];
        [self invokeDatafromNet];
    }
}
@end
