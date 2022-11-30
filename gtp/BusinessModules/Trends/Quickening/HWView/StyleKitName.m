//
//  StyleKitName.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/29.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "StyleKitName.h"


@implementation StyleKitName

#pragma mark Cache

static UIColor* _gradient2Color = nil;
static UIColor* _gradient3Color = nil;

static PCGradient* _gradient2 = nil;
static PCGradient* _gradient3 = nil;

#pragma mark Initialization

+ (void)initialize
{
    // Colors Initialization
    _gradient2Color = [UIColor colorWithRed: 0.873 green: 0.17 blue: 0.17 alpha: 1];
    _gradient3Color = [UIColor colorWithRed: 1 green: 0.27 blue: 0.535 alpha: 1];
    
    // Gradients Initialization
    CGFloat gradient2Locations[] = {0, 0, 1};
    _gradient2 = [PCGradient gradientWithColors: @[StyleKitName.gradient2Color, [StyleKitName.gradient2Color blendedColorWithFraction: 0.5 ofColor: UIColor.whiteColor], UIColor.whiteColor] locations: gradient2Locations];
    CGFloat gradient3Locations[] = {0, 0, 1};
    _gradient3 = [PCGradient gradientWithColors: @[StyleKitName.gradient3Color, [StyleKitName.gradient3Color blendedColorWithFraction: 0.5 ofColor: UIColor.whiteColor], UIColor.whiteColor] locations: gradient3Locations];
    
}

#pragma mark Colors

+ (UIColor*)gradient2Color { return _gradient2Color; }
+ (UIColor*)gradient3Color { return _gradient3Color; }

#pragma mark Gradients

+ (PCGradient*)gradient2 { return _gradient2; }
+ (PCGradient*)gradient3 { return _gradient3; }

//// In trial version of PaintCode, the code generation is limited to one canvas

#pragma mark Drawing Methods

//// PaintCode Trial Version
//// www.paintcodeapp.com

+ (void)drawGroupYue1Canvas
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(71.63, 188.74)];
    [bezierPath addCurveToPoint: CGPointMake(12.66, 157.05) controlPoint1: CGPointMake(71.63, 188.74) controlPoint2: CGPointMake(28.73, 187.76)];
    [bezierPath addCurveToPoint: CGPointMake(2.98, 76.06) controlPoint1: CGPointMake(-2.15, 128.74) controlPoint2: CGPointMake(-1.89, 100.19)];
    [bezierPath addCurveToPoint: CGPointMake(58.43, 2.1) controlPoint1: CGPointMake(7.85, 51.92) controlPoint2: CGPointMake(26.05, 10.2)];
    [bezierPath addCurveToPoint: CGPointMake(108.59, 17.07) controlPoint1: CGPointMake(90.81, -5.99) controlPoint2: CGPointMake(103.75, 11.49)];
    [bezierPath addCurveToPoint: CGPointMake(136.76, 80.46) controlPoint1: CGPointMake(113.43, 22.65) controlPoint2: CGPointMake(133.83, 74.6)];
    [bezierPath addCurveToPoint: CGPointMake(125.31, 172.89) controlPoint1: CGPointMake(139.68, 86.32) controlPoint2: CGPointMake(164.04, 139.38)];
    [bezierPath addCurveToPoint: CGPointMake(71.63, 188.74) controlPoint1: CGPointMake(125.31, 172.9) controlPoint2: CGPointMake(105.72, 190.55)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    CGContextSaveGState(context);
    [bezierPath addClip];
    CGContextDrawLinearGradient(context, StyleKitName.gradient3.CGGradient, CGPointMake(73.5, -0), CGPointMake(73.5, 188.87), 0);
    CGContextRestoreGState(context);
}

@end



@interface PCGradient ()
{
    CGGradientRef _CGGradient;
}
@end

@implementation PCGradient

- (instancetype)initWithColors: (NSArray*)colors locations: (const CGFloat*)locations
{
    self = super.init;
    if (self)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray* cgColors = NSMutableArray.array;
        for (UIColor* color in colors)
            [cgColors addObject: (id)color.CGColor];
        
        _CGGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, locations);
        CGColorSpaceRelease(colorSpace);
    }
    return self;
}

+ (instancetype)gradientWithColors: (NSArray*)colors locations: (const CGFloat*)locations
{
    return [self.alloc initWithColors: colors locations: locations];
}

+ (instancetype)gradientWithStartingColor: (UIColor*)startingColor endingColor: (UIColor*)endingColor
{
    CGFloat locations[] = {0, 1};
    return [self.alloc initWithColors: @[startingColor, endingColor] locations: locations];
}

- (void)dealloc
{
    CGGradientRelease(_CGGradient);
}

@end



@implementation UIColor (PaintCodeAdditions)

- (UIColor*)blendedColorWithFraction: (CGFloat)fraction ofColor: (UIColor*)color2
{
    UIColor* color1 = self;
    
    CGFloat r1 = 0, g1 = 0, b1 = 0, a1 = 0;
    CGFloat r2 = 0, g2 = 0, b2 = 0, a2 = 0;
    
    
    [color1 getRed: &r1 green: &g1 blue: &b1 alpha: &a1];
    [color2 getRed: &r2 green: &g2 blue: &b2 alpha: &a2];
    
    CGFloat r = r1 * (1 - fraction) + r2 * fraction;
    CGFloat g = g1 * (1 - fraction) + g2 * fraction;
    CGFloat b = b1 * (1 - fraction) + b2 * fraction;
    CGFloat a = a1 * (1 - fraction) + a2 * fraction;
    
    return [UIColor colorWithRed: r green: g blue: b alpha: a];
}

@end

