//
//  TurnView.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/5/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "TurnView.h"
#import "Customer.h"
#import "SmartHallConfig.h"
#import "CustTableViewCell.h"
#import "CustomIndicatorView.h"
#import "Branch.h"
#import "Station.h"
#import "BusinessChoiceTableViewCell.h"
#import "UIView+ShowMessage.h"

static CGFloat viewWidth = 450;
static CGFloat viewHeight = 614;

@interface TurnView ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSArray *_busType;
    NSArray *_stationType;
    NSArray *_callPolicy;
    
    NSArray *_items;
    
    NSDictionary *_busDic;
    NSDictionary *_staDic;
    NSDictionary *_polDic;
    
    BOOL _isKeyboardShowed;//用于判断键盘是否已经弹出
    
    NSInteger _currentLocation;
}

@property (nonatomic, weak) UIButton *turnBusBtn;
@property (nonatomic, weak) UIButton *turnStaBtn;
@property (nonatomic, weak) UIButton *currentTurnBtn;
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIView *line;

//中间位置的控件 业务类型和叫号策略
@property (nonatomic, strong) UIButton *choseBusBtn;
@property (nonatomic, weak) UILabel *busValue;
@property (nonatomic, weak) UIImageView *busArrow;

@property (nonatomic, strong) UIButton *choseStaBtn;
@property (nonatomic, weak) UILabel *staValue;
@property (nonatomic, weak) UIImageView *staArrow;

@property (nonatomic, strong) UIButton *callPolicyBtn;
@property (nonatomic, weak) UILabel *policyValue;
@property (nonatomic, weak) UIImageView *policyArrow;

@property (nonatomic, weak) UILabel *beizhuLb;
@property (nonatomic, strong) UIView *remarkView;
@property (nonatomic, weak) UILabel *placeholderLb;
@property (nonatomic, weak) UITextView *markText;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TurnView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置背景色
        self.backgroundColor = UIColorFromRGB(0xEEF3F6);
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        [self setupCommonUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColorFromRGB(0xEEF3F6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _callPolicy = @[@{@"bs__id":@"1", @"bs_name":@"时间优先"}, @{@"bs__id":@"2", @"bs_name":@"超级优先"}];
    }
    return self;
}

- (void)setCustomer:(Customer *)customer
{
    _customer = customer;
    
    [self invokeBusiness];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = viewWidth;
    frame.size.height = viewHeight;
    [super setFrame:frame];
}

