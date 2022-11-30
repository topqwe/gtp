//
//  CLGeocoderVC.m
//  TestDemo
//
//  Created by WIQChen on 16/3/1.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "CLGeocoderVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface CLGeocoderVC ()<UIAlertViewDelegate>
@property (nonatomic,strong) CLGeocoder *geocoder;
@end

@implementation CLGeocoderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    _geocoder=[[CLGeocoder alloc]init];
    [self listPlacemark];
    
    [self getCoordinateByAddress:@"广州"];
    
    [self getAddressByLatitude:39.54 longitude:116.28];
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        
//        NSDictionary *addressDic= placemark.addressDictionary;//ios11.0无 详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSString * str = [NSString stringWithFormat:@"位置:%@,区域:%@,地标:%@",location,region,placemark.subLocality];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"详细地址" message:str preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
        
    }];
}

#pragma mark 在地图上定位
-(void)listPlacemark{
    //根据“北京市”进行地理编码
    WS(weakSelf);
    [_geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark1=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkPlacemark1=[[MKPlacemark alloc]initWithPlacemark:clPlacemark1];
        //注意地理编码一次只能定位到一个位置，不能同时定位，所在放到第一个位置定位完成回调函数中再次定位
        [weakSelf.geocoder geocodeAddressString:@"广州市" completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *clPlacemark2=[placemarks firstObject];//获取第二个地标
            MKPlacemark *mkPlacemark2=[[MKPlacemark alloc]initWithPlacemark:clPlacemark2];
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
//            MKMapItem *mapItemCL=[MKMapItem mapItemForCurrentLocation];//当前位置,点击会闪退
            MKMapItem *mapItem1=[[MKMapItem alloc]initWithPlacemark:mkPlacemark1];
            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mkPlacemark2];
            
            if (placemarks.count >0)
            {
                CLPlacemark * plmark = [placemarks objectAtIndex:0];
                
                CLLocation *location=plmark.location;//位置
                CLRegion *region=plmark.region;//区域
                NSString * str = [NSString stringWithFormat:@"位置:%@\n区域:%@\n地址:%@\n",location,region,plmark.name];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"详细地址" message:str preferredStyle:  UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                
                [self presentViewController:alert animated:true completion:nil];
            }
            
            
            
           [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
            
        }];
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
            
        default:
            break;
    }
}

@end
