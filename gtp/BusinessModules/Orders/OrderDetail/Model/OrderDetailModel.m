//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "OrderDetailModel.h"


@implementation OrderDetailSubDataItem : NSObject

@end

@implementation OrderDetailSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [OrderDetailSubDataItem class]
             
             };
}
@end

@implementation OrderDetailData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [OrderDetailSubDataItem class]
             
             };
}
@end

@implementation OrderDetailResult

@end

@implementation OrderDetailModel

@end
