//
//  TransferNotificationView.m
//  Lobby
//
//  Created by CIB-MacMini on 16/3/30.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "TransferNotificationView.h"
#import "transferHanleTableViewCell.h"
#import "transferHandle.h"
#import "CommonAlertView.h"


@implementation TransferNotificationView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self invokeDatafromNet];
    self.transferTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 450, 150) style:UITableViewStylePlain];
    self.transferTable.dataSource = self;
    self.transferTable.delegate = self;
    self.transferTable.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.transferTable];
    
}

#pragma UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
// 使分割线顶到最左边
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"transferHanleTableViewCell" owner:nil options:nil].lastObject;
        transferHanleTableViewCell *transferHandleCell = (transferHanleTableViewCell *)cell;
        transferHandleCell.headImg.hidden = YES;
        if (indexPath.row != 2) {
            transferHandleCell.dateLabel.hidden = YES;
        }
        switch (indexPath.row) {
            case 0:{
                transferHandleCell.nameLabel.text = @"客户姓名";
                transferHandleCell.rightNameLabel.text = self.customerName;
            }
                break;
            case 1:{
                transferHandleCell.nameLabel.text = @"业务类别";
                transferHandleCell.rightNameLabel.text = @"理财产品";
            }
                break;
            case 2:{
                transferHandleCell.nameLabel.text = @"发起时间";
                transferHandleCell.dateLabel.text = self.sendDate;
                transferHandleCell.rightNameLabel.text = self.sendTime;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark 调用网络接口，请求数据
- (void)invokeDatafromNet{
    NSString *userid = COM_INSTANCE.userid;
    NSString *referra = @"2";
    NSString *marketing = @"5";
    NSString *begin = self.sendDate;
    NSString *end = self.sendDate;
    NSString *clu_id = self.clueId;
    NSDictionary *paragramDic = @{@"begin_date":begin,
                                  @"end_date":end,
                                  @"userid":userid,
                                  @"referralflag":referra,
                                  @"marketingstatus":marketing,
                                  @"currentpage":@"1",
                                  @"clueid_tag":clu_id
                                  };
    void(^failure)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo) {
        NSString *alertInfo = [NSString stringWithFormat:@"错误%@， 网络连接错误", responseCode];
        [self showMessage:alertInfo];
    };
    void(^success)(NSString *, NSString *) = ^(NSString *responseCode, NSString *responseInfo){
        if ([responseCode isEqualToString:@"I00"])
        {
            NSString *resultCode = [responseInfo valueForKey:@"resultCode"];
            NSDictionary *result = [responseInfo valueForKey:@"result"];
            if (![resultCode isEqualToString:@"0"]) {
                if ([result isKindOfClass:[NSString class]]) {
                    [self showMessage:(NSString *)result];
                }
            }else{
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSArray *monitorInfoGroup = [result objectForKey:@"referralInfoGroup"];
                    NSString *totalpage = [result objectForKey:@"totalpage"];
                    if ([totalpage isEqualToString:@"0"]) {
                        return;
                    }
                    if (monitorInfoGroup.count > 0 )
                    {
                        for (NSDictionary *dic in monitorInfoGroup) {
                            TransferCheck *customer = [[TransferCheck alloc] init];
                            customer.busi_amount = [dic objectForKey:@"busi_amount"];
                            customer.clue_date = [dic objectForKey:@"clue_date"];
                            customer.clue_id = [dic objectForKey:@"clue_id"];
                            customer.clue_time = [dic objectForKey:@"clue_time"];
                            customer.allTime = [NSString stringWithFormat:@"%@ %@",customer.clue_date,customer.clue_time];
                            customer.cluesource = [dic objectForKey:@"cluesource"];
                            customer.cluetype = [dic objectForKey:@"cluetype"];
                            customer.custinfo_name = [dic objectForKey:@"custinfo_name"];
                            customer.lastusercode = [dic objectForKey:@"lastusercode"];
                            customer.marketingstatus = [dic objectForKey:@"marketingstatus"];
                            customer.operateuser = [dic objectForKey:@"operateuser"];
                            customer.operateuser_name = [dic objectForKey:@"operateuser_name"];
                            customer.queue_num = [dic objectForKey:@"queue_num"];
                            customer.referral_bs_id = [dic objectForKey:@"referral_bs_id"];
                            customer.referral_bs_name = [dic objectForKey:@"referral_bs_name"];
                            customer.referraluser = [dic objectForKey:@"referraluser"];
                            customer.referraluser_name = [dic objectForKey:@"referraluser_name"];
                            customer.remark = [dic objectForKey:@"remark"];
                            customer.remark1 = [dic objectForKey:@"remark1"];
                            self.dataModel = customer;
                        }
                    }
                }
            }
        }else{
            [self showMessage:@"出错啦！"];
        }
    };
    [InvokeManager invokeApi:@"ibpzjck" withMethod:@"POST" andParameter:paragramDic onSuccess:success onFailure:failure];
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
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

- (IBAction)scanTheDetail:(id)sender {
    
    self.superview.hidden = YES;
    transferHandle *view = (transferHandle *)[[[NSBundle mainBundle] loadNibNamed:@"transferHandle" owner:nil options:nil] firstObject];
    view.checkModel = self.dataModel;
    CommonAlertView *baseView = [[CommonAlertView alloc] init];
//    baseView.backAlpah = 0.4;
    baseView.isAutoClose = YES;
    baseView.view = view;
    [baseView show];
    
}

- (IBAction)cancel:(id)sender {
    [self.superview removeFromSuperview];
}
@end