//初始化通用的UI
- (void)setupCommonUI
{
    //上部分共同元素控件
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    titleLb.backgroundColor = UIColorFromRGB(0x0088D2);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = K_FONT_16;
    titleLb.text = @"客户转移";
    [self addSubview:titleLb];
    
    UIButton *busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    busBtn.frame = CGRectMake(0, CGRectGetMaxY(titleLb.frame), viewWidth / 2, 53);
    [busBtn setTitle:@"转业务" forState:UIControlStateNormal];
    busBtn.backgroundColor = [UIColor whiteColor];
    busBtn.tag = 10001;
    busBtn.selected = YES;
    _currentTurnBtn = busBtn;
    [busBtn setTitleColor:UIColorFromRGB(0xC3C4CA) forState:UIControlStateNormal];
    [busBtn setTitleColor:UIColorFromRGB(0x5A5A5A) forState:UIControlStateSelected];
    [busBtn addTarget:self action:@selector(changeTurnStyle:) forControlEvents:UIControlEventTouchUpInside];
    [busBtn.titleLabel setFont:K_FONT_16];
    [self addSubview:busBtn];
    
    self.turnBusBtn = busBtn;
    
    UIButton *staBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    staBtn.frame = CGRectMake(viewWidth / 2, CGRectGetMaxY(titleLb.frame), viewWidth / 2, 53);
    [staBtn setTitle:@"转窗口" forState:UIControlStateNormal];
    staBtn.backgroundColor = [UIColor whiteColor];
    staBtn.tag = 10002;
    [staBtn setTitleColor:UIColorFromRGB(0xC3C4CA) forState:UIControlStateNormal];
    [staBtn setTitleColor:UIColorFromRGB(0x5A5A5A) forState:UIControlStateSelected];
    [staBtn addTarget:self action:@selector(changeTurnStyle:) forControlEvents:UIControlEventTouchUpInside];
    [staBtn.titleLabel setFont:K_FONT_16];
    [self addSubview:staBtn];
    
    self.turnStaBtn = staBtn;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(busBtn.frame) - 3, viewWidth / 2, 3)];
    lineView.backgroundColor = UIColorFromRGB(0x0086D6);
    [self addSubview:lineView];
    
    self.line = lineView;
    
    UIView *sepratorLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame), viewWidth, 1)];
    sepratorLine.backgroundColor = UIColorFromRGB(0xE7EAF2);
    [self addSubview:sepratorLine];
    
    //视图底部确定取消按钮
    UIButton *confBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confBtn.frame = CGRectMake(0, viewHeight - 50, viewWidth / 2, 50);
    [confBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confBtn setTitleColor:UIColorFromRGB(0x0086D6) forState:UIControlStateNormal];
    [confBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    [confBtn.titleLabel setFont:K_FONT_16];
    [confBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confBtn];
    
    self.confirmBtn= confBtn;
    
    UIView *sepratorLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.confirmBtn.frame), viewHeight - 50, 1, 50)];
    sepratorLine1.backgroundColor = UIColorFromRGB(0xE7EAF2);
    [self addSubview:sepratorLine1];
    
    UIButton *cancBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancBtn.frame = CGRectMake(viewWidth / 2, viewHeight - 50, viewWidth / 2, 50);
    [cancBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancBtn setTitleColor:UIColorFromRGB(0x979797) forState:UIControlStateNormal];
    [cancBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    [cancBtn.titleLabel setFont:K_FONT_16];
    [cancBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancBtn];
    
    self.cancelBtn = cancBtn;
    
    UIView *sepratorLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 51, viewWidth, 1)];
    sepratorLine2.backgroundColor = UIColorFromRGB(0xE7EAF2);
    [self addSubview:sepratorLine2];
    
    
    [self addSubview:self.choseBusBtn];
    [self addSubview:self.callPolicyBtn];
    
    UILabel *bzLb = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), 120, 40)];
    bzLb.textAlignment = NSTextAlignmentLeft;
    bzLb.textColor = UIColorFromRGB(0x5a5a5a);
    bzLb.font = K_FONT_14;
    bzLb.text = @"备注";
    [self addSubview:bzLb];
    
    self.beizhuLb = bzLb;
    
    [self addSubview:self.remarkView];
}

- (UIButton *)choseBusBtn
{
    if (!_choseBusBtn) {
        _choseBusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _choseBusBtn.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame) + 1, viewWidth, 50);
        _choseBusBtn.backgroundColor = [UIColor whiteColor];
        _choseBusBtn.tag = 101;
        [_choseBusBtn addTarget:self action:@selector(choseBusType:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, viewWidth, 50)];
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.textColor = UIColorFromRGB(0x5a5a5a);
        titleLb.font = K_FONT_14;
        titleLb.text = @"业务类型";
        [_choseBusBtn addSubview:titleLb];
        
        UILabel *valueLb = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 160, 0, 120, 50)];
        valueLb.textAlignment = NSTextAlignmentRight;
        valueLb.textColor = UIColorFromRGB(0x5a5a5a);
        valueLb.font = K_FONT_14;
        [_choseBusBtn addSubview:valueLb];
        
        self.busValue = valueLb;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(viewWidth - 40, 5, 40, 40);
        imageView.image = [UIImage imageNamed:@"hide"];
        imageView.contentMode = UIViewContentModeCenter;
        [_choseBusBtn addSubview:imageView];
        
        self.busArrow = imageView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, viewWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xE7EAF2);
        [_choseBusBtn addSubview:line];
    }
    
    return _choseBusBtn;
}

