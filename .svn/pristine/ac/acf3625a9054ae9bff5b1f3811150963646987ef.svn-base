//
//  LockViewController.m
//  CIBSafeBrowser
//
//  Created by CIB-Mac mini on 14-12-31.
//  Copyright (c) 2014年 cib. All rights reserved.
//

#import "LockViewController.h"
#import "LockIndicator.h"
#import "LockConfig.h"
#import "ImageAlertView.h"
#import "AppDelegate.h"
#import "SwySplitViewController.h"
#import "MasterViewController.h"
#import "QueueViewController.h"
#import "TransferController.h"
#import "WorkStationController.h"
#import "BadPostController.h"
#import "BankOutletsController.h"
#import "DateHomeController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface LockViewController ()

@property (nonatomic, strong) IBOutlet LockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) IBOutlet LockView* lockview; // 触摸田字控件

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *tipLable;
@property (strong, nonatomic) IBOutlet UIButton *tipButton; // 重设/(取消)的提示按钮
@property (nonatomic, strong) NSString *passwordOld; // 旧密码
@property (nonatomic, strong) NSString *passwordNew; // 新密码
@property (nonatomic, strong) NSString *passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString *tip1; // 三步提示语
@property (nonatomic, strong) NSString *tip2;
@property (nonatomic, strong) NSString *tip3;

@property(nonatomic, assign) UIStatusBarStyle preStatusBarStyle;

@end


@implementation LockViewController
{
    BOOL isCorrect;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(LockViewType)type
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
    }
    return self;
}

- (id)initWithType:(LockViewType)type user:(NSString *)user
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround"]];
    self.lockview.delegate = self;
    [self showEvaluatePolicy];
}

// 是否支持转屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef LockAnimationOn
    [self capturePreSnap];
#endif
    // 初始化内容
    switch (_nLockViewType) {
        case LockViewTypeCheck:
        {
            self.lockview.frame = CGRectMake(self.lockview.frame.origin.x, self.view.frame.size.height / 2.0 - 140, self.lockview.frame.size.width, self.lockview.frame.size.height);
            self.tipLable.frame = CGRectMake(self.tipLable.frame.origin.x, self.tipLable.frame.origin.y - 80, self.tipLable.frame.size.width, self.tipLable.frame.size.height);
            self.tipButton.frame = CGRectMake(self.tipButton.frame.origin.x, self.tipButton.frame.origin.y - 5, self.tipButton.frame.size.width, self.tipButton.frame.size.height);
            NSLog(@"%f",self.lockview.frame.origin.y);
            _titleLable.text = @"";
            _tipLable.text = [NSString stringWithFormat:@"请绘制手势密码解锁"];
        }
            break;
        case LockViewTypeCreate:
        {
            _titleLable.text = @"设置手势密码";
            _tipLable.text = @"绘制手势密码图案";
        }
            break;
        case LockViewTypeModify:
        {
            _titleLable.text = @"修改手势密码";
            _tipLable.text = @"请输入原来的密码";
        }
            break;
        case LockViewTypeClean:
        default:
        {
            _tipLable.text = @"请输入密码以清除密码";
        }
    }
    
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    [self updateTipButtonStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString *)string
{
    // 验证密码正确
    NSDictionary *usrPswInfo = [self getUserPswInfo];
    NSString *pswSting = [usrPswInfo objectForKey:@"usrPsw"];
    NSString *testTimes = [usrPswInfo objectForKey:@"testTimes"];
    if ([pswSting isEqualToString:string]) {
        isCorrect = YES;
        [self saveUserPswInfo:string andTestTimes:@"4"];
        [self hide];
    }

    // 验证密码错误
    else if (string.length > 0) {
        
        NSInteger nRetryTimesRemain = [testTimes intValue];
        if (nRetryTimesRemain > 0) {
            
            if (1 == nRetryTimesRemain) {
                [self setErrorTip:[NSString stringWithFormat:@"最后的机会咯-_-!"]
                        errorPswd:string];
            } else {
                [self setErrorTip:[NSString stringWithFormat:@"密码错误，还可以再输入%d次", (int)nRetryTimesRemain]
                        errorPswd:string];
            }
            [self saveUserPswInfo:pswSting andTestTimes:testTimes];
            
        }else{
            
            // 强制注销该账户，并清除手势密码，以便重设
            [self dismissViewControllerAnimated:NO completion:^{
                [self clearUserPswInfo];
                if (_failBlock) {
                    _failBlock();
                }
            }];
        }
        
    } else {
        NSAssert(YES, @"手势验证发生意外");
    }
}

// 存取用户密码信息
- (void)saveUserPswInfo:(NSString *)pswString andTestTimes:(NSString *)testTimes{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *usrPsw = pswString;
    NSInteger nRetryTimesRemain;
    if (isCorrect) {
        nRetryTimesRemain = [testTimes intValue];
    }else{
        nRetryTimesRemain = [testTimes intValue] - 1;
    }
    NSString *testtimes = [NSString stringWithFormat:@"%ld",(long)nRetryTimesRemain];
    NSDictionary *usrPswInfo = [NSDictionary dictionaryWithObjectsAndKeys:usrPsw,@"usrPsw",testtimes,@"testTimes", nil];
    NSString *usrId = [CommonUtils sharedInstance].noteId;
    [userDefault setObject:usrPswInfo forKey:usrId];
    
    [userDefault synchronize];

}

