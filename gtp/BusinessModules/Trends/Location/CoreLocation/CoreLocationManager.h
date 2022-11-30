//
//  CoreLocationManager.h
//  TestDemo
//
//  Created by WIQChen on 16/3/2.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define  CLLongitude @"lastLongitude"
#define  CLLatitude  @"lastLatitude"
#define  CLCity      @"lastCity"
#define  CLAddress   @"lastAddress"


typedef void (^LocationBlock)(CLLocationCoordinate2D locationCoordinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void (^NSStringBlock)(NSString *cityString);
typedef void (^NSStringBlock)(NSString *addressString);

@interface CoreLocationManager : NSObject<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;

///解决iOS8下的定位问题
@property (nonatomic,strong) MKMapView *mapView;
///解决iOS8上的定位问题
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) CLLocationCoordinate2D lastCoordinate;

@property (nonatomic,strong) NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;

@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;




+ (CoreLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locationBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locationBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取坐标和地址
 *
 *  @param locationBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 *  @param errorBlock    errorBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locationBlock  withAddress:(NSStringBlock) addressBlock error:(LocationErrorBlock) errorBlock;



/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;


@end