- (UIButton *)choseStaBtn
{
    if (!_choseStaBtn) {
        _choseStaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _choseStaBtn.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame) + 1, viewWidth, 50);
        _choseStaBtn.backgroundColor = [UIColor whiteColor];
        _choseStaBtn.tag = 103;
        [_choseStaBtn addTarget:self action:@selector(choseStaType:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, viewWidth, 50)];
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.textColor = UIColorFromRGB(0x5a5a5a);
        titleLb.font = K_FONT_14;
        titleLb.text = @"转移接受窗口";
        [_choseStaBtn addSubview:titleLb];
        
        UILabel *valueLb = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 160, 0, 120, 50)];
        valueLb.textAlignment = NSTextAlignmentRight;
        valueLb.textColor = UIColorFromRGB(0x5a5a5a);
        valueLb.font = K_FONT_14;
        [_choseStaBtn addSubview:valueLb];
        
        self.staValue = valueLb;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(viewWidth - 40, 5, 40, 40);
        imageView.image = [UIImage imageNamed:@"hide"];
        imageView.contentMode = UIViewContentModeCenter;
        [_choseStaBtn addSubview:imageView];
        
        self.staArrow = imageView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, viewWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xE7EAF2);
        [_choseStaBtn addSubview:line];
    }
    
    return _choseStaBtn;
}

- (UIButton *)callPolicyBtn
{
    if (!_callPolicyBtn) {
        _callPolicyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.choseBusBtn.frame), viewWidth, 50);
        _callPolicyBtn.backgroundColor = [UIColor whiteColor];
        _callPolicyBtn.tag = 102;
        [_callPolicyBtn addTarget:self action:@selector(callPolicy:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 50)];
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.textColor = UIColorFromRGB(0x5a5a5a);
        titleLb.font = K_FONT_14;
        titleLb.text = @"叫号策略";
        [_callPolicyBtn addSubview:titleLb];
        
        UILabel *valueLb = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 160, 0, 120, 50)];
        valueLb.textAlignment = NSTextAlignmentRight;
        valueLb.textColor = UIColorFromRGB(0x5a5a5a);
        valueLb.font = K_FONT_14;
        [_callPolicyBtn addSubview:valueLb];
        
        self.policyValue = valueLb;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(viewWidth - 40, 5, 40, 40);
        imageView.image = [UIImage imageNamed:@"hide"];
        imageView.contentMode = UIViewContentModeCenter;
        [_callPolicyBtn addSubview:imageView];
        
        self.policyArrow = imageView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, viewWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xE7EAF2);
        [_callPolicyBtn addSubview:line];
    }
    
    return _callPolicyBtn;
}

- (UIView *)remarkView
{
    if (!_remarkView) {
        _remarkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), viewWidth, 120)];
        _remarkView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xE7EAF2);
        [_remarkView addSubview:line];
        
        UILabel *placeHold = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, viewWidth - 40, 15)];
        placeHold.textAlignment = NSTextAlignmentLeft;
        placeHold.textColor = UIColorFromRGB(0xa6a7b1);
        placeHold.font = K_FONT_13;
        placeHold.text = @"限125字以内（选填）";
        [_remarkView addSubview:placeHold];
        
        self.placeholderLb = placeHold;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(20, 10, viewWidth - 40, 100);
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = UIColorFromRGB(0x5a5a5a);
        textView.font = K_FONT_13;
        textView.delegate = self;
        [_remarkView addSubview:textView];
        
        self.markText = textView;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, viewWidth, 1)];
        line1.backgroundColor = UIColorFromRGB(0xE7EAF2);
        [_remarkView addSubview:line1];
    }
    return _remarkView;
}

#pragma mark UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.placeholderLb.text = @"";
}

//由于联想输入的时候，无法用- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;判断字数，所以采用- (void)textViewDidChange:(UITextView *)textView
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 125) {
        textView.text = [textView.text substringToIndex:125];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 125) {
        textView.text = [textView.text substringToIndex:125];
        [self showMessage:@"超出125个字，超出部分将不予提交"];
        return NO;
    }
    return YES;
}

