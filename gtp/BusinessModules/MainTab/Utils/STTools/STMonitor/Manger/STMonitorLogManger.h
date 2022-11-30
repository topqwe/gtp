//
//  STMonitorLogManger.h
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMonitorHeader.h"
#import "STMonitorIndicatorView.h"
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
/************日志管理/在APPDelegate加载rootViewController之后开始，或者将indicatorViewManger birngToFront******************/
@interface STMonitorLogManger : NSObject
+ (STMonitorLogManger*)manger;
- (STMonitorIndicatorView*)indicatorViewManger;
- (void)beiginLogRecord;//需要手动开启 才会记录日志
//是否显示控制台ui
- (void)beginMonitorIndicatiorViewJudge;
- (NSArray<NSString*>*)allDDLogsPaths;
@end
