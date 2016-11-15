//
//  GJLocation.m
//
//
//  Created by Yangchao on 15/7/14.
//  Copyright (c) 2015年 Yangchao. All rights reserved.
//

#import "GJLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GJLocation ()<CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@end

@implementation GJLocation

+(instancetype)sharedInstance{
    static GJLocation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(instancetype)init{
    if(self = [super init]){
        _province = @"四川省";
        _area = @"成都市";
        _latitude=@"";
        _longitude=@"";
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
    }
    return self;
}

#pragma mark 根据地名确定地理坐标
-(void)getAddress:(NSString *)address{
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil)
            {
            CLPlacemark *firstPlacemark = [placemarks firstObject];
            CLLocation *location=firstPlacemark.location;//位置
            
            _longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            _latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            NSLog(@"Longitude = %@",_longitude);
            NSLog(@"Latitude = %@",_latitude);
            }
        else if ([placemarks count] == 0 && error == nil)
            {
            
            }
        else if (error != nil)
            {
            
            }
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    _geocoder = [[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSString *location = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"Name"]];
        NSLog(@"地址信息:%@",location);
    }];
}

-(void)startLocation{
    [self requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"定位服务已关闭" : @"后台定位功能未开启";
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:@"您需要在\"隐私\">\"定位服务\"中将安e帮设置为\"始终\"才能正常使用软件功能。"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"设置", nil];
//        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
}

//#pragma mark - alertView delegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        // Send the user to the Settings for this app
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        }
//        else
//        {
//            [SVProgressHUD showSuccessWithStatus:@"请手动到设置里面去设置" duration:1.5f];
//        }
//    }
//}

//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//            {
//                [_locationManager requestAlwaysAuthorization];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
//}

// NSString *name; // eg. Apple Inc.
// NSString *thoroughfare; // street address, eg. 1 Infinite Loop
// NSString *subThoroughfare; // eg. 1
// NSString *locality; // city, eg. Cupertino
// NSString *subLocality; // neighborhood, common name, eg. Mission District
// NSString *administrativeArea; // state, eg. CA
// NSString *subAdministrativeArea; // county, eg. Santa Clara
// NSString *postalCode; // zip code, eg. 95014
// NSString *ISOcountryCode; // eg. US
// NSString *country; // eg. United States
// NSString *inlandWater; // eg. Lake Tahoe
// NSString *ocean; // eg. Pacific Ocean
// NSArray *areasOfInterest; // eg. Golden Gate Par

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    CLLocation *YClocation = [location locationMarsFromEarth];
    _longitude = [NSString stringWithFormat:@"%f", YClocation.coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f", YClocation.coordinate.latitude];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AchieveLocationNotification" object:nil];
    _geocoder = [[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:YClocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"location info %@", placemark.name);
        NSString *tempString = placemark.locality;
        _province = [tempString stringByReplacingOccurrencesOfString:@"市辖区" withString:@""];
        _area = placemark.subLocality;
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [_locationManager stopUpdatingLocation];
}

@end