- (void)showMessage:(NSString *)msg
{
    CGSize size = [msg sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 30;
    CGFloat h = size.height + 20;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = (window.bounds.size.height - h) / 2 - 100;
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
    label.font = K_FONT_14;
    label.text = msg;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark 键盘显示隐藏
- (void)keyboardShow:(NSNotification *)noti
{
    if (_isKeyboardShowed) {//键盘弹出切换输入法时，避免一直改变其frame。
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 100, self.frame.size.width, self.frame.size.height);
    _isKeyboardShowed = YES;
}

- (void)keyboardHide:(NSNotification *)noti
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 100, self.frame.size.width, self.frame.size.height);
    _isKeyboardShowed = NO;
}

#pragma mark -- 切换转换类型
- (void)changeTurnStyle:(UIButton *)sender
{
    if (sender.tag == _currentTurnBtn.tag) {
        return;
    }
    
    _currentTurnBtn.selected = NO;
    sender.selected = YES;
    _currentTurnBtn = sender;
    
    CGFloat x = CGRectGetMinX(sender.frame);
    [self changeLine:x];
    
    [self.tableView removeFromSuperview];
    
    if (sender.tag == 10001) {
        if (self.choseStaBtn.isSelected) {
            self.choseStaBtn.selected = NO;
            self.staArrow.image = [UIImage imageNamed:@"hide"];
        }
        if (self.callPolicyBtn.isSelected) {
            self.callPolicyBtn.selected = NO;
            self.policyArrow.image = [UIImage imageNamed:@"hide"];
        }
        [self.choseStaBtn removeFromSuperview];
        [self addSubview:self.choseBusBtn];
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.choseBusBtn.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
    } else {
        if (self.choseBusBtn.isSelected) {
            self.choseBusBtn.selected = NO;
            self.busArrow.image = [UIImage imageNamed:@"hide"];
        }
        if (self.callPolicyBtn.isSelected) {
            self.callPolicyBtn.selected = NO;
            self.policyArrow.image = [UIImage imageNamed:@"hide"];
        }
        [self.choseBusBtn removeFromSuperview];
        [self addSubview:self.choseStaBtn];
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.choseStaBtn.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
    }
}

//改变转移类型按钮下面的线的位置
- (void)changeLine:(CGFloat)x
{
    [UIView animateWithDuration:0.0 animations:^{
        self.line.frame = CGRectMake(x, self.line.frame.origin.y, self.line.frame.size.width, self.line.frame.size.height);
    }];
}

- (void)choseBusType:(UIButton *)button
{
    _currentLocation = button.tag;
    _items = _busType;
    if (self.choseStaBtn.isSelected) {
        self.choseStaBtn.selected = NO;
        self.staArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (self.callPolicyBtn.isSelected) {
        self.callPolicyBtn.selected = NO;
        self.policyArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (!button.isSelected) {
        [self addSubview:self.tableView];
        [self.tableView reloadData];
        CGFloat tableHeight = 44 * _items.count > 176 ? 176 : (44 * _items.count);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), viewWidth, tableHeight);
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.busArrow.image = [UIImage imageNamed:@"show"];
    } else {
        [self.tableView removeFromSuperview];
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(button.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.busArrow.image = [UIImage imageNamed:@"hide"];
    }
    button.selected = !button.isSelected;
}

- (void)choseStaType:(UIButton *)button
{
    _currentLocation = button.tag;
    _items = _stationType;
    if (self.choseBusBtn.isSelected) {
        self.choseBusBtn.selected = NO;
        self.busArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (self.callPolicyBtn.isSelected) {
        self.callPolicyBtn.selected = NO;
        self.policyArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (!button.isSelected) {
        [self addSubview:self.tableView];
        [self.tableView reloadData];
        CGFloat tableHeight = 44 * _items.count > 176 ? 176 : (44 * _items.count);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), viewWidth, tableHeight);
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.staArrow.image = [UIImage imageNamed:@"show"];
    } else {
        [self.tableView removeFromSuperview];
        self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(button.frame), viewWidth, 50);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.staArrow.image = [UIImage imageNamed:@"hide"];
    }
    button.selected = !button.isSelected;
}

- (void)updateUI
{
    self.callPolicyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.choseBusBtn.frame), viewWidth, 50);
    self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.callPolicyBtn.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
    self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
}

