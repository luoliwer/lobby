//
//  RemindCollectCell.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/24.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "RemindCollectCell.h"
#import "Expiration.h"

@interface RemindCollectCell ()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *remindType;
@property (weak, nonatomic) IBOutlet UITextView *remindDes;

@end

@implementation RemindCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setExpiration:(Expiration *)expiration
{
    _expiration = expiration;
    
    NSInteger statusVal = [expiration.expirationStatus integerValue];
//  更新视图图片
    if (statusVal == RemindStatusTurn) {//转化为商机
        _status.text = @"转化为商机";
        _statusView.backgroundColor = RGB(35, 155, 66, 1.0);
        _image.image = [UIImage imageNamed:@"turn"];
    } else if (statusVal == RemindStatusUndo) {//未处理
        _status.text = @"未处理";
        _statusView.backgroundColor = RGB(254, 145, 66, 1.0);
        _image.image = [UIImage imageNamed:@"undo"];
    } else if (statusVal == RemindStatusDoing) {//处理中
        _status.text = @"处理中";
        _statusView.backgroundColor = RGB(0, 134, 182, 1.0);
        _image.image = [UIImage imageNamed:@"doing"];
    } else if (statusVal == RemindStatusClose) {//已关闭
        _status.text = @"已关闭";
        _statusView.backgroundColor = RGB(90, 90, 90, 1.0);
        _image.image = [UIImage imageNamed:@"close"];
    } else if (statusVal == RemindStatusFinished) {//已完成
        _status.text = @"已完成";
        _statusView.backgroundColor = RGB(0, 0, 0, 1.0);
        _image.image = [UIImage imageNamed:@"ic_Teller_handle"];
    }
    _remindType.text = expiration.expirationName;
    _remindDes.text = expiration.expirationContent;
}

@end
