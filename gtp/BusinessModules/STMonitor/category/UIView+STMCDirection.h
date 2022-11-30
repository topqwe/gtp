//
//  UIView+STMCDirection.h
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STMCDirection)
@property (nonatomic) CGFloat stmc_left;
@property (nonatomic) CGFloat stmc_top;
@property (nonatomic) CGFloat stmc_right;
@property (nonatomic) CGFloat stmc_bottom;
@property (nonatomic) CGFloat stmc_width;
@property (nonatomic) CGFloat stmc_height;
@property (nonatomic) CGPoint stmc_origin;
@property (nonatomic) CGSize  stmc_size;
@property (nonatomic) CGFloat stmc_centerX;
@property (nonatomic) CGFloat stmc_centerY;

- (void)stmc_setBorderWith:(CGFloat)width
             borderColor:(UIColor *)borderColor
            cornerRadius:(CGFloat)radius;
@end
