//
//  NSObject+STMCTools.h
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (STMCTools)
+ (NSDate*)stmc_localCurrentDate;
- (NSString *)stmc_yyyyMMddhhmmssWithDate;
@end
