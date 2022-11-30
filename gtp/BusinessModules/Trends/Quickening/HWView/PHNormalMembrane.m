//
//  PHNormalMembrane.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/29.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHNormalMembrane.h"

@implementation PHNormalMembrane
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    
//    NSLog(@"...........");
//    
//}
- (void)drawRect:(CGRect)rect
{
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //// Color Declarations
//    UIColor* fillColor = [UIColor colorWithRed: 1 green: 0.431 blue: 0.431 alpha: 1];
//    UIColor* shadow2Color = [UIColor colorWithRed: 0.966 green: 0.942 blue: 0.942 alpha: 1];
//    UIColor* shadow3Color = [UIColor colorWithRed: 0.91 green: 0.319 blue: 0.319 alpha: 1];
//    
//    //// Shadow Declarations
//    NSShadow* shadow2 = [[NSShadow alloc] init];
//    [shadow2 setShadowColor: shadow2Color];
//    [shadow2 setShadowOffset: CGSizeMake(0.1, -0.1)];
//    [shadow2 setShadowBlurRadius: 70];
//    NSShadow* shadow3 = [[NSShadow alloc] init];
//    [shadow3 setShadowColor: shadow3Color];
//    [shadow3 setShadowOffset: CGSizeMake(0.1, -0.1)];
//    [shadow3 setShadowBlurRadius: 18];
//    
//    //// Bezier Drawing
//    _circleNorPath = [self circleNorPath];
//    
//    
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, shadow3.shadowOffset, shadow3.shadowBlurRadius, [shadow3.shadowColor CGColor]);
//    [fillColor setFill];
//    [_circleNorPath fill];
//    
//    ////// Bezier Inner Shadow
//    CGContextSaveGState(context);
//    UIRectClip(_circleNorPath.bounds);
//    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
//    
//    CGContextSetAlpha(context, CGColorGetAlpha([shadow2.shadowColor CGColor]));
//    CGContextBeginTransparencyLayer(context, NULL);
//    {
//        UIColor* opaqueShadow = [shadow2.shadowColor colorWithAlphaComponent: 1];
//        CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [opaqueShadow CGColor]);
//        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
//        CGContextBeginTransparencyLayer(context, NULL);
//        
//        [opaqueShadow setFill];
//        [_circleNorPath fill];
//        
//        CGContextEndTransparencyLayer(context);
//    }
//    CGContextEndTransparencyLayer(context);
//    CGContextRestoreGState(context);
    
    
    //path -CGContext
    
    
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 0.357 blue: 0.537 alpha: 1];
    UIColor* shadowColor2 = [UIColor colorWithRed: 0.98 green: 0.98 blue: 0.98 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: shadowColor2];
    [shadow setShadowOffset: CGSizeMake(-1.1, -0.1)];
    [shadow setShadowBlurRadius: 49];
    
    //// small
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(3.69, 105.88)];
        [bezierPath addCurveToPoint: CGPointMake(62.49, 9.1) controlPoint1: CGPointMake(3.69, 105.88) controlPoint2: CGPointMake(17.52, 32.27)];
        [bezierPath addCurveToPoint: CGPointMake(142.02, 18.41) controlPoint1: CGPointMake(105.34, -12.99) controlPoint2: CGPointMake(135.74, 11.17)];
        [bezierPath addCurveToPoint: CGPointMake(171.34, 72.59) controlPoint1: CGPointMake(146.61, 23.7) controlPoint2: CGPointMake(156.25, 29.28)];
        [bezierPath addCurveToPoint: CGPointMake(196.53, 137.63) controlPoint1: CGPointMake(186.42, 115.89) controlPoint2: CGPointMake(192.42, 121.93)];
        [bezierPath addCurveToPoint: CGPointMake(192.76, 209.4) controlPoint1: CGPointMake(200.65, 153.33) controlPoint2: CGPointMake(202.88, 185.77)];
        [bezierPath addCurveToPoint: CGPointMake(103.11, 259.87) controlPoint1: CGPointMake(182.65, 233.04) controlPoint2: CGPointMake(158.99, 257.19)];
        [bezierPath addCurveToPoint: CGPointMake(7.63, 194.05) controlPoint1: CGPointMake(47.23, 262.54) controlPoint2: CGPointMake(17.23, 224.66)];
        [bezierPath addCurveToPoint: CGPointMake(3.69, 105.88) controlPoint1: CGPointMake(1.55, 174.64) controlPoint2: CGPointMake(-3.85, 157.13)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor setFill];
        [bezierPath fill];
        
        ////// Bezier Inner Shadow
        CGContextSaveGState(context);
        UIRectClip(bezierPath.bounds);
        CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
        
        CGContextSetAlpha(context, CGColorGetAlpha([shadow.shadowColor CGColor]));
        CGContextBeginTransparencyLayer(context, NULL);
        {
            UIColor* opaqueShadow = [shadow.shadowColor colorWithAlphaComponent: 1];
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
            CGContextSetBlendMode(context, kCGBlendModeSourceOut);
            CGContextBeginTransparencyLayer(context, NULL);
            
            [opaqueShadow setFill];
            [bezierPath fill];
            
            CGContextEndTransparencyLayer(context);
        }
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
        
        [color2 setStroke];
        bezierPath.lineWidth = 0;
        [bezierPath stroke];
    }

    
    
    
}

- (UIBezierPath *)circleNorPath {
    if (!_circleNorPath) {
        _circleNorPath = UIBezierPath.bezierPath;
        [_circleNorPath moveToPoint: CGPointMake(94.63, 213.74)];
        [_circleNorPath addCurveToPoint: CGPointMake(35.66, 182.05) controlPoint1: CGPointMake(94.63, 213.74) controlPoint2: CGPointMake(51.73, 212.76)];
        [_circleNorPath addCurveToPoint: CGPointMake(25.98, 101.06) controlPoint1: CGPointMake(20.85, 153.74) controlPoint2: CGPointMake(21.11, 125.19)];
        [_circleNorPath addCurveToPoint: CGPointMake(81.43, 27.1) controlPoint1: CGPointMake(30.85, 76.92) controlPoint2: CGPointMake(49.05, 35.2)];
        [_circleNorPath addCurveToPoint: CGPointMake(131.59, 42.07) controlPoint1: CGPointMake(113.81, 19.01) controlPoint2: CGPointMake(126.75, 36.49)];
        [_circleNorPath addCurveToPoint: CGPointMake(159.76, 105.46) controlPoint1: CGPointMake(136.43, 47.65) controlPoint2: CGPointMake(156.83, 99.6)];
        [_circleNorPath addCurveToPoint: CGPointMake(148.31, 197.89) controlPoint1: CGPointMake(162.68, 111.32) controlPoint2: CGPointMake(187.04, 164.38)];
        [_circleNorPath addCurveToPoint: CGPointMake(94.63, 213.74) controlPoint1: CGPointMake(148.31, 197.9) controlPoint2: CGPointMake(128.72, 215.55)];
        [_circleNorPath closePath];
        _circleNorPath.miterLimit = 4;
    }
    return _circleNorPath;
}
@end
