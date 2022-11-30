//
//  CircleLayer.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/26.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "StyleKitName.h"
@interface CircleLayer : CAShapeLayer
@property (strong, nonatomic) UIBezierPath *circleBigPath;
@property (strong, nonatomic) UIBezierPath *circleSmallPath;

@property (strong, nonatomic) UIBezierPath *circleVerticalSquishPath;
@property (strong, nonatomic) UIBezierPath *circleHorizontalSquishPath;
/**
 *  Wobble group animation
 */
- (void)wobbleAnimation;

/**
 *  Expend animation for circle layer
 */
- (void)expand;





- (UIBezierPath *)circleBigPath;

- (void)drawPath:(UIBezierPath*)path withCtx:(CGContextRef)ctx;
@end
