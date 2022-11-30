//
//  PHCALayer.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/30.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHCALayer.h"

@implementation PHCALayer
//-(void)drawInContext:(CGContextRef)ctx{
//    NSLog(@"3-drawInContext:");
//    NSLog(@"CGContext:%@",ctx);
//    
////    [self drawPath:[self circleBigPath] withCtx:ctx];
////    [self drawPath:[self circleVerticalSquishPath] withCtx:ctx];
////    [self drawPath:[self circleHorizontalSquishPath] withCtx:ctx];
//}

- (void)drawPath:(UIBezierPath*)path withCtx:(CGContextRef)ctx{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 0.431 blue: 0.431 alpha: 1];
    UIColor* shadow2Color = [UIColor colorWithRed: 0.966 green: 0.942 blue: 0.942 alpha: 1];
    UIColor* shadow3Color = [UIColor colorWithRed: 0.91 green: 0.319 blue: 0.319 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow2 = [[NSShadow alloc] init];
    [shadow2 setShadowColor: shadow2Color];
    [shadow2 setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow2 setShadowBlurRadius: 70];
    NSShadow* shadow3 = [[NSShadow alloc] init];
    [shadow3 setShadowColor: shadow3Color];
    [shadow3 setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow3 setShadowBlurRadius: 18];
    
    //// Bezier Drawing
    //    _circleHorizontalSquishPath = [self circleHorizontalSquishPath];
    
    UIGraphicsPushContext(ctx);
    CGContextSetShadowWithColor(ctx, shadow3.shadowOffset, shadow3.shadowBlurRadius, [shadow3.shadowColor CGColor]);
    [fillColor setFill];
    [path fill];
    
    ////// Bezier Inner Shadow
    UIGraphicsPushContext(ctx);
    UIRectClip(path.bounds);
    CGContextSetShadowWithColor(ctx, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(ctx, CGColorGetAlpha([shadow2.shadowColor CGColor]));
    CGContextBeginTransparencyLayer(ctx, NULL);
    {
        UIColor* opaqueShadow = [shadow2.shadowColor colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(ctx, shadow2.shadowOffset, shadow2.shadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(ctx, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(ctx, NULL);
        
        [opaqueShadow setFill];
        [path fill];
        
        CGContextEndTransparencyLayer(ctx);
    }
    CGContextEndTransparencyLayer(ctx);
    UIGraphicsPopContext();
    
    
}
- (UIBezierPath *)circleBigPath {
    if (!_circleBigPath) {
        
        _circleBigPath = UIBezierPath.bezierPath;
        [_circleBigPath moveToPoint: CGPointMake(94.63, 213.74)];
        [_circleBigPath addCurveToPoint: CGPointMake(35.66, 182.05) controlPoint1: CGPointMake(94.63, 213.74) controlPoint2: CGPointMake(51.73, 212.76)];
        [_circleBigPath addCurveToPoint: CGPointMake(25.98, 101.06) controlPoint1: CGPointMake(20.85, 153.74) controlPoint2: CGPointMake(21.11, 125.19)];
        [_circleBigPath addCurveToPoint: CGPointMake(81.43, 27.1) controlPoint1: CGPointMake(30.85, 76.92) controlPoint2: CGPointMake(49.05, 35.2)];
        [_circleBigPath addCurveToPoint: CGPointMake(131.59, 42.07) controlPoint1: CGPointMake(113.81, 19.01) controlPoint2: CGPointMake(126.75, 36.49)];
        [_circleBigPath addCurveToPoint: CGPointMake(159.76, 105.46) controlPoint1: CGPointMake(136.43, 47.65) controlPoint2: CGPointMake(156.83, 99.6)];
        [_circleBigPath addCurveToPoint: CGPointMake(148.31, 197.89) controlPoint1: CGPointMake(162.68, 111.32) controlPoint2: CGPointMake(187.04, 164.38)];
        [_circleBigPath addCurveToPoint: CGPointMake(94.63, 213.74) controlPoint1: CGPointMake(148.31, 197.9) controlPoint2: CGPointMake(128.72, 215.55)];
        [_circleBigPath closePath];
        _circleBigPath.miterLimit = 4;
        
        
    }
    return _circleBigPath;
}
- (UIBezierPath *)circleVerticalSquishPath {
    if (!_circleVerticalSquishPath) {
        _circleVerticalSquishPath = UIBezierPath.bezierPath;
        [_circleVerticalSquishPath moveToPoint: CGPointMake(94.63, 201.89)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(35.66, 174.2) controlPoint1: CGPointMake(94.63, 201.89) controlPoint2: CGPointMake(51.73, 201.02)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(25.98, 103.44) controlPoint1: CGPointMake(20.85, 149.47) controlPoint2: CGPointMake(21.11, 124.53)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(81.43, 38.84) controlPoint1: CGPointMake(30.85, 82.36) controlPoint2: CGPointMake(49.05, 45.91)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(131.59, 51.91) controlPoint1: CGPointMake(113.81, 31.76) controlPoint2: CGPointMake(126.75, 47.04)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(159.76, 107.29) controlPoint1: CGPointMake(136.43, 56.79) controlPoint2: CGPointMake(156.83, 102.17)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(148.31, 188.04) controlPoint1: CGPointMake(162.68, 112.41) controlPoint2: CGPointMake(187.04, 158.76)];
        [_circleVerticalSquishPath addCurveToPoint: CGPointMake(94.63, 201.89) controlPoint1: CGPointMake(148.31, 188.04) controlPoint2: CGPointMake(128.72, 203.47)];
        [_circleVerticalSquishPath closePath];
        _circleVerticalSquishPath.miterLimit = 4;
        
    }
    return _circleVerticalSquishPath;
}
- (UIBezierPath *)circleHorizontalSquishPath {
    if (!_circleHorizontalSquishPath) {
        _circleHorizontalSquishPath = UIBezierPath.bezierPath;
        [_circleHorizontalSquishPath moveToPoint: CGPointMake(94.78, 220.86)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(40.63, 186.12) controlPoint1: CGPointMake(94.78, 220.86) controlPoint2: CGPointMake(55.38, 219.78)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(31.74, 97.36) controlPoint1: CGPointMake(27.03, 155.09) controlPoint2: CGPointMake(27.27, 123.81)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(82.66, 16.31) controlPoint1: CGPointMake(36.21, 70.9) controlPoint2: CGPointMake(52.92, 25.18)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(128.73, 32.71) controlPoint1: CGPointMake(112.4, 7.43) controlPoint2: CGPointMake(124.28, 26.6)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(154.59, 102.18) controlPoint1: CGPointMake(133.18, 38.82) controlPoint2: CGPointMake(151.91, 95.76)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(144.09, 203.49) controlPoint1: CGPointMake(157.28, 108.6) controlPoint2: CGPointMake(179.65, 166.76)];
        [_circleHorizontalSquishPath addCurveToPoint: CGPointMake(94.78, 220.86) controlPoint1: CGPointMake(144.09, 203.49) controlPoint2: CGPointMake(126.09, 222.84)];
        [_circleHorizontalSquishPath closePath];
        _circleHorizontalSquishPath.miterLimit = 4;
        
    }
    return _circleHorizontalSquishPath;
}
@end
