//
//  SettingView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/4/5.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "SettingView.h"
#import "BlueTeethCellTableViewCell.h"
#import "ModifyTapGestureView.h"
#import "BusinessChoiceTableViewCell.h"
@interface SettingView()
{
    NSString *section0;
    NSString *section1;
    NSString *sourceURL;//保存当前更新的APP的URL
    NSString *timeString;
    
}
@end

@implementation SettingView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.updateBtn.hidden = YES;
    self.updateBtn.enabled = NO;
    [self checkup];
    [self initData];
    self.switchBtn = [[UISwitch alloc] init];
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = 5.0;
    self.systemTableView.delegate = self;
    self.systemTableView.dataSource = self;
    self.systemTableView.tableFooterView = [[UIView alloc] init];
    self.systemTableView.bounces = NO;
    self.systemTableView.tableFooterView.backgroundColor = self.backgroundColor;
    self.systemTableView.backgroundColor = self.backgroundColor;
    
    [self.updateBtn setTitleColor:UIColorFromRGB(0x004771) forState:UIControlStateHighlighted];
    self.updateBtn.layer.borderColor = UIColorFromRGB(0x0086d6).CGColor;
    self.updateBtn.layer.borderWidth = 1.0f;
    self.updateBtn.layer.cornerRadius = 4.0f;
    
    [self.enterTapGuestureViewUIControl addTarget:self action:@selector(enterTapGuestureView) forControlEvents:UIControlEventTouchUpInside];
    
}

// 初始化数据
- (void)initData{
    self.timeChoiceArr = [[NSArray alloc] initWithObjects:@"1分钟",@"2分钟",@"5分钟",nil];
    self.sectionArray = [[NSArray alloc] initWithObjects:@"系统刷新时间",@"",nil];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        return 50;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
    NSArray *cellarray = [tableView visibleCells];
    for(BusinessChoiceTableViewCell *cell in cellarray){
        cell.selectImage.hidden=YES;
    }
    businessCell.selectImage.hidden = NO;
    rightLabel.text = businessCell.businessNameLabel.text;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    [GlobleData sharedInstance].timeInterval = 60;
                    [self saveSystemUpdateTimeInterval:60];
                }
                    break;
                case 1:{
                    [GlobleData sharedInstance].timeInterval = 2 * 60;
                    [self saveSystemUpdateTimeInterval:120];
                    
                }
                    break;
                case 2:{
                    [GlobleData sharedInstance].timeInterval = 5 * 60;
                    [self saveSystemUpdateTimeInterval:300];
                }
                    break;
                default:
                    break;
            }
            section0 = businessCell.businessNameLabel.text;
        } break;
        default:
            break;
    }
    [self switchAction:indexPath.section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 50)];
    header.backgroundColor = UIColorFromRGB(0xfcfdff);
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
    leftLabel.textColor = UIColorFromRGB(0x5a5a5a);
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.text = [_sectionArray objectAtIndex:section];
    [header addSubview:leftLabel];
    
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
    rightLabel.textColor = UIColorFromRGB(0xa6a7b1);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = [UIFont systemFontOfSize:14];
    [header addSubview:rightLabel];
    if (section == 1) {
        header.backgroundColor = UIColorFromRGB(0xEFF2F7);
        return header;
    }else{
        // 添加分割线
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 450, 0.5)];
        separatorView.backgroundColor = UIColorFromRGB(0xcccccc);
        [header addSubview:separatorView];
        hideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.width - 38, 18, 18, 15)];
        if ([_showDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]]) {
            hideImgView.image = [UIImage imageNamed:@"show"];
        } else {
            hideImgView.image = [UIImage imageNamed:@"hide"];
        }
        [header addSubview:hideImgView];
        header.tag = section;
        if (section == 1) {
            
        }else{
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(SingleTap:)];
            singleRecognizer.numberOfTouchesRequired = 1;
            singleRecognizer.numberOfTapsRequired = 1;
            [header addGestureRecognizer:singleRecognizer];
        }
    }
    switch (section) {
        case 0:{
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            timeString = [userdefault objectForKey:@"timeInterval"];
            if (![timeString isEqualToString:@""] && timeString) {
                rightLabel.text = [NSString stringWithFormat:@"%d分钟",[timeString intValue] / 60]; ;
            }else{
                if (section0.length != 0) {
                    rightLabel.text = section0;
                }else{
                    rightLabel.text = @"1分钟";
            }
            }
            
        }return header;
            break;
        default:
            return header;
            break;
    }
    
}


