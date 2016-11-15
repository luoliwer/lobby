//
//  TransferNotificationView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/3/30.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferCheck.h"

@interface TransferNotificationView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *transferTable;

@property (strong, nonatomic) IBOutlet UIButton *scanBtn;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) NSString *customerName; // 用户姓名

@property (strong, nonatomic) NSString *busiType; // 业务类别

@property (strong, nonatomic) NSString *sendDate; // 发起日期

@property (strong, nonatomic) NSString *sendTime; // 发起时间

@property (strong, nonatomic) NSString *clueId; // 信息唯一标识

@property (strong, nonatomic) TransferCheck *dataModel; // 记录收到的数据

- (IBAction)scanTheDetail:(id)sender;

- (IBAction)cancel:(id)sender;

@end
