//
//  PrivateAppointmentView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/10/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "PrivateAppointmentView.h"
#import "CustomIndicatorView.h"
#import "ListView.h"
#import "DateInfo.h"

@implementation PrivateAppointmentView
{
    NSString *yystatus;
    UIScrollView *scrollview;
    float temporayVar;
    BOOL ischoiced;
    NSMutableArray *detailArray;
    NSArray *array1;
    NSArray *array2;
    NSArray *array3;
    NSArray *itemArr;
    NSArray *statusArr;
    NSArray *undealArr; // 未处理
    NSArray *doingArr; // 正在备钞
    NSArray *doneArr; // 已备钞待提取
    
    NSString *contentText; //短信内容
    
    ListView *_listView;
    NSArray *_statusTypesArr;
    NSDictionary *_statusTypesDic;
    
    NSString *_businessType;
    NSString *_dealTime;
    
    int Cnumber; // 汉字的个数
    int Enumber; // 非汉字的个数
    
    BOOL isOut; // 判断键盘是否已经弹出过
    BOOL istextField;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    isOut = NO;
    istextField = NO;
    ischoiced = NO;
    Cnumber = 0;
    Enumber = 0;
    self.remak_textview.delegate = self;
    self.remak_textview.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.appointmentStatus_Label.textColor = UIColorFromRGB(0x24344e);
    array1 = [NSArray arrayWithObjects:@"业务类型",@"客户姓名",@"币种",@"金额",@"期望提取日期",@"手机号",@"预约时间",@"备注",nil];
    array3 = [NSArray arrayWithObjects:@"业务类型",@"客户姓名",@"币种",@"金额",@"期望提取日期",@"新旧程度",@"面额",@"手机号",@"预约时间",@"备注",nil];
    
    array2 = [NSArray arrayWithObjects:@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"",@"\"null\"", nil];
    
    undealArr = @[@{@"9":@"正在备钞"},@{@"6":@"已备钞待提取"},@{@"4":@"客户放弃"},@{@"7":@"无法满足客户需求"},@{@"2":@"提取完成"}];
    
    doingArr = @[@{@"6":@"已备钞待提取"},@{@"4":@"客户放弃"},@{@"7":@"无法满足客户需求"},@{@"2":@"提取完成"}];
    
    doneArr = @[@{@"4":@"客户放弃"},@{@"7":@"无法满足客户需求"},@{@"2":@"提取完成"}];
    detailArray = [[NSMutableArray alloc] initWithArray:array2];
    
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
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



- (IBAction)statuschange:(UIButton *)sender {
    //初始化
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }else{
        _listView = [[ListView alloc] init];
        _listView.backgroundColor = [UIColor redColor];
        
        __block PrivateAppointmentView *weakSelf = self;
        _listView.frame = CGRectMake(420, 465, 120, 200);
        
        NSString *selected = self.appointmentStatus_Label.text;
        _listView.selectedValue = selected;
        _listView.listItems = _statusTypesArr;
        
        _listView.listViewSelectedValue = ^(NSDictionary *val) {
            [weakSelf selectedValueToButton:val];
        };
        
        [self addSubview:_listView];
    }
}

- (void)selectedValueToButton:(NSDictionary *)val
{
    NSString *value = [[val allValues] firstObject];
    self.appointmentStatus_Label.text = value;
    _statusTypesDic = val;
    [_listView removeFromSuperview];
    
    NSString *key = [[val allKeys] firstObject];
    if ([key isEqualToString:@"6"]) {
        _checkboxBtn.selected = YES;
        [self changeColorOrHidenText:NO];
        _checkboxBtn.userInteractionEnabled = YES;
    } else {
        if (_checkboxBtn.isSelected) {
            _checkboxBtn.selected = NO;
        }
        [self changeColorOrHidenText:YES];
        _checkboxBtn.userInteractionEnabled = NO;
    }
}




- (IBAction)sendmessage:(UIButton *)sender {
    if (![[[_statusTypesDic allKeys] firstObject] isEqualToString:@"6"]) {//只有当状态为已备钞待提取状态才可以点击
        return;
    }
    NSString *content = [NSString stringWithFormat:@"您的现钞预约已备钞，请%@来网点办理。您可先通过“服务预约”办理预约取号，免排队。", _dealTime];
    self.remak_textview.text = content;
    
    [self changeColorOrHidenText:sender.isSelected];
    
    sender.selected = !sender.isSelected;
}

