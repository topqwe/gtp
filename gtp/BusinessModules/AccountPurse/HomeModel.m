//
//  HomeModel.m
//  LiNiuYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "HomeModel.h"

@implementation WItem : NSObject

@end

@implementation WData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"rankinglist" : @"WItem"
             
             };
}
@end
@implementation HomeItem : NSObject

@end

@implementation HomeData
+(NSDictionary *)objectClassInArray
{
    return @{
//             @"b" : [WItem class]
             
             };
}
@end

@implementation HomeResult

@end

@implementation HomeModel

@end
