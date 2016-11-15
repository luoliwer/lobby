//
//  StationCollectionCell.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/3/30.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "StationCollectionCell.h"
#import "Station.h"

@interface StationCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *cicleView;
@property (weak, nonatomic) IBOutlet UILabel *stationNum;
@property (weak, nonatomic) IBOutlet UILabel *stationLb;
@property (weak, nonatomic) IBOutlet UILabel *stationer;
@property (weak, nonatomic) IBOutlet UILabel *stationStatus;
@property (weak, nonatomic) IBOutlet UILabel *customer;
@property (weak, nonatomic) IBOutlet UILabel *serverNum;
@property (weak, nonatomic) IBOutlet UILabel *avgTime;
@property (weak, nonatomic) IBOutlet UILabel *currentCustLb;

@end

@implementation StationCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _cicleView.layer.cornerRadius = 20;
    _cicleView.layer.borderColor = [RGB(101, 186, 244, 1.0) CGColor];
    _cicleView.layer.borderWidth = 2;
    
    _stationLb.layer.cornerRadius = 7.5;
    _stationLb.clipsToBounds = YES;
}

- (void)setStation:(Station *)station
{
    _station = station;
    
    _stationNum.text = _station.stationNo;
    _stationer.text = _station.tellerName;
    _customer.text = _station.currentCustName;
    _serverNum.text = _station.serverNum;
    NSString *avgT = (_station.duration && ![_station.duration isEqualToString:@""]) ? _station.duration : @"0";
    _avgTime.text = avgT ;
    
    NSString *status = @"";
    if ([station.serverStatus isEqualToString:@"2"]) {
        status = @"服务中";
        _cicleView.layer.borderColor = [RGB(101, 186, 244, 1.0) CGColor];
        _stationLb.backgroundColor = UIColorFromRGB(0x65baf4);
        _stationStatus.backgroundColor = UIColorFromRGB(0xe96200);
        _currentCustLb.hidden = NO;
        _customer.hidden = NO;
        _stationStatus.hidden = NO;
    } else if ([station.serverStatus isEqualToString:@"1"]) {
        status = @"空闲";
        _cicleView.layer.borderColor = [RGB(101, 186, 244, 1.0) CGColor];
        _stationLb.backgroundColor = UIColorFromRGB(0x65baf4);
        _stationStatus.backgroundColor = UIColorFromRGB(0x239b42);
        _currentCustLb.hidden = YES;
        _customer.hidden = YES;
        _stationStatus.hidden = NO;
    } else {
        status = @"离线";
        _cicleView.layer.borderColor = [UIColorFromRGB(0xb1b6ba) CGColor];
        _stationLb.backgroundColor = UIColorFromRGB(0xb1b6ba);
        _stationStatus.backgroundColor = UIColorFromRGB(0xb1b6ba);
        _currentCustLb.hidden = YES;
        _customer.hidden = YES;
        _stationStatus.hidden = YES;
    }
    _stationStatus.text = status;
}

@end
