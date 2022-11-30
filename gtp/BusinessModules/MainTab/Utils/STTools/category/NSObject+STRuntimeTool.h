//
//  NSObject+STRuntimeTool.h
//  STNewTools
//
//  Created by stoneobs on 17/1/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
// 查看一个类所有方法，和所有变量

#import <Foundation/Foundation.h>

@interface NSObject (STRuntimeTool)

- (void)st_showAllProperties;//展示所有变量
- (void)st_showAllFunctions;
@end