- (void)callPolicy:(UIButton *)button
{
    _currentLocation = button.tag;
    _items = _callPolicy;
    if (self.choseBusBtn.isSelected) {
        self.choseBusBtn.selected = NO;
        self.busArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (self.choseStaBtn.isSelected) {
        self.choseStaBtn.selected = NO;
        self.staArrow.image = [UIImage imageNamed:@"hide"];
    }
    if (!button.isSelected) {
        [self.tableView removeFromSuperview];
        [self addSubview:self.tableView];
        [self.tableView reloadData];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.choseBusBtn.frame), button.frame.size.width, button.frame.size.height);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), viewWidth, 88);
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(self.tableView.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.policyArrow.image = [UIImage imageNamed:@"show"];
    } else {
        [self.tableView removeFromSuperview];
        self.beizhuLb.frame = CGRectMake(20, CGRectGetMaxY(button.frame), self.beizhuLb.frame.size.width, self.beizhuLb.frame.size.height);
        self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.beizhuLb.frame), self.remarkView.frame.size.width, self.remarkView.frame.size.height);
        self.policyArrow.image = [UIImage imageNamed:@"hide"];
    }
    button.selected = !button.isSelected;
}

#pragma mark -- 确定取消按钮事件

- (void)confirm:(UIButton *)confBtn
{
    if (_currentTurnBtn.tag == 10002) {//转窗口
        if (!self.staValue.text || [self.staValue.text isEqualToString:@""]) {
            [self showMessage:@"请选择可接受窗口"];
            return;
        }
        if (!self.policyValue.text || [self.policyValue.text isEqualToString:@""]) {
            [self showMessage:@"请选择叫号策略"];
            return;
        }
        [self invokeTurnToStation];
    } else {
        if (!self.busValue.text || [self.busValue.text isEqualToString:@""]) {
            [self showMessage:@"请选择业务类型"];
            return;
        }
        if (!self.policyValue.text || [self.policyValue.text isEqualToString:@""]) {
            [self showMessage:@"请选择叫号策略"];
            return;
        }
        
        [self invokeTurnToBusiness];
    }
}

- (void)cancel:(UIButton *)cancBtn
{
    [self dismiss];
}

- (void)dismiss
{
    [self.superview removeFromSuperview];
}

#pragma UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentLocation == 101) {
        self.busArrow.image = [UIImage imageNamed:@"hide"];
        _busDic = _items[indexPath.row];
        self.busValue.text = [_busDic valueForKey:@"bs_name"];
    } else if (_currentLocation == 102) {
        self.policyArrow.image = [UIImage imageNamed:@"hide"];
        _polDic = _items[indexPath.row];
        self.policyValue.text = [_polDic valueForKey:@"bs_name"];
    } else if (_currentLocation == 103) {
        self.staArrow.image = [UIImage imageNamed:@"hide"];
        _staDic = _items[indexPath.row];
        self.staValue.text = [_staDic valueForKey:@"bs_name"];
    }
    [self.tableView removeFromSuperview];
    [self updateUI];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TurnBusinessCell";
    CustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustTableViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = UIColorFromRGB(0xe7eaf3);
    }
    NSInteger row = indexPath.row;
    cell.title.text = [_items[row] valueForKey:@"bs_name"];
    
    return cell;
}

