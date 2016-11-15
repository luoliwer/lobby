//
//  PhotoDisplayView.h
//  SmartHall
//
//  Created by YangChao on 30/10/15.
//  Copyright © 2015年 IndustrialBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoDisplayView;
typedef void  (^DisplayBlock)(PhotoDisplayView *photoView);

@interface PhotoDisplayView : UIView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UIImage *icon;

- (void)displayPhotoHandle:(DisplayBlock)display;

@end
