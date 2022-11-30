//
//  PHCALayer.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/30.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "StyleKitName.h"

@interface PHCALayer : CALayer
@property (strong, nonatomic) UIBezierPath *circleBigPath;
@property (strong, nonatomic) UIBezierPath *circleSmallPath;

@property (strong, nonatomic) UIBezierPath *circleVerticalSquishPath;
@property (strong, nonatomic) UIBezierPath *circleHorizontalSquishPath;

- (void)drawPath:(UIBezierPath*)path withCtx:(CGContextRef)ctx;
@end
