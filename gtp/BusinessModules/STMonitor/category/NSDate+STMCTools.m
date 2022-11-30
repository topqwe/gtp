//
//  NSObject+STMCTools.m
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import "NSDate+STMCTools.h"

@implementation NSDate (STMCTools)
+ (NSDate*)stmc_localCurrentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
- (NSString *)stmc_yyyyMMddhhmmssWithDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setTimeZone:GTMzone];
    return [formatter stringFromDate:self];
}
@end
