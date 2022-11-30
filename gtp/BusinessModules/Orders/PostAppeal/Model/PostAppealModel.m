//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "PostAppealModel.h"


@implementation PostAppealSubDataItem : NSObject

@end

@implementation PostAppealSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [PostAppealSubDataItem class]
             
             };
}
@end

@implementation PostAppealData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PostAppealSubDataItem class]
             
             };
}
@end

@implementation PostAppealResult

@end

@implementation PostAppealModel

@end
