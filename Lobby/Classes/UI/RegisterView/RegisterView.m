//
//  RegisterView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/3/30.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "RegisterView.h"
#import "CustomIndicatorView.h"
#import "TransferRegisterTableViewCell.h"
#import "BusinessChoiceTableViewCell.h"
#import "Branch.h"
#import "Station.h"
#import "Refbs.h"
#import "TransferRoleModel.h"
#import <CIBBaseSDK/CIBBaseSDK.h>

@implementation RegisterView
{

    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    
    UIImageView *hideImgView;
    UILabel *leftNameLabel;
    UITextField *textfield; // 金额输入框
    UIImageView *selectImgView;
    
    NSInteger windowindex; // 记录选择的几号窗口
    NSInteger zjjsindex; // 记录选择的转介角色
    NSInteger transfertypeIndex; //记录选择的业务类别
    NSInteger jiaohaoIndex; // 记录选择的叫号策略
    NSInteger  indext;
    NSString *section0;
    NSString *section1;
    NSString *section2;
    NSString *section3;
    NSString *section4;
    
    NSString *windowName; // 记录被点击选择的窗口名
    NSString *businessCount; // 记录交易金额
    NSString *transferRoleName; // 记录角色名
    NSString *transferBusiName; // 记录转介业务类别名字
    NSString *jiaohaoName; // 记录叫号策略
    
    UITextView *remarkTextView;
    BOOL istextField;
    NSString *remarkText; //暂存备注
    
    BOOL isOut; // 判断键盘是否已经弹出，如果已有键盘弹出，不再继续弹出
}

- (void)awakeFromNib{
    [super awakeFromNib];
    remarkText = [[NSString alloc] init];
    istextField = NO;
    isOut = NO;
    self.customerField.tag = 10105;
    self.customerField.userInteractionEnabled = NO;
    self.customerField.delegate = self;
    self.customerField.hidden = YES;
    remarkTextView = [[UITextView alloc] init];
    label1 = [[UILabel alloc] init];
    label2 = [[UILabel alloc] init];
    label3 = [[UILabel alloc] init];
    label4 = [[UILabel alloc] init];
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _sectionArray = [NSArray arrayWithObjects:@"交易金额",@"转介角色",@"转介接受窗口",@"转介业务类别",@"叫号策略",@"备注", nil];
    business_countArray = [NSArray arrayWithObjects:@"1000",@"2000",@"5000",@"10000",@"50000",@"100000", nil];
    transfer_windowArray = [[NSMutableArray alloc] init];
    transfer_busitypeArray = [[NSMutableArray alloc] init];
  
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = 5;
    self.registerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 163, 450, 420) style:UITableViewStylePlain];
    self.registerTable.dataSource = self;
    self.registerTable.delegate = self;
    self.registerTable.bounces = NO;
    self.registerTable.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.registerTable];
}

// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    if (istextField) {
        return;
    }else{
        if (isOut) {
            return;
        }else{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 340, self.frame.size.width, self.frame.size.height);
            isOut = YES;
        }
    }
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    if (istextField) {
        istextField = NO;
    }else{
        if (isOut) {
            isOut = NO;
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 340, self.frame.size.width, self.frame.size.height);
    }
}

