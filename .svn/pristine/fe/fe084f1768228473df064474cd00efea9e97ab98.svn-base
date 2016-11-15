//
//  GJLocation.h
//  
//
//  Created by Yangchao on 15/7/14.
//  Copyright (c) 2015年 Yangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLocation+YCLocation.h"

@interface GJLocation : NSObject

+ (instancetype)sharedInstance;

- (void)getAddress:(NSString *)address;
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void)startLocation;

@property (strong, nonatomic) NSString *province;//省份名称
@property (strong, nonatomic) NSString *area;//地区名称

@property (strong, nonatomic) NSString *longitude;//经度
@property (strong, nonatomic) NSString *latitude;//纬度

@end
