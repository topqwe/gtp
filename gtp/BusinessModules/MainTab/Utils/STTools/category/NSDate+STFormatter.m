//
//  NSDate+Formatter.h
//  Stoneobs
//
//  Created by Stoneobs on 16/7/30.
//  Copyright © 2016年 Stoneobs. All rights reserved.
//

#import "NSDate+STFormatter.h"

@implementation NSDate (STFormatter)

+ (NSDate *)st_yesterday{
    return  [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
}
+ (NSDateFormatter *)st_formatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDoesRelativeDateFormatting:YES];
    });
    return formatter;
}

+ (NSDateFormatter *)st_formatterWithoutTime {
    
    static NSDateFormatter *formatterWithoutTime = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        formatterWithoutTime = [[NSDate st_formatter] copy];
        [formatterWithoutTime setTimeStyle:NSDateFormatterNoStyle];
    });
    return formatterWithoutTime;
}

+ (NSDateFormatter *)st_formatterWithoutDate {
    static NSDateFormatter *formatterWithoutDate = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        formatterWithoutDate = [[NSDate st_formatter] copy];
        [formatterWithoutDate setDateStyle:NSDateFormatterNoStyle];
    });
    return formatterWithoutDate;
}

#pragma mark -
#pragma mark Formatter with date & time
-(NSString *)st_formatWithUTCTimeZone {
    return [self st_formatWithTimeZoneOffset:0];
}

-(NSString *)st_formatWithLocalTimeZone {
    return [self st_formatWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)st_formatWithTimeZoneOffset:(NSTimeInterval)offset {
    return [self st_formatWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)st_formatWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate st_formatter];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without time
-(NSString *)st_formatWithUTCTimeZoneWithoutTime {
    return [self st_formatWithTimeZoneOffsetWithoutTime:0];
}

-(NSString *)st_formatWithLocalTimeZoneWithoutTime {
    return [self st_formatWithTimeZoneWithoutTime:[NSTimeZone localTimeZone]];
}

-(NSString *)st_formatWithTimeZoneOffsetWithoutTime:(NSTimeInterval)offset {
    return [self st_formatWithTimeZoneWithoutTime:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)st_formatWithTimeZoneWithoutTime:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate st_formatterWithoutTime];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without date
-(NSString *)st_formatWithUTCWithoutDate {
    return [self st_formatTimeWithTimeZone:0];
}
-(NSString *)st_formatWithLocalTimeWithoutDate {
    return [self st_formatTimeWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)st_formatWithTimeZoneOffsetWithoutDate:(NSTimeInterval)offset {
    return [self st_formatTimeWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)st_formatTimeWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate st_formatterWithoutDate];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}
#pragma mark -
#pragma mark Formatter  date
//获取此时的本地时间
+ (NSDate*)st_localCurrentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
+ (NSString *)st_currentDateStringWithFormat:(NSString *)format
{
    NSDate *chosenDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:chosenDate];
    return date;
}
+ (NSDate *)st_dateWithSecondsFromNow:(NSInteger)seconds {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [NSDateComponents new];
    [components setSecond:seconds];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateSecondsAgo = [calendar dateByAddingComponents:components toDate:date options:0];
    return dateSecondsAgo;
}
+ (NSDate *)st_dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}
//获取某个date 的本地时间
- (NSDate*)st_localDate
{
    NSDate *date = self;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
- (NSString *)st_dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}
- (NSString *)st_yyyyMMByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:self];
}
- (NSString *)st_mmddByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)st_mmddChineseWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    return [formatter stringFromDate:self];
}

- (NSString *)st_hhmmssWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:self];
}

- (NSString *)st_yyyyMMddByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
     NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setTimeZone:GTMzone];
    return [formatter stringFromDate:self];
}
- (NSString *)st_yyyyMMddhhmmssWithDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setTimeZone:GTMzone];
    return [formatter stringFromDate:self];
}
- (NSString *)st_morningOrAfterWithHH{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *status = [formatter stringFromDate:self];
    if (status.intValue > 0 && status.intValue < 12) {
        return @"上午好";
    }else{
        return @"下午好";
    }
    return @"";
}
-(NSString *)st_weekOrMonth
{
    //[NSDate dateWithTimeIntervalSince1970:time.integerValue/1000]
    NSDate * date = self;
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents* com= [greCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekOfYear |NSCalendarUnitWeekday fromDate:date];
    
    NSCalendar *curentCal = [NSCalendar currentCalendar];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents* curentCalcom= [curentCal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSString * hourMin=[NSString stringWithFormat:@"%lu:%lu:%lu",com.hour,com.minute,com.second];
    BOOL isThisYear =(com.year==curentCalcom.year);
    if (isThisYear&&curentCalcom.weekOfYear==com.weekOfYear) {
        return [NSString stringWithFormat:@"周%@%@",[self st_weekDay:com.weekday],hourMin];
    }
    if (isThisYear&&com.month==curentCalcom.month) {
        return [NSString stringWithFormat:@"本月%lu日%lu时",com.day,com.hour];
    }
    return [NSString stringWithFormat:@"%lu年%lu月%lu日 %lu:%lu:%lu:",com.year,com.month,com.day,
            com.hour,com.minute,com.second];

}
-(NSString*)st_weekDay:(NSInteger)num
{
    switch (num) {
        case 1:
            return @"日";
            break;
        case 2:
            return @"一";
            break;
        case 3:
            return @"二";
            break;
        case 4:
            return @"三";
            break;
        case 5:
            return @"四";
            break;
        case 6:
            return @"五";
            break;
        case 7:
            return @"六";
            break;
        default:
            break;
    }
    return nil;
}
- (NSString *)st_dynamicFormater{
    NSInteger time = [self timeIntervalSince1970];
    NSDate * currentDate = [NSDate st_localCurrentDate];
    NSInteger now = [currentDate timeIntervalSince1970];
    NSInteger chazhi = now - time;
    if (chazhi <  60 * 3) {
        return @"刚刚";
    }else if (chazhi < 60 * 60  ){
        NSInteger min = chazhi / 60;
        NSString * desc =  [NSString stringWithFormat:@"%lu分钟前",min];
        return desc;
    }else if (chazhi < 60 * 60 * 24  ){
        NSInteger hour = chazhi / 3600;
        NSString * desc =  [NSString stringWithFormat:@"%lu小时前",hour];
        return desc;
    }else if (chazhi < 60 * 60 * 24  * 2  ){
        NSString * desc =  @"一天前";
        return desc;
    }else if (chazhi < 60 * 60 * 24  * 30  ){
        NSInteger day = chazhi / (3600*24);
        NSString * desc = [NSString stringWithFormat:@"%lu天前",day];
        return desc;
    }
    return self.st_yyyyMMddhhmmssWithDate;
}
+ (NSString *)st_countDownWithSecend:(NSInteger)secend{
    NSInteger hour = secend / 3600;
    NSString * hourStr = @(hour).description;
    if (hourStr.length < 2) {
        hourStr = [NSString stringWithFormat:@"0%@",@(hour)];
    }
    
    NSInteger minte = (secend - hour*3600) / 60;
    NSString * minteStr = @(minte).description;
    if (minteStr.length < 2) {
        minteStr = [NSString stringWithFormat:@"0%@",@(minte)];
    }
    
    NSInteger sec = secend % 60;
    NSString * secStr = @(sec).description;
    if (secStr.length < 2) {
        secStr = [NSString stringWithFormat:@"0%@",@(sec)];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",hourStr,minteStr,secStr];
}
@end
