
//
//  PHOvalView.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/26.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHOvalView.h"

@implementation PHOvalView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setup];
    }
    return self;
}

- (void)setup {
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [UIColor colorWithRed: 0.847 green: 0.847 blue: 0.847 alpha: 1].CGColor;
    _shapeLayer.strokeColor = [UIColor colorWithRed: 0.851 green: 0.263 blue: 0.263 alpha: 1].CGColor;
    [self.layer addSublayer:_shapeLayer];
}

//- (void)drawRect:(CGRect)rect {
//    
//    if (!_circleSmallPath) {
//        _circleSmallPath = [UIBezierPath bezierPath];
//        
//        _circleSmallPath.lineCapStyle = kCGLineCapRound; //线条拐角
//        _circleSmallPath.lineJoinStyle = kCGLineCapRound; //终点处理
//        
//        [_circleSmallPath moveToPoint:CGPointMake(0, 0)];
//        
//        [_circleSmallPath addQuadCurveToPoint:CGPointMake(rect.size.width , 0) controlPoint:CGPointMake(rect.size.width * 0.5, rect.size.height*2)];
//        [_circleSmallPath stroke];
//        _shapeLayer.path = _circleSmallPath.CGPath;
//    }
//    
//}

//- (void)drawRect:(CGRect)rect {
//    
//    _circleSmallPath = [UIBezierPath bezierPath];
//    [_circleSmallPath moveToPoint:CGPointMake(0, rect.size.height)];
//    [_circleSmallPath addLineToPoint:CGPointMake(MAINSCREEN_WIDTH, rect.size.height)];
//    [_circleSmallPath addLineToPoint:CGPointMake(MAINSCREEN_WIDTH, rect.size.height * 0.3)];
//    [_circleSmallPath addQuadCurveToPoint:CGPointMake(0, rect.size.height * 0.3) controlPoint:CGPointMake(rect.size.width * 0.5, rect.size.height)];
//    [_circleSmallPath closePath];
//    _shapeLayer.path = _circleSmallPath.CGPath;
//}

- (void)drawRect:(CGRect)rect
{
//    _circleSmallPath = [UIBezierPath bezierPath];
//    
//    
//    [_circleSmallPath moveToPoint:CGPointMake(0, rect.size.height/2)];
//    
//    [_circleSmallPath addCurveToPoint:CGPointMake(rect.size.width/2, rect.size.height) controlPoint1:CGPointMake(rect.size.width, -rect.size.height) controlPoint2:CGPointMake(rect.size.width, rect.size.height/2)];
////    [_circleSmallPath addLineToPoint:CGPointMake(0, rect.size.height/2)];
//    [_circleSmallPath stroke];
    
//    UIBezierPath* oval1Path = UIBezierPath.bezierPath;
//    [oval1Path moveToPoint: CGPointMake(2.26, 12.97)];
//    [oval1Path addCurveToPoint: CGPointMake(12.61, 36.26) controlPoint1: CGPointMake(-1.3, 22.27) controlPoint2: CGPointMake(3.34, 32.7)];
//    [oval1Path addLineToPoint: CGPointMake(12.61, 36.26)];
//    [oval1Path addCurveToPoint: CGPointMake(35.86, 25.89) controlPoint1: CGPointMake(21.89, 39.83) controlPoint2: CGPointMake(32.3, 35.19)];
//    [oval1Path addCurveToPoint: CGPointMake(25.51, 2.6) controlPoint1: CGPointMake(39.43, 16.6) controlPoint2: CGPointMake(34.79, 6.17)];
//    [oval1Path addCurveToPoint: CGPointMake(19.73, 1.48) controlPoint1: CGPointMake(25.51, 2.59) controlPoint2: CGPointMake(22.84, 1.6)];
//    [oval1Path addCurveToPoint: CGPointMake(12.26, 2.86) controlPoint1: CGPointMake(17.06, 1.37) controlPoint2: CGPointMake(14.06, 2.06)];
//    [oval1Path addCurveToPoint: CGPointMake(5.68, 7.42) controlPoint1: CGPointMake(10.51, 3.63) controlPoint2: CGPointMake(7.57, 5.29)];
//    [oval1Path addCurveToPoint: CGPointMake(2.46, 12.82) controlPoint1: CGPointMake(3.48, 9.89) controlPoint2: CGPointMake(2.46, 12.82)];
//    [oval1Path addLineToPoint: CGPointMake(12.03, 28.58)];
//    [oval1Path addLineToPoint: CGPointMake(29.17, 13.42)];
//    _shapeLayer.path = oval1Path.CGPath;
    
    //// Oval-1 Drawing
//    UIBezierPath* oval1Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 1, rect.size.height-50, rect.size.height)];
//
//    [oval1Path fill];
//
//    oval1Path.lineWidth = 1;
//    [oval1Path stroke];
//    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
//    [bezierPath moveToPoint: CGPointMake(85.39, 224.85)];
//    [bezierPath addCurveToPoint: CGPointMake(15.04, 187.05) controlPoint1: CGPointMake(85.39, 224.85) controlPoint2: CGPointMake(34.21, 223.68)];
//    [bezierPath addCurveToPoint: CGPointMake(3.49, 90.45) controlPoint1: CGPointMake(-2.63, 153.29) controlPoint2: CGPointMake(-2.31, 119.24)];
//    [bezierPath addCurveToPoint: CGPointMake(69.64, 2.25) controlPoint1: CGPointMake(9.3, 61.67) controlPoint2: CGPointMake(31.01, 11.91)];
//    [bezierPath addCurveToPoint: CGPointMake(129.5, 20.1) controlPoint1: CGPointMake(108.28, -7.4) controlPoint2: CGPointMake(123.72, 13.45)];
//    [bezierPath addCurveToPoint: CGPointMake(163.1, 95.7) controlPoint1: CGPointMake(135.27, 26.76) controlPoint2: CGPointMake(159.61, 88.72)];
//    [bezierPath addCurveToPoint: CGPointMake(149.45, 205.95) controlPoint1: CGPointMake(166.59, 102.69) controlPoint2: CGPointMake(195.65, 165.98)];
//    [bezierPath addCurveToPoint: CGPointMake(85.39, 224.85) controlPoint1: CGPointMake(149.44, 205.95) controlPoint2: CGPointMake(126.06, 227.01)];
//    [bezierPath closePath];
//    _shapeLayer.path = bezierPath.CGPath;//path-shapeLayer
    

    
}


@end