- (void)didMoveToSuperview
{
    self.queueNum.text = self.customerModel.ticketNo;
    if ([[self.customerModel.customerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqualToString:@""]) {
        self.customerField.hidden = NO;
        self.userNameLabel.hidden = YES;
    }else{
        self.userNameLabel.hidden = NO;
        self.userNameLabel.text = self.customerModel.customerName;
        self.customerField.hidden = YES;
    }
    // 调用工位视图接口
    [self getdatafromgongwei];
}

- (void)getdatafromgongwei{
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    self.userInteractionEnabled = NO;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
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
                _stationsArray = stas;
                [self getdatafromwangdianAndtransferbusiness];
            } else {
                [self showMessage:[responseInfo valueForKey:@"result"]];
            }
        }else{
            [self showMessage:@"出错啦！"];
        }
    };
    
    [InvokeManager invokeApi:@"ibpgws" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (void)getdatafromwangdianAndtransferbusiness{
    NSDictionary *padic = [NSDictionary dictionaryWithObjectsAndKeys:COM_INSTANCE.currentBranch.branchNo,@"branch",nil];
    [InvokeManager invokeApi:@"ibpwzyw" withMethod:@"POST" andParameter:padic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        self.userInteractionEnabled = YES;
        if ([responseCode isEqualToString:@"I00"]){
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]){
                NSDictionary *result = [responseInfo valueForKey:@"result"];
                NSArray *trfsArray = [result objectForKey:@"refBusiInfoGroup"];
                NSMutableArray *referBsArray = [NSMutableArray array];
                for (NSDictionary *dic in trfsArray) {
                    Refbs *refb = [[Refbs alloc] init];
                    refb.refbs_branch = dic[@"refbs_branch"];
                    refb.refbs_id = dic[@"refbs_id"];
                    refb.refbs_name = dic[@"refbs_name"];
                    [referBsArray addObject:refb];
                }
                _refbArray = referBsArray;
                [self initData];
                [self.registerTable reloadData];
            } else {
                [self showMessage:[responseInfo valueForKey:@"result"]];
            }
        }else{
            [self showMessage:@"出错啦！"];
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        self.userInteractionEnabled = YES;
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    }];
}