#pragma mark 获取业务类型
- (void)invokeBusiness
{
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                
                id result = [responseInfo valueForKey:@"result"];
                if ([responseInfo isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *resultDic = (NSDictionary *)result;
                    id business = [resultDic valueForKey:@"busiInfoGroup"];
                    if ([business isKindOfClass:[NSArray class]]) {
                        _busType = (NSArray *)business;
                        
                        _items = _busType;
                    }
                    
                    [self invokeStation];
                }
            } else {
                
            }
        }
        [[CustomIndicatorView sharedView] stopAnimating];
    };
    
    [InvokeManager invokeApi:@"ibpwzyw" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark 获取窗口
- (void)invokeStation
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        [[CustomIndicatorView sharedView] stopAnimating];
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                NSArray *result = [responseInfo valueForKey:@"result"];
                NSMutableArray *stas = [NSMutableArray array];
                for (NSDictionary *item in result) {
                    NSString *status = item[@"status"];
                    NSString *queueNum = item[@"queueNum"];
                    if ([_customer.ticketNo isEqualToString:queueNum]) {
                        continue ;
                    }
                    if ([status isEqualToString:@"1"] || [status isEqualToString:@"2"]) {
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
                        
                        NSString *name = [NSString stringWithFormat:@"%@号窗口", sta.stationNo];
                        
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sta.qmNum, @"qmnum", sta.stationNo, @"bs__id", name, @"bs_name", nil];
                        
                        [stas addObject:dic];
                    }
                }
                
                _stationType = [NSArray arrayWithArray:stas];
            }
        }
    };
    
    [InvokeManager invokeApi:@"ibpgws" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark 转业务
- (void)invokeTurnToBusiness
{
    NSString *busType = [_busDic valueForKey:@"bs__id"];
    NSString *celue = [_polDic valueForKey:@"bs__id"];
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    NSDictionary *paramDic = nil;
    NSString *branch = COM_INSTANCE.currentBranch.branchNo;
    NSString *markText = @"";
    if (self.markText.text && ![self.markText.text isEqualToString:@""]) {
        if (self.markText.text.length > 125) {
            markText = [self.markText.text substringToIndex:124];
        } else {
            markText = self.markText.text;
        }
    }
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:branch, @"branch",
                _customer.ticketNo, @"queue_num",
                @"02", @"custtype_i",
                @"999888_02005", @"queuetype_id",
                @"5", @"queuenum_type",
                busType, @"transferBsId",
                celue, @"queue_strategy",
                @"", @"transferQmNum",
                @"", @"transferWinNum",
                markText, @"remark",
                COM_INSTANCE.noteId, @"softcall_teller",
                COM_INSTANCE.realName, @"softcall_teller_name", nil];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        [[CustomIndicatorView sharedView] stopAnimating];
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            NSString *reason = [responseInfo valueForKey:@"result"];
            [self showMessage:reason];
            [self.superview removeFromSuperview];
            if ([resultCode isEqualToString:@"0"]) {
                _UpdateData();
            }
        }
    };
    
    [InvokeManager invokeApi:@"ibpkhzy" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

#pragma mark 转窗口
- (void)invokeTurnToStation
{
    [[CustomIndicatorView sharedView] showInView:self];
    [[CustomIndicatorView sharedView] startAnimating];
    
    NSString *qmnum = [_staDic valueForKey:@"qmnum"];
    NSString *stationNo = [_staDic valueForKey:@"bs__id"];
    NSString *celue = [_polDic valueForKey:@"bs__id"];
    NSString *markText = @"";
    if (self.markText.text && ![self.markText.text isEqualToString:@""]) {
        if (self.markText.text.length > 125) {
            markText = [self.markText.text substringToIndex:124];
        } else {
            markText = self.markText.text;
        }
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:COM_INSTANCE.currentBranch.branchNo forKey:@"branch"];
    [paramDic setObject:_customer.ticketNo forKey:@"queue_num"];
    [paramDic setObject:@"4" forKey:@"queuenum_type"];
    [paramDic setObject:qmnum forKey:@"transferQmNum"];
    [paramDic setObject:stationNo forKey:@"transferWinNum"];
    [paramDic setObject:celue forKey:@"queue_strategy"];
    [paramDic setObject:markText forKey:@"remark"];
    [paramDic setObject:COM_INSTANCE.noteId forKey:@"softcall_teller"];
    [paramDic setObject:COM_INSTANCE.realName forKey:@"softcall_teller_name"];
    
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        [[CustomIndicatorView sharedView] stopAnimating];
    };
    
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        
        [[CustomIndicatorView sharedView] stopAnimating];
        
        if ([responseCode isEqualToString:@"I00"]) {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            NSString *reason = [responseInfo valueForKey:@"result"];
            [self showMessage:reason];
            [self.superview removeFromSuperview];
            if ([resultCode isEqualToString:@"0"]) {
                _UpdateData();
            }
        }
    };
    
    [InvokeManager invokeApi:@"ibpkhzy" withMethod:@"POST" andParameter:paramDic onSuccess:success onFailure:failure];
}

@end
