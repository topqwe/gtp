//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "PostAdsDetailModel.h"


@implementation PostAdsDetailSubDataItem : NSObject

@end

@implementation PostAdsDetailSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [PostAdsDetailSubDataItem class]
             
             };
}
@end

@implementation PostAdsDetailData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PostAdsDetailSubDataItem class]
             
             };
}
@end

@implementation PostAdsDetailResult

@end

@implementation PostAdsDetailModel

@end