// 获取用户密码信息
- (NSDictionary *)getUserPswInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *usrId = [CommonUtils sharedInstance].noteId;
    NSDictionary *usrPswInfo = [userDefault objectForKey:usrId];
    return usrPswInfo;
}
// 清除用户密码信息
- (void)clearUserPswInfo{
    NSString *userid = [CommonUtils sharedInstance].noteId;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)createPassword:(NSString *)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        // 检查最小长度
        int minLength;
    #ifdef LOCK_PWD_WITH_SEPARATOR  // 兼容老版本的string（逗号分隔）
        minLength = 2 * LOCK_MIN_PWD_LENGTH - 1; // 2n-1
    #else
        minLength = LOCK_MIN_PWD_LENGTH;
    #endif
        
        if ([string length] < minLength) {
            [self updateTipButtonStatus];
            [self setErrorTip:[NSString stringWithFormat:@"密码至少%d位，请重新绘制", LOCK_MIN_PWD_LENGTH] errorPswd:string];
            return;
        }
        self.passwordNew = string;
        [self setTip:self.tip2];
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {

        self.passwordconfirm = string;
        
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) { // 成功

            ImageAlertView *imageAlert = [[ImageAlertView alloc] initWithFrame:self.view.frame];
            imageAlert.autoHideAfterSeconds = 3.0;
            imageAlert.isHasBtn = NO;
            NSString *messageStr = @"设置手势密码成功，正在进入主页...";
            UIImage *image = [UIImage imageNamed:@"ic_ok"];
            [imageAlert viewShowWithImage:image message:messageStr];
            [self.view addSubview:imageAlert];
            self.tipLable.text = @"密码设置成功";
            self.tipLable.textColor = [UIColor whiteColor];
            [self performSelector:@selector(hide) withObject:nil afterDelay:3.0];
            [self performSelector:@selector(enterMainViewVc) withObject:nil afterDelay:3.0];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *usrPsw = string;
            NSString *testTimes = @"4";
            NSDictionary *usrPswInfo = [NSDictionary dictionaryWithObjectsAndKeys:usrPsw,@"usrPsw",testTimes,@"testTimes", nil];
            NSString *usrId = [CommonUtils sharedInstance].noteId;
            [userDefault setObject:usrPswInfo forKey:usrId];
            [userDefault synchronize];
        } else {
            self.passwordconfirm = @"";
            [self setTip:self.tip2];
            [self setErrorTip:@"密码不一致，请重新输入" errorPswd:string];
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}

#pragma mark - 显示提示
- (void)setTip:(NSString *)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorNormal];
    
    _tipLable.alpha = 0;
    [UIView animateWithDuration:0.8
                     animations:^{
                          _tipLable.alpha = 1;
                     }completion:^(BOOL finished){
                     }
     ];
}

// 错误
- (void)setErrorTip:(NSString *)tip errorPswd:(NSString *)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_tipLable setText:tip];
    [_tipLable setTextColor:UIColorFromRGB(0xff2a00)];
    [_tipLable setFont:[UIFont systemFontOfSize:15]];
    
    [self shakeAnimationForView:_tipLable];
}

#pragma mark 新建/修改后保存
// 重设TipButton
- (void)updateTipButtonStatus
{
    if ((_nLockViewType == LockViewTypeCreate || _nLockViewType == LockViewTypeModify) &&
        ![self.passwordNew isEqualToString:@""]) // 新建或修改 & 确认时 显示
    {
        [self.tipButton setTitle:@"重新设置手势密码" forState:UIControlStateNormal];
        [self.tipButton removeFromSuperview];
        [self.tipButton setAlpha:1.0];
        
    }
    else if (_nLockViewType == LockViewTypeCheck)  // 解锁时 显示
    {
        [self.tipButton setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
        
        [self.tipButton setAlpha:1.0];
    }
    else if (_nLockViewType == LockViewTypeModify && [self.passwordNew isEqualToString:@""]) {  // 修改 & 未输入 时显示
        [self.tipButton setTitle:@"取消修改" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
    }
    else {
        [self.tipButton setAlpha:0.0];
    }
    
    // 更新指示圆点
    if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]){
        self.indecator.hidden = NO;
        [self.indecator setPasswordString:self.passwordNew];
    } else {
        self.indecator.hidden = YES;
    }
}

#pragma mark - 点击了按钮
- (IBAction)tipButtonPressed:(id)sender {
    if (_nLockViewType == LockViewTypeModify && [self.passwordNew isEqualToString:@""]) {  // 点击取消修改
        [self dismissViewControllerAnimated:YES completion:^{
            if (_succeededBlock) {
                _succeededBlock();
            }
        }];
    }
    else if (_nLockViewType != LockViewTypeCheck) {
        self.passwordNew = @"";
        self.passwordconfirm = @"";
        [self setTip:self.tip1];
        [self updateTipButtonStatus];
    }
    else {  // 点击忘记手势作失败处理
        
        // 强制注销该账户，并清除手势密码，以便重设
        [self dismissViewControllerAnimated:NO completion:^{
            [self clearUserPswInfo];
            if (_failBlock) {
                _failBlock();
            }
        }];
    }
}

