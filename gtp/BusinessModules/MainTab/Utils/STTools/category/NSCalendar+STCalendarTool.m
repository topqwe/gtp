//
//  NSObject+ZBCalendarTool.m
//  ZuoBiao
//
//  Created by stoneobs on 17/3/22.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "NSCalendar+STCalendarTool.h"
@implementation NSCalendar (STCalendarTool)
+ (NSString *)st_yearAndMonthByDate:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    return [NSString stringWithFormat:@"%ld年%ld月",comps.year,comps.month];
}

+ (NSInteger)st_indexOfTheMonthDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    return comps.day;
}

+ (NSInteger)st_whatTheMonthBeginInWeekByDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday|NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.day = 1;
    NSDate * monthBginDate = [greCalendar dateFromComponents:comps];
    //计算这天周几
    NSCalendar *dayCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dayCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *daycomps = [dayCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekday| NSCalendarUnitDay|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:monthBginDate];
    return daycomps.weekday;
}

+ (NSInteger)st_numOfMonthDaysByDate:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSDate *)st_lastMonthDate:(NSDate *)date
{
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
     [greCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.month =comps.month - 1;
    comps.day = 15; //比如 3月31 如果获取到上一个月，按照算法就是 2月31 日，当然不可能存在，自动换算成3月3日，所以错误，手动到一个月的15号，保证结果是上一个月
    NSDate * lastDate =[greCalendar dateFromComponents:comps];
    return lastDate;
}
+ (NSDate *)st_nextMonthDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.month += 1;
    comps.day = 15;//比如 1月31 如果获取到下一个月，按照算法就是 2月31 日，当然不可能存在，自动换算成3月3日，所以错误，手动到一个月的15号，保证结果是下一个月
    return [greCalendar dateFromComponents:comps];
}
+ (NSDate *)st_lastDayDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.day =comps.day - 1;
    return [greCalendar dateFromComponents:comps];
}
+ (NSDate *)st_nextDayDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.day =comps.day + 1;
    return [greCalendar dateFromComponents:comps];
}
+ (NSDateComponents *)st_comWithDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday| NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    
    return comps;
}
+ (NSDate *)st_dateFromCom:(NSDateComponents *)com{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar dateFromComponents:com];
}
+ (NSDate *)st_dateForMonthFirstDay:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday| NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                               fromDate:date];
    comps.day = 1;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 1;
    return [greCalendar dateFromComponents:comps];
}
+ (NSDate *)st_dateForWeekFirstDay:(NSDate *)date{
    NSCalendar *dayCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dayCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *daycomps = [dayCalendar
                                  components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekday| NSCalendarUnitDay|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                                  fromDate:date];
    NSInteger index = daycomps.weekday;
    index = (index - 2)>=0?(index - 2):(index - 2)+7;
    daycomps.day = daycomps.day - index;
    return [dayCalendar dateFromComponents:daycomps];
}
+ (NSDate *)st_dateForWeekLastDay:(NSDate *)date{
    NSCalendar *dayCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dayCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *daycomps = [dayCalendar
                                  components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekday| NSCalendarUnitDay|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond
                                  fromDate:date];
    NSInteger index = daycomps.weekday;
    index = (- index + 1)<0?(7 - index + 1):0;
    daycomps.day = daycomps.day + index;
    return [dayCalendar dateFromComponents:daycomps];
}
@end
