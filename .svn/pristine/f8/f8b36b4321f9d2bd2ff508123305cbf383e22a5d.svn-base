//
//  QueueViewController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "QueueViewController.h"
#import "MasterChoseCell.h"
#import "CustomerCell.h"
#import "CustCollectionCell.h"
#import "Public.h"
#import "Customer.h"
#import "CommonAlertView.h"
#import "CustomerView.h"
#import "MoveOutCustomerView.h"
#import "MJRefresh.h"
#import "RegisterView.h"
#import "CustomIndicatorView.h"
#import "CommonUtils.h"
#import <CIBBaseSDK/CIBBaseSDK.h>
#import "SmartHallConfig.h"
#import "Branch.h"
#import "Queue.h"
#import "AppDelegate.h"
#import "TurnView.h"

@interface QueueViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, SMMoreOptionsDelegate>
{
    UIButton *_currentSender;//当前选中的排序按钮
    NSMutableArray *_queues;//队列信息数组 存放获取的队列信息
    NSInteger _selectedQueueIndex;
    
    NSMutableArray *customerList;//从接口获取客户列表
    NSInteger currentPage;
    NSInteger totalPages;
    
    BOOL _showLoading;//第一次进入该页面的时候显示
    BOOL _refreshing;//刷新
    BOOL _needClearAllDatas;//是否清楚所有的本地客户列表数据
    
    NSString *sourceURL;//保存当前更新的APP的URL
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *queueName;
@property (weak, nonatomic) IBOutlet UILabel *waitNum;
@property (weak, nonatomic) IBOutlet UILabel *waitTime;
@property (weak, nonatomic) IBOutlet UILabel *allWaitNum;
@property (weak, nonatomic) IBOutlet UILabel *avgWaitTime;
@property (weak, nonatomic) IBOutlet UIButton *showOrHideBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *customListView;
@property (weak, nonatomic) IBOutlet UITableView *customerTable;

@property (nonatomic, strong) NSMutableArray *customers;

@property (nonatomic, strong) UIView *headView;
//CollectionView的成员变量

//约束变量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraints;

@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    customerList = [NSMutableArray array];
    
    //描边处理
    _topView.layer.borderWidth = 0.5;
    _topView.layer.borderColor = [RGB(144, 144, 144, 1.0) CGColor];
    _topView.layer.cornerRadius = 5;
    
    _collectionView.layer.borderWidth = 0.5;
    _collectionView.layer.borderColor = [RGB(144, 144, 144, 1.0) CGColor];
    _collectionView.layer.cornerRadius = 5;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"CustCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CustCollectionCell"];
    
    _customListView.layer.cornerRadius = 4;
    _customListView.layer.borderWidth = 0.5;
    _customListView.layer.borderColor = [RGB(144, 144, 144, 1.0) CGColor];
    _customerTable.dataSource = self;
    _customerTable.delegate = self;
    _customerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(customerFresh)];
    UIImage *potrat = [UIImage imageNamed:@"potrat"];
    UIImage *left = [UIImage imageNamed:@"left"];
    UIImage *right = [UIImage imageNamed:@"right"];
    UIImage *updown = [UIImage imageNamed:@"updown"];
    [header setImages:@[potrat, left, updown, right] duration:0.5 forState:MJRefreshStatePulling];
    _customerTable.header = header;
    
    [self setCustomListHeadView];
    
    UITapGestureRecognizer *showOrHideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideQueue)];
    [self.topView addGestureRecognizer:showOrHideGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToHome:) name:@"backToHomeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activieToFront:) name:@"enterFrontNotification" object:nil];
    
    //检测更新 测试阶段 方便更新版本 正式版本移除 以设置界面更新功能为准
//    [self performSelector:@selector(checkUpdate) withObject:nil afterDelay:10];
}

