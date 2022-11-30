//
//  NSDate+Formatter.h
//  SystemXinDai
//
//  Created by stoneobs on 16/3/26.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (STFormatter)

+(NSDate *)st_yesterday;

+(NSDateFormatter *)st_formatter;
+(NSDateFormatter *)st_formatterWithoutTime;
+(NSDateFormatter *)st_formatterWithoutDate;

-(NSString *)st_formatWithUTCTimeZone;
-(NSString *)st_formatWithLocalTimeZone;
-(NSString *)st_formatWithTimeZoneOffset:(NSTimeInterval)offset;
-(NSString *)st_formatWithTimeZone:(NSTimeZone *)timezone;

-(NSString *)st_formatWithUTCTimeZoneWithoutTime;
-(NSString *)st_formatWithLocalTimeZoneWithoutTime;
-(NSString *)st_formatWithTimeZoneOffsetWithoutTime:(NSTimeInterval)offset;
-(NSString *)st_formatWithTimeZoneWithoutTime:(NSTimeZone *)timezone;

-(NSString *)st_formatWithUTCWithoutDate;
-(NSString *)st_formatWithLocalTimeWithoutDate;
-(NSString *)st_formatWithTimeZoneOffsetWithoutDate:(NSTimeInterval)offset;
-(NSString *)st_formatTimeWithTimeZone:(NSTimeZone *)timezone;


+ (NSString *)st_currentDateStringWithFormat:(NSString *)format;
+ (NSDate *)st_dateWithSecondsFromNow:(NSInteger)seconds;
+ (NSDate *)st_dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (NSString *)st_dateWithFormat:(NSString *)format;

//Other
+ (NSDate*)st_localCurrentDate;//本地当前时间
- (NSDate*)st_localDate;//本地时间
- (NSString *)st_mmddByLineWithDate;
- (NSString *)st_yyyyMMByLineWithDate;
- (NSString *)st_yyyyMMddByLineWithDate;
- (NSString *)st_mmddChineseWithDate;
- (NSString *)st_hhmmssWithDate;
- (NSString *)st_yyyyMMddhhmmssWithDate;
- (NSString *)st_morningOrAfterWithHH;
- (NSString *)st_weekOrMonth;//本周，本月，几时几分---调用者用本地时间，
- (NSString *)st_dynamicFormater;//类似微信朋友圈，刚刚，3-59分钟前分钟，小余3分钟刚刚，1-23小时前，昨天，2-30天前，具体时间
+ (NSString *)st_countDownWithSecend:(NSInteger)secedn;//倒计时，小时计算
@end
