//
//  HistoryUserCell.m
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/6/20.
//  Copyright © 2016年 swy. All rights reserved.
//

#import "HistoryUserCell.h"

@implementation HistoryUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)del:(UIButton *)sender
{
    _DeleteHistoryUser(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        self.alpha = 1;
        self.backgroundColor = UIColorFromRGB(0x001429);
    } else {
        self.alpha = 0.9;
        self.backgroundColor = UIColorFromRGB(0x001429);
    }
}

@end
