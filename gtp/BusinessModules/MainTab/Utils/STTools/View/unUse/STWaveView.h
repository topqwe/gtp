//
//  STWaveView.h
//  BBHyperbolicWaveAnimation
//
//  Created by Mac on 2017/12/15.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <UIKit/UIKit.h>
/************双曲线水波动画******************/
@interface STWaveView : UIView

/**
 曲线颜色
 */
@property(nonatomic, strong) UIColor                     *waveTopColor;
/**
 曲线颜色
 */
@property(nonatomic, strong) UIColor                     *waveBootomColor;
/**
 当前百分比0~1,默认0
 */
@property(nonatomic,assign)  CGFloat present;
/**
 浮动百分比 0~1 默认1
 */
@property(nonatomic,assign)  CGFloat wavePresent;
- (void)pause;
- (void)begin;
- (void)setPresent:(CGFloat)present withAnimation:(BOOL)animation;
@end
