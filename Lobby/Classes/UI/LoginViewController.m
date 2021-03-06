//
//  LoginViewController.m
//  SmartHall
//
//  Created by YangChao on 21/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "CommonUtils.h"
#import "Branch.h"

#import "SwySplitViewController.h"
#import "MasterViewController.h"
#import "QueueViewController.h"
#import "TransferController.h"
#import "WorkStationController.h"
#import "BadPostController.h"
#import "BankOutletsController.h"
#import "TransferRoleModel.h"

#import "CustomIndicatorView.h"
#import <CIBBaseSDK/CIBBaseSDK.h>
#import "ComplianceChecks.h"

@interface LoginViewController ()<LoginProtocol, UIAlertViewDelegate>
{
    UITextField *_userField;
    UITextField *_pwdField;

}

@property (weak, nonatomic) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snapShot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    LoginView *loginView = [[LoginView alloc] init];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    
    self.loginView = loginView;
}

- (void)loginWithUser:(UITextField *)userF password:(UITextField *)pwdF
{
    // 首先进行MDM检查
#ifdef MDM_ENV
    NSString *mdmServerUrl = @"https://220.250.30.210:8112";
    NSString *deviceId = [DeviceInfoManager getDeviceId];
    
    NSMutableDictionary *infoDic = [ComplianceChecks checkPhoneComplianceWithUrl:mdmServerUrl cibID:deviceId isBackStage:NO];
    
    if ([[infoDic objectForKey:COMLIANCECHECKS] isEqualToString:@"0"]) {
        NSLog(@"设备合规，正常启动");
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不合规，请前往应用商城查看具体违规信息。点击确定退出应用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert.tag = 1001;
        return;
    }
#endif
    
    if ([userF.text isEqualToString:@""] || !userF.text) {
        [self showMessage:@"用户名不能为空"];
        return;
    }
    if ([pwdF.text isEqualToString:@""] || !pwdF.text) {
        [self showMessage:@"密码不能为空"];
        return;
    }
    COM_INSTANCE.userid = userF.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CustomIndicatorView *indicatorView = [CustomIndicatorView sharedView];
        [indicatorView startAnimating];
        [indicatorView showInView:self.view];
    
        [UrlManager setBasicUrl:APP_SERVER_URL];//需要更改外网环境，去SmartHallConfig.h里去配置
        
        _userField = userF;
        _pwdField = pwdF;
        
        [LoginManager loginWithUsername:userF.text andPassword:pwdF.text onSuccess:^(NSString *responseCode, NSString *responseInfo) {
            NSError *err;
            NSData *data = [responseInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            if ([responseCode isEqualToString:@"0"]) {
                if (dic) {
                    COM_INSTANCE.realName = [dic valueForKey:@"realname"];
                }
                COM_INSTANCE.noteId = userF.text;
                
                [self branchInfo];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if ([defaults objectForKey:k_History_users] == nil) {
                    NSArray *users = [NSArray arrayWithObject:userF.text];
                    [defaults setObject:users forKey:k_History_users];
                } else {
                    NSArray *users = [defaults objectForKey:k_History_users];
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:users];
                    NSInteger index = [temp indexOfObject:userF.text];
                    if (index == NSNotFound) {
                        [temp addObject:userF.text];
                        NSArray *newUsers = [NSArray arrayWithArray:temp];
                        [defaults setObject:newUsers forKey:k_History_users];
                    }
                }
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate pushRegist];
                
            } else {
                [[CustomIndicatorView sharedView] stopAnimating];
                if (dic) {
                    NSString *msg = [dic valueForKey:@"info"];
                    if ([responseCode isEqualToString:@"4"]) {
                        NSString *deviceId = [DeviceInfoManager getDeviceId];
                        NSString *temp = [NSString stringWithFormat:@"%@\n当前设备号[%@]", msg, deviceId];
                        msg = temp;
                    }
                    [self showAlertMessage:msg logout:NO];
                }
                else {
                    [self showAlertMessage:@"服务端返回信息解析错误" logout:NO];
                }
            }
            
        } onFailure:^(NSString *responseCode, NSString *responseInfo) {
            [[CustomIndicatorView sharedView] stopAnimating];
            NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
            [self showAlertMessage:alertInfo logout:NO];
        }];
    });
//    NSString *usrId = userF.text;
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [GlobleData sharedInstance].usrID = usrId;
//    NSDictionary *usrPswInfo = [userDefault objectForKey:usrId];
//    if (!usrPswInfo) {
//        [self showLockViewController:LockViewTypeCreate onSucceeded:nil onFailed:nil];
//        
//    }else{
//        [self showLockViewController:LockViewTypeCheck onSucceeded:nil onFailed:nil];
//    }

}

