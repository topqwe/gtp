//
//  MKCalloutAnnotationView.h
//  TestDemo
//
//  Created by WIQChen on 16/3/3.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>
#import "CoreLocationVC.h"


@interface MKCalloutAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;
#pragma mark 左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 详情描述
@property (nonatomic,copy) NSString *detail;
#pragma mark 星级评价
@property (nonatomic,strong) UIImage *rate;

@end


@interface MKCalloutAnnotationView : MKAnnotationView
#pragma mark 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;
@end
