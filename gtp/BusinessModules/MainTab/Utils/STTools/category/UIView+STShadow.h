//
//  UIView+STShadow.h
//  STNewTools
//
//  Created by stoneobs on 17/1/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
//  说明：此扩展是展示shadow 的方法，还有常见按钮右边➕竖线

#import <UIKit/UIKit.h>

@interface UIView (STShadow)
//展示4种阴影
- (void)st_showTopShadow;
- (void)st_showBottomShadow;
- (void)st_showLeftShadow;
- (void)st_showRightShadow;
- (void)st_showRightAndBottomShadow;
//展示各种线条
- (void)st_showRightLine:(CGFloat)height;
- (void)st_showRightInsetLine:(CGFloat)height insetx:(CGFloat)insetx;
- (void)st_showLeftLine:(CGFloat)height;
- (void)st_showBottomLine;
- (void)st_showBottomLineAndWitdh:(CGFloat)witdh;
- (void)st_showTopLine;

//展示周围的layer 到父view
- (CALayer*)st_showRoundLayer;

//展示边框 一般0.3 黑色
- (void)st_setBrderWidth:(CGFloat)width
             borderColor:(UIColor*)borderColor;
//展示虚线边框 如果frame 改变 则需要重新设置
- (void)st_setDottedLineBrderWidth:(CGFloat)width
                       borderColor:(UIColor*)borderColor;

- (void)st_setBorderWith:(CGFloat)width
             borderColor:(UIColor *)borderColor
            cornerRadius:(CGFloat)radius;
@end
