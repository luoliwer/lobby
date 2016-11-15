//
//  TransferCellTableViewCell.h
//  Lobby
//
//  Created by CIB-MacMini on 16/3/28.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *stateImage;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UILabel *productnameLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) NSInteger index;

@end
