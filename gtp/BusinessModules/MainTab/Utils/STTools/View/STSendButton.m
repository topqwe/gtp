//
//  STSendButton.m
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  需要精确计时

#import "STSendButton.h"
@interface STSendButton()
@property(nonatomic,assign)NSInteger  saveDuration;/**< 保存的时间 */
@property(nonatomic,assign)BOOL            isFirstClic;/**< 初次点击，永远判断是否应该响应事件 */
@property(nonatomic,strong)dispatch_source_t            timer;
@end
@implementation STSendButton
- (instancetype)initWithFrame:(CGRect)frame andWithDuration:(NSInteger)duration
{
    self = [super initWithFrame:frame];
    if (self) {
        self.duration = duration;
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
        self.isFirstClic = YES;
    }
    return self;
}
-(void)setDuration:(NSInteger)duration
{
    _duration = duration;
    _saveDuration = duration;
}

- (void)butAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(st_sendButtonWillClic:)]) {
        BOOL canResponse = [self.delegate st_sendButtonWillClic:self];
        if (!canResponse) {
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(st_sendButtonDidClic:isFirstClic:duration:)]) {
        //第一次点击
        [self.delegate st_sendButtonDidClic:self isFirstClic:_isFirstClic duration:self.duration];
        _isFirstClic = NO;
    }

}
- (void)st_timerBegin
{
    //需要在主线程，因为会存在修改button title ，子线程是改不到的
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        //开始
        //NSLog(@"计时开始%ld",_duration);
        if (self.delegate && [self.delegate respondsToSelector:@selector(st_sendButtonDidCountdown:duration:)]) {
            [self.delegate st_sendButtonDidCountdown:self duration:self.duration];
            self.duration --;
            if (self.duration == 0) {
                //时间终止
                if (self.delegate && [self.delegate respondsToSelector:@selector(st_sendButtonTimeEnded:)]) {
                    [self.delegate st_sendButtonTimeEnded:self];
                }
                self.duration = self.saveDuration;
            }
        }
    });
    dispatch_resume(_timer);

}
- (void)st_timerEnd
{
    _timer = nil;
    _isFirstClic = YES;

}
@end
