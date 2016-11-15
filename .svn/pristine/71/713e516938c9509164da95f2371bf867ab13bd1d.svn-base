//
//  BankOutletsController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "BankOutletsController.h"
#import "CicleView.h"
#import "ChartView.h"
#import "CustomIndicatorView.h"
#import "CommonUtils.h"
#import "Branch.h"
#import "Station.h"
#import "AppDelegate.h"


@interface BankOutletsController ()
{
    BOOL _showLoading;
}
@property (weak, nonatomic) IBOutlet UIView *custNumView;
@property (weak, nonatomic) IBOutlet UILabel *custNum;

@property (weak, nonatomic) IBOutlet UIView *preorderView;
@property (weak, nonatomic) IBOutlet UILabel *preorderNum;

@property (weak, nonatomic) IBOutlet UIView *activeView;
@property (weak, nonatomic) IBOutlet UILabel *activeNum;

@property (weak, nonatomic) IBOutlet UIView *unactiveView;
@property (weak, nonatomic) IBOutlet UILabel *unactiveNum;

@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIView *validateView;
@property (weak, nonatomic) IBOutlet UIView *satifyView;

@property (weak, nonatomic) IBOutlet UILabel *allTicketsNum;
@property (weak, nonatomic) IBOutlet UILabel *quitTicketNum;
@property (weak, nonatomic) IBOutlet CicleView *quitRateView;

@property (weak, nonatomic) IBOutlet UILabel *validateNum;
@property (weak, nonatomic) IBOutlet UILabel *validateCustNum;
@property (weak, nonatomic) IBOutlet CicleView *validateRateView;

@property (weak, nonatomic) IBOutlet UILabel *badNum;
@property (weak, nonatomic) IBOutlet UILabel *validateAllNum;
@property (weak, nonatomic) IBOutlet CicleView *badRateView;
@property (weak, nonatomic) IBOutlet CicleView *satisfyRateView;

@end

@implementation BankOutletsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUI];
    
    [self setup];
}

- (void)updateUI
{
    _custNumView.layer.cornerRadius = 5;
    _custNumView.clipsToBounds = YES;
    
    _preorderView.layer.cornerRadius = 5;
    _preorderView.clipsToBounds = YES;
    
    _activeView.layer.cornerRadius = 5;
    _activeView.clipsToBounds = YES;
    
    _unactiveView.layer.cornerRadius = 5;
    _unactiveView.clipsToBounds = YES;
    
    _dataView.layer.cornerRadius = 5;
    _dataView.clipsToBounds = YES;
    
    _validateView.layer.cornerRadius = 4;
    _validateView.clipsToBounds = YES;
    
    _satifyView.layer.cornerRadius = 3;
    _satifyView.clipsToBounds = YES;
}

- (void)setup
{
    self.quitRateView.backcolor = RGB(201, 209, 211, 1.0);
    self.quitRateView.strokenWidth = 2;
    self.quitRateView.frontcolor = RGB(255, 205, 83, 1.0);
    self.quitRateView.arcWidth = 4;
    self.quitRateView.percentVal = @"0.0";
    
    self.validateRateView.backcolor = RGB(201, 209, 211, 1.0);
    self.validateRateView.strokenWidth = 2;
    self.validateRateView.frontcolor = RGB(118, 119, 255, 1.0);
    self.validateRateView.arcWidth = 4;
    self.validateRateView.percentVal = @"0.0";
    
    self.badRateView.backcolor = RGB(201, 209, 211, 1.0);
    self.badRateView.strokenWidth = 2;
    self.badRateView.frontcolor = RGB(247, 112, 75, 1.0);
    self.badRateView.arcWidth = 4;
    self.badRateView.percentVal = @"0.0";
    
    self.satisfyRateView.backcolor = RGB(201, 209, 211, 1.0);
    self.satisfyRateView.strokenWidth = 2;
    self.satisfyRateView.frontcolor = RGB(120, 223, 150, 1.0);
    self.satisfyRateView.arcWidth = 4;
    self.satisfyRateView.percentVal = @"0.0";
}

- (void)chartView
{
    ChartView *chartView = [[ChartView alloc] init];
    chartView.backgroundColor = [UIColor whiteColor];
    chartView.frame = CGRectMake(0, 50, _dataView.frame.size.width, _dataView.frame.size.height - 50);
    chartView.bottomValues = @[@"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00"];
    chartView.ticketsNumbers = @[@(20), @(30), @(25), @(175), @(10), @(100), @(50), @(60), @(35), @(70)];
    [_dataView addSubview:chartView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self invokeBankoutlet];
}

