//
//  STMonitorLogManger.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorLogManger.h"
#import "STMonitorLogFormatter.h"
#import "STMonitorCrashManger.h"
#import "STMonitorIndicatorView.h"
#import "STMonitorFileLogger.h"
@implementation STMonitorLogManger
+ (STMonitorLogManger*)manger{
    static STMonitorLogManger * manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [STMonitorLogManger new];
    });
    return manger;
}
- (STMonitorIndicatorView *)indicatorViewManger{
    return [STMonitorIndicatorView deflult];
}
- (void)beiginLogRecord{
    [STMonitorCrashManger defult];//开始闪退监听

    STMonitorLogFormatter*logFormatter = [[STMonitorLogFormatter alloc] init];

    STMonitorFileLogger *fileLogger = [[STMonitorFileLogger alloc] init];
    
    fileLogger.rollingFrequency = 60 * 60 * 24 * 5;//五天一个文件，最多7个文件
    fileLogger.rollingFrequency = 60 * 60 * 24 ;//1天一个文件，最多7个文件
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:logFormatter];
    [DDLog addLogger:fileLogger withLevel:DDLogLevelVerbose];//所有的写到文件中

    //3.初始化DDLog日志输出，在这里，我们仅仅希望在xCode控制台输出
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];// 启用颜色区分
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 0, 0)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(125,200,80)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(200,100,200)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagDebug];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#if DEBUG
    DDLogInfo(@"当前环境:Debug");
#else
    DDLogInfo(@"当前环境:Release");
#endif
    //判断 view 是否显示
    [[STMonitorLogManger manger] beginMonitorIndicatiorViewJudge];

}
- (NSArray<NSString *> *)allDDLogsPaths{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    NSString * path = fileLogger.logFileManager.logsDirectory;
    //文件操作对象
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray * dirArray = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *finshArray = [NSMutableArray new];
    for (NSString * name in dirArray) {
        NSString * realName = [NSString stringWithFormat:@"%@/%@",path,name];
        [finshArray addObject:realName];
    }
    return finshArray;
}
- (void)beginMonitorIndicatiorViewJudge{
    [[STMonitorIndicatorView deflult] updateConsoleState];
}
@end
