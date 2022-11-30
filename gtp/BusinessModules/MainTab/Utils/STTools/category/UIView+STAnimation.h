//
//  UIView+STAnimation.h
//  STRich
//
//  Created by stoneobs on 2017/3/7.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STAnimationType) {
    STAnimationTypekCATransitionPush,//推入
    STAnimationTypekCATransitionMoveIn,//移入
    STAnimationTypekCATransitionReveal,//揭开效果
    STAnimationTypekCATransitionFade,//渐入渐出效果
    STAnimationTypecube,//立方体效果
    STAnimationTypesuckEffect,//吮吸 效果
    STAnimationTyperippleEffect,//水波抖动效果
    STAnimationTypeSTpageCurle,// 翻页
    STAnimationTypeSTpageUnCurl,//反翻页
    STAnimationTypeoglFlip,//上下翻转
    STAnimationTypecameraIrisHollowOpen,//镜头打开
    STAnimationTypecameraIrisHollowClose,//镜头关闭
    STAnimationTypeCurlDown,//下翻页
    STAnimationTypeCurlUp,//上翻页
    STAnimationTypeFlipFromLeft,//左翻转
    STAnimationTypeFlipFromRight,//右翻转
};

@interface UIView (STAnimation)

- (void)st_showAnimationWithType:(STAnimationType)type;

- (void)st_showAnimationWithType:(STAnimationType)type duration:(CFTimeInterval) duration;
- (void)st_showCircleRoundAnimationWithKey:(NSString*)key;
@end

