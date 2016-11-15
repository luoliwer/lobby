//
//  LoginView.h
//  SmartHall
//
//  Created by YangChao on 21/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYKeyboard.h"

@protocol LoginProtocol <NSObject>

@required
- (void)loginWithUser:(UITextField *)userF password:(UITextField *)pwdF;
- (void)helpToInformation;
@end

@interface LoginView : UIView

{
    NSMutableArray*dataArray;
    HYKeyboard*keyboard;
    NSArray*contents;
    NSString*inputText;
    NSInteger tag;
    BOOL usesafeKeyboard;
}

@property (nonatomic, weak) id<LoginProtocol> delegate;

@end
