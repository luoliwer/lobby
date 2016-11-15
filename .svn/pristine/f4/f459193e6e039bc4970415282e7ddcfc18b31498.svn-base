//
//  LoginView.m
//  SmartHall
//
//  Created by YangChao on 21/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import "LoginView.h"
#import "Public.h"
#import "NSString+Size.h"
#import "HistoryUserCell.h"
#define KEYBOARD_NIB_PATH @"Resoure.bundle/resources/HYKeyboard"

//logo常量
static CGFloat padding_10 = 10;
static CGFloat padding_15 = 15;
static CGFloat padding_17 = 17;
static CGFloat padding_20 = 20;
static CGFloat padding_35 = 35;
static CGFloat padding_70 = 70;
static CGFloat padding_60 = 60;
static CGFloat logoTop = 160;//距顶部高度
static CGFloat line_top_width = 240;//距顶部高度
//横线宽高
static CGFloat line_width = 350;
static CGFloat line_height = 1;
//登录按钮宽高
static CGFloat icon_width = 24;
static CGFloat icon_height = 24;
//登录按钮宽高
static CGFloat button_width = 350;
static CGFloat button_height = 50;
//帮助按钮宽高
//分割线
static CGFloat line_spector_width = 1;
static CGFloat line_spector_height = 25;

@interface LoginView ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,HYKeyboardDelegate>
{
    NSMutableArray *_historyUsers;
    BOOL _isKeyboardShowed;//用于判断键盘是否已经弹出
    BOOL _isShowed;//用于判断历史用户列表是否已经展示
}

@property (nonatomic, weak) UITextField *userF;
@property (nonatomic, weak) UITextField *pwdF;
@property (nonatomic, strong) UITableView *historyUserList;//历史记录

@end

