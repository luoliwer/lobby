//
//  CustomerCell.m
//  SmartHall
//
//  Created by YangChao on 26/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import "CustomerCell.h"
#import "Customer.h"
#import "PhotoDisplayView.h"
#import "CommonUtils.h"
#import "Branch.h"
#import "Public.h"
#import "UIView+ShowMessage.h"
#import <CIBBaseSDK/FileManager.h>
#import "CustomIndicatorView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat const SMMoreOptionsDefaultContentWidth = 150.0f;
CGFloat const SMMoreOptionsAnimationDuration = 0.25f;
NSString *const SMMoreOptionsShouldHideNotification = @"SMMoreOptionsHideNotification";

static CGFloat cellHeight = 48;

#define normalTextColor  RGB(90, 90, 90, 1.0)

#define hightLightTextColor  RGB(90, 90, 90, 1.0)

#define kBackgroundColor  RGB(244, 245, 251, 1.0)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SMMoreOptionsCellGestureDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableViewCell *cell;

- (instancetype)initWithCell:(UITableViewCell *)cell;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CustomerCell () <UIScrollViewDelegate> {
    struct {
        unsigned int delegateDidHideOptions:1;
        unsigned int delegateDidShowOptions:1;
        unsigned int optionsVisible:1;
    } _optionsFlags;
    
    UIButton *_ticketTimeBtn;
    UIButton *_customerNameBtn;
    UILabel *_ticketNoLb;
    UILabel *_busTypeLb;
    UILabel *_statusLb;
    UILabel *_managerLb;
    UIButton *_custLevel;
    UILabel *_gapLb;
    UILabel *_unsignLb;
    UIImageView *_icon;
    UIView *_line;
    NSMutableDictionary *_ticketStatusDic;
}

@property (nonatomic, strong) SMMoreOptionsCellGestureDelegate *gestureDelegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIButton *singleTapButton;
@property (nonatomic, assign) CGPoint start;

@end

@implementation CustomerCell

#pragma mark - Setter/Getter

- (void)setDelegate:(id<SMMoreOptionsDelegate>)delegate {
    if ( _delegate == delegate )
        return;
    
    _delegate = delegate;
    _optionsFlags.delegateDidHideOptions = [_delegate respondsToSelector:@selector(cellDidHideOptions:)];
    _optionsFlags.delegateDidShowOptions = [_delegate respondsToSelector:@selector(cellDidShowOptions:)];
}

- (void)setScrollViewContentView:(UIView *)swipeContentView {
    if ( _scrollViewContentView == swipeContentView )
        return;
    
    [_scrollViewContentView removeFromSuperview]; // remove the old view
    
    _scrollViewContentView = swipeContentView;
    [self.contentView addSubview:_scrollViewContentView];
    [self setNeedsLayout];
}

- (void)setScrollViewOptionsView:(UIView *)optionsContentView {
    if ( _scrollViewOptionsView == optionsContentView )
        return;
    
    [_scrollViewOptionsView removeFromSuperview];  // remove the old view
    
    _scrollViewOptionsView = optionsContentView;
    _scrollViewOptionsView.hidden = !_optionsFlags.optionsVisible;
    [self.contentView insertSubview:_scrollViewOptionsView belowSubview:self.scrollViewContentView];
    [self setNeedsLayout];
}

