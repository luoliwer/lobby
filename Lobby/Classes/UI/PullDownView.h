//
//  PullDownView.h
//  Lobby
//
//  Created by cibdev-macmini-1 on 16/4/11.
//  Copyright © 2016年 swy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PullDownViewTypeBusiness,
    PullDownViewTypeStation,
} PullDownViewType;

@interface PullDownView : UIView

@property (nonatomic, assign) BOOL show;//Default is NO

@property (nonatomic, assign) PullDownViewType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIImage *defaultImage;//正常状态

@property (nonatomic, strong) UIImage *selectedImage;//选中状态

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, readonly) id selectedValue;//选中的值

@property (nonatomic, strong) void (^layoutView)(PullDownView *pullView);//查看群信息事件

@end
