//
//  WorkStationController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "WorkStationController.h"
#import "StationCollectionCell.h"
#import "CommonAlertView.h"
#import "StationSettingView.h"
#import "CustomIndicatorView.h"
#import "CommonUtils.h"
#import "Branch.h"
#import "Station.h"
#import "AppDelegate.h"


@interface WorkStationController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_stationsArray;
    BOOL _showLoading;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WorkStationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stationsArray = [NSMutableArray array];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"StationCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"StationCollectionCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self invokeStation];
}

- (void)initTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.stationTimer = [NSTimer scheduledTimerWithTimeInterval:[GlobleData sharedInstance].timeInterval target:self selector:@selector(invokeStation) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.stationTimer) {
        [delegate.stationTimer setFireDate:[NSDate distantPast]];
    } else {
        
        [self performSelector:@selector(initTimer) withObject:nil afterDelay:0];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopTimer];
    _showLoading = NO;
    if ([[CustomIndicatorView sharedView] isAnimating]) {
        [[CustomIndicatorView sharedView] stopAnimating];
    }
}

- (void)stopTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.stationTimer) {//定时器停止工作
            [delegate.stationTimer setFireDate:[NSDate distantFuture]];
        }
}

- (void)dealloc
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.stationTimer isValid]) {
        [delegate.stationTimer invalidate];
        delegate.stationTimer = nil;
    }
}

- (void)invokeStation
{
    if (!_showLoading) {
        [self startAnimateInView:self.view];
        _showLoading = YES;
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    
    
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
                NSArray *result = [responseInfo valueForKey:@"result"];
                NSMutableArray *stas = [NSMutableArray array];
                for (NSDictionary *item in result) {
                    Station *sta = [[Station alloc] init];
                    sta.stationNo = item[@"winNum"];
                    sta.tellerName = item[@"tellerName"];
                    sta.serverStatus = item[@"status"];
                    sta.currentCustName = item[@"custinfoName"];
                    sta.serverNum = item[@"peopleCount"];
                    sta.duration = item[@"averageTime"];
                    sta.tellerNum = item[@"tellerNum"];
                    sta.callRule = item[@"callRule"];
                    sta.callRuleID = item[@"parameterId"];
                    sta.qmNum = item[@"qmNum"];
                    sta.queueNum = item[@"queueNum"];
                    
                    [stas addObject:sta];
                }
                
                //排序
                //1.首页按照服务中->空闲->暂停服务->离线的顺序排列（status分别为2，1，3，0）
                //2.然后如果状态相同 按照窗口号排序
                [stas sortUsingComparator:^NSComparisonResult(Station *obj1, Station *obj2) {
                    NSComparisonResult result = [obj2.serverStatus compare:obj1.serverStatus];
                    if ([obj2.serverStatus isEqualToString:@"3"] && ([obj1.serverStatus isEqualToString:@"1"] || [obj1.serverStatus isEqualToString:@"2"])) {
                        result = NSOrderedAscending;
                    }
                    else if ([obj1.serverStatus isEqualToString:@"3"] && ([obj2.serverStatus isEqualToString:@"1"] || [obj2.serverStatus isEqualToString:@"2"])) {
                        result = NSOrderedDescending;
                    }
                    if (result == NSOrderedSame) {
                        int station1No = [obj1.stationNo intValue];
                        int station2No = [obj2.stationNo intValue];
                        if (station1No < station2No) {
                            result = NSOrderedAscending;
                        }
                        else {
                            result = NSOrderedDescending;
                        }
                    }
                    return result;
                }];
                
                _stationsArray = stas;
                
                [self.collectionView reloadData];
            } else {
                [self showMessage:[responseInfo valueForKey:@"result"]];
            }
        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
    [InvokeManager invokeApi:@"ibpgws" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark CollectionView 数据源和方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _stationsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"StationCollectionCell";
    
    StationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    Station *station = _stationsArray[indexPath.row];
    
    cell.station = station;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (COM_INSTANCE.callRuleGroupOfBranch.count == 0) {
        [[CustomIndicatorView sharedView] showInView:self.view];
        [[CustomIndicatorView sharedView] startAnimating];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
        
        void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
            [[CustomIndicatorView sharedView] stopAnimating];
        };
        
        void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
            
            if ([responseCode isEqualToString:@"I00"]) {
                NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
                if ([resultCode isEqualToString:@"0"]) {
                    NSDictionary *result = [responseInfo valueForKey:@"result"];
                    id callGroup = [result objectForKey:@"callRuleInfoGroup"];
                    
                    if ([callGroup isKindOfClass:[NSArray class]]) {
                        COM_INSTANCE.callRuleGroupOfBranch = (NSArray *)callGroup;
                        StationSettingView *setView = (StationSettingView *)[[[NSBundle mainBundle] loadNibNamed:@"StationSettingView" owner:nil options:nil] firstObject];
                        [setView setStation:_stationsArray[indexPath.row]];
                        setView.rebackHandleResult = ^(NSString *result) {//处理结果
                            [self showMessage:result];
                        };
                        
                        CommonAlertView *baseView = [[CommonAlertView alloc] init];
//                        baseView.backAlpah = 0.7;
                        baseView.view = setView;
                        [baseView show];
                    }
                }
            } else {
                [self showMessage:responseInfo];
            }
            [[CustomIndicatorView sharedView] stopAnimating];
        };
        
        [InvokeManager invokeApi:@"ibpjgjhgz" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
    } else {
        StationSettingView *setView = (StationSettingView *)[[[NSBundle mainBundle] loadNibNamed:@"StationSettingView" owner:nil options:nil] firstObject];
        [setView setStation:_stationsArray[indexPath.row]];
        setView.rebackHandleResult = ^(NSString *result) {//处理结果
            [self showMessage:result];
        };
        
        CommonAlertView *baseView = [[CommonAlertView alloc] init];
//        baseView.backAlpah = 0.7;
        baseView.view = setView;
        [baseView show];
    }
    
}

- (void)startAnimateInView:(UIView *)view
{
    CustomIndicatorView *indicatorView = [CustomIndicatorView sharedView];
    [indicatorView showInView:view];
    [indicatorView startAnimating];
}

- (void)stopAnimate
{
    [[CustomIndicatorView sharedView] stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