- (void)initTimer
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.myTimer = [NSTimer scheduledTimerWithTimeInterval:[GlobleData sharedInstance].timeInterval target:self selector:@selector(invokeBankoutlet) userInfo:nil repeats:YES ];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.myTimer) {
        
        [delegate.myTimer setFireDate:[NSDate distantPast]];
    } else {
        
        [self performSelector:@selector(initTimer) withObject:nil afterDelay:30];
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
    if (delegate.myTimer) {
        [delegate.myTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.myTimer isValid]) {
        [delegate.myTimer invalidate];
        delegate.myTimer = nil;
    }
}

- (void)invokeBankoutlet
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
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSArray *item = [responseInfo valueForKey:@"result"];
                if ([item count] > 0) {
                    NSDictionary *dic = item[0];
                    NSString *isreservNumStr = dic[@"isReservNum"];
                    NSString *isReservNum = (isreservNumStr == nil || [isreservNumStr isEqualToString:@""]) ? @"0" : isreservNumStr;
                    NSString *negativeNumStr = dic[@"negativeNum"];
                    NSString *negativeNum = (negativeNumStr == nil || [negativeNumStr isEqualToString:@""]) ? @"0" : negativeNumStr;
                    NSString *noReservNumStr = dic[@"noReservNum"];
                    NSString *noReservNum = (noReservNumStr == nil || [noReservNumStr isEqualToString:@""]) ? @"0" : noReservNumStr;
                    NSString *totalAbandonNumStr = dic[@"totalAbandonNum"];
                    NSString *totalAbandonNum = (totalAbandonNumStr == nil || [totalAbandonNumStr isEqualToString:@""]) ? @"0" : totalAbandonNumStr;
                    NSString *totalCallNumStr = dic[@"totalCallNum"];
                    NSString *totalCallNum = (totalCallNumStr == nil || [totalCallNumStr isEqualToString:@""]) ? @"0" : totalCallNumStr;
                    NSString *totalServiceNumStr = dic[@"totalServiceNum"];
                    NSString *totalServiceNum = (totalServiceNumStr == nil || [totalServiceNumStr isEqualToString:@""]) ? @"0" : totalServiceNumStr;
                    
                    _preorderNum.text = totalAbandonNum;
                    _activeNum.text = isReservNum;
                    _unactiveNum.text = noReservNum;
                    _allTicketsNum.text = totalCallNum;
                    _quitTicketNum.text = totalAbandonNum;
                    _validateCustNum.text = totalServiceNum;
                    _badNum.text = negativeNum;
                    
                    [self invokeValidate];
                }
            }
            
        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
    [InvokeManager invokeApi:@"ibpkli" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (void)invokeValidate
{
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
                id item = [responseInfo valueForKey:@"result"];
                if ([item isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)item;
                    
                    NSString *totalQueueNum = [dic valueForKey:@"totalQueueNum"];
                    NSString *assessRate = [dic valueForKey:@"assessRate"];
                    NSString *verySatisfyRate = [dic valueForKey:@"verySatisfyRate"];
                    NSString *notSatisfyRate = [dic valueForKey:@"notSatisfyRate"];
                    NSString *totalAccessNum = [dic valueForKey:@"totalAccessNum"];
                    NSString *abandonRate = [dic valueForKey:@"abandonRate"];
                    
                    _validateNum.text = totalAccessNum;
                    _validateAllNum.text = totalAccessNum;
                    _custNum.text = totalQueueNum;
                    
                    CGFloat quit = [[abandonRate substringToIndex:abandonRate.length - 1] floatValue] / 100;
                    CGFloat validate = [[assessRate substringToIndex:assessRate.length - 1] floatValue] / 100;
                    CGFloat bad = [[notSatisfyRate substringToIndex:notSatisfyRate.length - 1] floatValue] / 100;
                    CGFloat satisify = [[verySatisfyRate substringToIndex:verySatisfyRate.length - 1] floatValue] / 100;
                    
                    self.quitRateView.percentVal = [NSString stringWithFormat:@"%.2f", quit];
                    self.validateRateView.percentVal = [NSString stringWithFormat:@"%.2f", validate];
                    self.badRateView.percentVal = [NSString stringWithFormat:@"%.2f", bad];
                    
                    self.satisfyRateView.percentVal = [NSString stringWithFormat:@"%.2f", satisify];
                }
            }
            
        } else if ([responseCode isEqualToString:@"I03"] || [responseCode isEqualToString:@"I02"]) {
            [self stopAnimate];
        }
    };
    
    [InvokeManager invokeApi:@"ibpgca" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
