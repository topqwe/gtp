//
//  HomeModel.m
//  LiNiuYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "DataStatisticsModel.h"


@implementation DataStatisticsSubDataItem : NSObject

@end

@implementation DataStatisticsSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [DataStatisticsSubDataItem class]
             
             };
}
@end

@implementation DataStatisticsData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [DataStatisticsSubDataItem class]
             
             };
}
@end

@implementation DataStatisticsResult

@end

@implementation DataStatisticsModel

@end
