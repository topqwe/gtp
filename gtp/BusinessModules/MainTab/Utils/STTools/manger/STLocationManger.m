//
//  STLocationManger.m
//  KunLun
//
//  Created by Mac on 2017/11/29.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STLocationManger.h"
#define STLast_location @"STLast_location"
@interface STLocationManger()<CLLocationManagerDelegate>
@property(nonatomic,strong) CLLocationManager               *locationManger;
@property(nonatomic,copy) STLocationMangerDidLocation       handle;
@end

@implementation STLocationManger
+ (STLocationManger *)defult{
    static STLocationManger * defult = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defult = [STLocationManger new];
    });
    return defult;
}
- (CLLocationManager *)locationManger{
    if (!_locationManger) {
        _locationManger = [CLLocationManager new];
        _locationManger.delegate = self;
        _locationManger.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManger.distanceFilter = 100.0f;
    }
    return _locationManger;
}
- (NSDictionary *)lastPlacemark{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:STLast_location];
    if (!dic) {
        NSLog(@"您未调用updatePlacemarkWith，没有储存地址");
    }
    return dic;
}
- (NSString *)lastProvence{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:STLast_location];
    if (!dic) {
        NSLog(@"您未调用updatePlacemarkWith，没有储存地址");
    }
    return dic[@"administrativeArea"];
}
- (NSString *)lastCity{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:STLast_location];
    if (!dic) {
        NSLog(@"您未调用updatePlacemarkWith，没有储存地址");
    }
    return dic[@"locality"];
}
- (NSString *)lastSubLocality{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:STLast_location];
    if (!dic) {
        NSLog(@"您未调用updatePlacemarkWith，没有储存地址");
    }
    return dic[@"subLocality"];
}
- (void)updatePlacemarkWith:(CLPlacemark *)lastPalcemark{
    if (lastPalcemark &&
        lastPalcemark.locality.length &&
        lastPalcemark.subLocality.length) {
        NSString * administrativeArea = lastPalcemark.administrativeArea;
        administrativeArea = administrativeArea.length?administrativeArea:@"";
        //如果是直辖市，那么省为空，接口province字段传@“”，可以获取到数据
        NSDictionary *dic = @{@"administrativeArea":administrativeArea,
                              @"locality":lastPalcemark.locality,
                              @"subLocality":lastPalcemark.subLocality};
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:STLast_location];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:STLast_location];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)dealAuthorization{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManger startUpdatingLocation];
    } else{
        [self dealErrorAuthorization];
    }
}
- (void)dealErrorAuthorization{
    CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted) {
        NSString * desc = @"定位：定位服务授权状态是受限制的";
        STError * error = [[STError alloc] initWithCode:22222 andDesc:desc];
        NSLog(@"status = kCLAuthorizationStatusRestricted%@",error.desc);
        if (self.handle) {
            self.handle(error, nil);
        }
    }else if (status == kCLAuthorizationStatusDenied) {
        NSString * desc = @"定位：定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭";
        STError * error = [[STError alloc] initWithCode:22222 andDesc:desc];
        NSLog(@"status = kCLAuthorizationStatusDenied %@",desc);
        if (self.handle) {
            self.handle(error, nil);
        }
    }
}
/**
 开始定位，未获取权限则请求权限
 
 @param handel handel description
 */
- (void)startUpdatingLocationHande:(STLocationMangerDidLocation)handel{
    [self setHandle:handel];
    CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"定位：用户还未做出选择");
        //开始请求权限
        [self.locationManger requestWhenInUseAuthorization];
    }else{
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManger startUpdatingLocation];
        }else{
            [self dealErrorAuthorization];
        }
    }
}
#pragma mark --CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self dealAuthorization];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            self.currentPlacemark = place;
            if (self.handle) {
                NSLog(@"经度：%f,纬度：%f", oldCoordinate.longitude, oldCoordinate.latitude);
                self.handle(nil,place);
                //方法多次调用，防止多次回调
                [self setHandle:nil];
            }
            //            NSLog(@"name,%@",place.name);                      // 位置名
            //            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            //            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            //            NSLog(@"locality,%@",place.locality);              // 市
            //            NSLog(@"subLocality,%@",place.subLocality);        // 区
            //            NSLog(@"country,%@",place.country);                // 国家
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(nonnull CLBeaconRegion *)region withError:(nonnull NSError *)error{
    if (manager == self.locationManger && error) {
        NSString * desc = error.description;
        STError * stError = [[STError alloc] initWithCode:22222 andDesc:desc];
        if (self.handle) {
            self.handle(stError,nil);
        }
    }
}


@end