- (void)setCustomListHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 796, 40)];
    _headView.backgroundColor = UIColorFromRGB(0xf4f5fb);
    
    NSArray *titles = @[@"取号时间", @"姓名", @"票号", @"业务种类", @"票号状态", @"客户经理", @"客户层级", @"提升差距", @"未签约"];
    CGFloat width = 796 / titles.count;
    int i = 0;
    CGFloat height = 30;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 5, width, height);
        button.selected = NO;
        button.titleLabel.font = K_FONT_13;
        [button setTitleColor:RGB(66, 80, 93, 1.0) forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.userInteractionEnabled = NO;
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = 100 + i;
        
        if (i == 0 || i == 6 || i == 7 || i == 8) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
            CGSize size = [Public sizeOfString:title defaultSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withFont:K_FONT_13];
            CGFloat spacing = size.width + 15;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, spacing, 0, 0)];
            [button setImage:[UIImage imageNamed:@"paixu1"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"paixu2"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
        }
        
        [_headView addSubview:button];
        
        i++;
    }
    [_customListView addSubview:_headView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.customerTimer) {
        
        [self startTimer:delegate.customerTimer];
    } else {
        [self invokeQueue];
        [self initTimer];
    }
}

#pragma mark 从后台唤醒
- (void)activieToFront:(NSNotification *)t
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [self performSelector:@selector(startTimer:) withObject:delegate.customerTimer afterDelay:customerListRefreshInterval];
//    if (_customers.count == 0) {
//        [self invokeQueue];
//    }
}

#pragma mark 进入后台
/**
 *  点击HOME键，应用程序进入后台，将本地数据情况。刷新TableView。
 *  去重处理
 */
- (void)backToHome:(NSNotification *)t
{
//    [customerList removeAllObjects];
//    [_customers removeAllObjects];
//    [_customerTable reloadData];
//    [_customerTable reloadData];
}

#pragma mark 客户视图刷新
- (void)customerFresh
{
    _refreshing = YES;
    [self invokeCustomers];
}

- (void)endFresh
{
    [self.customerTable.header endRefreshing];
}

- (void)initTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.customerTimer = [NSTimer scheduledTimerWithTimeInterval:[GlobleData sharedInstance].timeInterval target:self selector:@selector(invokeQueue) userInfo:nil repeats:YES];
    
}

- (void)startTimer:(NSTimer *)timer
{
    [timer setFireDate:[NSDate distantPast]];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [customerList removeAllObjects];
    [_customers removeAllObjects];
    [_customerTable reloadData];
    [self stopTimer];
    _showLoading = NO;
    if ([[CustomIndicatorView sharedView] isAnimating]) {
        [[CustomIndicatorView sharedView] stopAnimating];
    }
}

- (void)stopTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.customerTimer) {//定时器停止工作
        [delegate.customerTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.customerTimer isValid]) {
        [delegate.customerTimer invalidate];
        delegate.customerTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)invokeCustomers
{
    
    [self invokeCustomerList];
}

#pragma mark 数据构建

