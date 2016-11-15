//
//  RegisterView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/3/30.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Customer;

@interface RegisterView : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSArray *_sectionArray;
    NSMutableDictionary *_showDic; // 用来判断分组展开与收缩
    NSArray *business_countArray; // 交易金额
    NSArray *transfer_roleArray; // 转介角色
    NSMutableArray *transfer_windowArray; // 转介接受窗口
    NSMutableArray *transfer_busitypeArray; // 转介业务类别
    NSArray *jiaohao_celArray; // 叫号策略
    
    NSMutableArray *_stationsArray; //工位数据
    NSMutableArray *_refbArray; //转介业务数据
}


@property (strong, nonatomic) IBOutlet UITextField *customerField;
@property (strong, nonatomic) IBOutlet UILabel *queueNum;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIView *separatorLine1;
@property (strong, nonatomic) IBOutlet UIView *separatorLine2;
@property (strong, nonatomic) UITableView *registerTable;
@property (strong, nonatomic) Customer *customerModel;

- (IBAction)sure:(id)sender;
- (IBAction)cancel:(id)sender;

@end
