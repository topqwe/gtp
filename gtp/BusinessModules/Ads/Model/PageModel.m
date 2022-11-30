//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "PageModel.h"

@implementation PageItem : NSObject

@end


@implementation PageData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PageItem class]
             };
}
@end

@implementation PageResult

@end

@implementation PageModel

@end
