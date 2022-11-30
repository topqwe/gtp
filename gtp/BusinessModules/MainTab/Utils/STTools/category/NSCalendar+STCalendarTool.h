//
//  NSObject+ZBCalendarTool.h
//  ZuoBiao
//
//  Created by stoneobs on 17/3/22.
//  Copyright © 2017年 shixinyun. All rights reserved.
//
//**********************日历扩展，参与计算的一定需要时本地时间，不然会造成8个小时的误差***************************
#import <Foundation/Foundation.h>

@interface NSCalendar (STCalendarTool)

/**
 返回多少年多少月的string

 @param date 计算后的date
 @return string
 */
+ (NSString*)st_yearAndMonthByDate:(NSDate*)date;

/**
 当前日期是这个月的第几天

 @param date 传入时间需要本地化
 @return index
 */
+ (NSInteger)st_indexOfTheMonthDate:(NSDate*)date;

/**
 根据当前时间获取到这个月开始的第一天是周几，注意 返回3 代表周2，周日算1；

 @param date 时间
 @return 周几
 */
+ (NSInteger)st_whatTheMonthBeginInWeekByDate:(NSDate*)date;


/**
 根据时间计算这个月有多少天

 @param date 时间
 @return 多少天
 */
+ (NSInteger)st_numOfMonthDaysByDate:(NSDate*)date;


/**
 获取上一个月的时间，固定日期是15号，防止错误日期自动计算，比如3、31 换算成上个月就是2.31 在自动计算成3.3，这是不允许的

 @param date 时间(一定要本地化)
 @return 上一个月时间
 */
+ (NSDate*)st_lastMonthDate:(NSDate*)date;


/**
 获取下一个月的时间，固定日期是15号，防止错误日期自动计算，比如1、31 换算成上个月就是2.31，自动变成3.3 这是不允许的

 @param date 时间(一定要本地化)
 @return 下一个月
 */
+ (NSDate*)st_nextMonthDate:(NSDate*)date;
/**
 获取上一天的时间

 @param date 时间(一定要本地化)
 @return 上一天时间
 */
+ (NSDate*)st_lastDayDate:(NSDate*)date;
/**
 获取下一天时间

 @param date 时间(一定要本地化)
 @return 下一天
 */
+ (NSDate*)st_nextDayDate:(NSDate*)date;
/**
 将date 转换成日历模型，包括年月周日时分秒

 @param date 时间(一定要本地化)
 @return 日历模型
 */
+ (NSDateComponents*)st_comWithDate:(NSDate*)date;

/**
 将com 转成本地date

 @param com com description
 @return return value description
 */
+ (NSDate*)st_dateFromCom:(NSDateComponents*)com;
/**
 将date 转换成这个月的第一天0时0分1秒的时间
 
 @param date 时间(一定要本地化)
 @return 这个月的第一天时间
 */

+ (NSDate*)st_dateForMonthFirstDay:(NSDate*)date;


/**
 获取这一周的第一天date，周一

 @param date date description
 @return return value description
 */
+ (NSDate*)st_dateForWeekFirstDay:(NSDate*)date;

/**
 获取这一周的周日date
 
 @param date date description
 @return return value description
 */
+ (NSDate*)st_dateForWeekLastDay:(NSDate*)date;
@end