#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.timeChoiceArr.count;
            break;
        case 1:
            return self.deviceNameArr.count;
            break;
        default:
            return 0;
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"cellIdentity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BusinessChoiceTableViewCell" owner:nil options:nil].lastObject;
        BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
        switch (indexPath.section) {
            case 0:{
                businessCell.businessNameLabel.text = [_timeChoiceArr objectAtIndex:indexPath.row];
                if (businessCell.businessNameLabel.text == section0) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }break;
            case 1:{
                {
                    businessCell.businessNameLabel.text = [_deviceNameArr objectAtIndex:indexPath.row];
                    if (businessCell.businessNameLabel.text == section1) {
                        businessCell.selectImage.hidden = NO;
                    }else{
                        businessCell.selectImage.hidden = YES;
                    }
                }break;
            default:
                break;
            }
        }
    }
    
    return cell;
}

// 点击打开手势设置页面
-(void)enterTapGuestureView{
    
    self.enterTapGuestureViewUIControl.backgroundColor = [UIColor whiteColor];
    [GlobleData sharedInstance].isModify = YES;
    CGRect rect = self.frame;
    ModifyTapGestureView *view = [[NSBundle mainBundle]loadNibNamed:@"ModifyTapGestureView" owner:nil options:nil].lastObject;
    view.isCreatingPsw = NO;
    view.testTimesIsNilBlock = ^{
        _lout();
    };
    view.layer.cornerRadius = 5.0;
    view.clipsToBounds = 5.0;
    view.frame = rect;
    [self.superview addSubview:view];
}

- (void)checkup{
    // 请求更新数据
    NSDictionary *paramDic = @{@"appId":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"], @"deviceType":@"iPhone"};
    [InvokeManager invokeApi:@"cav" withMethod:@"POST" andParameter:paramDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        
        if ([responseCode isEqualToString:@"0"] || [responseCode isEqualToString:@"I00"]) {
            if (responseInfo != nil) {
                
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[responseInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *result;
                if (info) {
                    result = [info objectForKey:@"result"];
                }
                
                // 获取最新版本信息
                NSString *versionCode, *versionName, *versionUrl;
                if (result) {
                    versionCode = [result objectForKey:@"versionCode"];
                    versionName = [result objectForKey:@"versionName"];
                    versionUrl = [result objectForKey:@"url"];
                    
                    // 以下避免出现NSNull
                    versionCode = [NSString stringWithFormat:@"%@", versionCode];
                    versionName = [NSString stringWithFormat:@"%@", versionName];
                    versionUrl = [NSString stringWithFormat:@"%@", versionUrl];
                    sourceURL = versionUrl;
                }
                
                // 比对最新版本
                NSString *curVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];  // build
                NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];  // version
                if (versionCode && [versionCode intValue] > [curVersionCode intValue]) {  // 如果有新版本
                    // 设备本地版本信息
                    self.versionLabel.text = [NSString stringWithFormat:@"v%@",versionName];
                    self.isNewOrOldLabel.text = @"new!";
                    self.isNewOrOldLabel.hidden = NO;
                    self.updateBtn.hidden = NO;
                    self.versionTip.hidden = NO;
                    self.versionTip.hidden = YES;
                    self.updateBtn.enabled = YES;
                    self.currentVersion.hidden = YES;
                    
                }else{
                    self.versionLabel.text = [NSString stringWithFormat:@"v%@",curVersion];
                    self.isNewOrOldLabel.hidden = YES;
                    self.updateBtn.enabled = NO;
                    self.versionLabel.hidden = YES;
                    self.updateBtn.hidden = YES;
                    self.versionTip.text = @"已是最新版";
                    self.currentVersion.text = [NSString stringWithFormat:@"v%@",curVersion];
                    self.versionTip.hidden = NO;
                    self.currentVersion.hidden = NO;
                }
            }
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        
    }];
    
}

//点击更新
- (IBAction)clickUpdate:(id)sender {
    NSURL *appUrl = [NSURL URLWithString:sourceURL];
    [[UIApplication sharedApplication] openURL:appUrl];
}



#pragma mark 展开收缩section中cell 手势监听

- (void)SingleTap:(UITapGestureRecognizer *)recognizer{
    NSInteger didSection = recognizer.view.tag;
    if (indext == didSection) {
        
    }else{
        _showDic = nil;
    }
    if (!_showDic) {
        _showDic = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)didSection];
    if (![_showDic objectForKey:key]) {
        [_showDic setObject:@"1" forKey:key];
    }else{
        [_showDic removeObjectForKey:key];
    }
    [self.systemTableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
    indext = didSection;
}

- (void)saveSystemUpdateTimeInterval:(NSInteger)timeInter{
    [GlobleData sharedInstance].timeInterval = timeInter;
    
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInter];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:timeIntervalStr forKey:@"timeInterval"];
    [userdefault synchronize];
}


- (void)switchAction:(NSInteger)indexSection{
    if (!_showDic) {
        _showDic = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexSection];
    if (![_showDic objectForKey:key]) {
        [_showDic setObject:@"1" forKey:key];
    }else{
        [_showDic removeObjectForKey:key];
    }
    [self.systemTableView reloadSections:[NSIndexSet indexSetWithIndex:indexSection] withRowAnimation:UITableViewRowAnimationFade];
}
@end
