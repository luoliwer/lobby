//
//  PublicAppointmentView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/10/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicAppointmentView : UIView

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *agentNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *characterLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, strong) NSArray *pragrames;//接口参数

- (IBAction)close:(id)sender;
@end