//队列接口
- (void)invokeQueue
{
    if (!_showLoading) {
        [self startAnimateInView:self.view];
        _showLoading = YES;
    }
    NSDictionary *paramDic = @{@"branch":COM_INSTANCE.currentBranch.branchNo};
    [InvokeManager invokeApi:@"ibpgqi"
                  withMethod:@"POST"
                andParameter:paramDic
                   onSuccess:^(NSString *responseCode, NSString *responseInfo) {
                        if ([responseCode isEqualToString:@"I00"]) {
                            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
                            if ([resultCode isEqualToString:@"0"]) {
                                NSArray *result = [responseInfo valueForKey:@"result"];
                                NSMutableArray *queueArray = [NSMutableArray array];
                                int allQueueNum = 0;
                                float allWaitTimes = 0;
                                for (NSDictionary *dic in result) {
                                    Queue *queue = [[Queue alloc] init];
                                    queue.queueID = dic[@"queuetypeId"];
                                    queue.queueName = dic[@"queuetypeName"];
                                    queue.queueNum = dic[@"waitNum"];
                                    queue.waitTime = dic[@"averageWaitingTime"];
                                    
                                    float times = [queue.queueNum intValue] * [queue.waitTime floatValue];
                                    allQueueNum += [queue.queueNum intValue];
                                    allWaitTimes += times;
                                    
                                    [queueArray addObject:queue];
                                }
                                
                                Queue *queue = [[Queue alloc] init];
                                queue.queueName = @"全部";
                                queue.queueNum = [NSString stringWithFormat:@"%d", allQueueNum];
                                if (allQueueNum == 0) {
                                    queue.waitTime = @"0";
                                } else {
                                    queue.waitTime = [NSString stringWithFormat:@"%d", (int)(allWaitTimes / allQueueNum)];
                                }
                                
                                [queueArray insertObject:queue atIndex:0];
                                _queues = queueArray;
                                
                                //刷新collectionview
                                [self.collectionView reloadData];
                                
                                [self invokeCustomers];
                            }
                            else {
                                [self stopAnimate];
                                NSString *result = [responseInfo valueForKey:@"result"];
                                if ([result isKindOfClass:[NSString class]]) {
                                    NSString *alertInfo = [NSString stringWithFormat:@"%@", result];
                                    [self showMessage:alertInfo];
                                }
                                
                            }
                        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
                            [self logoutToLoginPage];
                        }
                    }
                   onFailure:^(NSString *responseCode, NSString *responseInfo) {
                        [self stopAnimate];
                        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
                        [self showMessage:alertInfo];
                   }
     ];
}

//客户群体接口 即查询客户信息列表

- (void)invokeCustomerList
{
    // 初始化客户信息列表，当前页码，总页码
    totalPages = 1;
    currentPage = 1;
    
    [self getAllCustomerInfo];
    
}

