//
//  STSendButton.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  发送验证码button，可以倒计时
#import <UIKit/UIKit.h>
@protocol STSendButtonDlegate <NSObject>

/**
 将要点击，可判断一系列状态

 @param button button description
 @return return 返回yes 响应点击事件，返回NO，不响应
 */
- (BOOL)st_sendButtonWillClic:(UIButton*)button;
/**
 点击按钮

 @param button 按钮
 @param isFirstClic 是否是第一次点击
 @param duration  时间
 */
- (void)st_sendButtonDidClic:(UIButton*)button isFirstClic:(BOOL)isFirstClic duration:(NSInteger)duration;

/**
 正在倒计时，此时可以使用关闭按钮交互，并且title 随动

 @param button 按钮
 @param duration 当前剩余时间
 */
- (void)st_sendButtonDidCountdown:(UIButton*)button duration:(NSInteger)duration;

/**
 设置的时间已经结束

 @param button 倒计时按钮
 */
- (void)st_sendButtonTimeEnded:(UIButton*)button;
@end
#import <UIKit/UIKit.h>
@interface STSendButton : UIButton
@property(nonatomic,assign)NSInteger            duration;//时间
@property(nonatomic,weak)id<STSendButtonDlegate>            delegate;
- (instancetype)initWithFrame:(CGRect)frame andWithDuration:(NSInteger)duration;
- (void)st_timerBegin;//手动开始 开始之后 isFirstClic = NO
- (void)st_timerEnd;//手动结束 isFirstClic = yes
@end

