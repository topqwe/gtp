//
//  MKAnnotationVC.m
//  TestDemo
//
//  Created by WIQChen on 16/3/3.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "MKAnnotationVC.h"

@interface MKAnnotationVC ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)MKMapView *mapView;


@end

@implementation MKAnnotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [self addAnnotation];
    
    //设置代理
    _mapView.delegate=self;
}

#pragma mark 添加大头针
-(void)addAnnotation{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(23.03, 113.15);
    MKAnnotationModel *annotation1=[[MKAnnotationModel alloc]init];
    annotation1.title=@"FS";
    annotation1.subtitle=@"WIQ's Home";
    annotation1.coordinate=location1;
    annotation1.image=[UIImage imageNamed:@"icon_pin_floating"];
    annotation1.icon=[UIImage imageNamed:@"icon_mark1"];
    annotation1.detail=@"WIQ's Home...";
    annotation1.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
    [_mapView addAnnotation:annotation1];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(23.11, 113.27);
    MKAnnotationModel *annotation2=[[MKAnnotationModel alloc]init];
    annotation2.title=@"GZ";
    annotation2.subtitle=@"WIQ's Studio";
    annotation2.coordinate=location2;
    annotation2.image=[UIImage imageNamed:@"icon_paopao_waterdrop_streetscape"];
    annotation2.icon=[UIImage imageNamed:@"icon_mark2"];
    annotation2.detail=@"WIQ's Studio...";
    annotation2.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
    [_mapView addAnnotation:annotation2];
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //红色大头针GPS定位，点击弹框
        
//        MKAnnotationModel* annotation = [[MKAnnotationModel alloc]initWithCoords:userLocation.location.coordinate];
//        annotation.title = placemark.country;
//        annotation.subtitle = placemark.name;
//        annotation.image=[UIImage imageNamed:@"icon_openmap_item"];
//        annotation.icon=[UIImage imageNamed:@"icon_mark1"];
//        annotation.detail=@"WIQ's Studio...";
//        annotation.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
//        [mapView addAnnotation:annotation];
        
        //蓝色发光圆圈，显示用户位置，点击弹框
        mapView.userLocation.title=placemark.country;
        mapView.userLocation.subtitle = placemark.name;
        //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
        [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
        
        //设置地图精度以及显示用户所在位置的地图
        MKCoordinateSpan span=MKCoordinateSpanMake(0.01f, 0.01f);
        MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
        [mapView setRegion:region animated:true];
    }];
}
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MKAnnotationModel class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
//            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((MKAnnotationModel *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else if([annotation isKindOfClass:[MKCalloutAnnotation class]]){
        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
        MKCalloutAnnotationView *calloutView=[MKCalloutAnnotationView calloutViewWithMapView:mapView];
        calloutView.annotation=annotation;
        calloutView.canShowCallout = YES;
        return calloutView;
    } else {
        return nil;
    }
}

#pragma mark 选中大头针时触发
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图,如何返回调用👆的viewForAnnotation做类判断
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

    MKAnnotationModel * annotation= (MKAnnotationModel*)view.annotation;
    if ([view.annotation isKindOfClass:[MKAnnotationModel class]]) {
        //点击一个大头针时移除其他弹出详情视图
        //        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        
        MKCalloutAnnotation *annotation1=[[MKCalloutAnnotation alloc]init];
        annotation1.icon = annotation.icon;
        annotation1.detail = annotation.detail;
        annotation1.rate = annotation.rate;
        annotation1.coordinate = annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    WS(weakSelf);
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MKCalloutAnnotation class]]) {
            [weakSelf.mapView removeAnnotation:obj];
        }
    }];
}
@end
