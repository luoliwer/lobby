//
//  CustCollectionCell.m
//  SmartHall
//
//  Created by cibdev-macmini-1 on 16/3/22.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "CustCollectionCell.h"
#import "Queue.h"

@interface CustCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *queueName;
@property (weak, nonatomic) IBOutlet UILabel *waitManLb;
@property (weak, nonatomic) IBOutlet UILabel *waitMan;
@property (weak, nonatomic) IBOutlet UILabel *waitTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *waitTime;

@end

@implementation CustCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        
        self.backgroundColor = RGB(51, 162, 239, 1.0);
        _queueName.textColor = RGB(224, 238, 242, 1.0);
        _waitManLb.textColor = [UIColor whiteColor];
        _waitMan.textColor = [UIColor whiteColor];
        _waitTimeLb.textColor = [UIColor whiteColor];
        _waitTime.textColor = [UIColor whiteColor];
        
    } else {
        
        self.backgroundColor = RGB(192, 228, 255, 1.0);
        _queueName.textColor = RGB(64, 117, 156, 1.0);
        _waitMan.textColor = RGB(0, 78, 123, 1.0);
        _waitManLb.textColor = RGB(121, 164, 196, 1.0);
        _waitTime.textColor = RGB(0, 78, 123, 1.0);
        _waitTimeLb.textColor = RGB(121, 164, 196, 1.0);
    }
    
    if ([_queue.queueNum intValue] >= 10) {
        _waitMan.textColor = UIColorFromRGB(0xffb05a);
    }
    
    if ([_queue.waitTime intValue] >= 30) {
        _waitTime.textColor = UIColorFromRGB(0xffb05a);
    }
}

- (void)setQueue:(Queue *)queue
{
    _queue = queue;
    
    _queueName.text = _queue.queueName;
    _waitMan.text = _queue.queueNum;
    _waitTime.text = _queue.waitTime;
    
    if ([_queue.queueNum intValue] >= 10) {
        _waitMan.textColor = [UIColor redColor];
    }
    
    if ([_queue.waitTime intValue] >= 30) {
        _waitTime.textColor = [UIColor redColor];
    }
}

@end
