//
//  AnimatiomView.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/26.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleLayer.h"

#import "PHCALayer.h"

@interface AnimatiomView : UIButton

@property (strong, nonatomic) CircleLayer *circleLayer;
@property (strong, nonatomic) PHCALayer *caLayer;
@property (strong, nonatomic) PHCALayer *caLayer1;
@property (strong, nonatomic) PHCALayer *caLayer2;
- (void)addCircleLayer;
- (void)wobbleCircleLayer;
@end
