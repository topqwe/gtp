//
//  TMCountDownManger.h
//  STToolsMaker
//
//  Created by Mac on 2018/11/13.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMCountDownManger;
@protocol  TMCountDownMangerDelegate <NSObject>
- (void)countDownManger:(TMCountDownManger*)countDownManger everySecendRun:(NSInteger)runSectends;
@end
/************倒计时管理******************/
@interface TMCountDownManger : NSObject
@property(nonatomic, assign) NSInteger                     runSectends;/**< 运行时间 */
+ (TMCountDownManger*)manger;
- (void)beginMonitor;//开始每一秒执行
- (void)addDelegate:(NSObject<TMCountDownMangerDelegate>*)obj;
@end