- (void)initData{
    transfer_roleArray = [GlobleData sharedInstance].zjjsArray;
    jiaohao_celArray = [GlobleData sharedInstance].jhaoArray;
    for (Station *station in _stationsArray) {
        if ([station.queueNum isEqualToString:self.customerModel.ticketNo]) {
            
        }else{
            if ([station.serverStatus isEqualToString:@"1"] || [station.serverStatus isEqualToString:@"2"]) {
                NSString *windowstr = [NSString stringWithString:station.stationNo];
                [transfer_windowArray addObject:windowstr];
            }
        }
    }
    for (Refbs *refbs in _refbArray) {
        NSString *refername = [NSString stringWithString:refbs.refbs_name];
        [transfer_busitypeArray addObject:refername];
    }
}
#pragma UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
    NSArray *cellarray = [tableView visibleCells];
    for(BusinessChoiceTableViewCell *cell in cellarray){
        cell.selectImage.hidden=YES;
    }
    businessCell.selectImage.hidden = NO;
    switch (indexPath.section) {
        case 0:{
            textfield.text = businessCell.businessNameLabel.text;
            section0 = businessCell.businessNameLabel.text;
            businessCount = businessCell.businessNameLabel.text;
        } break;
        case 1:{
            label1.text = businessCell.businessNameLabel.text;
            section1 = businessCell.businessNameLabel.text;
            transferRoleName = businessCell.businessNameLabel.text;
            zjjsindex = indexPath.row;
        }break;
        case 2:{
            label2.text = businessCell.businessNameLabel.text;
            section2 = businessCell.businessNameLabel.text;
            windowName = businessCell.businessNameLabel.text;
            windowindex = [[windowName substringFromIndex:2] intValue];
        } break;
        case 3:{
            label3.text = businessCell.businessNameLabel.text;
            section3 = businessCell.businessNameLabel.text;
            transferBusiName = businessCell.businessNameLabel.text;
            transfertypeIndex = indexPath.row;
        } break;
        case 4:{
            label4.text = businessCell.businessNameLabel.text;
            section4 = businessCell.businessNameLabel.text;
            jiaohaoName = businessCell.businessNameLabel.text;
            jiaohaoIndex = indexPath.row;
        } break;
        default:
            break;
    }
    [self switchAction:indexPath.section];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:return business_countArray.count; break;
        case 1:return transfer_roleArray.count; break;
        case 2:return transfer_windowArray.count; break;
        case 3:return transfer_busitypeArray.count; break;
        case 4:return jiaohao_celArray.count; break;
        default: return 0; break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
        return 50;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 5: return 210; break;
        default: return 50; break;
    }
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
    
    // 添加分割线
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 450, 0.5)];
    separatorView.backgroundColor = UIColorFromRGB(0xcccccc);
    [header addSubview:separatorView];
    if (section == 0) {
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 0.5)];
        separatorView.backgroundColor = UIColorFromRGB(0xcccccc);
        [header addSubview:separatorView];
    }
    
    if (section == 0) {
        if (textfield.text.length != 0) {
            NSString *string = textfield.text;
            textfield = [[UITextField alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
            textfield.text = string;
            textfield.delegate = self;
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.font = [UIFont systemFontOfSize:14];
            textfield.textColor = UIColorFromRGB(0xa6a7b1);
            [header addSubview:textfield];

        }else{
            textfield = [[UITextField alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
            textfield.placeholder = @"手动输入或选择";
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            textfield.delegate = self;
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.font = [UIFont systemFontOfSize:14];
            textfield.textColor = UIColorFromRGB(0xa6a7b1);
            [header addSubview:textfield];
        }
    }
    hideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.width - 38, 18, 18, 15)];
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]]) {
        hideImgView.image = [UIImage imageNamed:@"show"];
    } else {
        hideImgView.image = [UIImage imageNamed:@"hide"];
    }
    [header addSubview:hideImgView];
    
    header.tag = section;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(SingleTap:)];
    singleRecognizer.numberOfTouchesRequired = 1;
    singleRecognizer.numberOfTapsRequired = 1;
    [header addGestureRecognizer:singleRecognizer];
    switch (section) {
        case 0:{
            if (section0.length != 0) {
                textfield.text = section0;
            }else{
                
            }
            return header;
        }
            break;
        case 1:{
            label1.frame = CGRectMake(200, 15, 204, 20);
            label1.textColor = UIColorFromRGB(0xa6a7b1);
            label1.textAlignment = NSTextAlignmentRight;
            label1.font = [UIFont systemFontOfSize:14];
            [header addSubview:label1];
            if (section1.length != 0) {
                label1.text = section1;
            }else{
                label1.text = @"请选择";
            }
            return header;
        }
            break;
        case 2:{
            label2.frame = CGRectMake(200, 15, 204, 20);
            label2.textColor = UIColorFromRGB(0xa6a7b1);
            label2.textAlignment = NSTextAlignmentRight;
            label2.font = [UIFont systemFontOfSize:14];
            [header addSubview:label2];
            if (section2.length != 0) {
                label2.text = section2;
            }else{
                label2.text = @"请选择";
            }
            return header;
        }
            break;
        case 3:{
            
            label3.frame = CGRectMake(200, 15, 204, 20);
            label3.textColor = UIColorFromRGB(0xa6a7b1);
            label3.textAlignment = NSTextAlignmentRight;
            label3.font = [UIFont systemFontOfSize:14];
            [header addSubview:label3];
            
            if (section3.length != 0) {
                label3.text = section3;
            }else{
                label3.text = @"请选择";
            }
            return header;
        }
            break;
        case 4:{
            label4.frame = CGRectMake(200, 15, 204, 20);
            label4.textColor = UIColorFromRGB(0xa6a7b1);
            label4.textAlignment = NSTextAlignmentRight;
            label4.font = [UIFont systemFontOfSize:14];
            [header addSubview:label4];
            if (section4.length != 0) {
                label4.text = section4;
            }else{
                label4.text = @"请选择";
            }
            return header;
        }
            break;
        default:{
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 450, 130)];
            backgroundView.backgroundColor = [UIColor whiteColor];
            [header addSubview:backgroundView];
            remarkTextView.frame = CGRectMake(16, 0, 434, 130);
            remarkTextView.backgroundColor = [UIColor clearColor];
            remarkTextView.editable = YES;
            remarkTextView.delegate = self;
            remarkTextView.font = [UIFont systemFontOfSize:13];
            
            if (![remarkText isEqualToString:@""]) {
                remarkTextView.text = remarkText;
                remarkTextView.textColor = UIColorFromRGB(0x5a5a5a);
            }else{
                remarkTextView.text = @"限125字以内(选填)";
                remarkTextView.textColor = UIColorFromRGB(0xa6a7b1);
            }
            [backgroundView addSubview:remarkTextView];
            leftLabel.frame = CGRectMake(20, 12, 100, 20);
