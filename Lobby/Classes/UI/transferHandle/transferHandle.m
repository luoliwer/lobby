//
//  transferHandle.m
//  Lobby
//
//  Created by CIB-MacMini on 16/3/29.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "transferHandle.h"
#import "TransferRoleModel.h"
#import "transferHanleTableViewCell.h"
#import "BusinessChoiceTableViewCell.h"
#import "TransferCheck.h"
#import "branch.h"
@interface transferHandle()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITextView *recommendTextView;
    UILabel *rightLabel;
    UIImageView *hideImgView;
    NSMutableDictionary *_showDic; // 用来判断分组展开与收缩
    NSArray *_rowArray;
    NSString *section2;
    UITextView *feedbackTextView;
    TransferCheck *customerCheck;
    CGFloat pointY;
    
    BOOL isClicked; // 判断textView是否被点击过
    NSString *remarkText; //暂存备注
    BOOL isOut;
    
    NSString *marketingStatus; // 处理状态
}
@end
@implementation transferHandle

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initData];
    isClicked = NO;
    if (!remarkText) {
        remarkText = [[NSString alloc] init];
    }
    if (!recommendTextView) {
        recommendTextView = [[UITextView alloc] init];
    }
    if (!feedbackTextView) {
        feedbackTextView = [[UITextView alloc] init];
    }
    
    
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = 5;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 450, 596) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self addSubview:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.backgroundColor = UIColorFromRGB(0xE7EAF2);

   }
-(void)initData{
    _rowArray = [GlobleData sharedInstance].zjmsArray;
}

- (void)didMoveToSuperview{
    customerCheck = [[TransferCheck alloc] init];
    customerCheck = self.checkModel;
}
// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    if (isClicked) {
        return;
    }else{
        if (isOut) {
            return;
        }else{
            NSDictionary *userInfo = [noti userInfo];
            NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect rect = [avalue CGRectValue];
            CGFloat higth = rect.size.height;
            pointY = self.frame.origin.y + 44 + higth - self.frame.size.height;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + pointY - 140, self.frame.size.width, self.frame.size.height);
            isOut = YES;
        }
    }
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    if (isOut) {
        isOut = NO;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - pointY + 140, self.frame.size.width, self.frame.size.height);
    isClicked = NO;
}

