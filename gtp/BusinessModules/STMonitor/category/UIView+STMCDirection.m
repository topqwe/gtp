//
//  UIView+STMCDirection.m
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import "UIView+STMCDirection.h"

@implementation UIView (STMCDirection)
- (CGFloat)stmc_left {
    return self.frame.origin.x;
}

- (void)setStmc_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)stmc_top {
    return self.frame.origin.y;
}

- (void)setStmc_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)stmc_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setStmc_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)stmc_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setStmc_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)stmc_width {
    return self.frame.size.width;
}

- (void)setStmc_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)stmc_height {
    return self.frame.size.height;
}

- (void)setStmc_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)stmc_origin {
    return self.frame.origin;
}

- (void)setStmc_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)stmc_size {
    return self.frame.size;
}

- (void)setStmc_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setStmc_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)stmc_centerX
{
    return self.center.x;
}

- (void)setStmc_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)stmc_centerY
{
    return self.center.y;
}

- (void)stmc_setBorderWith:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
@end