- (void)changeColorOrHidenText:(BOOL)changed
{
    if (!changed) {
        self.contentLabel.hidden = NO;
        self.leftbracket.hidden = NO;
        self.rightbracket.hidden = NO;
        self.contentLabel.textColor = [UIColor redColor];
        self.contentLabel.text = @"请编辑短信文本，短信限60字";
        [self.contentLabel setWidth:234];
        [self.rightbracket setX:390];
        self.remak_textview.userInteractionEnabled = YES;
        self.remak_textview.textColor = UIColorFromRGB(0x24344e);
        [self.checkboxBtn setBackgroundImage:[UIImage imageNamed:@"btn_send_click"] forState:UIControlStateNormal];
        
        
    }else{
        self.contentLabel.hidden = YES;
        self.rightbracket.hidden = YES;
        self.leftbracket.hidden = YES;
        self.remak_textview.userInteractionEnabled = NO;
        self.remak_textview.textColor = UIColorFromRGB(0xa6a7b1);
        [self.checkboxBtn setBackgroundImage:[UIImage imageNamed:@"btn_send_unclick"] forState:UIControlStateNormal];
    }
}

- (void)setPragrames:(NSArray *)pragrames
{
    _pragrames = pragrames;
    
    //访问接口
    [self dateDetail:_pragrames];
}