@implementation LoginView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        usesafeKeyboard = 
        [self readInfoFromPlist];
        
        _historyUserList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _historyUserList.frame = CGRectMake(-100, -100, 0, 0);
        _historyUserList.delegate = self;
        _historyUserList.dataSource = self;
        _historyUserList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyUserList.backgroundColor = [UIColor clearColor];
        [self addSubview:_historyUserList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
// 读取plist文件的信息
- (BOOL)readInfoFromPlist{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path=[bundle pathForResource:@"Setting" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    BOOL isusesafeKeyboard = [[dic objectForKey:@"UseSafeKeyboard"] boolValue];
    return isusesafeKeyboard;
}
- (void)showTable
{
    _isShowed = YES;
    _historyUserList.frame = CGRectMake((SCREEN_WIDTH - line_width) / 2, CGRectGetMaxY(_userF.superview.frame) - 5, line_width, 200);
}

- (void)hideTable
{
    _isShowed = NO;
    _historyUserList.frame = CGRectMake(-100, -100, 0, 0);
}

- (void)localHistoryUsers
{
    NSArray *history = [[NSUserDefaults standardUserDefaults] objectForKey:k_History_users];
    _historyUsers = [NSMutableArray arrayWithArray:history];
}

- (void)initView
{
    //背景图片
    UIImageView *backView = [[UIImageView alloc] init];
    backView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    backView.image = [UIImage imageNamed:@"LoginBackPic"];
    [self addSubview:backView];
    
    //智慧厅堂a
    NSString *smart = @"智慧厅堂";
    CGSize size = [smart textSizeWithFont:K_FONT_48 constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat x = (SCREEN_WIDTH - size.width) / 2;
    CGFloat y = logoTop;
    
    UILabel *smartLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y, size.width, size.height)];
    smartLb.text = smart;
    smartLb.textColor = [UIColor whiteColor];
    smartLb.font = K_FONT_48;
    [self addSubview:smartLb];
    
    CGFloat liney = CGRectGetMaxY(smartLb.frame) + padding_15;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - line_top_width) / 2, liney, line_top_width, line_height)];
    topLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:topLine];
    
    NSString *subTitle = @"兴业银行   ∙   移动营销系统";
    CGSize subTitleSize = [subTitle textSizeWithFont:K_FONT_20 constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat subx = (SCREEN_WIDTH - subTitleSize.width) / 2;
    CGFloat suby = CGRectGetMaxY(topLine.frame) + padding_15;
    UILabel *subTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(subx, suby, subTitleSize.width, subTitleSize.height)];
    subTitleLb.text = subTitle;
    subTitleLb.textColor = [UIColor whiteColor];
    subTitleLb.font = K_FONT_20;
    [self addSubview:subTitleLb];
    
    //定义用户名区域
    CGFloat userx = (SCREEN_WIDTH - line_width) / 2;
    CGFloat usery = CGRectGetMaxY(subTitleLb.frame) + padding_70;
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(userx, usery, line_width, line_spector_height + padding_15 + line_height)];
    userView.backgroundColor = [UIColor clearColor];
    [self addSubview:userView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(padding_17, 0, icon_width, icon_height)];
    iconView.image = [UIImage imageNamed:@"icon"];
    [userView addSubview:iconView];
    
    CGFloat sepx1 = CGRectGetMaxX(iconView.frame) +padding_17;
    UIView *sepratorLine1 = [[UIView alloc] initWithFrame:CGRectMake(sepx1, 0, line_spector_width, line_spector_height)];
    sepratorLine1.backgroundColor = [UIColor whiteColor];
    [userView addSubview:sepratorLine1];
    
    //用户名输入框
    CGFloat userFX = CGRectGetMaxX(sepratorLine1.frame) + padding_20;
    CGFloat userFW = line_width - padding_20 - padding_17 * 2 - icon_width - line_spector_width;
    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(userFX , 0, userFW, line_spector_height)];
    userField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userField.font = K_FONT_18;
    userField.textColor = RGB(225, 236, 247, 1.0);
    userField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    userField.placeholder = @"请输入工号";
    userField.delegate = self;
    //kvo应用
    //设置placeholder的颜色
    [userField setValue:RGB(225, 236, 247, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    //设置clearButton的自定义图片
    UIButton *clearButton = [userField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"clearBtnNormal"] forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:@"clearBtnHighlighted"] forState:UIControlStateHighlighted];
    userField.returnKeyType = UIReturnKeyNext;
    userField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [userView addSubview:userField];
    
    self.userF = userField;
    self.userF.tag = 201607;
    
    UIView *sepratorLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepratorLine1.frame) + padding_10, line_width, line_height)];
    sepratorLine2.backgroundColor = [UIColor whiteColor];
    [userView addSubview:sepratorLine2];
    
    //密码区域
    CGFloat pwdx = (SCREEN_WIDTH - line_width) / 2;
    CGFloat pwdy = CGRectGetMaxY(userView.frame) + padding_35;
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(pwdx, pwdy, line_width, line_spector_height + padding_15 + line_height)];
    userView.backgroundColor = [UIColor clearColor];
    [self addSubview:pwdView];
    
    UIImageView *pwdImage = [[UIImageView alloc] initWithFrame:CGRectMake(padding_17, 0, icon_width, icon_height)];
    pwdImage.image = [UIImage imageNamed:@"pwd"];
    [pwdView addSubview:pwdImage];
    
    CGFloat sepx2 = CGRectGetMaxX(pwdImage.frame) +padding_17;
    UIView *sepratorLine3 = [[UIView alloc] initWithFrame:CGRectMake(sepx2, 0, line_spector_width, line_spector_height)];
    sepratorLine3.backgroundColor = [UIColor whiteColor];
    [pwdView addSubview:sepratorLine3];
    
    //密码输入框
    CGFloat pwdFX = CGRectGetMaxX(sepratorLine3.frame) + padding_20;
    CGFloat pwdFW = line_width - padding_20 - padding_17 * 2 - icon_width - line_spector_width;
    UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(pwdFX , 0, pwdFW, line_spector_height)];
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdField.font = K_FONT_18;
    pwdField.textColor = RGB(225, 236, 247, 1.0);
    pwdField.placeholder = @"请输入密码";
    [pwdField setValue:RGB(225, 236, 247, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *clearBtn = [pwdField valueForKey:@"_clearButton"];
    [clearBtn setImage:[UIImage imageNamed:@"clearBtnNormal"] forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"clearBtnHighlighted"] forState:UIControlStateHighlighted];
    pwdField.delegate = self;
    pwdField.returnKeyType = UIReturnKeyDone;
    pwdField.secureTextEntry = YES;
    [pwdView addSubview:pwdField];
    
    self.pwdF = pwdField;
    self.pwdF.tag = 201608;
    
    UIView *sepratorLine4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepratorLine3.frame) + padding_10, line_width, line_height)];
    sepratorLine4.backgroundColor = [UIColor whiteColor];
    [pwdView addSubview:sepratorLine4];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake((SCREEN_WIDTH - button_width) / 2, CGRectGetMaxY(pwdView.frame) + padding_60, button_width, button_height);
    UIImage *normal = [Public imageFromColor:RGB(255, 255, 255, 1.0) size:CGSizeMake(button_height, 44)];
    UIImage *highlighted = [Public imageFromColor:RGB(185, 225, 229, 1.0) size:CGSizeMake(button_height, 44)];
    [loginBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    loginBtn.layer.cornerRadius = 4;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGB(51, 162, 239, 1.0) forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGB(28, 129, 196, 1.0) forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = K_FONT_18;
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    CGFloat logow = 144;
    CGFloat logoh = 28;
    CGFloat logox = (SCREEN_WIDTH - logow) / 2;
    CGFloat logoy = SCREEN_HEIGHT - padding_60 - logoh;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logox, logoy, logow, logoh)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoView];
    
    
    // 根据业务要求，去掉登录界面的帮助按钮
    /*
    CGFloat helpx = SCREEN_WIDTH - padding_50 - help_button_width;
    CGFloat helpy = SCREEN_HEIGHT - padding_64 - help_button_height;
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(helpx, helpy, help_button_width, help_button_height);
    [helpBtn setBackgroundImage:[UIImage imageNamed:@"helpBtnInLoginNormal"] forState:UIControlStateNormal];
    [helpBtn setBackgroundImage:[UIImage imageNamed:@"helpBtnInLoginHigh"] forState:UIControlStateHighlighted];
    [helpBtn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:helpBtn];
     */
}

