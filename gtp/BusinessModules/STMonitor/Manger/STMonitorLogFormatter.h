//
//  STMonitorLogFormatter.h
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMonitorHeader.h"
@interface STMonitorLogFormatter : NSObject<DDLogFormatter>
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;
@end