- (void)setTurnToButton:(UIButton *)turnToButton
{
    if (_turnToButton == turnToButton) {
        return;
    }
    [_turnToButton removeFromSuperview];
    
    _turnToButton = turnToButton;
    [_turnToButton addTarget:self action:@selector(_touchOnTurnTo:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewOptionsView addSubview:_turnToButton];
    [self setNeedsLayout];
}
- (void)setTransferButton:(UIButton *)transferButton {
    if ( _transferButton == transferButton )
        return;
    [_transferButton removeFromSuperview];
    
    _transferButton = transferButton;
    [_transferButton addTarget:self action:@selector(_touchOnTransfer:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewOptionsView addSubview:_transferButton];
    [self setNeedsLayout];
}

- (void)setMoveoutButton:(UIButton *)moveoutButton {
    if ( _moveoutButton == moveoutButton )
        return;
    [_moveoutButton removeFromSuperview];
    
    _moveoutButton = moveoutButton;
    [_moveoutButton addTarget:self action:@selector(_touchOnMoveOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewOptionsView addSubview:_moveoutButton];
    [self setNeedsLayout];
}

- (void)setScrollViewOptionsWidth:(CGFloat)optionsContentWidth {
    if ( _scrollViewOptionsWidth == optionsContentWidth )
        return;
    
    _scrollViewOptionsWidth = optionsContentWidth;
    [self setNeedsLayout];
}

- (void)setup
{
    self.backgroundColor = kBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    careBtn.selected = NO;
    careBtn.titleLabel.font = K_FONT_13;
    [careBtn setTitleColor:normalTextColor forState:UIControlStateNormal];
    careBtn.imageView.contentMode = UIViewContentModeCenter;
//    careBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    careBtn.userInteractionEnabled = YES;
    [careBtn addTarget:self action:@selector(care:) forControlEvents:UIControlEventTouchUpInside];
    _ticketTimeBtn = careBtn;
    [self.scrollViewContentView addSubview:_ticketTimeBtn];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.selected = NO;
    button.titleLabel.font = K_FONT_13;
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeCenter;
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(downloadImageFromServer) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewContentView addSubview:button];
    
    _customerNameBtn = button;
    
    _ticketNoLb = [[UILabel alloc] init];
    _ticketNoLb.backgroundColor = [UIColor clearColor];
    _ticketNoLb.textColor = normalTextColor;
    _ticketNoLb.textAlignment = NSTextAlignmentCenter;
    _ticketNoLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_ticketNoLb];
    
    _busTypeLb = [[UILabel alloc] init];
    _busTypeLb.backgroundColor = [UIColor clearColor];
    _busTypeLb.textColor = normalTextColor;
    _busTypeLb.textAlignment = NSTextAlignmentCenter;
    _busTypeLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_busTypeLb];
    
    _statusLb = [[UILabel alloc] init];
    _statusLb.backgroundColor = [UIColor clearColor];
    _statusLb.textColor = normalTextColor;
    _statusLb.textAlignment = NSTextAlignmentCenter;
    _statusLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_statusLb];
    
    _managerLb = [[UILabel alloc] init];
    _managerLb.backgroundColor = [UIColor clearColor];
    _managerLb.textColor = normalTextColor;
    _managerLb.textAlignment = NSTextAlignmentCenter;
    _managerLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_managerLb];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.selected = NO;
    button2.titleLabel.font = K_FONT_13;
    [button2 setTitleColor:normalTextColor forState:UIControlStateNormal];
    button2.imageView.contentMode = UIViewContentModeCenter;
    button2.userInteractionEnabled = NO;
    [self.scrollViewContentView addSubview:button2];
    
    _custLevel = button2;
    
    _gapLb = [[UILabel alloc] init];
    _gapLb.backgroundColor = [UIColor clearColor];
    _gapLb.textColor = normalTextColor;
    _gapLb.textAlignment = NSTextAlignmentCenter;
    _gapLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_gapLb];
    
    _unsignLb = [[UILabel alloc] init];
    _unsignLb.backgroundColor = [UIColor clearColor];
    _unsignLb.textColor = normalTextColor;
    _unsignLb.textAlignment = NSTextAlignmentCenter;
    _unsignLb.font = K_FONT_13;
    [self.scrollViewContentView addSubview:_unsignLb];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = RGB(242, 245, 246, 1.0);
    [self.scrollViewContentView addSubview:_line];
    
    //从本地获取客户的票号状态码值
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"keyvalue.plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (rootDic) {
        NSArray *roots = [rootDic valueForKey:@"Root"];
        _ticketStatusDic = [NSMutableDictionary dictionary];
        for (NSDictionary *item in roots) {
            if ([[item valueForKey:@"codeType"] isEqualToString:@"PHZT"]) {
                NSString *key = [item valueForKey:@"codeId"];
                NSString *val = [item valueForKey:@"codeValue"];
                [_ticketStatusDic addEntriesFromDictionary:@{key : val}];
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeCellContent];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super initWithCoder:aDecoder] ) {
        [self initializeCellContent];
        [self setup];
    }
    return self;
}