- (void)help
{
    if (_delegate && [_delegate respondsToSelector:@selector(helpToInformation)]) {
        [_delegate helpToInformation];
    }
}

- (void)login:(id)sender
{
    [self login];
}

- (void)login
{
    [UIView animateWithDuration:0.3 animations:^{
        [_userF resignFirstResponder];
        [_pwdF resignFirstResponder];
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(loginWithUser:password:)]) {
            [_delegate loginWithUser:_userF password:_pwdF];
        }
    }];
}

#pragma mark 键盘显示隐藏
- (void)keyboardShow:(NSNotification *)noti
{
    if (_isKeyboardShowed) {//键盘弹出切换输入法时，避免一直改变其frame。
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 260, self.frame.size.width, self.frame.size.height);
    _isKeyboardShowed = YES;
}

- (void)keyboardHide:(NSNotification *)noti
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 260, self.frame.size.width, self.frame.size.height);
    _isKeyboardShowed = NO;
}

#pragma mark -- 文本框代理

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self localHistoryUsers];
    tag = textField.tag;
    if (textField == _userF && _historyUsers.count > 0) {
        if (textField.text.length == 6) {
            return;
        }
        if (!_isShowed) {
            [self showTable];
            _pwdF.text = @"";
        }
    }
    
    if (usesafeKeyboard) {
        [textField resignFirstResponder];
        [self showSecureKeyboardAction];
    }
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_isShowed) {
        [self hideTable];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self localHistoryUsers];
    if (!_isShowed) {
        [self showTable];
    }
    [self.historyUserList reloadData];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if (textField == _userF) {
        if (textField.text.length == 5 && ![string isEqualToString:@""]) {
            if (_isShowed) {
                [self hideTable];
            }
            return YES;
        }
        
        if (string) {
            if ([string isEqualToString:@""]) {//删减
                if (range.location == 0) {
                    [self localHistoryUsers];
                    if (!_isShowed) {
                        [self showTable];
                    }
                    [self.historyUserList reloadData];
                } else {
                    //筛选历史用户
                    NSString *filterString = [textField.text substringToIndex:range.location];
                    NSMutableArray *filterUsers = [self filter:filterString];
                    _historyUsers = filterUsers;
                    if (!_isShowed) {
                        [self showTable];
                    }
                    [self.historyUserList reloadData];
                }
                
            } else {//输入
                //筛选历史用户
                NSString *filterString = [NSString stringWithFormat:@"%@%@", textField.text, string];
                NSMutableArray *filterUsers = [self filter:filterString];
                _historyUsers = filterUsers;
                if (!_isShowed) {
                    [self showTable];
                }
                [self.historyUserList reloadData];
            }
        }
    }
    
    return YES;
}
#pragma mark--
/**初始化安全键盘*/
- (void)showSecureKeyboardAction{
    
    if (keyboard) {
        [keyboard.view removeFromSuperview];
        keyboard.view =nil;
        keyboard=nil;
    }
    
    keyboard = [[HYKeyboard alloc] initWithNibName:KEYBOARD_NIB_PATH bundle:nil];
    /**弹出安全键盘的宿主控制器，不能传nil*/
    keyboard.hostViewController = self;
    /**是否设置按钮无按压和动画效果*/
    keyboard.btnPressAnimation=YES;
    /**是否设置按钮随机变化*/
    keyboard.btnrRandomChange=YES;
    /**是否显示密码明文动画*/
    keyboard.shouldTextAnimation=YES;
    /**安全键盘事件回调，必须实现HYKeyboardDelegate内的其中一个*/
    keyboard.keyboardDelegate=self;
    /**弹出安全键盘的宿主输入框，可以传nil*/
    if (tag == 201607) {
         /**是否输入内容加密*/
        keyboard.secure = NO;
        keyboard.hostTextField = self.userF;
        //背景提示
        keyboard.stringPlaceholder = self.userF.placeholder;
    }else if(tag == 201608) {
         /**是否输入内容加密*/
        keyboard.secure = YES;
        keyboard.hostTextField = self.pwdF;
        //背景提示
        keyboard.stringPlaceholder = self.pwdF.placeholder;
    }
    //    keyboard.arrayText = [NSMutableArray arrayWithArray:contents];//把已输入的内容以array传入;
    /**输入框已有的内容*/
    keyboard.contentText=inputText;
    keyboard.synthesize = YES;//hostTextField输入框同步更新，用*填充
    /**是否清空输入框内容*/
    keyboard.shouldClear = NO;
    /**背景提示*/
    keyboard.intMaxLength = 12;//最大输入长度
    keyboard.keyboardType = HYKeyboardTypeNone;//输入框类型
    /**更新安全键盘输入类型*/
    [keyboard shouldRefresh:HYKeyboardTypeNumber];
    
    //--------添加安全键盘到ViewController---------
    
    [self addSubview:keyboard.view];
    [self bringSubviewToFront:keyboard.view];
    //安全键盘显示动画
    CGRect rect=keyboard.view.frame;
    rect.size.width=self.frame.size.width;
    rect.origin.y=self.frame.size.height+10;
    keyboard.view.frame=rect;
    //显示输入框动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    rect.origin.y=self.frame.size.height-keyboard.view.frame.size.height;
    keyboard.view.frame=rect;
    [UIView commitAnimations];
}
#pragma mark--关闭键盘回调
//输入的内容以NSArray返回
//-(void)inputOverWithTextField:(UITextField *)textField inputArrayText:(NSArray *)arrayText
//{
//    contents=arrayText;//接收输入内容
//
//    [self hiddenKeyboardView];
//}
/**安全键盘点击确定回调方法,输入的内容以NSString返回
 @textField 传入的宿主输入框对象
 @text安全键盘输入的内容，NSString
 */
