//
//  CoreLocationVC.h
//  TestDemo
//
//  Created by WIQChen on 16/3/2.
//  Copyright © 2016年 WIQChen. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "CoreLocationManager.h"
@interface MKAnnotationModel : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;
#pragma mark 大头针详情左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 大头针详情描述
@property (nonatomic,copy) NSString *detail;
#pragma mark 大头针右下方星级评价
@property (nonatomic,strong) UIImage *rate;

-(id) initWithCoords:(CLLocationCoordinate2D) coords;

@end


@interface CoreLocationVC : UIViewController

@end