#pragma UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return  6;
            break;
        case 2:{
            return 4;
        }
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 2:{
            if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]) {
                return 50;
            }
            return 0;
        }
            break;
        default:
            return 0;
            break;
    }
    }
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: return 0; break;
        case 1: return 132; break;
        case 2: return 50; break;
        default: return 115; break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
        {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 132)];
            header.backgroundColor = self.backgroundColor;
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 120)];
            backgroundView.backgroundColor = [UIColor whiteColor];
            
            UILabel *recommendRemarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 58, 20)];
            recommendRemarkLabel.textColor = UIColorFromRGB(0x5a5a5a);
            recommendRemarkLabel.font = [UIFont systemFontOfSize:14];
            recommendRemarkLabel.text = @"推荐备注";
            [backgroundView addSubview:recommendRemarkLabel];

            recommendTextView.frame = CGRectMake(15, 40, 427, 79.5);
            recommendTextView.tag = 100102;
            recommendTextView.text = customerCheck.remark;
            recommendTextView.delegate = self;
            recommendTextView.font = [UIFont systemFontOfSize:13];
            recommendTextView.textColor = UIColorFromRGB(0x24344e);
            recommendTextView.editable = NO;
            [backgroundView addSubview:recommendTextView];
            [header addSubview:backgroundView];
            
            // 分割线
            UIView *separatorLine1 = [self createSeparatorLine:119.5];
            [backgroundView addSubview:separatorLine1];
            
            UIView *separatorLine2 = [self createSeparatorLine:131.5];
            [backgroundView addSubview:separatorLine2];
            
            return header;
        }
            break;
        case 2:{
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 50)];
            UIView *separatorLine2 = [self createSeparatorLine:49.5];
            [header addSubview:separatorLine2];
            header.backgroundColor = [UIColor whiteColor];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 20)];
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.textColor = UIColorFromRGB(0x5a5a5a);
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = @"处理状态";
            [header addSubview:nameLabel];
            
            rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 204, 20)];
            if (section2.length != 0) {
                rightLabel.text = section2;
            }else{
                if (customerCheck) {
                    for (TransferRoleModel *model in _rowArray) {
                        if ([model.codeId isEqualToString:customerCheck.marketingstatus]) {
                            rightLabel.text = model.codeValue;
                            marketingStatus = model.codeId;
                            break;
                        }else{
                            rightLabel.text = @"请选择";
                        }
                    }
                }else{
                    rightLabel.text = @"请选择";
                }
            }
            rightLabel.textColor = UIColorFromRGB(0xa6a7b1);
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font = [UIFont systemFontOfSize:14];
            [header addSubview:rightLabel];
            
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
            
            return header;
        }
            break;
        case 3:{
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 115)];
            UIView *separatorLine1 = [self createSeparatorLine:39.5];
            [header addSubview:separatorLine1];
            UIView *separatorLine2 = [self createSeparatorLine:114.5];
            [header addSubview:separatorLine2];
            header.backgroundColor = UIColorFromRGB(0xeff2f7);
            UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 20)];
            feedbackLabel.textColor = UIColorFromRGB(0x5a5a5a);
            feedbackLabel.textAlignment = NSTextAlignmentLeft;
            feedbackLabel.font = [UIFont systemFontOfSize:14];
            feedbackLabel.text = @"反馈备注";
            [header addSubview:feedbackLabel];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 450, 75)];
            backgroundView.backgroundColor = [UIColor whiteColor];
            
            feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 0, 427, 75)];
            feedbackTextView.tag = 100101;
            feedbackTextView.font = [UIFont systemFontOfSize:13];
            if ([[self.checkModel.remark1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                feedbackTextView.text = @"限125字以内(必输)";
                feedbackTextView.textColor = UIColorFromRGB(0xa6a7b1);
            }else{
                feedbackTextView.text = self.checkModel.remark1;
                remarkText = self.checkModel.remark1;
                feedbackTextView.textColor = UIColorFromRGB(0x5a5a5a);
            }
            feedbackTextView.delegate = self;
            [backgroundView addSubview:feedbackTextView];
            [header addSubview:backgroundView];
            
            return header;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //     选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
    
    NSArray *cellarray = [tableView visibleCells];
    for(BusinessChoiceTableViewCell *cell in cellarray){
        cell.selectImage.hidden=YES;
    }
    businessCell.selectImage.hidden = YES;
    businessCell.selectImage.hidden = NO;
    rightLabel.text = businessCell.businessNameLabel.text;
    for (TransferRoleModel *model in [GlobleData sharedInstance].zjmsArray) {
        if ([rightLabel.text isEqualToString:model.codeValue]) {
            marketingStatus = model.codeId;
            break;
        }
    }
    section2 = businessCell.businessNameLabel.text;
    [self switchAction:indexPath.section];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        if (indexPath.section == 2) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BusinessChoiceTableViewCell" owner:nil options:nil].lastObject;
             BusinessChoiceTableViewCell *businessCell = (BusinessChoiceTableViewCell *)cell;
            TransferRoleModel *model = [_rowArray objectAtIndex:indexPath.row];
             businessCell.businessNameLabel.text = model.codeValue;
            if (businessCell.businessNameLabel.text == section2) {
                businessCell.selectImage.hidden = NO;
            }else{
                businessCell.selectImage.hidden = YES;
            }
            businessCell.backgroundColor = UIColorFromRGB(0xe7eaf3);

        }else{
            cell = [[NSBundle mainBundle] loadNibNamed:@"transferHanleTableViewCell" owner:nil options:nil].lastObject;
            transferHanleTableViewCell *transferHandleCell = (transferHanleTableViewCell *)cell;
            transferHandleCell.userInteractionEnabled = NO;
            transferHandleCell.backgroundColor = UIColorFromRGB(0xfcfdff);
            if (indexPath.row != 0) {
                transferHandleCell.headImg.hidden = YES;
            }
            if (indexPath.row != 2) {
                transferHandleCell.dateLabel.hidden = YES;
            }
            switch (indexPath.row)
            {
                case 0:{
                    transferHandleCell.nameLabel.text = @"客户姓名";
                    
                    transferHandleCell.rightNameLabel.text = customerCheck.custinfo_name;
                    transferHandleCell.headImg.image = [UIImage imageNamed:@"headpotraitLogo"];
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                case 1:{
                    transferHandleCell.nameLabel.text = @"业务类别";
                    transferHandleCell.rightNameLabel.text = customerCheck.referral_bs_name;
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                case 2:{
                    transferHandleCell.nameLabel.text = @"发起时间";
                    transferHandleCell.dateLabel.text = [self dateFormatterTransfer:customerCheck.clue_date];
                    transferHandleCell.rightNameLabel.text = [self timeFormatterTransfer:customerCheck.clue_time];
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                case 3:{
                    transferHandleCell.nameLabel.text = @"商机来源";
                    for (TransferRoleModel *model in [GlobleData sharedInstance].xslyArray) {
                        if ([model.codeId isEqualToString:customerCheck.cluesource]) {
                            transferHandleCell.rightNameLabel.text = model.codeValue;
                            break;
                        }
                    }
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                case 4:{
                    transferHandleCell.nameLabel.text = @"转介人";
                    transferHandleCell.rightNameLabel.text = customerCheck.referraluser_name;
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                case 5:{
                    transferHandleCell.nameLabel.text = @"交易金额";
                    transferHandleCell.rightNameLabel.text = customerCheck.busi_amount;
                    [cell addSubview:[self separatorLine:cell.frame]];
                }
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
}
// cell 的分割线
- (UIView *)separatorLine:(CGRect) cellFrame{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, cellFrame.size.height - 1, cellFrame.size.width, 0.5)];
    view.backgroundColor = UIColorFromRGB(0xCCCCCC);
    return view;
}
// 创建Section的分割线
- (UIView *)createSeparatorLine:(CGFloat) point_y{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, point_y, 450, 0.5)];
    view.backgroundColor = UIColorFromRGB(0xcccccc);
    return view;
}
#pragma mark 展开收缩section中cell 手势监听
- (void)SingleTap:(UITapGestureRecognizer *)recognizer{

    if (!_showDic) {
        _showDic = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [NSString stringWithFormat:@"%d",2];
    if (![_showDic objectForKey:key]) {
        [_showDic setObject:@"1" forKey:key];
    }else{
        [_showDic removeObjectForKey:key];
    }
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
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
    if (textView.tag == 100101) {
        customerCheck.remark1 = textView.text;
        if (textView.markedTextRange == nil && 125 > 0 && textView.text.length > 125) {
            textView.text = [textView.text substringToIndex:125];
        }
        remarkText = textView.text;
    }    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        feedbackTextView.textColor = UIColorFromRGB(0xa6a7b1);
        feedbackTextView.text = @"限125字以内(必输)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

- (IBAction)sure:(id)sender {
    NSString *branchNo = COM_INSTANCE.currentBranch.branchNo;
    NSString *clueDate = customerCheck.clue_date;
    NSString *referraluser = customerCheck.referraluser;
    NSString *clueid = customerCheck.clue_id;
    if ([marketingStatus isEqualToString:@""] || marketingStatus == nil) {
        [self showMessage:@"请选择处理状态"];
        return;
    }
    if ([remarkText isEqualToString:@""] || customerCheck.remark1 == nil) {
         [self showMessage:@"请填写反馈备注"];
        return;
    }
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:branchNo,@"branch",clueDate,@"clue_date",referraluser,@"operateuser",clueid,@"clue_id",marketingStatus,@"marketingstatus",remarkText,@"remark1", nil];
    [InvokeManager invokeApi:@"ibpzjcl" withMethod:@"POST" andParameter:paraDic onSuccess:^(NSString *responseCode, NSString *responseInfo) {
        if ([responseCode isEqualToString:@"I00"]){
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            NSString *resultStr = [responseInfo valueForKey:@"result"];
            if ([resultCode isEqualToString:@"0"]) {
                self.checkModel.marketingstatus = marketingStatus;
                self.checkModel.remark1 = remarkText;
                UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"提示" message:resultStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"TransferNotificationCenter" object:nil];
                
            }else{
                UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"提示" message:resultStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
        
    }];
    [self.superview removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    [self.superview removeFromSuperview];
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

// 将HHmmss格式的时间转换成HH:mm格式的时间
- (NSString *)timeFormatterTransfer:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate *time = [formatter dateFromString:timeString];
    NSDateFormatter *timeMatter = [[NSDateFormatter alloc] init];
    [timeMatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [timeMatter stringFromDate:time];
    return timeStr;
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

//点击Cell收起下拉列表
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
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexSection] withRowAnimation:UITableViewRowAnimationFade];
}
@end
