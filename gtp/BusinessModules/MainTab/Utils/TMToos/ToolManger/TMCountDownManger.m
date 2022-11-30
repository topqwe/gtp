//
//  GGCountDownManger.m
//  GrapeGold
//
//  Created by Mac on 2018/5/4.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMCountDownManger.h"
@interface TMCountDownManger()
@property(nonatomic,strong)dispatch_source_t            timer;
@property(nonatomic, strong) NSPointerArray                     *pointerArray;/**< weakArray */
@end
@implementation TMCountDownManger
+ (TMCountDownManger *)manger{
    static TMCountDownManger * manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [TMCountDownManger new];
    });
    return manger;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.runSectends = 0;
        self.pointerArray =  [NSPointerArray weakObjectsPointerArray];;
    }
    return self;
}
#pragma mark --public
- (void)beginMonitor{
    //需要在主线程，因为会存在修改button title ，子线程是改不到的
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        //开始
        self.runSectends ++;
        [self timerAction];
    });
    dispatch_resume(_timer);
}
- (void)addDelegate:(id<TMCountDownMangerDelegate>)obj{
    [self.pointerArray addPointer:(__bridge void*)obj];
}
#pragma mark --Private Method
- (void)timerAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSObject<TMCountDownMangerDelegate> * obj in self.pointerArray.allObjects) {
            if ([obj respondsToSelector:@selector(countDownManger:everySecendRun:)]) {
                [obj countDownManger:self everySecendRun:self.runSectends];
            }
        }
    });
    
}
@end
