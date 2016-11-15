//
//  TimeTableViewCell.h
//  Lobby
//
//  Created by CIB-MacMini on 16/4/1.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *leftNameLable;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIImageView *selectImage;
@end
