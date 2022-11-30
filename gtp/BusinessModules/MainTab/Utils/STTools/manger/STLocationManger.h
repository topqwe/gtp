//
//  STLocationManger.h
//  KunLun
//
//  Created by Mac on 2017/11/29.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "STError.h"
typedef void(^STLocationMangerDidLocation)(STError * error,CLPlacemark *placemark);
/************定位管理器，使用期间******************/
@interface STLocationManger : NSObject
//当前位置信息
@property(nonatomic,strong)CLPlacemark                  *currentPlacemark;
+ (STLocationManger*)defult;
- (NSDictionary*)lastPlacemark;//上次定位的缓存位置,只能字典，不能生成对象
- (NSString*)lastProvence;
- (NSString*)lastCity;
- (NSString*)lastSubLocality;
//更新储存的位置信息,需要手动调用
- (void)updatePlacemarkWith:(CLPlacemark*)lastPalcemark;
//开始定位，定位成功自动结束
- (void)startUpdatingLocationHande:(STLocationMangerDidLocation)handel;
@end
