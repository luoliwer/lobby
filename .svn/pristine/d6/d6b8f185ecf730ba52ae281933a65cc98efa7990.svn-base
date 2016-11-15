//
//  ModifyTapGestureView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/4/7.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "ModifyTapGestureView.h"
@interface ModifyTapGestureView()

@property (strong, nonatomic) IBOutlet LockView *LockView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) NSString *passwordOld; // 旧密码
@property (nonatomic, strong) NSString *passwordNew; // 新密码
@property (nonatomic, strong) NSString *passwordconfirm; // 确认密码


@end
@implementation ModifyTapGestureView
{
    BOOL iscorrect;
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
-(void)awakeFromNib{
    [super awakeFromNib];
    self.LockView.delegate = self;
}


// 是否支持转屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
#ifdef LockAnimationOn
    [self capturePreSnap];
#endif
    // 初始化内容
    switch (_nLockViewType) {
        case LockViewTypeCheck:
        {
            
            self.titleLabel.text = @"";
            self.titleLabel.text = [NSString stringWithFormat:@"请绘制手势密码解锁"];
        }
            break;
        case LockViewTypeCreate:
        {
            self.titleLabel.text = @"设置手势密码";
            self.tipLabel.text = @"绘制手势密码图案";
        }
            break;
        case LockViewTypeModify:
        {
            self.titleLabel.text = @"修改手势密码";
            self.tipLabel.text = @"请输入原来的密码";
        }
            break;
        case LockViewTypeClean:
        default:
        {
            self.tipLabel.text = @"请输入密码以清除密码";
        }
    }
    
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
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
            [self setErrorTip:[NSString stringWithFormat:@"密码至少%d位，请重新绘制", LOCK_MIN_PWD_LENGTH] errorPswd:string];
            return;
        }
        
        self.passwordNew = string;
        self.titleLabel.textColor = UIColorFromRGB(0xb0b1b4);
        self.titleLabel.text = @"请确认新手势密码";
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        self.passwordconfirm = string;
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) { // 成功
            iscorrect = YES;
            [self saveUserPswInfo:string andTestTimes:@"4"];
            [self performSelector:@selector(hide) withObject:nil afterDelay:3.0];
            [self.superview removeFromSuperview];
        } else {
            self.passwordconfirm = @"";
            self.titleLabel.text = @"密码不一致，请重新输入";
            [self setErrorTip:@"密码不一致，请重新输入" errorPswd:string];
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}



// 错误
- (void)setErrorTip:(NSString *)tip errorPswd:(NSString *)string
{
    // 显示错误点点
    [self.LockView showErrorCircles:string];
    
    // 直接_变量的坏处是
    [self.titleLabel setText:tip];
    [self.titleLabel setTextColor:UIColorFromRGB(0xff2a00)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self shakeAnimationForView:self.tipLabel];
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
    
    NSDictionary *usrPswInfo = [self getUserPswInfo];
    NSString *pswSting = [usrPswInfo objectForKey:@"usrPsw"];
    NSString *testTimes = [usrPswInfo objectForKey:@"testTimes"];
    if (self.isCreatingPsw) {
        [self createPassword:string];
    }else{
        if ([pswSting isEqualToString:string]) {
            self.titleLabel.textColor = UIColorFromRGB(0xb0b1b4);
            self.titleLabel.text = @"请绘制新手势密码";
            self.tipLabel.text = @"";
            self.isCreatingPsw = YES;
            self.passwordNew = @"";
            self.passwordconfirm = @"";
        }else if (string.length > 0){

            NSInteger nRetryTimesRemain = [testTimes intValue];
            if (nRetryTimesRemain > 0) {
                if (1 == nRetryTimesRemain) {
                    [self setErrorTip:[NSString stringWithFormat:@"最后的机会咯-_-!"]
                            errorPswd:string];
                }else {
                    [self setErrorTip:[NSString stringWithFormat:@"密码错误，还可以再输入%d次", (int)nRetryTimesRemain]
                            errorPswd:string];
                }
                
                [self saveUserPswInfo:pswSting andTestTimes:testTimes];
                
            }else {
                
                [self.superview removeFromSuperview];
                [GlobleData sharedInstance].isModify = NO;
                [self clearUserPswInfo];
                _testTimesIsNilBlock();
                
            }

        }

    }
}

// 存取用户密码信息
- (void)saveUserPswInfo:(NSString *)pswString andTestTimes:(NSString *)testTimes{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *usrPsw = pswString;
    NSInteger nRetryTimesRemain;
    if (iscorrect) {
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

- (IBAction)backToSettingView:(id)sender {
    [GlobleData sharedInstance].isModify = NO;
    [self removeFromSuperview];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
