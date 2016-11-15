//
//  PrivateAppointmentView.h
//  Lobby
//
//  Created by CIB-MacMini on 16/10/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateInfo;

@interface PrivateAppointmentView : UIView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *appointmentStatus_Label;

@property (strong, nonatomic) IBOutlet UITextView *remak_textview;

@property (strong, nonatomic) IBOutlet UILabel *leftbracket;

@property (strong, nonatomic) IBOutlet UILabel *rightbracket;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIButton *checkboxBtn;

@property (nonatomic, strong) NSArray *pragrames;//接口参数

@property (nonatomic, strong) DateInfo *date;

@property (nonatomic, strong) void (^UpdateDatesInTableView)(DateInfo *date);

- (IBAction)statuschange:(id)sender;

- (IBAction)sendmessage:(id)sender;

- (IBAction)sure:(id)sender;

- (IBAction)cancel:(id)sender;
@end
