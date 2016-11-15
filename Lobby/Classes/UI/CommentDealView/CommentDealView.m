//
//  CommentDealView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/4/1.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "CommentDealView.h"
#import "TransferRegisterTableViewCell.h"
#import "TimeTableViewCell.h"
#import "BusinessChoiceTableViewCell.h"
#import "CommentCustomer.h"
#import "Branch.h"
#import "TransferRoleModel.h"



#import <CIBBaseSDK/CIBBaseSDK.h>

@implementation CommentDealView
{
    
    NSArray *_sectionArray;
    
    // 每个section对应的label
    UILabel *rightLabel1;
    UILabel *rightLabel2;
    UILabel *rightLabel3;
    
    UIImageView *hideImgView;
    NSString *section1;
    NSString *section2;
    NSString *section3;
    NSMutableDictionary *_showDic; // 用来判断分组展开与收缩
    NSInteger  indext;
    CommentCustomer *cus;
    
    // 处理后要传的数据
    NSString *notsatifyrenson; // 处理问题归类
    NSString *processend; // 处理结果
    NSString *processstatus; // 处理状态
    
    // 数据列表
    NSArray *_questionTypeArray; // 问题归类
    NSArray *_dealResultArray; // 处理结果
    NSArray *_dealStateArray; // 处理状态
    
    UITextField *teleTextField;
    UITextField *customerField;
    
    BOOL istextField;
    UITextView *feedbackTextView;
    NSString *remarkText;
    
    BOOL isOut; // 判断键盘是否已经弹出过
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    istextField = NO;
    isOut = NO;
    remarkText = [[NSString alloc] init];
    if (!feedbackTextView) {
        feedbackTextView = [[UITextView alloc] init];
    }
    if (!teleTextField) {
        teleTextField = [[UITextField alloc] init];
    }
    rightLabel1 = [[UILabel alloc] init];
    rightLabel2 = [[UILabel alloc] init];
    rightLabel3 = [[UILabel alloc] init];
    
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = 5;
    [self initData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 450, 592) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.tableView];
}

- (void)didMoveToSuperview{
    if (!cus) {
        cus = [[CommentCustomer alloc] init];
        cus = self.commentModel;
    }
}

- (void)initData{
    _sectionArray = [NSArray arrayWithObjects:@"问题归类",@"处理结果",@"处理状态", nil];
    _questionTypeArray = [GlobleData sharedInstance].wtglArray;
    _dealResultArray = [GlobleData sharedInstance].cljgArray;
    _dealStateArray = [GlobleData sharedInstance].clztArray;
    
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
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 360, self.frame.size.width, self.frame.size.height);
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
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 360, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
    NSArray *cellarray = [tableView visibleCells];
    for(BusinessChoiceTableViewCell *cell in cellarray){
        cell.selectImage.hidden=YES;
    }
    businessCell.selectImage.hidden = NO;
//    rightLabel.text = businessCell.businessNameLabel.text;
    switch (indexPath.section) {
        case 1: {
            rightLabel1.text = businessCell.businessNameLabel.text;
            section1 = businessCell.businessNameLabel.text;
            for (TransferRoleModel *model in [GlobleData sharedInstance].wtglArray) {
                if ([model.codeValue isEqualToString:businessCell.businessNameLabel.text]) {
                    notsatifyrenson = model.codeId;
                    break;
                }
            }
        }break;
        case 2: {
            rightLabel2.text = businessCell.businessNameLabel.text;
            section2 = businessCell.businessNameLabel.text;
            for (TransferRoleModel *model in [GlobleData sharedInstance].cljgArray) {
                if ([model.codeValue isEqualToString:businessCell.businessNameLabel.text]) {
                    processend = model.codeId;
                    break;
                }
            }
        }break;
        case 3: {
            rightLabel3.text = businessCell.businessNameLabel.text;
            section3 = businessCell.businessNameLabel.text;
            for (TransferRoleModel *model in [GlobleData sharedInstance].clztArray) {
                if ([model.codeValue isEqualToString:businessCell.businessNameLabel.text]) {
                    processstatus = model.codeId;
                    break;
                }
            }
        }break;
        default: break;
    }
    [self switchAction:indexPath.section];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else if(section >= 1 && section <= 3){
        switch (section) {
            case 1:
                return _questionTypeArray.count;
                break;
            case 2:
                return _dealResultArray.count;
                break;
            case 3:
                return _dealStateArray.count;
                break;
            default:
                return 0;
                break;
        }
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 7) {
            return 12;
        }else{
            return 50;
        }
    }else {
        if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
            return 50;
        }
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

