//
//  SettingView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/4/5.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobleData.h"

@interface SettingView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *rightLabel;
    UIImageView *hideImgView;
    NSInteger  indext;
    NSMutableDictionary *_showDic; // 用来判断分组展开与收缩
}
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentVersion;

@property (strong, nonatomic) IBOutlet UILabel *versionTip;

@property (strong, nonatomic) IBOutlet UIButton *updateBtn;

@property (strong, nonatomic) IBOutlet UILabel *isNewOrOldLabel;

@property (strong, nonatomic) IBOutlet UITableView *systemTableView;

@property (strong, nonatomic) IBOutlet UIControl *enterTapGuestureViewUIControl;
@property (copy, nonatomic) void(^lout)();

@property (strong, nonatomic) NSArray *deviceNameArr;
@property (strong, nonatomic) NSArray *timeChoiceArr;
@property (strong, nonatomic) NSArray *sectionArray;
@property (strong, nonatomic) UISwitch *switchBtn;

- (IBAction)clickUpdate:(id)sender;
@end
