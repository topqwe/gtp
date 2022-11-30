//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "ModifyAdsModel.h"


@implementation ModifyAdsSubDataItem : NSObject

@end

@implementation ModifyAdsSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [ModifyAdsSubDataItem class]
             
             };
}
@end

@implementation ModifyAdsData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [ModifyAdsSubDataItem class]
             
             };
}
@end

@implementation ModifyAdsResult

@end

@implementation ModifyAdsModel

@end