- (void)getAllCustomerInfo {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];

    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld", (long)currentPage] forKey:@"currentpage"];
    
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [self stopAnimate];
        if (_refreshing) {
            _refreshing = NO;
            [self.customerTable.header endRefreshing];
        }
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        if (_refreshing) {
            _refreshing = NO;
            [self.customerTable.header endRefreshing];
        }
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSDictionary *result = [responseInfo valueForKey:@"result"];
                NSArray *customerArray = [result valueForKey:@"custInfoMemGroup"];
                NSString *totalpage = [result valueForKey:@"totalpage"];
                totalPages = [totalpage integerValue];
                if (!_needClearAllDatas) {
                    [customerList removeAllObjects];
                    _needClearAllDatas = YES;
                }
                
                if ([customerArray count] > 0) {
                    currentPage ++;
                    for (NSDictionary *dic in customerArray) {
                        Customer *customer = [[Customer alloc] init];
                        customer.customerName = dic[@"custinfoName"];
                        customer.ticketTime = dic[@"queueTime"];
                        customer.ticketNo = dic[@"queueNum"];
                        customer.busType = dic[@"bsnameCh"];
                        customer.ticketStatus = dic[@"queueStatus"];
                        customer.manager = dic[@"custmgrName"];
                        customer.custLevel = dic[@"custType"];
                        customer.bs_id = dic[@"bsId"];
                        customer.gap = dic[@"appSpace"];
                        customer.unsignNum = dic[@"noCount"];
                        customer.care = dic[@"marketingInfo"];
                        customer.idCardNum = dic[@"idNum"];
                        customer.terminalCode = [dic valueForKey:@"zddh"];
                        customer.queueType = [dic valueForKey:@"queueType"];
                        
                        [customerList addObject:customer];
                    }
                    if (currentPage <= totalPages) {
                        [self getAllCustomerInfo];
                    }
                    else {
                        [self stopAnimate];
                        _needClearAllDatas = NO;
                        _customers = [NSMutableArray arrayWithArray:customerList];
                        
                        Queue *queue = _queues[_selectedQueueIndex];
                        //更新视图顶部
                        
                        [self updateQueueHeadView:_selectedQueueIndex];
                        [self updateCustomsWithQueueID:queue.queueID];
                    }
                } else {
                    [self stopAnimate];
                }
            }
        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
            [self stopAnimate];
            [self logoutToLoginPage];
        }
    };
    
    [InvokeManager invokeApi:@"ibpgci" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark 加载动画

- (void)startAnimateInView:(UIView *)view
{
    CustomIndicatorView *indicatorView = [CustomIndicatorView sharedView];
    [indicatorView startAnimating];
    [indicatorView showInView:view];
}

- (void)stopAnimate
{
    [[CustomIndicatorView sharedView] stopAnimating];
}

#pragma mark 退出登录

- (void)logoutToLoginPage
{
    [CommonUtils sharedInstance].noteId = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 视图构建
#pragma mark 展开/隐藏
- (IBAction)showMore:(UIButton *)sender
{
    if (sender.isSelected) {
        [self changeConstraints:0];
    } else {
        NSInteger queueNum = _queues.count;
        NSInteger row = queueNum % 3 == 0 ? queueNum / 3 : (queueNum / 3 + 1);
        if (queueNum >= 9) {
            [self changeConstraints:230];
        } else {
            CGFloat h = row * 60 + 50;
            [self changeConstraints:h];
        }
        
    }
    sender.selected = !sender.isSelected;
}

- (void)showOrHideQueue
{
    [self showMore:_showOrHideBtn];
}

- (void)changeConstraints:(float)constant
{
    //添加该动画 并没有动画效果 只能是改变frame来实现动画
    [UIView animateWithDuration:0.5 animations:^{
        _collectionViewConstraints.constant = constant;
    }];
}

#pragma mark CollectionView 数据源和方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _queues.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CustCollectionCell";
    
    CustCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.queue = _queues[indexPath.row];
    
    if (indexPath.row == _selectedQueueIndex) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //改变颜色
    CustCollectionCell *cell = (CustCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isSelected = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_selectedQueueIndex == 0) {
        //改变颜色
        NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
        CustCollectionCell *cell = (CustCollectionCell *)[collectionView cellForItemAtIndexPath:index];
        
        cell.isSelected = NO;
    }
    _selectedQueueIndex = indexPath.row;
    //改变颜色
    CustCollectionCell *cell = (CustCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isSelected = YES;
    
    //更新客户信息
    Queue *queue = _queues[indexPath.row];
    [self updateCustomsWithQueueID:queue.queueID];
    //更新视图顶部
    [self updateQueueHeadView:_selectedQueueIndex];
}

#pragma mark 选中队列显示队列信息

- (void)updateCustomsWithQueueID:(NSString *)queueID
{
    if (queueID == nil && _selectedQueueIndex == 0) {
        _customers = customerList;
    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (Customer *customer in customerList) {
            if ([customer.queueType isEqualToString:queueID]) {
                [tempArray addObject:customer];
            }
        }
        _customers = [NSMutableArray arrayWithArray:tempArray];
    }
    NSArray *temp = [_customers sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Customer *obj1, Customer * obj2) {
        return [obj1.ticketTime compare:obj2.ticketTime];
    }];
    _customers = [NSMutableArray arrayWithArray:temp];
    
    //更新视图
    [self.customerTable reloadData];
}

#pragma mark 更新视图最上方的队列信息
- (void)updateQueueHeadView:(NSInteger)currentIndex
{
    Queue *queue = _queues[currentIndex];
    Queue *allQueue = [_queues firstObject];
    //更新队列名称
    _queueName.text = queue.queueName;
    _waitNum.text = queue.queueNum;
    _waitTime.text = queue.waitTime;
    _allWaitNum.text = allQueue.queueNum;
    _avgWaitTime.text = allQueue.waitTime;
}

#pragma mark UITableView头部设置

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customerTable.size.width, 40)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"取号时间", @"姓名", @"票号", @"业务种类", @"票号状态", @"客户经理", @"客户层级", @"提升差距", @"未签约"];
        CGFloat width = self.customerTable.size.width / titles.count;
        int i = 0;
        CGFloat height = 30;
        for (NSString *title in titles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width * i, 5, width, height);
            button.selected = NO;
            button.titleLabel.font = K_FONT_13;
            [button setTitleColor:RGB(66, 80, 93, 1.0) forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeCenter;
            button.userInteractionEnabled = NO;
            [button setTitle:title forState:UIControlStateNormal];
            button.tag = 100 + i;
            
            if (i == 0 || i == 6 || i == 7 || i == 8) {
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
                CGSize size = [Public sizeOfString:title defaultSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withFont:K_FONT_13];
                CGFloat spacing = size.width + 15;
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, spacing, 0, 0)];
                [button setImage:[UIImage imageNamed:@"paixu1"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"paixu2"] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
                button.userInteractionEnabled = YES;
            }
            
            [_headView addSubview:button];
            
            i++;
        }
    }
    return _headView;
}

