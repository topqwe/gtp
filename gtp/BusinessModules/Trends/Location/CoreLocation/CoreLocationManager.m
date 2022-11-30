//
//  CoreLocationManager.m
//  TestDemo
//
//  Created by WIQChen on 16/3/2.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "CoreLocationManager.h"

@implementation CoreLocationManager
+ (CoreLocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.longitude = [GetUserDefaultWithKey(CLLongitude) floatValue];
        self.latitude = [GetUserDefaultWithKey(CLLatitude) floatValue];
        self.lastCoordinate = CLLocationCoordinate2DMake(self.longitude,self.latitude);
        self.lastCity = GetUserDefaultWithKey(CLCity);
        self.lastAddress= GetUserDefaultWithKey(CLAddress);
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locationBlock error:(LocationErrorBlock) errorBlock
{
    self.locationBlock = [locationBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}
- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock
{
    self.addressBlock = [addressBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}
- (void) getLocationCoordinate:(LocationBlock) locationBlock  withAddress:(NSStringBlock) addressBlock error:(LocationErrorBlock) errorBlock
{
    self.locationBlock = [locationBlock copy];
    self.addressBlock = [addressBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}



- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        //定位功能开启的情况下进行定位
        self.locationManager = [[CLLocationManager alloc] init];
//            self.locationManager.distanceFilter = kCLDistanceFilterNone;
//            ///精度设置
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [SVProgressHUD showErrorWithStatus:@"定位服务当前可能尚未打开，请设置打开！"];
    }
    
    [self performSelector:@selector(closeSVProgressHUD) withObject:self afterDelay:5.0f];
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusDenied) {
        [SVProgressHUD showErrorWithStatus:@"您已拒绝系统定位服务，请设置打开！"];
        
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
//        self.locationManager.distanceFilter = kCLDistanceFilterNone;
//        ///精度设置
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
//        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;

        self.locationManager.delegate = self;
        //开启位置更新
        [self.locationManager startUpdatingLocation];
        [SVProgressHUD showWithStatus:@"正在定位中" maskType:SVProgressHUDMaskTypeBlack];
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization]; // 永久授权
        }
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization]; //使用中授权
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count <= 0) {
        return;
    }
    
    [_locationManager stopUpdatingLocation];
    
    CLLocation * newLocation = [locations objectAtIndex:0];
    self.lastCoordinate = newLocation.coordinate;
    
    
    SetUserDefaultKeyWithObject(CLLongitude, @(self.lastCoordinate.longitude));
    SetUserDefaultKeyWithObject(CLLatitude, @(self.lastCoordinate.latitude));

    WS(weakSelf);
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
//        for (CLPlacemark * placeMark in placemarks) {
//            NSDictionary *addressDic=placeMark.addressDictionary;
//            
//            NSString *state=[addressDic objectForKey:@"State"];
//            NSString *city=[addressDic objectForKey:@"City"];
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//            NSString *street=[addressDic objectForKey:@"Street"];
//            
//            self.lastCity = city;
//            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
//            
//            SetUserDefaultKeyWithObject(CLCity, self.lastCity);
//            SetUserDefaultKeyWithObject(CLAddress, self.lastAddress);
//
//        }
        if (placemarks.count >0)
        {
            CLPlacemark * plmark = [placemarks objectAtIndex:0];
            
            self.lastCity = plmark.locality;
            self.lastAddress=[NSString stringWithFormat:@"%@",plmark.name];
            
            SetUserDefaultKeyWithObject(CLCity, self.lastCity);
            SetUserDefaultKeyWithObject(CLAddress, self.lastAddress);
        }
        
        //避免不回调不关闭提示框
        
        
        if (weakSelf.locationBlock) {
            weakSelf.locationBlock(weakSelf.lastCoordinate);
            weakSelf.locationBlock = nil;
        }
        
        if (weakSelf.cityBlock) {
            weakSelf.cityBlock(weakSelf.lastCity);
            weakSelf.cityBlock = nil;
        }
        
        if (weakSelf.addressBlock) {
            weakSelf.addressBlock(weakSelf.lastAddress);
            weakSelf.addressBlock = nil;
        }
    };
    UserDefaultSynchronize;
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];

}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    
    [manager stopUpdatingLocation];
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation * newLocation = userLocation.location;
    self.lastCoordinate=mapView.userLocation.location.coordinate;
    
    SetUserDefaultKeyWithObject(CLLongitude, @(self.lastCoordinate.longitude));
    SetUserDefaultKeyWithObject(CLLatitude, @(self.lastCoordinate.latitude));
    WS(weakSelf);
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
//        for (CLPlacemark * placeMark in placemarks)
//        {
//            NSDictionary *addressDic= placeMark.addressDictionary;
        
//        NSString *state= addressDic objectForKey:@"State"];
//        NSString *city=[addressDic objectForKey:@"City"];
//        NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//        NSString *street=[addressDic objectForKey:@"Street"];
        
        //ios 11.0以后以此对应上面的
        CLPlacemark * addressDic =  placemarks[0];
        NSString *state= addressDic.administrativeArea;
        NSString *city = addressDic.subAdministrativeArea;
        NSString *subLocality= addressDic.subLocality;
        NSString *street= addressDic.thoroughfare;
            
            self.lastCity = city;
            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            SetUserDefaultKeyWithObject(CLCity, self.lastCity);
            SetUserDefaultKeyWithObject(CLAddress, self.lastAddress);
            
            [self stopUpdatingLocationForBelowiOS8];
            
            //避免不回调不关闭提示框
            
            
            if (weakSelf.locationBlock) {
                weakSelf.locationBlock(weakSelf.lastCoordinate);
                weakSelf.locationBlock = nil;
            }
            
            if (weakSelf.cityBlock) {
                weakSelf.cityBlock(weakSelf.lastCity);
                weakSelf.cityBlock = nil;
            }
            
            
            if (weakSelf.addressBlock) {
                weakSelf.addressBlock(weakSelf.lastAddress);
                weakSelf.addressBlock = nil;
            }
//        }
    };
    UserDefaultSynchronize;
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}
-(void)stopUpdatingLocationForBelowiOS8
{
    _mapView.showsUserLocation = NO;
    _mapView = nil;
}
-(void)closeSVProgressHUD
{
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    [self stopUpdatingLocationForBelowiOS8];
}


@end


