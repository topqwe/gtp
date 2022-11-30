//
//  UIView+STShadow.m
//  STNewTools
//
//  Created by stoneobs on 17/1/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
#define STRGB(v)  [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define ST_firstTextColor       STRGB(0x333333)
#define ST_secendTextColor      STRGB(0x666666)
#define ST_thirdTextColor       STRGB(0x999999)
#define ST_lineColor            STRGB(0xe0e4e5)

#import "UIView+STShadow.h"

@implementation UIView (STShadow)
- (void)st_showTopShadow
{
    self.layer.shadowOffset = CGSizeMake(0, -0.8);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
}
- (void)st_showBottomShadow
{
    self.layer.shadowOffset = CGSizeMake(0, 0.8);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
}
- (void)st_showLeftShadow
{
    self.layer.shadowOffset = CGSizeMake(-1, 0);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
}
- (void)st_showRightShadow
{
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
}
- (void)st_showRightAndBottomShadow
{
    self.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1.0;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
}
//展示周围的layer 到父view
- (CALayer*)st_showRoundLayer{
    CALayer *layer = [CALayer layer];
    layer.frame = self.frame;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.shadowColor =  [UIColor.grayColor colorWithAlphaComponent:0.3].CGColor;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width + 5, self.frame.size.height + 5) cornerRadius:self.layer.cornerRadius].CGPath;
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(-3, -2);
    layer.cornerRadius = self.layer.cornerRadius;
    //这里self表示当前自定义的view
    [self.superview.layer insertSublayer:layer below:self.layer];
    return layer;
}
//展示左右上下线
- (void)st_showRightLine:(CGFloat)height
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 1, 0.8, self.frame.size.height-2)];
    line.backgroundColor = ST_lineColor;
    [self addSubview:line];
    if (height) {
        CGRect frame = line.frame;
        frame.size.height = height;
        line.frame = frame;
        line.center = CGPointMake(line.center.x, self.frame.size.height/2);
    }
}
- (void)st_showRightInsetLine:(CGFloat)height insetx:(CGFloat)insetx{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 1, 0.8, self.frame.size.height-insetx)];
    if (insetx < 0) {
        line.st_right = self.st_width + ABS(insetx);
    }
    line.backgroundColor = ST_lineColor;
    [self addSubview:line];
    if (height) {
        CGRect frame = line.frame;
        frame.size.height = height;
        line.frame = frame;
        line.center = CGPointMake(line.center.x, self.frame.size.height/2);
    }
}
- (void)st_showLeftLine:(CGFloat)height
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 0.8, self.frame.size.height - 2)];
    line.backgroundColor = ST_lineColor;
    [self addSubview:line];
    if (height) {
        CGRect frame = line.frame;
        frame.size.height = height;
        line.frame = frame;
        line.center = CGPointMake(line.center.x, height/2);
    }
}

- (void)st_showBottomLine
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width , 0.5)];
    line.backgroundColor = ST_lineColor;
    [self addSubview:line];
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scroll = (UIScrollView*)self;
        line.frame = CGRectMake(0, self.frame.size.height-1, scroll.contentSize.width , 1);
    }
}
- (void)st_showBottomLineAndWitdh:(CGFloat)witdh{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, witdh , 0.5)];
    line.backgroundColor = ST_lineColor;
    CGPoint center = self.center;
    center.x = self.frame.size.width / 2;
    center.y = self.frame.size.height - 0.5;
    line.center = center;
    [self addSubview:line];
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scroll = (UIScrollView*)self;
        line.frame = CGRectMake(0, self.frame.size.height-1, scroll.contentSize.width , 1);
    }
}
- (void)st_showTopLine
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , 0.5)];
    line.backgroundColor = ST_lineColor;
    [self addSubview:line];
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scroll = (UIScrollView*)self;
        line.frame = CGRectMake(1, self.frame.size.height-1, scroll.contentSize.width - 2, 1);
    }
}
//边框 一般0.3 黑色
- (void)st_setBrderWidth:(CGFloat)width borderColor:(UIColor*)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
}
//展示虚线边框
- (void)st_setDottedLineBrderWidth:(CGFloat)width
                       borderColor:(UIColor*)borderColor{
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = borderColor.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = width;
    //设置线条的样式 //
    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:border];

}
- (void)st_setBorderWith:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
@end
