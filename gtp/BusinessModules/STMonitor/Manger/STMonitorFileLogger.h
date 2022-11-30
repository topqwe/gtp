//
//  STMonitorFileLogger.h
//  GoldChampion
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "STMonitorHeader.h"
/************file******************/
@interface STMonitorFileLogger : DDFileLogger
@property(nonatomic, copy) void(^didLogHandle)(DDLogMessage* message) ;

@end
