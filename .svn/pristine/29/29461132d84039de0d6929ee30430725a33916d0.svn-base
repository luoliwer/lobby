//
//  CustomerCell.h
//  SmartHall
//
//  Created by YangChao on 26/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Customer;
@protocol SMMoreOptionsDelegate;

@interface CustomerCell : UITableViewCell

@property (nonatomic, strong) UIView *scrollViewContentView;  // This content view is above the more options view.

// This scrollViewOptionsView contains per default the following 2 buttons, feel free to set your own options view. In
// the case you set your own custom scrollViewOptionsView, the -didTouchOnDelete: and -didTouchOnMore: are not called.
// The options view is always set to hidden if not visible through the scroll behaviour.
@property (nonatomic, strong) UIView *scrollViewOptionsView;
@property (nonatomic, strong) UIButton *turnToButton;
@property (nonatomic, strong) UIButton *transferButton;
@property (nonatomic, strong) UIButton *moveoutButton;
@property (nonatomic, assign) CGFloat scrollViewOptionsWidth;  // set width of the scrollViewOptionsView, default 150 px

@property (nonatomic, weak) id<SMMoreOptionsDelegate> delegate;

- (void)dismissOptionsAnimated:(BOOL)animated;  // in the case the options are visble the view will dismiss them

@property (strong, nonatomic) Customer *customer;
@property (assign, nonatomic) BOOL hasPhoto;//当前客户是否已经设置头像
@property (assign, nonatomic) BOOL isBirthday;//是否为客户生日
@property (assign, nonatomic) BOOL hasCare;//是否有关注产品
@property (assign, nonatomic) BOOL changedBackgroundColor;

@property (nonatomic, strong) void (^careProducts)(id toucher, NSString *careInfo);

+ (CGFloat)cellHeight;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol SMMoreOptionsDelegate <NSObject>
@required
- (void)didTouchOnTurnTo:(CustomerCell *)cell;
- (void)didTouchOnTransfer:(CustomerCell *)cell;
- (void)didTouchOnMoveOut:(CustomerCell *)cell;

@optional
- (void)cellDidHideOptions:(CustomerCell *)cell;
- (void)cellDidShowOptions:(CustomerCell *)cell;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIImage (CustomerCell)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern const CGFloat SMMoreOptionsDefaultContentWidth;
extern NSString * const SMMoreOptionsShouldHideNotification; // post this notification to hide currently visible options
