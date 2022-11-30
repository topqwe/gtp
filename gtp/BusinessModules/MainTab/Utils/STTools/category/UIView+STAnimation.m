//
//  UIView+STAnimation.m
//  STRich
//
//  Created by stoneobs on 2017/7/7.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "UIView+STAnimation.h"

@implementation UIView (STAnimation)
- (void)st_showAnimationWithType:(STAnimationType)type{
    CATransition * transion = [CATransition new];
    transion.type = [self stringWithType:type];
    transion.duration = 1;
    transion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transion forKey:nil];
}
- (void)st_showAnimationWithType:(STAnimationType)type duration:(CFTimeInterval)duration{
    CATransition * transion = [CATransition new];
    transion.type = [self stringWithType:type];
    transion.duration = duration;
    transion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transion forKey:nil];
}

- (NSString*)stringWithType:(STAnimationType)type{
    if (type == STAnimationTypekCATransitionPush) {
        return @"kCATransitionPush";
    }
    else if (type == STAnimationTypekCATransitionMoveIn){
        return @"kCATransitionMoveIn";
    }
    else if (type == STAnimationTypekCATransitionReveal){
        return @"kCATransitionReveal";
    }
    else if (type == STAnimationTypekCATransitionFade){
        return @"kCATransitionFade";
    }
    else if (type == STAnimationTypecube){
        return @"cube";
    }
    else if (type == STAnimationTypesuckEffect){
        return @"suckEffect";
    }
    else if (type == STAnimationTyperippleEffect){
        return @"rippleEffect";
    }
    else if (type == STAnimationTypeSTpageCurle){
        return @"pageCurl";
    }
    else if (type == STAnimationTypeSTpageUnCurl){
        return @"pageUnCurl";
    }
    else if (type == STAnimationTypeoglFlip){
        return @"oglFlip";
    }
    else if (type == STAnimationTypecameraIrisHollowOpen){
        return @"CameraIrisHollowOpen";
    }
    else if (type == STAnimationTypecameraIrisHollowClose){
        return @"CameraIrisHollowClose";
    }
    else if (type == STAnimationTypeCurlDown){
        return @"CurlDown";
    }
    else if (type == STAnimationTypeCurlUp){
        return @"CurlUp";
    }
    else if (type == STAnimationTypeFlipFromLeft){
        return @"FlipFromLeft";
    }
    else if (type == STAnimationTypeFlipFromRight){
        return @"FlipFromRight";
    }else{
    
        return @"STcameraIrisHollowClose";
    }
}
- (void)st_showCircleRoundAnimationWithKey:(NSString*)key{
    CABasicAnimation *rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    
    rotationAnimation.duration = 3;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    
    if (key) {
        [self.layer addAnimation:rotationAnimation forKey:key];
    }
    
    
}
@end