-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;
    [self hiddenKeyboardView];
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    NSLog(@"变化内容:%@",text);
}

-(void)hiddenKeyboardView
{
    //隐藏输入框动画
    [ UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect=keyboard.view.frame;
         rect.origin.y=self.frame.size.height+10;
         keyboard.view.frame=rect;
         
     }completion:^(BOOL finished){
         
         [keyboard.view removeFromSuperview];
         keyboard.view =nil;
         keyboard=nil;
     }];
}


- (NSMutableArray *)filter:(NSString *)text
{
    NSArray *oldUsers = [[NSUserDefaults standardUserDefaults] objectForKey:k_History_users];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *user in oldUsers) {
        NSRange r = [user rangeOfString:text];
        if (r.location != NSNotFound) {
            [temp addObject:user];
        }
    }
    return temp;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userF) {
        [_pwdF becomeFirstResponder];
    } else {
        [self login];
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
}


- (void)endEdit
{
    if (_isShowed) {
        [self hideTable];
    }
    [_userF resignFirstResponder];
    [_pwdF resignFirstResponder];
    [self endEditing:YES];
}

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [[UIColor blackColor] set];
    
    UIRectFill(self.bounds);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    imageView.image = image;
    
    return imageView;
}

#pragma mark -- UITableView 代理和数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _historyUsers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HistoryCell";
    HistoryUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = (HistoryUserCell *)[[[NSBundle mainBundle] loadNibNamed:@"HistoryUserCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.userNum.text = _historyUsers[indexPath.section];
    
    cell.DeleteHistoryUser = ^(HistoryUserCell *delCell) {//删除历史用户
        NSIndexPath *indexP = [tableView indexPathForCell:delCell];
        
        //删除本地数据
        NSString *noteId = delCell.userNum.text;
        [_historyUsers removeObject:noteId];
        //改变本地缓存数据
        NSArray *oldUsers = [[NSUserDefaults standardUserDefaults] objectForKey:k_History_users];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:oldUsers];
        [temp removeObject:noteId];
        NSArray *nowUsers = [NSArray arrayWithArray:temp];
        [[NSUserDefaults standardUserDefaults] setObject:nowUsers forKey:k_History_users];
        //删除cell
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexP.section] withRowAnimation:UITableViewRowAnimationFade];
        if (_historyUsers.count == 0) {
            if (_isShowed) {
                [self hideTable];
            }
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = YES;
    
    _userF.text = _historyUsers[indexPath.section];
    
    if (_isShowed) {
        [self hideTable];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
}

@end