- (void)branchInfo
{
    NSDictionary *paramDic = @{@"note_id":COM_INSTANCE.noteId};
    [InvokeManager invokeApi:@"ibpyhjg" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if (![resultCode isEqualToString:@"0"]) {
                NSString *result = [responseInfo valueForKey:@"result"];
                [self showAlertMessage:result logout:NO];
            } else {
                NSDictionary *dic = [responseInfo valueForKey:@"result"];
                
                Branch *branch = [[Branch alloc] init];
                branch.areaCode = [dic valueForKey:@"dqdh"];
                branch.branchCode = [dic valueForKey:@"jgdh"];
                branch.branchNo = [dic valueForKey:@"jgdm"];
                NSString *userType = [dic valueForKey:@"usertype"];
                NSDictionary *userTypes = @{@"1":@"总行管理员", @"2":@"分行管理员", @"3":@"大堂经理 ", @"4":@"营业厅主任", @"5":@"现金柜员", @"6":@"贵宾理财", @"7":@"低柜理财"};
                NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
                NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                NSMutableDictionary *userTypeDic = [NSMutableDictionary dictionary];
                if (rootDic) {
                    NSArray *branches = rootDic[@"Root"];
                    for (NSDictionary *item in branches) {
                        if ([@"USERTYPE" isEqualToString:item[@"codeType"]]) {
                            NSString *val = item[@"codeValue"];
                            NSString *key = item[@"codeId"];
                            [userTypeDic addEntriesFromDictionary:@{key:val}];
                        }
                    }
                    userTypes = [NSDictionary dictionaryWithDictionary:userTypeDic];
                }
                branch.userType = [userTypes valueForKey:userType];
                [CommonUtils sharedInstance].currentBranch = branch;
                if ([userType isEqualToString:@"3"] || [userType isEqualToString:@"4"] || [userType isEqualToString:@"6"] || [userType isEqualToString:@"7"]) {
                    
                    //测试锁控件
                    [[NSUserDefaults standardUserDefaults] setValue:_userField.text forKey:K_USER_NOTE_ID];//保存用户登录id于本地，记住用户名
                    NSString *usrId = _userField.text;
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [CommonUtils sharedInstance].noteId = usrId;
                    NSDictionary *usrPswInfo = [userDefault objectForKey:usrId];
                    if (!usrPswInfo)
                        {
                            [[AppDelegate delegate] showLockViewController:LockViewTypeCreate onSucceeded:^{
                                [[AppDelegate delegate].lockVc enterMainViewVc];
                                self.lockVc = nil;
                            } onFailed:nil];
                        
                        }else{
                            [[AppDelegate delegate] showLockViewController:LockViewTypeCheck onSucceeded:^{
                                [[AppDelegate delegate].lockVc enterMainViewVc];
                                self.lockVc = nil;
                            } onFailed:nil];
                        }
                  
                    _pwdField.text = @"";
                    _userField.text = @"";
                    
                    [self performSelectorInBackground:@selector(invokeCallRuleOfBranch:) withObject:branch.branchNo];
                    [self performSelectorInBackground:@selector(getdatafrommazi) withObject:nil];
                } else {
                    NSString *msg = [NSString stringWithFormat:@"很抱歉，账户【%@】的角色无权限登录本应用", _userField.text];
                    [self showAlertMessage:msg logout:NO];
                }
            }
        } else {
            [self showAlertMessage:@"查询当前机构信息失败！请稍后重试！" logout:NO];
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    }];
}