- (void)dateDetail:(NSArray *)pragram
{
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:pragram[0] forKey:@"dqdh"];
    [paramDic setObject:pragram[1] forKey:@"jgdh"];
    [paramDic setObject:pragram[2] forKey:@"yybh"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                id result = [responseInfo valueForKey:@"result"];
                if ([result isKindOfClass:[NSString class]]) {
                    [self showMessage:result];
                }else if (result == nil){
                    itemArr = [NSArray arrayWithArray:array3];
                    [self showMessage:@"后台无数据返回。"];
                }else if ([result isKindOfClass:[NSDictionary class]]){
                    NSMutableDictionary *testDic = [NSMutableDictionary dictionaryWithDictionary:result];
                    if (testDic.count == 0) {
                        [self showMessage:@"后台无数据返回。"];
                       itemArr = [NSArray arrayWithArray:array3];
                    }else{
                        NSDictionary *businessTypeDic = nil;//业务类型
                        NSDictionary *moneyTypeDic = nil;//公司性质类型
                        NSDictionary *statusDic = nil;//预约状态类型
                        
                        //从本地获取客户层级
                        NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                        NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
                        NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                        if (rootDic) {
                            NSArray *branches = rootDic[@"Root"];
                            NSMutableDictionary *tempDic1 = [NSMutableDictionary dictionary];
                            NSMutableDictionary *tempDic2 = [NSMutableDictionary dictionary];
                            NSMutableDictionary *tempDic3 = [NSMutableDictionary dictionary];
                            for (NSDictionary *item in branches) {
                                if ([@"OTO_DSYW" isEqualToString:item[@"codeType"]]) {
                                    NSString *val = item[@"codeValue"];
                                    NSString *key = item[@"codeId"];
                                    [tempDic1 addEntriesFromDictionary:@{key:val}];
                                } else if ([@"OTO_YWBZ" isEqualToString:item[@"codeType"]]) {
                                    NSString *val = item[@"codeValue"];
                                    NSString *key = item[@"codeId"];
                                    [tempDic2 addEntriesFromDictionary:@{key:val}];
                                } else if ([@"OTO_BITX" isEqualToString:item[@"codeType"]]) {
                                    NSString *val = item[@"codeValue"];
                                    NSString *key = item[@"codeId"];
                                    [tempDic3 addEntriesFromDictionary:@{key:val}];
                                }
                            }
                            businessTypeDic = tempDic1;
                            moneyTypeDic = tempDic2;
                            statusDic = tempDic3;
                        }
                        // 设置预约状态
                        NSString *statusTypeKey = result[@"yyzt"];
                        if (statusTypeKey == nil || [statusTypeKey isEqualToString:@""]) {
                            [self showMessage:@"预约状态数据异常！"];
                        }else{
                            NSString *statusVal = statusDic[statusTypeKey];
                            self.appointmentStatus_Label.text = statusVal;
                            if ([statusTypeKey isEqualToString:@"1"]) {
                                _statusTypesArr = [NSArray arrayWithArray:undealArr];
                            }else if ([statusTypeKey isEqualToString:@"9"]){
                                _statusTypesArr = [NSArray arrayWithArray:doingArr];
                            }else if ([statusTypeKey isEqualToString:@"6"]){
                                _statusTypesArr = [NSArray arrayWithArray:doneArr];
                            }
                            self.appointmentStatus_Label.text = [[_statusTypesArr[0] allValues] firstObject];
                            _statusTypesDic = _statusTypesArr[0];
                        }
                        
                        // 设置业务类型
                        NSString *busTypeKey = result[@"ywzl"];
                        _businessType = busTypeKey;
                        NSString *busVal = businessTypeDic[busTypeKey];
                        if (busVal == nil) {
                            busVal = @"";
                        }
                        [detailArray replaceObjectAtIndex:0 withObject:busVal];
                        
                        // 设置姓名
                        NSString *nameStr = result[@"khmc"];
                        if (nameStr == nil) {
                            nameStr = @"";
                        }
                        [detailArray replaceObjectAtIndex:1 withObject:nameStr];
                        
                        // 设置币种
                        NSString *moneyTypeKey = result[@"bz"];
                        NSString *bzValue = moneyTypeDic[moneyTypeKey];
                        if ([bzValue isEqualToString:@"人民币"]) {
                            
                            //设置期望提取时间
                            NSString *dateTime = result[@"qwqxrq"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyyMMdd"];
                            NSDate *d = [formatter dateFromString:dateTime];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            NSString *qwtqtimeStr = [formatter stringFromDate:d];
                            _dealTime = [formatter stringFromDate:d];
                            //设置默认值
                            NSString *content = [NSString stringWithFormat:@"您的现钞预约已备钞，请%@来网点办理。您可先通过“服务预约”办理预约取号，免排队。", _dealTime];
                            self.remak_textview.text = content;
                            contentText = content;
                            if (qwtqtimeStr == nil) {
                                qwtqtimeStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:4 withObject:qwtqtimeStr];
                            
                            //设置预约时间
                            NSString *createTime = result[@"cjsj"];
                            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                            [dateformatter setDateFormat:@"yyyyMMdd"];
                            NSDate *date = [dateformatter dateFromString:createTime];
                            if (createTime.length > 8) {
                                [dateformatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
                            }else{
                                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                            }
                            
                            NSString *createtimeStr = [formatter stringFromDate:date];
                            if (createtimeStr == nil) {
                                createtimeStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:8 withObject:createtimeStr];
                            
                            itemArr = [NSArray arrayWithArray:array3];
                            if (bzValue == nil) {
                                bzValue = @"";
                            }
                            [detailArray replaceObjectAtIndex:2 withObject:bzValue];
                            
                            // 设置金额
                            NSString *numberOfMoney = result[@"qxje"];
                            if (numberOfMoney == nil) {
                                numberOfMoney = @"";
                            }
                            [detailArray replaceObjectAtIndex:3 withObject:numberOfMoney];
                            
                            // 设置新旧程度
                            NSString *degreeOfMoney = result[@"xcbz"];
                            if (degreeOfMoney && [degreeOfMoney isEqualToString:@"1"]) {
                                degreeOfMoney = @"新钞";
                            }else{
                                degreeOfMoney = @"普通";
                            }
                            if (degreeOfMoney == nil) {
                                degreeOfMoney = @"";
                            }
                            [detailArray replaceObjectAtIndex:5 withObject:degreeOfMoney];
                            // 设置面额
                            NSString *ybynumber = @""; // 100 元的数量
                            NSString *wsynumber = @""; // 50 元的数量
                            NSString *esynumber = @""; // 20 元的数量
                            NSString *synumber = @""; // 10 元的数量
                            NSString *wynumber = @""; // 5 元的数量
                            NSString *yynumber = @""; // 1 元的数量
                            NSString *wjnumber = @""; // 5 角的数量
                            if (![result[@"bycpsl"] isEqualToString:@""]) {
                                ybynumber = [NSString stringWithFormat:@"100元/%d张  ",[result[@"bycpsl"] intValue]];
                            }
                            if (![result[@"wsycpsl"] isEqualToString:@""]) {
                                wsynumber = [NSString stringWithFormat:@"50元/%d张  ",[result[@"wsycpsl"] intValue]];
                            }
                            if (![result[@"esycpsl"] isEqualToString:@""]) {
                                esynumber =[NSString stringWithFormat:@"20元/%d张  ",[result[@"esycpsl"] intValue]];
                            }
                            if (![result[@"sycpsl"] isEqualToString:@""]) {
                                synumber = [NSString stringWithFormat:@"10元/%d张  ",[result[@"sycpsl"] intValue]];
                            }
                            if (![result[@"wycpsl"] isEqualToString:@""]) {
                                wynumber = [NSString stringWithFormat:@"5元/%d张  ",[result[@"wycpsl"] intValue]];
                            }
                            if (![result[@"yycpsl"] isEqualToString:@""]) {
                                yynumber = [NSString stringWithFormat:@"1元/%d张  ",[result[@"yycpsl"] intValue]];
                            }
                            if (![result[@"wjcpsl"] isEqualToString:@""]) {
                                wjnumber = [NSString stringWithFormat:@"5角/%d张  ",[result[@"wjcpsl"] intValue]];
                            }
                            NSString *mianenumber = [[[[[[[ybynumber stringByAppendingString:wsynumber] stringByAppendingString:esynumber] stringByAppendingString:synumber] stringByAppendingString:synumber] stringByAppendingString:wynumber] stringByAppendingString:yynumber] stringByAppendingString:wjnumber];
                            if (mianenumber == nil) {
                                [detailArray replaceObjectAtIndex:6 withObject:@""];
                            }else{
                                [detailArray replaceObjectAtIndex:6 withObject:mianenumber];
                            }
                            // 设置手机号
                            NSString *phoneNumber = result[@"yysj"];
                            if (phoneNumber == nil) {
                                phoneNumber = @"";
                            }
                            [detailArray replaceObjectAtIndex:7 withObject:phoneNumber];
                            
                            // 设置备注
                            NSString *remarkStr = result[@"khly"];
                            if (remarkStr == nil) {
                                remarkStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:9 withObject:remarkStr];
                        }else{
                            
                            //设置期望提取时间
                            NSString *dateTime = result[@"qwqxrq"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyyMMdd"];
                            NSDate *d = [formatter dateFromString:dateTime];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            NSString *qwtqtimeStr = [formatter stringFromDate:d];
                            _dealTime = [formatter stringFromDate:d];
                            //设置默认值
                            NSString *content = [NSString stringWithFormat:@"您的现钞预约已备钞，请%@来网点办理。您可先通过“服务预约”办理预约取号，免排队。", _dealTime];
                            NSLog(@"%lu",(unsigned long)content.length);
                            self.remak_textview.text = content;
                            
                            contentText = content;
                            if (qwtqtimeStr == nil) {
                                qwtqtimeStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:4 withObject:qwtqtimeStr];
                            
                            //设置预约时间
                            NSString *createTime = result[@"cjsj"];
                            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                            [dateformatter setDateFormat:@"yyyyMMdd"];
                            NSDate *date = [dateformatter dateFromString:createTime];
                            if (createTime.length > 8) {
                                [dateformatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
                            }else{
                                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                            }
                            
                            NSString *createtimeStr = [formatter stringFromDate:date];
                            if (createtimeStr == nil) {
                                createtimeStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:6 withObject:createtimeStr];
                            
                            itemArr = [NSArray arrayWithArray:array1];
                            if (bzValue == nil) {
                                bzValue = @"";
                            }
                            [detailArray replaceObjectAtIndex:2 withObject:bzValue];
                            
                            // 设置金额
                            NSString *numberOfMoney = result[@"qxje"];
                            if (numberOfMoney == nil) {
                                numberOfMoney = @"";
                            }
                            [detailArray replaceObjectAtIndex:3 withObject:numberOfMoney];
                            
                            // 设置手机号
                            NSString *phoneNumber = result[@"yysj"];
                            if (phoneNumber == nil) {
                                phoneNumber = @"";
                            }
                            [detailArray replaceObjectAtIndex:5 withObject:phoneNumber];
                            
                            // 设置备注
                            NSString *remarkStr = result[@"khly"];
                            if (remarkStr == nil) {
                                remarkStr = @"";
                            }
                            [detailArray replaceObjectAtIndex:7 withObject:remarkStr];
                        }
                    }
                }
                [self componentView];//构建视图
            }
        }
    };
    
    [InvokeManager invokeApi:@"otodsxx" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

- (void)componentView
{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 450, 365)];
    scrollview.scrollEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = YES;
    scrollview.bounces = NO;
    
    for (int i=0; i<itemArr.count; i++) {
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = itemArr[i];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentRight;
        label1.textColor = UIColorFromRGB(0x5a5a5a);
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = detailArray[i];
        label2.numberOfLines = 0;
        label2.font = [UIFont systemFontOfSize:14];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.textColor = UIColorFromRGB(0x24344e);
        CGSize label2size = {0,0};
        label2size = [detailArray[i] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (i == 0) {
            label1.frame = CGRectMake(65, 15, 120, 30);
            label2.frame = CGRectMake(215, 15, 200, (label2size.height > 30) ? label2size.height : 30);
            temporayVar = label2.frame.size.height;
            
        }else{
            label1.frame = CGRectMake(65, 15 + 20 * i + temporayVar, 120, 30);
            label2.frame = CGRectMake(215, label1.frame.origin.y, 200, (label2size.height > 30) ? label2size.height : 30);
            temporayVar = label2.frame.size.height + temporayVar;
        }
        scrollview.contentSize = CGSizeMake(450, label2.frame.origin.y + ((label2size.height > 30) ? label2size.height : 30));
        [scrollview addSubview:label1];
        [scrollview addSubview:label2];
    }
    [self addSubview:scrollview];
}


//自定义提示框
- (void)showMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 30;
    CGFloat h = size.height + 20;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = window.bounds.size.height - h - 50;
    showview.frame = CGRectMake(x, y - 450, w, h);
    
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
    label.font = K_FONT_14;
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

- (IBAction)sure:(id)sender {
    [self dealDate];
}

- (void)dealDate
{
    NSString *des = self.remak_textview.text;
    if ([[des stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [self showMessage:@"短信内容不能为空！"];
        return;
    }
    
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_pragrames[0] forKey:@"dqdh"];
    [paramDic setObject:_pragrames[1] forKey:@"jgdh"];
    [paramDic setObject:_pragrames[2] forKey:@"yybh"];
    NSString *resultKey = [[_statusTypesDic allKeys] firstObject];
    [paramDic setObject:resultKey forKey:@"shjg"];
    
    if ([resultKey isEqualToString:@"6"]) {
        [paramDic setObject:des forKey:@"jgms"];
    } else {
        [paramDic setObject:@"" forKey:@"jgms"];
    }
    [paramDic setObject:_businessType forKey:@"ywzl"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSString *result = [responseInfo valueForKey:@"result"];
                [self showMessage:result];
                _date.dateStatus = [[_statusTypesDic allKeys] firstObject];
                _UpdateDatesInTableView(_date);
                [self.superview removeFromSuperview];
            }
        }
    };
    
    [InvokeManager invokeApi:@"otopersMerg2" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (![contentText isEqualToString:@""]) {
        textView.text = contentText;
    }else{
        textView.text = @"";
    }
    textView.textColor = UIColorFromRGB(0x24344e);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //禁止输入法输入表情
    if ([PrivateAppointmentView stringContainsEmoji:text]) {
        return NO;
    }
    
    for (int i=0; i<textView.text.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [textView.text substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            Cnumber++;
            
        }else if (strlen(cString) == 1){
            Enumber++;
            
        }
    }
    if ((Cnumber * 2 + Enumber) >= 120 && text.length > range.length) {
        Cnumber = 0;
        Enumber = 0;
        return NO;
    }
    Enumber = 0;
    return YES;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    
    __block BOOL containsEmoji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    containsEmoji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            
            if (ls == 0x20e3) {
                containsEmoji = YES;
            }
            
        } else {
            
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                containsEmoji = YES;
            } else if (0x2B05 <= hs && hs <=0x2b07) {
                containsEmoji = YES;
            } else if (0x2934 <= hs && hs <=0x2935) {
                containsEmoji = YES;
            } else if (0x3297 <= hs && hs <=0x3299) {
                containsEmoji = YES;
            } else if (hs == 0xa9 || hs ==0xae || hs == 0x303d || hs ==0x3030 || hs == 0x2b55 || hs ==0x2b1c || hs == 0x2b1b || hs ==0x2b50 || hs == 0x231a) {
                containsEmoji = YES;
            }
        }
        
    }];
    
    return containsEmoji;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.markedTextRange == nil && 120 > 0 && textView.text.length > 0) {
        for (int i=0; i<textView.text.length; i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [textView.text substringWithRange:range];
            const char *cString = [subString UTF8String];
            if (strlen(cString) == 3) {
                Cnumber++;
                
            }else if (strlen(cString) == 1){
                Enumber++;
                
            }
            if ((Cnumber * 2 + Enumber) >= 120 ) {
                [self showMessage:@"不能超过120个字符！"];
                break;
            }
        }
        if ((Cnumber * 2 + Enumber) == 121 ) {
            textView.text = [textView.text substringToIndex:((Cnumber + Enumber) - 1)];
        }else{
            textView.text = [textView.text substringToIndex:(Cnumber + Enumber)];
        }
    }
    
    Cnumber = 0;
    Enumber = 0;
    contentText = textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    contentText = textView.text;
}


- (IBAction)cancel:(id)sender {
    [self.superview removeFromSuperview];
}
@end