- (void)initializeCellContent {
    self.scrollViewOptionsWidth = SMMoreOptionsDefaultContentWidth;
    _optionsFlags.optionsVisible = NO;
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    // The cell is already delegate of some gesture recognizer classes and to prevent conflicts use this object.
    self.gestureDelegate = [[SMMoreOptionsCellGestureDelegate alloc] initWithCell:self];
    
    // Is only usable if the userInteractionEnabled property of the scrollview is set to NO.
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.delegate = self.gestureDelegate;
    
    self.scrollViewContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.scrollViewContentView.backgroundColor = [UIColor whiteColor];
    
    self.scrollViewOptionsView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.singleTapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.singleTapButton.backgroundColor = [UIColor clearColor];
    [self.singleTapButton addTarget:self action:@selector(_handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *green = [UIColor colorWithRed:(116.0f/255.0f) green:(239.0f/255.0f) blue:(140.0f/255) alpha:1.0f];
    UIColor *greenHighlight = [UIColor colorWithRed:(90.0f/255.0f) green:(192.0f/255.0f) blue:(117.0f/255) alpha:1.0f];
    UIImage *greenImage = [UIImage imageWithColor:green];
    UIImage *greenImageHighlight = [UIImage imageWithColor:greenHighlight];
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:NSLocalizedString(@"转移", @"") forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:greenImage forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:greenImageHighlight forState:UIControlStateHighlighted];
    [deleteButton setAdjustsImageWhenHighlighted:YES];
    [deleteButton.titleLabel setFont:K_FONT_13];
    self.turnToButton = deleteButton;
    
    UIColor *blue = [UIColor colorWithRed:(144.0f/255.0f) green:(208.0f/255.0f) blue:(249.0f/255) alpha:1.0f];
    UIImage *grayImage = [UIImage imageWithColor:blue];
    UIColor *blueH = [UIColor colorWithRed:(120.0f/255.0f) green:(192.0f/255.0f) blue:(238.0f/255) alpha:1.0f];
    UIImage *grayImageH = [UIImage imageWithColor:blueH];
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:NSLocalizedString(@"转介", @"") forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton setBackgroundImage:grayImageH forState:UIControlStateHighlighted];
    [moreButton setBackgroundImage:grayImage forState:UIControlStateNormal];
    [moreButton setAdjustsImageWhenHighlighted:YES];
    [moreButton.titleLabel setFont:K_FONT_13];
    self.transferButton = moreButton;
    
    UIColor *red = [UIColor colorWithRed:(217.0f/255.0f) green:(75.0f/255.0f) blue:(71.0f/255) alpha:1.0f];
    UIImage *redImage = [UIImage imageWithColor:red];
    UIColor *redH = [UIColor colorWithRed:(201.0f/255.0f) green:(62.0f/255.0f) blue:(58.0f/255) alpha:1.0f];
    UIImage *redImageH = [UIImage imageWithColor:redH];
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveButton setTitle:NSLocalizedString(@"移除", @"") forState:UIControlStateNormal];
    [moveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moveButton setBackgroundImage:redImageH forState:UIControlStateHighlighted];
    [moveButton setBackgroundImage:redImage forState:UIControlStateNormal];
    [moveButton setAdjustsImageWhenHighlighted:YES];
    [moveButton.titleLabel setFont:K_FONT_13];
    self.moveoutButton = moveButton;
    
    [self.contentView addGestureRecognizer:self.panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_receivedHideNotification:)
                                                 name:SMMoreOptionsShouldHideNotification
                                               object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    
    self.scrollViewOptionsView.frame = CGRectMake(bounds.size.width - self.scrollViewOptionsWidth,
                                                  0.0f,
                                                  self.scrollViewOptionsWidth,
                                                  bounds.size.height);
    self.scrollViewContentView.frame = bounds;
    
    CGFloat width = self.scrollViewContentView.frame.size.width / 9;
    _ticketTimeBtn.frame = CGRectMake(0, 0, width, cellHeight);
    _customerNameBtn.frame = CGRectMake(width, 0, width, cellHeight);
    _ticketNoLb.frame = CGRectMake(width * 2, 0, width, cellHeight);
    _busTypeLb.frame = CGRectMake(width * 3, 0, width, cellHeight);
    _statusLb.frame = CGRectMake(width * 4, 0, width, cellHeight);
    _managerLb.frame = CGRectMake(width * 5, 0, width, cellHeight);
    _custLevel.frame = CGRectMake(width * 6, 0, width, cellHeight);
    _gapLb.frame = CGRectMake(width * 7, 0, width, cellHeight);
    _unsignLb.frame = CGRectMake(width * 8, 0, width, cellHeight);
    _line.frame = CGRectMake(0, cellHeight, self.scrollViewContentView.frame.size.width, 0.5);
    
    CGFloat buttonWidth = ceilf(self.scrollViewOptionsWidth/3);
    self.turnToButton.frame = CGRectMake(0.0f, 0.0f, buttonWidth, bounds.size.height);
    self.transferButton.frame = CGRectMake(buttonWidth, 0.0f, buttonWidth, bounds.size.height);
    self.moveoutButton.frame = CGRectMake(2 * buttonWidth, 0.0f, buttonWidth, bounds.size.height);
    self.singleTapButton.frame = bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.scrollViewContentView.frame = self.contentView.bounds;
    self.scrollViewOptionsView.hidden = YES;
    _optionsFlags.optionsVisible = NO;
    [self.singleTapButton removeFromSuperview];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if ( _optionsFlags.optionsVisible ) {
        [self dismissOptionsAnimated:animated];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

- (void)_optionsViewDidDisappear {
    if ( _optionsFlags.delegateDidHideOptions && _optionsFlags.optionsVisible ) {
        [self.delegate cellDidHideOptions:self];
    }
    
    _optionsFlags.optionsVisible = NO;
    self.scrollViewOptionsView.hidden = YES;
    [self.singleTapButton removeFromSuperview];
    
}

- (void)_optionsViewDidAppear {
    if ( _optionsFlags.delegateDidShowOptions && !_optionsFlags.optionsVisible ) {
        [self.delegate cellDidShowOptions:self];
    }
    
    _optionsFlags.optionsVisible = YES;
    self.scrollViewContentView.userInteractionEnabled = YES;
    [self.scrollViewContentView addSubview:self.singleTapButton];
}

- (CGPoint)_scrollContentViewCenterForOffset:(CGFloat)offset {
    CGFloat x = ceil(CGRectGetWidth(self.contentView.bounds)/2.0f);
    
    if ( _optionsFlags.optionsVisible == YES ) {
        x -= ( self.scrollViewOptionsWidth + offset);
    } else {
        x -= MAX(offset, 0.0f);
    }
    
    return CGPointMake(x, self.scrollViewContentView.center.y);
}

- (CGPoint)_scrollContentViewStartPoint {
    return CGPointMake(ceil(CGRectGetWidth(self.contentView.bounds)/2.0f), self.scrollViewContentView.center.y);
}

- (CGPoint)_scrollContentViewEndPoint {
    return CGPointMake(ceil(CGRectGetWidth(self.contentView.bounds)/2.0f) - self.scrollViewOptionsWidth,
                       self.scrollViewContentView.center.y);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)dismissOptionsAnimated:(BOOL)animated {
    [UIView animateWithDuration:(animated) ? SMMoreOptionsAnimationDuration : 0.0f animations:^(void) {
        self.scrollViewContentView.frame = self.contentView.bounds;
    } completion:^(BOOL finished) {
        [self _optionsViewDidDisappear];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action Methods

- (void)_touchOnTurnTo:(UIButton *)button {
    [self.delegate didTouchOnTurnTo:self];
    [self dismissOptionsAnimated:YES];
}

- (void)_touchOnTransfer:(UIButton *)button {
    [self.delegate didTouchOnTransfer:self];
    [self dismissOptionsAnimated:YES];
}

- (void)_touchOnMoveOut:(UIButton *)button {
    [self.delegate didTouchOnMoveOut:self];
    [self dismissOptionsAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture Methods

- (void)_handleSingleTap:(UIButton *)singleTabButton {
    [self dismissOptionsAnimated:YES];
}


- (void)_handlePanGesture:(UIPanGestureRecognizer *)gesture {
    // Is the cell selected or isEditing set do nothing to prevent undefined behaviour.
//    if ( self.selected || self.isEditing )
//        return;
    
    CGPoint position = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.start = position;
            self.scrollViewOptionsView.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:SMMoreOptionsShouldHideNotification object:self];
        } break;
        case UIGestureRecognizerStateChanged: {
            self.scrollViewContentView.center = [self _scrollContentViewCenterForOffset:(self.start.x - position.x)];
        } break;
        case UIGestureRecognizerStateEnded: {
            CGFloat distance = self.start.x - position.x;
            CGFloat threshold = ceilf(_scrollViewOptionsWidth/2.0f);
            
            if ( _optionsFlags.optionsVisible == YES ) {
                if ( fabs(distance) >= threshold ) {
                    [UIView animateWithDuration:SMMoreOptionsAnimationDuration animations:^(void) {
                        self.scrollViewContentView.center = [self _scrollContentViewStartPoint];
                    } completion:^(BOOL finished) {
                        [self _optionsViewDidDisappear];
                    }];
                } else {
                    [UIView animateWithDuration:SMMoreOptionsAnimationDuration animations:^(void) {
                        self.scrollViewContentView.center = [self _scrollContentViewEndPoint];
                    }];
                }
            } else {
                if (  MAX(distance, 0.0f) >= threshold ) {
                    [UIView animateWithDuration:SMMoreOptionsAnimationDuration
                                          delay:0.0f
                         usingSpringWithDamping:0.8f
                          initialSpringVelocity:0.0f
                                        options:0
                                     animations:^(void) {
                                         self.scrollViewContentView.center = [self _scrollContentViewEndPoint];
                                     }
                                     completion:^(BOOL finished) {
                                         [self _optionsViewDidAppear];
                                     }];
                } else {
                    CGPoint center = [self _scrollContentViewStartPoint];
                    if ( CGPointEqualToPoint(center, self.scrollViewContentView.center) ) {
                        // In the case the pan gesture ended at the center point
                        self.scrollViewContentView.center = center;
                        [self _optionsViewDidDisappear];
                    } else {
                        [UIView animateWithDuration:SMMoreOptionsAnimationDuration animations:^(void) {
                            self.scrollViewContentView.center = center;
                        }];
                    }
                }
            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.scrollViewContentView.center = [self _scrollContentViewStartPoint];
        } break;
        default:
            break;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification Methods

- (void)_receivedHideNotification:(NSNotification *)ntf {
    if ( ntf.object == self )
        return;
    
    [self dismissOptionsAnimated:YES];
}

+ (CGFloat)cellHeight
{
    return cellHeight;
}

- (void)setCustomer:(Customer *)customer
{
    _customer = customer;
    NSString *custName = (customer.customerName == nil || [customer.customerName isEqualToString:@""]) ? @"(无)" : customer.customerName;
    [_customerNameBtn setTitle:custName forState:UIControlStateNormal];
    NSString *time = customer.ticketTime;
    NSMutableString *mutableTime = [NSMutableString stringWithString:time];
    if ([mutableTime length] >= 4) {
        [mutableTime insertString:@":" atIndex:2];
        [mutableTime insertString:@":" atIndex:5];
    }
    [_ticketTimeBtn setTitle:mutableTime forState:UIControlStateNormal];
    _ticketNoLb.text = customer.ticketNo;
    _busTypeLb.text = customer.busType;
    NSString *status = customer.ticketStatus;
    NSString *stas = [_ticketStatusDic valueForKey:status];
    _statusLb.text = ([stas isEqualToString:@""] || stas == nil) ? @"未知" : stas;
    _managerLb.text = ![customer.manager isEqualToString:@""] ? customer.manager : @"（无）";
    NSString *level = _customer.custLevel;
    if ([level rangeOfString:@"普通"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v1"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"金卡"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v2"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"钻石"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v3"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"白金"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v4"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"信用卡普通"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v5"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"信用卡钻石"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v6"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"信用卡白金"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v7"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"信用卡高端白金"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v8"] forState:UIControlStateNormal];
    } else if ([level rangeOfString:@"黑金"].location != NSNotFound) {
        [_custLevel setImage:[UIImage imageNamed:@"v9"] forState:UIControlStateNormal];
    }
    [_custLevel setTitle:_customer.custLevel forState:UIControlStateNormal];
    _gapLb.text = customer.gap;
    _unsignLb.text = customer.unsignNum;
}

- (void)setHasCare:(BOOL)hasCare
{
    _hasCare = hasCare;
    
    _ticketTimeBtn.userInteractionEnabled = _hasCare;
    _ticketTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
    if (_hasCare) {
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 31, 0, 0);
        [_ticketTimeBtn setImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
    } else {
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 31, 0, 0);
    }
}

- (void)setIsBirthday:(BOOL)isBirthday
{
    _isBirthday = isBirthday;
    
    
    if (isBirthday) {//如果今天生日，显示生日图标
        _icon.hidden = NO;
        _customerNameBtn.userInteractionEnabled = NO;
        _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_customerNameBtn setImage:[UIImage imageNamed:@"cake"] forState:UIControlStateNormal];
    } else {//如果今天非生日 则判断当前用户是否含有图片
        if (_hasPhoto) {//有图片显示图片标识
            _icon.hidden = NO;
            _customerNameBtn.userInteractionEnabled = YES;
            _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
            _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            [_customerNameBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        } else {//两者图片都没有，隐藏图片和生日标识
            _icon.hidden = YES;
            _customerNameBtn.userInteractionEnabled = NO;
            _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
            _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 31, 0, 0);
        }
    }
}

- (void)setHasPhoto:(BOOL)hasPhoto
{
    _hasPhoto = hasPhoto;
    
    //如果有图片，则显示图片标识
    if (hasPhoto) {
        _icon.hidden = NO;
        _customerNameBtn.userInteractionEnabled = YES;
        _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_customerNameBtn setImage:[UIImage imageNamed:@"cake"] forState:UIControlStateNormal];
        [_customerNameBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    } else {//如果没有图片，则隐藏
        _icon.hidden = YES;
        _customerNameBtn.userInteractionEnabled = NO;
        _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 31, 0, 0);
    }
    if (_isBirthday) {//判断是否是今天生日，如果是，则显示生日标识
        _icon.hidden = NO;
        _customerNameBtn.userInteractionEnabled = NO;
        _customerNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//Button的文字做对已
        _customerNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _customerNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_customerNameBtn setImage:[UIImage imageNamed:@"cake"] forState:UIControlStateNormal];
        [_customerNameBtn setImage:[UIImage imageNamed:@"cake"] forState:UIControlStateNormal];
    }
}

- (void)setChangedBackgroundColor:(BOOL)changedBackgroundColor
{
    _changedBackgroundColor = changedBackgroundColor;
    if (changedBackgroundColor) {
        [_customerNameBtn setTitleColor:RGB(200, 200, 200, 1.0) forState:UIControlStateHighlighted];
        [_ticketTimeBtn setTitleColor:RGB(200, 200, 200, 1.0) forState:UIControlStateHighlighted];
        _ticketNoLb.textColor = RGB(200, 200, 200, 1.0);
        _busTypeLb.textColor = RGB(200, 200, 200, 1.0);
        _statusLb.textColor = RGB(200, 200, 200, 1.0);
        _managerLb.textColor = RGB(200, 200, 200, 1.0);
        _gapLb.textColor = RGB(200, 200, 200, 1.0);
        [_custLevel setTitleColor:RGB(200, 200, 200, 1.0) forState:UIControlStateHighlighted];
        _unsignLb.textColor = RGB(200, 200, 200, 1.0);
        self.backgroundColor = RGB(159, 172, 188, 1.0);
    } else {
        [_customerNameBtn setTitleColor:RGB(97, 97, 97, 1.0) forState:UIControlStateNormal];
        [_ticketTimeBtn setTitleColor:RGB(97, 97, 97, 1.0) forState:UIControlStateNormal];
        _ticketNoLb.textColor = RGB(97, 97, 97, 1.0);
        _busTypeLb.textColor = RGB(97, 97, 97, 1.0);
        _statusLb.textColor = RGB(97, 97, 97, 1.0);
        _managerLb.textColor = RGB(97, 97, 97, 1.0);
        _gapLb.textColor = RGB(97, 97, 97, 1.0);
        [_custLevel setTitleColor:RGB(97, 97, 97, 1.0) forState:UIControlStateNormal];
        _unsignLb.textColor = RGB(97, 97, 97, 1.0);
        self.backgroundColor = RGB(247, 247, 247, 1.0);
    }
}

- (void)care:(UIButton *)sender
{
    if (_careProducts) {
        _careProducts(sender, _customer.care);
    }
}

- (void)downloadImageFromServer
{
    PhotoDisplayView *view = [[PhotoDisplayView alloc] init];
    [[CustomIndicatorView sharedView] showInView:view];
    [[CustomIndicatorView sharedView] startAnimating];
    [view displayPhotoHandle:^(PhotoDisplayView *view) {
//        1.查询本地是否存在图片 通过身份证号码查找
//        1.1 本地有图片 加载本地图片
//        1.2 本地没有图片 去服务器下载图片 以身份证号码作为名称保存到本地 确保其唯一性
                view.message = _customer.customerName;
                NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *imageString = [NSString stringWithFormat:@"Png%@%@.png", _customer.ticketTime, _customer.ticketNo];
                NSString *filePath = [homePath stringByAppendingPathComponent:imageString];
                NSFileManager *manager = [NSFileManager defaultManager];
                if ([manager fileExistsAtPath:filePath]) {
                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    view.icon = [UIImage imageWithData:data];
                    [[CustomIndicatorView sharedView] stopAnimating];
                } else {
                    NSDictionary *paramDic = @{@"branch":[CommonUtils sharedInstance].currentBranch.branchNo, @"queue_num":_customer.ticketNo};
                    [FileManager downloadImage:@"ibpimg" withParameter:paramDic onSuccess:^(NSDictionary *responseHeader, NSData *responseBody) {
                        if (responseBody && responseBody.bytes > 0) {
                            [responseBody writeToFile:filePath atomically:YES];
                            UIImage *image = [UIImage imageWithData:responseBody];
                            [view performSelectorOnMainThread:@selector(setIcon:) withObject:image waitUntilDone:YES];
                            [[CustomIndicatorView sharedView] stopAnimating];
                        }
                    } onFailure:^(NSString *responseCode, NSString *responseInfo) {
                        [self showMessage:@"图片下载失败"];
                        [[CustomIndicatorView sharedView] stopAnimating];
                    }];
                }
    }];
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SMMoreOptionsCellGestureDelegate

- (instancetype)initWithCell:(UITableViewCell *)cell {
    if (self = [super init]) {
        self.cell = cell;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gesture {
    // The cell only reacts on horizontal gestures, otherwise the table will block
    CGPoint translation = [gesture translationInView:self.cell.superview];
    return (fabs(translation.x) > fabs(translation.y));
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIImage (SMMoreOptionsCell)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