#pragma mark UITableView数据源和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customers.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.headView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CustomerCell";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    Customer *customer = _customers[indexPath.row];
    cell.customer = customer;
    cell.delegate = self;
    //异步判断用户是否存在图片
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDictionary *paramDic = @{@"branch":[CommonUtils sharedInstance].currentBranch.branchNo, @"queue_num":customer.ticketNo};
        [InvokeManager invokeApi:@"ibpimgcz" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
            if ([responseCode isEqualToString:@"I00"]) {
                id item = [responseInfo valueForKey:@"result"];
                if ([item isKindOfClass:[NSDictionary class]]) {
                    BOOL isExist = [[(NSDictionary *)item valueForKey:@"isExist"] boolValue];
                    dispatch_async(dispatch_get_main_queue(), ^{//主线程中更新UI
                        cell.hasPhoto = isExist;
                    });
                }
            }
        } onFailure:^(NSString *responseCode, NSString *responseInfo) {

        }];
    });

    //异步判断是否当天生日
    dispatch_async(queue, ^{
        NSDictionary *paramDic = @{@"zjlx":@"A", @"zjhm":customer.idCardNum};
        [InvokeManager invokeApi:@"ocrmgcbi" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
            if ([responseCode isEqualToString:@"I00"]) {
                id resultDic = [responseInfo valueForKey:@"result"];
                if ([resultDic isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)resultDic;
                    NSString *birth = [dic valueForKey:@"sr"];
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *today = [formatter stringFromDate:date];
                    BOOL isBirthday = NO;
                    if ([[today substringFromIndex:5] isEqualToString:[birth substringFromIndex:5]]) {
                        isBirthday = YES;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.isBirthday = isBirthday;
                    });
                }
            }
        } onFailure:^(NSString *responseCode, NSString *responseInfo) {

        }];
    });
    //判断是否有关注
    if (customer.care && ![customer.care isEqualToString:@""]) {
        cell.hasCare = YES;
        cell.careProducts = ^(id toucher, NSString *careInfo) {//有关注消息处理
            if ([toucher isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)toucher;
                CGSize careInfoSize = [Public sizeOfString:careInfo defaultSize:CGSizeMake(100, 400) withFont:K_FONT_13];
                //关注信息
                UIView *superView = btn.superview.superview.superview;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, superView.frame.origin.y + 25, careInfoSize.width + 30, careInfoSize.height + 30)];
                imageView.image = [Public imageScales:[UIImage imageNamed:@"careInfo"]];
                
                UILabel *care = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, careInfoSize.width, careInfoSize.height)];
                care.font = K_FONT_13;
                care.numberOfLines = 0;
                
                care.textColor = [UIColor whiteColor];
                care.text = careInfo;
                [imageView addSubview:care];
                
                [self.customerTable addSubview:imageView];
                
                [self performSelector:@selector(careInfoDismiss:) withObject:imageView afterDelay:3];
            }
        };
    }
    return cell;
}