// 使分割线顶到最左边
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
          {
             [cell setSeparatorInset:UIEdgeInsetsZero];
          }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
          {
             [cell setLayoutMargins:UIEdgeInsetsZero];
          }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section > 0 && section < 4 ){
        return 50;
    }else{
        return 150;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section >= 1 && section <= 3) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 50)];
        header.backgroundColor = UIColorFromRGB(0xfcfdff);
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
        leftLabel.textColor = UIColorFromRGB(0x5a5a5a);
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.text = [_sectionArray objectAtIndex:(section - 1)];
        [header addSubview:leftLabel];
        
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
            case 1:{
                rightLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
                rightLabel1.textColor = UIColorFromRGB(0xa6a7b1);
                rightLabel1.textAlignment = NSTextAlignmentRight;
                rightLabel1.font = [UIFont systemFontOfSize:14];
                [header addSubview:rightLabel1];
                
                UIView *separatorLine1 = [self createSeparatorLine:0];
                [header addSubview:separatorLine1];
                UIView *separatorLine2 = [self createSeparatorLine:49.5];
                [header addSubview:separatorLine2];
                if (section1.length != 0) {
                    rightLabel1.text = section1;
                }else{
                    if (cus) {
                        for (TransferRoleModel *model in _questionTypeArray) {
                            if ([model.codeId isEqualToString:cus.not_satify_reason]) {
                                rightLabel1.text = model.codeValue;
                                notsatifyrenson = model.codeId;
                                break;
                            }else{
                                rightLabel1.text = @"请选择";
                            }
                        }
                        
                    }else{
                        rightLabel1.text = @"请选择";
                    }
                }
                return header;
            }
                break;
            case 2:{
                rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
                rightLabel2.textColor = UIColorFromRGB(0xa6a7b1);
                rightLabel2.textAlignment = NSTextAlignmentRight;
                rightLabel2.font = [UIFont systemFontOfSize:14];
                [header addSubview:rightLabel2];
                
                UIView *separatorLine2 = [self createSeparatorLine:49.5];
                [header addSubview:separatorLine2];
                if (section2.length != 0) {
                    rightLabel2.text = section2;
                }else{
                    if (cus) {
                        for (TransferRoleModel *model in _dealResultArray) {
                            if ([model.codeId isEqualToString:cus.process_end]) {
                                rightLabel2.text = model.codeValue;
                                processend = model.codeId;
                                break;
                            }else{
                                rightLabel2.text = @"请选择";
                            }
                        }
                    }else{
                        rightLabel2.text = @"请选择";
                    }
                }
                return header;
            }
                break;
            case 3:{
                rightLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
                rightLabel3.textColor = UIColorFromRGB(0xa6a7b1);
                rightLabel3.textAlignment = NSTextAlignmentRight;
                rightLabel3.font = [UIFont systemFontOfSize:14];
                [header addSubview:rightLabel3];
                UIView *separatorLine2 = [self createSeparatorLine:49.5];
                [header addSubview:separatorLine2];
                if (section3.length != 0) {
                    rightLabel3.text = section3;
                }else{
                    if (cus) {
                        for (TransferRoleModel *model in _dealStateArray) {
                            if ([model.codeId isEqualToString:cus.process_status]) {
                                rightLabel3.text = model.codeValue;
                                processstatus = model.codeId;
                                break;
                            }else{
                                rightLabel3.text = @"请选择";
                            }
                        }
                    }else{
                        rightLabel3.text = @"请选择";
                    }
                }
                return header;
            }
                break;
            default:
                break;
        }
        return header;
    }else {
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 115)];
        header.backgroundColor = UIColorFromRGB(0xeff2f7);
        UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 20)];
        feedbackLabel.textColor = UIColorFromRGB(0x5a5a5a);
        feedbackLabel.textAlignment = NSTextAlignmentLeft;
        feedbackLabel.font = [UIFont systemFontOfSize:14];
        feedbackLabel.text = @"备注";
        [header addSubview:feedbackLabel];
        
        UIView *separatorLine1 = [self createSeparatorLine:39.5];
        [header addSubview:separatorLine1];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 450, 90)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        
        feedbackTextView.frame = CGRectMake(18, 0, 427, 89.5);
        feedbackTextView.font = [UIFont systemFontOfSize:13];
        if ([[self.commentModel.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            feedbackTextView.text = @"限200字以内(选填)";
            feedbackTextView.textColor = UIColorFromRGB(0xa6a7b1);
        }else{
            feedbackTextView.text = self.commentModel.remark;
            remarkText = self.commentModel.remark;
            feedbackTextView.textColor = UIColorFromRGB(0x5a5a5a);
        }
        feedbackTextView.delegate = self;
        [backgroundView addSubview:feedbackTextView];
        
        UIView *separatorLine2 = [self createSeparatorLine:89.5];
        [backgroundView addSubview:separatorLine2];
        
        [header addSubview:backgroundView];
        
        return header;
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    istextField = YES;
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 200 && text.length > range.length) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil && 200 > 0 && textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    remarkText = textView.text;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (![remarkText isEqualToString:@""]) {
        textView.text = remarkText;
    }else{
        textView.text = @"";
    }
    
    textView.textColor = UIColorFromRGB(0x24344e);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        feedbackTextView.textColor = UIColorFromRGB(0xa6a7b1);
        feedbackTextView.text = @"限200字以内(选填)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        if (indexPath.section == 0)
        {
            
            if (indexPath.row < 6)
                {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"TransferRegisterTableViewCell" owner:nil options:nil].lastObject;
                    TransferRegisterTableViewCell *transferRegisterTableViewCell = (TransferRegisterTableViewCell *)cell;
                    transferRegisterTableViewCell.userInteractionEnabled = NO;
                    
                    switch (indexPath.row)
                    {
                        case 0:{
                            transferRegisterTableViewCell.leftNameLabel.text = @"评价结果";
                            for (TransferRoleModel *model in [GlobleData sharedInstance].pjjgArray) {
                                if ([model.codeId isEqualToString:cus.access_stauts]) {
                                    NSLog(@"%@",cus.access_stauts);
                                    transferRegisterTableViewCell.rightNameLabel.text = model.codeValue;
                                    break;
                                }
                            }
                        }
                            break;
                        case 1:{
                            transferRegisterTableViewCell.leftNameLabel.text = @"日期";
                            transferRegisterTableViewCell.rightNameLabel.text = [self dateFormatterTransfer:cus.work_date];
                        }
                            break;
                        case 2:{
                            transferRegisterTableViewCell.leftNameLabel.text =  @"排队号";
                            transferRegisterTableViewCell.rightNameLabel.text = cus.queue_num;
                        }
                            break;
                        case 3:{
                            transferRegisterTableViewCell.leftNameLabel.text = @"柜员名";
                            transferRegisterTableViewCell.rightNameLabel.text = cus.teller_name;
                        }
                            break;
                        case 4:{
                            transferRegisterTableViewCell.leftNameLabel.text = @"客户姓名";
                            if ([[cus.customer_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqualToString:@""]){
                                transferRegisterTableViewCell.userInteractionEnabled = YES;
                                customerField.hidden = NO;
                                customerField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, transferRegisterTableViewCell.frame.size.width - 120, 40)];
                                customerField.delegate = self;
                                customerField.placeholder = @"请输入";
                                customerField.font = [UIFont systemFontOfSize:14];
                                customerField.textColor = UIColorFromRGB(0x5a5a5a);
                                customerField.textAlignment = NSTextAlignmentRight;
                                [transferRegisterTableViewCell addSubview:customerField];
                                transferRegisterTableViewCell.rightNameLabel.hidden = YES;
                                
                            }else{
                                transferRegisterTableViewCell.rightNameLabel.hidden = NO;
                                transferRegisterTableViewCell.rightNameLabel.text = cus.customer_name;
                                customerField.hidden = YES;
                            }
                        }
                            break;
                        case 5:{
                            transferRegisterTableViewCell.leftNameLabel.text = @"客户手机";
                            transferRegisterTableViewCell.rightNameLabel.text = @"";
                            [transferRegisterTableViewCell.rightNameLabel removeFromSuperview];
                            transferRegisterTableViewCell.userInteractionEnabled = YES;
                            teleTextField.frame = CGRectMake(100, 5, transferRegisterTableViewCell.frame.size.width - 120, 40);
                            teleTextField.keyboardType = UIKeyboardTypeNumberPad;
                            teleTextField.delegate = self;
                            if (![[cus.customer_tel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                                teleTextField.text = cus.customer_tel;
                            }else{
                                teleTextField.placeholder = @"选填";
                            }
                            teleTextField.font = [UIFont systemFontOfSize:14];
                            teleTextField.textColor = UIColorFromRGB(0x5a5a5a);
                            teleTextField.textAlignment = NSTextAlignmentRight;
                            [transferRegisterTableViewCell addSubview:teleTextField];
                            
                        }
                            break;
                        default:
                            break;
                    }
                }else if(indexPath.row == 6){
                    cell = [[NSBundle mainBundle]loadNibNamed:@"TimeTableViewCell" owner:nil options:nil].lastObject;
                    TimeTableViewCell *timecell = (TimeTableViewCell *)cell;
                    if ([cus.lastmoddate isEqualToString:@""]) {
                        timecell.dateLabel.text = @"";
                    }else{
                        NSMutableString *dateString = [NSMutableString stringWithString:cus.lastmoddate];
                        [dateString insertString:@"  " atIndex:10];
                        timecell.dateLabel.text = dateString;
                    }
                    timecell.userInteractionEnabled = NO;
                }else{
                    cell = [[NSBundle mainBundle]loadNibNamed:@"SeparatorLine" owner:nil options:nil].lastObject;
                    cell.userInteractionEnabled = NO;
                }
        
        }else if(indexPath.section > 0 && indexPath.section < 4){
            cell = [[NSBundle mainBundle] loadNibNamed:@"BusinessChoiceTableViewCell" owner:nil options:nil].lastObject;
            BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
            
            switch (indexPath.section) {
                case 1:{
                    TransferRoleModel *model = [_questionTypeArray objectAtIndex:indexPath.row];
                    businessCell.businessNameLabel.text = model.codeValue;
                    if (businessCell.businessNameLabel.text == section1) {
                        businessCell.selectImage.hidden = NO;
                    }else{
                        businessCell.selectImage.hidden = YES;
                    }
                }
                    break;
                case 2:{
                    TransferRoleModel *model = [_dealResultArray objectAtIndex:indexPath.row];
                    businessCell.businessNameLabel.text = model.codeValue;
                    if (businessCell.businessNameLabel.text == section2) {
                        businessCell.selectImage.hidden = NO;
                    }else{
                        businessCell.selectImage.hidden = YES;
                    }
                }
                    break;
                case 3:{
                    TransferRoleModel *model = [_dealStateArray objectAtIndex:indexPath.row];
                    businessCell.businessNameLabel.text = model.codeValue;
                    if (businessCell.businessNameLabel.text == section3) {
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
    }
    return cell;
}

// 创建Section的分割线
- (UIView *)createSeparatorLine:(CGFloat) point_y{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, point_y, 450, 0.5)];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    return view;
}
- (IBAction)dealAction:(id)sender {
    NSString *not = notsatifyrenson;
    NSString *process = processstatus;
    NSString *end = processend;
    NSString *transfernum = cus.transfer_num;
    NSString *teleNum = teleTextField.text;
    NSString *customerName;
    if ([[cus.customer_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (![[customerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            customerName = customerField.text;
        }else{
             [self showMessage:@"客户姓名为空"];
            return;
        }
    }else{
        customerName = cus.customer_name;
    }
    if (![self isSuccess]) {
        return;
    }
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:cus.work_date,@"work_date",COM_INSTANCE.currentBranch.branchNo,@"branch",cus.queue_num,@"queue_num",transfernum,@"transfer_num",customerName,@"custinfo_name",teleNum,@"custinfo_tel",not,@"not_satify_renson",end,@"process_end",process,@"process_status",remarkText,@"note1", nil];
    
    [InvokeManager invokeApi:@"ibpcpcl" withMethod:@"POST" andParameter:paramDictionary onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        if ([responseCode isEqualToString:@"I00"]){
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                self.commentModel.process_status = process;
                self.commentModel.not_satify_reason = not;
                self.commentModel.process_end = end;
                self.commentModel.remark = remarkText;
                self.commentModel.customer_tel = teleNum;
                NSString *messageStr = [responseInfo valueForKey:@"result"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"commentDealNotification" object:nil];
                [self showMessage:messageStr];

            }else{
                [self showMessage: [responseInfo valueForKey:@"result"]];
            }
        }else{
            [self showMessage:@"出错啦！"];
        }
        
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    }];
    [self.superview removeFromSuperview];
}

- (IBAction)cancelAction:(id)sender {
    [self.superview removeFromSuperview];
}
// 判断处理条件是否满足
- (BOOL)isSuccess{
    if ([processstatus isEqualToString:@""] || processstatus == nil) {
        [self showMessage:@"请选择处理状态"];
        return NO;
    }else if ([notsatifyrenson isEqualToString:@""] || notsatifyrenson == nil) {
        [self showMessage:@"请选择问题归类"];
        return NO;
    }else if ([processend isEqualToString:@""] || processend == nil){
        [self showMessage:@"请选择处理结果"];
        return NO;
    }else {
        return YES;
    }
}
#pragma mark 展开收缩section中cell 手势监听
- (void)SingleTap:(UITapGestureRecognizer *)recognizer{
    NSInteger didSection = recognizer.view.tag;
    if (indext == didSection) {
        
    }else{
        _showDic = nil;
        [self.tableView reloadData];
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexSection] withRowAnimation:UITableViewRowAnimationFade];
}

@end