//            rightLabel.text = nil;
            hideImgView.hidden = YES;
            [singleRecognizer removeTarget:self action:nil];
            header.backgroundColor = UIColorFromRGB(0xEFF2F7);
            return header;
        }
            break;
    }
}
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (![remarkText isEqualToString:@""]) {
        textView.text = remarkText;
    }else{
        textView.text = @"";
    }
    textView.textColor = UIColorFromRGB(0x24344e);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 125 && text.length > range.length) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.markedTextRange == nil && 125 > 0 && textView.text.length > 125) {
        textView.text = [textView.text substringToIndex:125];
    }
    remarkText = textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        remarkTextView.textColor = UIColorFromRGB(0xa6a7b1);
        remarkTextView.text = @"限125字以内(选填)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    section0 = @"";
    istextField = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    section0 = @"";
    if (textField.tag == 10105) {

    }else{
        if ([textField.text intValue] < 0) {
            [self showMessage:@"金额不能为负,请重新输入。"];
            textField.text = @"";
        }
    }
}


#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdenti";
    UITableViewCell *cell = [self.registerTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"BusinessChoiceTableViewCell" owner:nil options:nil].lastObject;
        BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
        switch (indexPath.section) {
            case 0:{
                businessCell.businessNameLabel.text = [business_countArray objectAtIndex:indexPath.row];
                if (businessCell.businessNameLabel.text == section0) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }
                break;
            case 1:{
                TransferRoleModel *model = [transfer_roleArray objectAtIndex:indexPath.row];
                businessCell.businessNameLabel.text = model.codeValue;
                if (businessCell.businessNameLabel.text == section1) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }
                break;
            case 2:{
                businessCell.businessNameLabel.text = [NSString stringWithFormat:@"窗口%@",[transfer_windowArray objectAtIndex:indexPath.row]];
                if (businessCell.businessNameLabel.text == section2) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }
                break;
            case 3:{
                businessCell.businessNameLabel.text = [transfer_busitypeArray objectAtIndex:indexPath.row];
                if (businessCell.businessNameLabel.text == section3) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }
                break;
            case 4:{
                TransferRoleModel *model = [jiaohao_celArray objectAtIndex:indexPath.row];
                businessCell.businessNameLabel.text = model.codeValue;
                if (businessCell.businessNameLabel.text == section4) {
                    businessCell.selectImage.hidden = NO;
                }else{
                    businessCell.selectImage.hidden = YES;
                }
            }
                break;
            default:
                break;
        }
        businessCell.backgroundColor = UIColorFromRGB(0xe7eaf3);
    }
    return cell;
}