- (void)careInfoDismiss:(id)obj
{
    if ([obj isKindOfClass:[UIImageView class]]) {
        [obj removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Customer *cust = _customers[indexPath.row];
    if ([cust.idCardNum isEqualToString:@""] || !cust.idCardNum) {
        [self showMessage:@"该客户无客户信息或身份信息不全"];
        return;
    }
    CustomerView *custView = (CustomerView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomerView" owner:nil options:nil] firstObject];
    
    custView.customer = cust;
    
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
    baseView.view = custView;
    [baseView show];
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CustomerCell *selectedCell = (CustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
//    selectedCell.changedBackgroundColor = YES;
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CustomerCell *selectedCell = (CustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
//    selectedCell.changedBackgroundColor = NO;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomerCell cellHeight];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -- 排序

- (void)sort:(UIButton *)sender
{
    if (_currentSender && sender.tag != _currentSender.tag) {
        _currentSender.selected = NO;
    }
    if (sender.selected) {
        switch (sender.tag) {
            case 100:
                [self sortByTime:2];
                break;
            case 106:
                [self sortByLevel:2];
                break;
            case 107:
                [self sortByGap:2];
                break;
            case 108:
                [self sortByUnsignNum:2];
                break;
                
            default:
                break;
        }
        
    } else {
        
        switch (sender.tag) {
            case 100:
                [self sortByTime:1];
                break;
            case 106:
                [self sortByLevel:1];
                break;
            case 107:
                [self sortByGap:1];
                break;
            case 108:
                [self sortByUnsignNum:1];
                break;
                
            default:
                break;
        }
    }
    sender.selected = !sender.isSelected;
    _currentSender = sender;
    [_customerTable reloadData];
}


- (void)sortByTime:(int)flag //flag 1 升序 2 降序
{
    NSArray *temp = [_customers sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Customer *obj1, Customer * obj2) {
        if (flag == 1) {
            return [obj2.ticketTime compare:obj1.ticketTime];
        } else {
            return [obj1.ticketTime compare:obj2.ticketTime];
        }
    }];
    _customers = [NSMutableArray arrayWithArray:temp];
}

- (void)sortByLevel:(int)flag //flag 1 升序 2 降序
{
    NSArray *temp = [_customers sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Customer *obj1, Customer * obj2) {
        if (flag == 1) {
            return [obj2.custLevel compare:obj1.custLevel];
        } else {
            return [obj1.custLevel compare:obj2.custLevel];
        }
    }];
    _customers = [NSMutableArray arrayWithArray:temp];
}

- (void)sortByGap:(int)flag //flag 1 升序 2 降序
{
    NSArray *temp = [_customers sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Customer *obj1, Customer * obj2) {
        if (flag == 1) {
            return [obj2.gap intValue] > [obj1.gap intValue];
        } else {
            return [obj1.gap intValue] > [obj2.gap intValue];
        }
    }];
    _customers = [NSMutableArray arrayWithArray:temp];;
}

- (void)sortByUnsignNum:(int)flag //flag 1 升序 2 降序
{
    NSArray *temp = [_customers sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Customer *obj1, Customer * obj2) {
        if (flag == 1) {
            return [obj2.unsignNum intValue] > [obj1.unsignNum intValue];
        } else {
            return [obj1.unsignNum intValue] > [obj2.unsignNum intValue];
        }
    }];
    _customers = [NSMutableArray arrayWithArray:temp];;
}

#pragma mark 转移 转介 移除等功能

- (void)didTouchOnTurnTo:(CustomerCell *)cell
{
//    TurnToView *turnView = (TurnToView *)[[[NSBundle mainBundle] loadNibNamed:@"TurnToView" owner:nil options:nil] firstObject];
//    
//    turnView.customer = cell.customer;
//    
//    turnView.UpdateData = ^{//转移结束后，更新当前数据
//        [self invokeCustomers];
//    };
//    
//    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
//    baseView.view = turnView;
//    [baseView show];
    TurnView *turnView = [[TurnView alloc] init];
    
    turnView.customer = cell.customer;
    
    turnView.UpdateData = ^{//转移结束后，更新当前数据
        [self invokeCustomers];
    };
    
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
    baseView.view = turnView;
    [baseView show];
}

- (void)didTouchOnTransfer:(CustomerCell *)cell
{
    RegisterView *view = (RegisterView *)[[[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:nil options:nil] firstObject];
    view.customerModel = cell.customer;
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
    baseView.isAutoClose = YES;
    baseView.view = view;
    [baseView show];

}

- (void)didTouchOnMoveOut:(CustomerCell *)cell
{
    MoveOutCustomerView *custView = (MoveOutCustomerView *)[[[NSBundle mainBundle] loadNibNamed:@"MoveOutCustomerView" owner:nil options:nil] firstObject];
    
    custView.moveoutCustomer = ^(MoveOutCustomerView *moveoutView){//移除事件
        [self moveout:cell view:moveoutView];
    };
    
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.7;
    baseView.view = custView;
    [baseView show];
}

- (void)moveout:(CustomerCell *)cell view:(MoveOutCustomerView *)moveoutView
{
    [self startAnimateInView:self.splitVc.view];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    [paramDic setObject:cell.customer.ticketNo forKey:@"queue_num"];
    
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [self stopAnimate];
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        [self stopAnimate];
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                [_customers removeObject:cell.customer];//先删除数据源 再去删除cell
                NSIndexPath *indexPath = [_customerTable indexPathForCell:cell];
                [_customerTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self showMessage:@"移除失败"];
            }
        } else {
            [self showMessage:responseInfo];
        }
    };
    
    [InvokeManager invokeApi:@"ibpcustdel" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

//#pragma mark 检查应用更新
//- (void)checkUpdate {
//    
//    // 请求更新数据
//    NSDictionary *paramDic = @{@"appId":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"], @"deviceType":@"iPhone"};
//    [InvokeManager invokeApi:@"cav" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
//        
//        if ([responseCode isEqualToString:@"0"] || [responseCode isEqualToString:@"I00"]) {
//            if (responseInfo != nil) {
//                
//                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[responseInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//                
//                NSDictionary *result;
//                if (info) {
//                    result = [info objectForKey:@"result"];
//                }
//                
//                // 获取最新版本信息
//                NSString *versionCode, *versionName, *versionUrl, *versionInfo;
//                if (result) {
//                    versionCode = [result objectForKey:@"versionCode"];
//                    versionName = [result objectForKey:@"versionName"];
//                    versionUrl = [result objectForKey:@"url"];
//                    versionInfo = [result objectForKey:@"txt"];
//                    
//                    // 以下避免出现NSNull
//                    versionCode = [NSString stringWithFormat:@"%@", versionCode];
//                    versionName = [NSString stringWithFormat:@"%@", versionName];
//                    versionUrl = [NSString stringWithFormat:@"%@", versionUrl];
//                    versionInfo = [NSString stringWithFormat:@"%@", versionInfo];
//                    sourceURL = versionUrl;
//                }
//                
//                // 比对最新版本
//                NSString *curVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];  // build
//                if (versionCode && [versionCode intValue] > [curVersionCode intValue]) {  // 如果有新版本
//                    // 设备本地版本信息
//                    NSString *alerInfo = [NSString stringWithFormat:@"版本V%@可更新", versionName];
//                    
//                    // 弹窗提示
//                    NSString *msg = versionInfo;
//                    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alerInfo message:msg preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                            NSURL *appUrl = [NSURL URLWithString:versionUrl];
//                            [[UIApplication sharedApplication] openURL:appUrl];
//                        }];
//                        
//                        [alert addAction:cancelAction];
//                        [alert addAction:sureAction];
//                        [self presentViewController:alert animated:YES completion:nil];
//                        
//                    } else {
//                        
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alerInfo
//                                                                        message:msg
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"取消"
//                                                              otherButtonTitles:@"确定", nil];
//                        [alert setTag:8502];
//                        [alert show];
//                    }
//                }
//            }
//        }
//    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
//        
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
