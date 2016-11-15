//
//  MasterViewController.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "MasterViewController.h"
#import "SwySplitViewController.h"
#import "MasterChoseCell.h"
#import "CommonUtils.h"
#import "QueueViewController.h"
#import "TransferController.h"
#import "WorkStationController.h"
#import "BadPostController.h"
#import "BankOutletsController.h"
#import "CommonAlertView.h"
#import "LogoutView.h"
#import "AboutView.h"
#import "SettingView.h"
#import "Branch.h"

@interface MasterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_masterItems;
    NSInteger _currentIndexRow;
    MasterChoseCell *_currentCell;
}

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *currentBank;
@property (weak, nonatomic) IBOutlet UILabel *currentName;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

extern NSString *HasNewDatesNotification;

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _masterItems = @[@[@"队        列", @"queue", @"queue_h"],
                     @[@"转        介", @"transfer", @"transfer_h"],
                     @[@"工        位", @"station", @"station_h"],
                     @[@"预约查询", @"date", @"date_h"],
                     @[@"差评管理", @"bad", @"bad_h"],
                     @[@"网点概况", @"net", @"net_h"]
                    ];
    _currentIndexRow = -1;
    
    _userView.layer.cornerRadius = 10;
    
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self analysisBranchName:COM_INSTANCE.currentBranch.branchNo];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(newDate:) name:HasNewDatesNotification object:nil];
}

- (void)newDate:(NSNotification *)t
{
    MasterChoseCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    cell.hasNewMsg = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSInteger row = _splitVc.selectedIndex - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    MasterChoseCell *cell = [_table cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    _currentIndexRow = row;
    _currentCell = cell;
}

#pragma mark --UITableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _masterItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MasterCell";
    MasterChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MasterChoseCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.item = _masterItems[indexPath.row];
    
    id controller = [_splitVc.controllers objectAtIndex:indexPath.row + 1];
    [controller setMasterCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id controller = [_splitVc.controllers objectAtIndex:indexPath.row + 1];
    [controller setTopInWindow:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //左侧导航栏逻辑
    if (_currentIndexRow == indexPath.row) {//点击已选中行 不做任何处理
        return;
    }
    if (_currentCell) {
        _currentCell.isSelected = !_currentCell.isSelected;
    }
    MasterChoseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    _currentIndexRow = indexPath.row;
    _currentCell = cell;
    
    id controller = [_splitVc.controllers objectAtIndex:indexPath.row + 1];
    [controller setTopInWindow:YES];
    //控制器跳转
    NSInteger index = indexPath.row + 1;
    _splitVc.selectedIndex = index;
    cell.hasNewMsg = NO;
}

#pragma mark 退出
- (IBAction)logout:(id)sender
{
    [CommonUtils sharedInstance].noteId = nil;
    LogoutView *outView = (LogoutView *)[[[NSBundle mainBundle] loadNibNamed:@"LogoutView" owner:nil options:nil] firstObject];
    
    outView.logoutEvent = ^{
        [GlobleData sharedInstance].isModify = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.7;
    baseView.view = outView;
    [baseView show];
}

#pragma mark 关于
- (IBAction)about:(id)sender
{
    AboutView *aboutView = (AboutView *)[[[NSBundle mainBundle] loadNibNamed:@"AboutView" owner:nil options:nil] firstObject];
    
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.7;
    baseView.view = aboutView;
    [baseView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)settingAction:(id)sender {
    SettingView *view = (SettingView *)[[[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:nil options:nil] firstObject];
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
    view.lout = ^{
        [GlobleData sharedInstance].isModify = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
};
//    baseView.backAlpah = 0.4;
    baseView.isAutoClose = YES;
    baseView.view = view;
    [baseView show];
}

#pragma mark 获取支行信息
- (void)analysisBranchName:(NSString *)branchCode
{
    //设置机构信息
    //本地码表查询
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *str = @"获取当前机构信息失败";
    if (rootDic) {
        NSArray *branches = rootDic[@"Root"];
        for (NSDictionary *item in branches) {
            if ([branchCode isEqualToString:item[@"codeId"]]) {
                NSString *branchStr = item[@"codeValue"];
                str = [NSString stringWithFormat:@"%@", branchStr];
                if (branchStr == nil || [branchStr isEqualToString:@""]) {
                    str = @"获取当前机构信息失败";
                }
                break;
            }
        }
        [_currentBank performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];//主线程上更新UI
    } else {
        [_currentBank performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];//主线程上更新UI
    }
    
    //设置用户信息和身份信息
    NSString *name = [NSString stringWithFormat:@"%@ ∙ %@", COM_INSTANCE.realName, COM_INSTANCE.currentBranch.userType];
    _currentName.text = name;
}

@end