// 获取码字数据
- (void)getdatafrommazi{
    
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
    NSFileManager *manager = [NSFileManager defaultManager];
    
// 临时存储相关数据
    NSMutableArray *jiaohaoArray = [NSMutableArray array];
    NSMutableArray *transRoleArray = [NSMutableArray array];
    NSMutableArray *clztArray = [NSMutableArray array]; // 差评处理状态
    NSMutableArray *cljgArray = [NSMutableArray array]; // 差评处理结果
    NSMutableArray *wtglArray = [NSMutableArray array]; // 差评问题归类
    NSMutableArray *pjjgArray = [NSMutableArray array]; // 差评评价结果
    NSMutableArray *zjmsArray = [NSMutableArray array]; // 转介处理状态
    NSMutableArray *xslyArray = [NSMutableArray array]; // 转介线索来源
    
    NSDictionary *paramDic = @{@"version":@"-1"};
    if ([manager fileExistsAtPath:filePath]) {
        NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *vals = [root valueForKey:@"Root"];
        for (NSDictionary *item in vals) {
            TransferRoleModel *model = [[TransferRoleModel alloc] init];
            if ([[item valueForKey:@"codeType"] isEqualToString:@"VERSION"]) {
                paramDic = @{@"version":[item valueForKey:@"codeValue"]};
            }else if ([[item valueForKey:@"codeType"] isEqualToString:@"JHCL"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [jiaohaoArray addObject:model];
            }else if ([[item valueForKey:@"codeType"] isEqualToString:@"ZJJS"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [transRoleArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"CLZT"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [clztArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"CLJG"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [cljgArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"WTGJ"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [wtglArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"ZJMS"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [zjmsArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"PJJG"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [pjjgArray addObject:model];
            }else if([[item valueForKey:@"codeType"] isEqualToString:@"XSLY"]){
                model.codeId = [item valueForKey:@"codeId"];
                model.codeValue = [item valueForKey:@"codeValue"];
                [xslyArray addObject:model];
            }
        }
        
        [GlobleData sharedInstance].jhaoArray = jiaohaoArray;
        [GlobleData sharedInstance].zjjsArray = transRoleArray;
        [GlobleData sharedInstance].clztArray = clztArray; // 差评处理状态
        [GlobleData sharedInstance].cljgArray = cljgArray; // 差评处理结果
        [GlobleData sharedInstance].wtglArray = wtglArray; // 差评问题归类
        [GlobleData sharedInstance].zjmsArray = zjmsArray; // 转介处理状态
        [GlobleData sharedInstance].pjjgArray = pjjgArray; // 差评评价结果
        [GlobleData sharedInstance].xslyArray = xslyArray; // 转介线索来源
    
    } else {
        
        paramDic = @{@"version":@"-1"};
    }

    [InvokeManager invokeApi:@"mzdy" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        if ([responseCode isEqualToString:@"I00"]) {
            id result = [responseInfo valueForKey:@"result"];
            if ([result isKindOfClass:[NSArray class]] && [((NSArray *)result) count] > 1) {
                [manager createFileAtPath:filePath contents:nil attributes:nil];
                NSDictionary *dic = @{@"Root":result};
                BOOL isSuccess = [dic writeToFile:filePath atomically:YES];
                if (isSuccess) {
                    NSLog(@"文件保存成功");
                    for (NSDictionary *item in result) {
                        TransferRoleModel *model = [[TransferRoleModel alloc] init];
                        if ([[item valueForKey:@"codeType"] isEqualToString:@"JHCL"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [jiaohaoArray addObject:model];
                        }else if ([[item valueForKey:@"codeType"] isEqualToString:@"ZJJS"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [transRoleArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"CLZT"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [clztArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"CLJG"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [cljgArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"WTGJ"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [wtglArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"ZJMS"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [zjmsArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"PJJG"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [pjjgArray addObject:model];
                        }else if([[item valueForKey:@"codeType"] isEqualToString:@"XSLY"]){
                            model.codeId = [item valueForKey:@"codeId"];
                            model.codeValue = [item valueForKey:@"codeValue"];
                            [xslyArray addObject:model];
                        }
                    }
                    
                    [GlobleData sharedInstance].jhaoArray = jiaohaoArray;
                    [GlobleData sharedInstance].zjjsArray = transRoleArray;
                    [GlobleData sharedInstance].clztArray = clztArray; // 差评处理状态
                    [GlobleData sharedInstance].cljgArray = cljgArray; // 差评处理结果
                    [GlobleData sharedInstance].wtglArray = wtglArray; // 差评问题归类
                    [GlobleData sharedInstance].zjmsArray = zjmsArray; // 转介处理状态
                    [GlobleData sharedInstance].pjjgArray = pjjgArray; // 差评评价结果
                    [GlobleData sharedInstance].xslyArray = xslyArray; // 转介线索来源
                } else{
                    NSLog(@"文件保存失败");
                }
            }
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    }];
}

//获取当前机构下的叫号规则 缓存于内存
- (void)invokeCallRuleOfBranch:(NSString *)branchId
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:branchId forKey:@"branch"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSDictionary *result = [responseInfo valueForKey:@"result"];
                id callGroup = [result objectForKey:@"callRuleInfoGroup"];
                
                if ([callGroup isKindOfClass:[NSArray class]]) {
                    COM_INSTANCE.callRuleGroupOfBranch = (NSArray *)callGroup;
                }
            }
        }
    };
    
    [InvokeManager invokeApi:@"ibpjgjhgz" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (void)snapShot:(NSNotification *)notification
{
    NSLog(@"接受到的信息：%@", notification);
    [self showAlertMessage:@"您刚刚进行了截屏操作，该操作已被记录，请确认其合规性并删除不合规的截图。" logout:NO];
}

- (void)helpToInformation
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (alertView.tag == 1001) {
        exit(0);
    }
}

@end
