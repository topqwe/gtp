//
//  STCrashManger.h
//  ligenyun
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMonitorHeader.h"
/************崩溃日志管理器******************/
@interface STMonitorCrashManger : NSObject
//当前日志路径
@property(nonatomic, strong) NSString                     *currentCashPath;
+ (STMonitorCrashManger*)defult;
//获取当前手机版本
- (NSString*)iphoneType;
//获取闪退日志数组
- (NSArray<NSString*>*)crashArray;
@end
