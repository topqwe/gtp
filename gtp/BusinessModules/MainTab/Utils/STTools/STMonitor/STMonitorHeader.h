//
//  STMonitorHeader.h
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//
/************监听框架头文件******************/
#ifndef STMonitorHeader_h
#define STMonitorHeader_h

//#ifdef DEBUG
//#undef NSLog
//#define NSLog(FORMAT, ...) {\
//DDLogInfo(@"%@",[NSString stringWithFormat:(FORMAT), ##__VA_ARGS__]);\
//}
//#endif

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "STMonitorCrashManger.h"
#import "STMonitorHomeViewController.h"
#import "STMonitorLogManger.h"

#import "NSDate+STMCTools.h"
#import "UIView+STMCDirection.h"
#define isOpenDeBugWindowKey @"isOpenDeBugWindowKey"//是否开启了调试模式
#define isOpenCrashProtectKey @"isOpenCrashProtectKey"//是否开启了闪退保护模式
#define STMC_UIColorFromRGBA(v)  [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define STMC_ThemeBackGroundColor  STMC_UIColorFromRGBA(0x169DF6)
#define STMC_UIScrenWitdh [UIScreen mainScreen].bounds.size.width
#define STMC_UIScrenHeight [UIScreen mainScreen].bounds.size.height
#define STMC_IOS11  ([UIDevice currentDevice].systemVersion.floatValue > 11.0)

#endif /* STMonitorHeader_h */
