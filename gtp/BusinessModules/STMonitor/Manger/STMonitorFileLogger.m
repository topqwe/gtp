//
//  STMonitorFileLogger.m
//  GoldChampion
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorFileLogger.h"

@implementation STMonitorFileLogger
- (void)logMessage:(DDLogMessage *)logMessage{
    [super logMessage:logMessage];
    if (self.didLogHandle) {
        self.didLogHandle(logMessage);
    }
}
@end
