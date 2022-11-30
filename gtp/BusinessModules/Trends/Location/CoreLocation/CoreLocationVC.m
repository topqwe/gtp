//
//  CoreLocationVC.m
//  TestDemo
//
//  Created by WIQChen on 16/3/2.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "CoreLocationVC.h"
#import "SelectCityListVC.h"
@interface CoreLocationVC ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) CLGeocoder *geocoder;
@end

@implementation CoreLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    //根据地理名字定位
    [self getCoordinateByAddressName:@"澳洲"];
    
    //定位管理器
//    [[CoreLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCoordinate) {
//        //显示坐标
//        [self setMapPoint:locationCoordinate];
//
//    } error:^(NSError *error) {
//        
//    }];
}

-(void)getCoordinateByAddressName:(NSString *)address{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
    }
    
    MKMapView* mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    //默认是standard模式，还有卫星模式satellite和杂交模式Hybrid
    mapView.mapType=MKMapTypeStandard;
    
    //显示用户位置（蓝色发光圆圈），还有None和FollowWithHeading两种，当有这个属性的时候，iOS8第一次打开地图，会自动定位并显示这个位置。iOS7模拟器上不会。
    mapView.userTrackingMode=MKUserTrackingModeFollow;
    [self.view addSubview:mapView];
    
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        // 处理出错
                if (error || placemarks.count == 0) {
                    NSLog(@"解析出错");
                    return;
                }
                // 遍历数组
                for (CLPlacemark *placeMark in placemarks) {
                    NSLog(@"latitude: %f", placeMark.location.coordinate.latitude);
                    NSLog(@"longitude: %f", placeMark.location.coordinate.longitude);
                    NSLog(@"name: %@", placeMark.name);
                    
                    CLLocationCoordinate2D locationCoordinate = placeMark.location.coordinate;
                    
                    CLLocation *location=[[CLLocation alloc]initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
                    
                    [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                            CLPlacemark *placemark=[placemarks firstObject];
                            //红色大头针GPS定位，点击弹框
                        MKAnnotationModel* annotation = [[MKAnnotationModel alloc]initWithCoords:locationCoordinate];
                            annotation.title = placemark.country;
                            annotation.subtitle = placemark.name;
                            annotation.image=[UIImage imageNamed:@"icon_openmap_item"];
                            annotation.icon=[UIImage imageNamed:@"icon_mark1"];
                            annotation.detail=@"WIQ's Studio...";
                            annotation.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
                    //        [mapView selectAnnotation:annotation animated:YES];
                            [mapView addAnnotation:annotation];
                            
                            //蓝色发光圆圈，显示用户位置，点击弹框
                    //        mapView.userLocation.title=placemark.country;
                    //        mapView.userLocation.subtitle = placemark.name;
                            //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
                    //        [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
                            
                            //设置地图精度以及显示用户所在位置的地图
                            MKCoordinateSpan span=MKCoordinateSpanMake(0.01f, 0.01f);
                            MKCoordinateRegion region=MKCoordinateRegionMake(locationCoordinate, span);
                            [mapView setRegion:region animated:true];
                            
                    //        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"详细地址" message:placemark.name delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    //        [alertView show];
                            NSString * str = [NSString stringWithFormat:@"LocationName:%@\n City:%@\n Country:%@\n",placemark.name,placemark.locality,placemark.country];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"详细地址" message:str preferredStyle:  UIAlertControllerStyleAlert];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            }]];
                            
                            [self presentViewController:alert animated:true completion:nil];
                        }];
                }
        
        
    }];
}

-(void)setMapPoint:(CLLocationCoordinate2D)locationCoordinate
{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
    }
    
    MKMapView* mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    //默认是standard模式，还有卫星模式satellite和杂交模式Hybrid
    mapView.mapType=MKMapTypeStandard;
    //显示用户位置（蓝色发光圆圈），还有None和FollowWithHeading两种，当有这个属性的时候，iOS8第一次打开地图，会自动定位并显示这个位置。iOS7模拟器上不会。
    mapView.userTrackingMode=MKUserTrackingModeFollow;
    [self.view addSubview:mapView];
    
    
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //红色大头针GPS定位，点击弹框
        MKAnnotationModel* annotation = [[MKAnnotationModel alloc]initWithCoords:locationCoordinate];
        annotation.title = placemark.country;
        annotation.subtitle = placemark.name;
        annotation.image=[UIImage imageNamed:@"icon_openmap_item"];
        annotation.icon=[UIImage imageNamed:@"icon_mark1"];
        annotation.detail=@"WIQ's Studio...";
        annotation.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
//        [mapView selectAnnotation:annotation animated:YES];
        [mapView addAnnotation:annotation];
        
        //蓝色发光圆圈，显示用户位置，点击弹框
//        mapView.userLocation.title=placemark.country;
//        mapView.userLocation.subtitle = placemark.name;
        //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
//        [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
        
        //设置地图精度以及显示用户所在位置的地图
        MKCoordinateSpan span=MKCoordinateSpanMake(0.01f, 0.01f);
        MKCoordinateRegion region=MKCoordinateRegionMake(locationCoordinate, span);
        [mapView setRegion:region animated:true];
        
//        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"详细地址" message:placemark.name delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//        [alertView show];
        NSString * str = [NSString stringWithFormat:@"LocationName:%@\n City:%@\n Country:%@\n",placemark.name,placemark.locality,placemark.country];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"详细地址" message:str preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
    }];
  
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MKAnnotationModel class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            //修改点击大头针的详情annotationView
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((MKAnnotationModel *)annotation).image;//修改大头针视图的图片
        
        return annotationView;
    }
//    else if([annotation isKindOfClass:[KCCalloutAnnotation class]]){
//        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
//        KCCalloutAnnotationView *calloutView=[KCCalloutAnnotationView calloutViewWithMapView:mapView];
//        calloutView.annotation=annotation;
//        calloutView.canShowCallout = NO;
//        return calloutView;
//    }
    else {
        return nil;
    }
}

#pragma mark 选中大头针时触发
//默认点击一个消失另一个annotationView
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图,如何返回调用👆的viewForAnnotation做类判断
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    MKAnnotationModel *annotation=view.annotation;
//    if ([view.annotation isKindOfClass:[KCAnnotation class]]) {
//        //点击一个大头针时移除其他弹出详情视图
//        //        [self removeCustomAnnotation];
//        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
//        KCCalloutAnnotation *annotation1=[[KCCalloutAnnotation alloc]init];
//        annotation1.icon=annotation.icon;
//        annotation1.detail=annotation.detail;
//        annotation1.rate=annotation.rate;
//        annotation1.coordinate=annotation.coordinate;
//        [mapView addAnnotation:annotation1];
//    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
//    [self removeCustomAnnotationWithMapView:mapView];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotationWithMapView:(MKMapView *)mapView{
    [mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[KCCalloutAnnotation class]]) {
            [mapView removeAnnotation:obj];
//        }
    }];
}
@end


@implementation MKAnnotationModel

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        
        self.coordinate = coords;
        
    }
    
    return self;
    
}

@end
