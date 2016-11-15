//
//  TransferController.h
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBaseViewController.h"


@interface TransferController : DetailBaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *receiveBtn;

@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) IBOutlet UIView *stateLine_L;

@property (strong, nonatomic) IBOutlet UIView *stateLine_R;

@property (strong, nonatomic) IBOutlet UIView *partingLine_1;

@property (strong, nonatomic) IBOutlet UIView *partingLine_2;

@property (strong, nonatomic)  UIView *partingLine_3;  // 分割线，手动添加

@property (strong, nonatomic) IBOutlet UILabel *weekLabel_L;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel_L;

@property (strong, nonatomic) IBOutlet UIButton *dateChoicebutton_L;

@property (strong, nonatomic) IBOutlet UILabel *weekLabel_R;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel_R;

@property (strong, nonatomic) IBOutlet UIButton *dateChoiceBtn_R;

@property (strong, nonatomic) IBOutlet UIButton *dealStateBtn;

@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UIView *mennuView;

@property (strong, nonatomic) IBOutlet UIView *stateView;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) NSMutableArray *transferArr;

@property (strong, nonatomic)  UITableView *tableView;
- (IBAction)checkBtn:(id)sender;

- (IBAction)stateChoice:(id)sender;
- (IBAction)receiveTransfer:(id)sender;
- (IBAction)sendTransfer:(id)sender;
- (IBAction)selectDateStart:(id)sender;
- (IBAction)selectDataEnd:(id)sender;

- (IBAction)leftBtn:(id)sender;
- (IBAction)rightBtn:(id)sender;

@end
