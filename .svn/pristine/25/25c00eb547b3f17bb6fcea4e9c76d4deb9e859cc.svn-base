//
//  BadPostController.h
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/17.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBaseViewController.h"

@interface BadPostController : DetailBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *leftDateLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *leftWeekLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftCalendatBtn;
@property (strong, nonatomic) IBOutlet UILabel *rightDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightWeekLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightCalendarBtn;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UIButton *stateChoiceBtn;
@property (strong, nonatomic) NSMutableArray *commentArr;
- (IBAction)stateChoice:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *check;

@property (strong, nonatomic) IBOutlet UIView *stateView;

- (IBAction)checkAction:(id)sender;

- (IBAction)startDateAction:(id)sender;
- (IBAction)endDateAction:(id)sender;


- (IBAction)leftDateChoiceBtn:(id)sender;

- (IBAction)rightDateChoiceBtn:(id)sender;
@end
