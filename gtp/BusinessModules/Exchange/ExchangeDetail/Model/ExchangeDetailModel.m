//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "ExchangeDetailModel.h"


@implementation ExchangeDetailSubDataItem : NSObject

@end

@implementation ExchangeDetailSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [ExchangeDetailSubDataItem class]
             
             };
}
@end

@implementation ExchangeDetailData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [ExchangeDetailSubDataItem class]
             
             };
}
@end

@implementation ExchangeDetailResult

@end

@implementation ExchangeDetailModel

@end
