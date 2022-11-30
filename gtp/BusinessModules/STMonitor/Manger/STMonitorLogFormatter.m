//
//  STMonitorLogFormatter.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorLogFormatter.h"

@implementation STMonitorLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    NSString *loglevel = nil;
    NSDate * date = [NSDate stmc_localCurrentDate];

    switch (logMessage.flag)
    {
        case DDLogFlagError:
        {
            loglevel = [NSString stringWithFormat:@"%@[ERROR]\n",date.stmc_yyyyMMddhhmmssWithDate];
        }
            break;
        case DDLogFlagWarning:
        {
            loglevel = [NSString stringWithFormat:@"%@[WARNING]\n",date.stmc_yyyyMMddhhmmssWithDate];
        }
            break;
        case DDLogFlagInfo:
        {
            loglevel = [NSString stringWithFormat:@"%@[INFO]\n",date.stmc_yyyyMMddhhmmssWithDate];
        }
            break;
        case DDLogFlagDebug:
        {
            loglevel = @"[DEBUG]---->";
        }
            break;
        case DDLogFlagVerbose:
        {
            //打印error，warning，Info，debug，verbose级别的日志
            loglevel = @"[VBOSE]----->";
        }
            break;
            
        default:
            break;
    }
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@___line[%ld]__%@", loglevel, logMessage->_function,logMessage->_line, logMessage->_message];
    return formatStr;
}
@end
