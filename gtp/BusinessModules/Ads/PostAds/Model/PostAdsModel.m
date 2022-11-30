//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "PostAdsModel.h"


@implementation PostAdsSubDataItem : NSObject

@end

@implementation PostAdsSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [PostAdsSubDataItem class]
             
             };
}
@end

@implementation PostAdsData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PostAdsSubDataItem class]
             
             };
}
@end

@implementation PostAdsResult

@end

@implementation PostAdsModel

@end