#pragma mark - 成功后返回
- (void)hide
{
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    if (_succeededBlock) {
        _succeededBlock();
    }

#ifdef LockAnimationOn
     [self captureCurrentSnap];
    // 隐藏控件
    for (UIView* v in self.view.subviews) {
        if (v.tag > 10000) continue;
        v.hidden = YES;
    }
    // 动画解锁
    [self animateUnlock];

#endif
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string
{    
    switch (_nLockViewType) {
            
        case LockViewTypeCheck:
        {
            self.tip1 = @"请输入解锁密码";
            [self checkPassword:string];
        }
            break;
        case LockViewTypeCreate:
        {
            self.tip1 = @"绘制手势密码图案";
            self.tip2 = @"请再次绘制解锁图案";
            self.tip3 = @"设置手势密码成功，正在进入主页...";
            [self createPassword:string];
        }
            break;
        case LockViewTypeModify:
        {
            if ([self.passwordOld isEqualToString:@""]) {
                self.tip1 = @"请输入原来的密码";
                [self checkPassword:string];
            } else {
                self.tip1 = @"请绘制新的解锁图案";
                self.tip2 = @"请再次绘制解锁图案";
                self.tip3 = @"设置手势密码成功，正在进入主页...";
                [self createPassword:string];
            }
        }
            break;
        case LockViewTypeClean:
        default:
        {
            self.tip1 = @"请输入密码以清除密码";
            self.tip2 = @"解锁密码清除成功";
            [self checkPassword:string];
        }
    }
    [self updateTipButtonStatus];
}

#pragma mark - 解锁动画
// 截屏，用于动画
#ifdef LockAnimationOn
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 上一界面截图
- (void)capturePreSnap
{
    self.preSnapImageView.hidden = YES; // 默认是隐藏的
    self.preSnapImageView.image = [self imageFromView:self.presentingViewController.view];
}

// 当前界面截图
- (void)captureCurrentSnap
{
    self.currentSnapImageView.hidden = YES; // 默认是隐藏的
    self.currentSnapImageView.image = [self imageFromView:self.view];
}

- (void)animateUnlock {
    
    self.currentSnapImageView.hidden = NO;
    self.preSnapImageView.hidden = NO;
    
    static NSTimeInterval duration = 0.5;
    
    // currentSnap
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    
    CABasicAnimation *opacityAnimation;
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue=[NSNumber numberWithFloat:1];
    opacityAnimation.toValue=[NSNumber numberWithFloat:0];
    
    CAAnimationGroup* animationGroup =[CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO; // 防止最后显现
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.currentSnapImageView.layer addAnimation:animationGroup forKey:nil];
    
    // preSnap
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;

    [self.preSnapImageView.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.currentSnapImageView.hidden = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    self.preSnapImageView = nil;
    self.currentSnapImageView = nil;
}
#endif

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - 指纹验证提示
- (void)showEvaluatePolicy
{
    //只有当检查手势密码时，弹出指纹验证
    if (self.nLockViewType == LockViewTypeCheck) {
        LAContext *context = [LAContext new];
        context.localizedFallbackTitle = @"验证手势密码";
        NSError *error;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证您的指纹ID" reply:^(BOOL success, NSError *error) {
                if (success) {
                    
                    if (self.succeededBlock) {
                        self.succeededBlock();
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }
}

- (void)jumpToMainVc{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enterMainViewVc{
    SwySplitViewController *splitVc = [[SwySplitViewController alloc] init];
    
    MasterViewController *masterVc = [[MasterViewController alloc] init];
    masterVc.splitVc = splitVc;
    
    QueueViewController *queueVc = [[QueueViewController alloc] initWithNibName:@"QueueViewController" bundle:nil];
    queueVc.splitVc = splitVc;
    
    TransferController *transferVc = [[TransferController alloc] init];
    transferVc.splitVc = splitVc;
    
    WorkStationController *workVc = [[WorkStationController alloc] init];
    workVc.splitVc = splitVc;
    
    DateHomeController *dateVc = [[DateHomeController alloc] initWithNibName:@"DateHomeController" bundle:nil];
    dateVc.splitVc = splitVc;
    
    BadPostController *badVc = [[BadPostController alloc] init];
    badVc.splitVc = splitVc;
    
    BankOutletsController *bankOutletVc = [[BankOutletsController alloc] init];
    bankOutletVc.splitVc = splitVc;
    
    NSArray *controllers = @[masterVc, queueVc, transferVc, workVc, dateVc, badVc, bankOutletVc];
    splitVc.controllers = controllers;
    splitVc.selectedIndex = 1;//从1开始
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatesQuery" object:nil];
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)controller;
            [navi pushViewController:splitVc animated:YES];
        }
    }];
    
//    [self presentViewController:splitVc animated:YES completion:nil];

}
@end