- (IBAction)sure:(id)sender {
    if (!windowName || [windowName isEqualToString:@"请选择"]) {
        [self showMessage:@"请填写相关信息！"];
        return;
    }
    Station *station;
    station = [_stationsArray objectAtIndex:(windowindex - 1)];
    
    NSString *branchNO = COM_INSTANCE.currentBranch.branchNo; //必输
    if ([branchNO isEqualToString:@""] || branchNO == nil) {
        [self showMessage:@"网点代号为空"];
        return;
    }
    NSString *queueNum = self.customerModel.ticketNo; //必输
    if ([queueNum isEqualToString:@""] || queueNum == nil) {
        [self showMessage:@"排队号为空"];
        return;
    }
    NSString *cusName;
    if ([[self.customerModel.customerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (![[self.customerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            cusName = self.customerField.text;
        }else{
            cusName = @"";
        }
    }else{
        cusName = self.customerModel.customerName;
    } //必输
    NSString *bsid = self.customerModel.bs_id; //必输
    if ([bsid isEqualToString:@""] || bsid == nil) {
        [self showMessage:@"业务类型ID为空"];
        return;
    }
    TransferRoleModel *rolemodel = [transfer_roleArray objectAtIndex:zjjsindex]; // 必输（由19. 获取码值对应数据接口获取数据）
    NSString *referralrole = rolemodel.codeId;
    if ([referralrole isEqualToString:@""] || referralrole == nil) {
        [self showMessage:@"转介接收人角色为空"];
        return;
    }
    TransferRoleModel *jiaohaomodel = [jiaohao_celArray objectAtIndex:jiaohaoIndex];
    NSString *queue_strategy = jiaohaomodel.codeId; // 必输（由19. 获取码值对应数据接口获取数据）
    if ([queue_strategy isEqualToString:@""] || queue_strategy == nil) {
        [self showMessage:@"叫号策略为空"];
        return;
    }
    NSString *qm_num = station.qmNum; // 必输（由22. 工位视图接口获取）
    if ([qm_num isEqualToString:@""] || queueNum == nil) {
        [self showMessage:@"转介接收工位_排队机编号为空"];
        return;
    }
    NSString *win_num = [NSString stringWithFormat:@"%ld",(long)windowindex];; // 必输 （由22. 工位视图接口获取）
    if ([win_num isEqualToString:@""] || win_num == nil) {
        [self showMessage:@"转介接收工位_窗口号为空"];
        return;
    }
    NSString *referraluser = station.tellerNum; //必输（由22. 工位视图接口获取）
    if ([referraluser isEqualToString:@""] || referraluser == nil) {
        [self showMessage:@"转介接收工位_柜员ID为空"];
        return;
    }
    NSString *referraluser_name = station.tellerName; // 必输（由22. 工位视图接口获取）
    if ([referraluser_name isEqualToString:@""] || referraluser_name == nil) {
        [self showMessage:@"转介接收工位_柜员姓名为空"];
        return;
    }
    Refbs *refbmodel = [_refbArray objectAtIndex:transfertypeIndex];
    
    NSString *referral_bs_id = refbmodel.refbs_id; // 必输（由29. 网点业务和转介业务列表接口获取）
    if ([referral_bs_id isEqualToString:@""] || referral_bs_id == nil) {
        [self showMessage:@"转介业务类型ID"];
        return;
    }
    NSString *busi_amount = textfield.text;// 交易金额（必输）
    if ([busi_amount isEqualToString:@""] || busi_amount == nil) {
        [self showMessage:@"交易金额为空"];
        return;
    }else if ([busi_amount intValue] < 0){
        [self showMessage:@"金额不能为负，请重新输入。"];
        return;
    }
    NSString *remark = remarkTextView.text; // 转介提示消息
    NSString *operateuser = COM_INSTANCE.noteId; // 必输
    if ([operateuser isEqualToString:@""] || operateuser == nil) {
        [self showMessage:@"转介发起人notesID"];
        return;
    }
    NSString *operateuser_nam = COM_INSTANCE.realName; // 必输
    if ([operateuser_nam isEqualToString:@""] || operateuser_nam == nil) {
        [self showMessage:@"转介发起人名称"];
        return;
    }
    NSString *cluetype = @"1"; // 必输（默认为1）
    NSString *cluename = @"营销转介"; // 必输（默认）
    NSString *cluelevel = @"1"; // 必输（默认为1）

    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:branchNO,@"branch",queueNum,@"queue_num",cusName,@"custinfo_name",bsid,@"bs_id",referralrole,@"referralrole",qm_num,@"qm_num",win_num,@"win_num",referraluser,@"referraluser",referraluser_name,@"referraluser_name",referral_bs_id,@"referral_bs_id",busi_amount,@"busi_amount",queue_strategy,@"queue_strategy",remark,@"remark",operateuser,@"operateuser",operateuser_nam,@"operateuser_name",cluetype,@"cluetype",cluename,@"cluename",cluelevel,@"cluelevel", nil];
    [InvokeManager invokeApi:@"ibpzjdj" withMethod:@"POST" andParameter:paraDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        if ([responseCode isEqualToString:@"I00"]){
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSString *messageStr = [responseInfo valueForKey:@"result"];
                [self showMessage:messageStr];
                
            }else{
                NSString *result = [responseInfo valueForKey:@"result"];
                [self showMessage:result];
                ;
            }
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    }];

    [self.superview removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    [self.superview removeFromSuperview];
}

#pragma mark 展开收缩section中cell 手势监听
- (void)SingleTap:(UITapGestureRecognizer *)recognizer{
    NSInteger didSection = recognizer.view.tag;
    if (indext == didSection) {
        
    }else{
        _showDic = nil;
        [self.registerTable reloadData];
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
    [self.registerTable reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
    indext = didSection;
}
//自定义提示框
- (void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = 260;
    CGFloat h = 50;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = (window.bounds.size.height - h) / 2;
    showview.frame = CGRectMake(x, y, w, h);
    showview.backgroundColor = RGB(0, 0, 0, 0.7);
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, w, h);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = K_FONT_16;
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
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

// 点击cell会缩回展开的列表
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
    [self.registerTable reloadSections:[NSIndexSet indexSetWithIndex:indexSection] withRowAnimation:UITableViewRowAnimationFade];
}
@end
