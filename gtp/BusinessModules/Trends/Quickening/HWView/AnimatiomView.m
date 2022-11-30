//
//  AnimatiomView.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/26.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "AnimatiomView.h"

@interface AnimatiomView ()

@end
//static const NSTimeInterval KAnimationDuration = 1;
//static const NSTimeInterval KAnimationBeginTime = 0.0;
@implementation AnimatiomView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addCircleLayer];
//        [self initCALayer];
    }
    return self;
}

- (CircleLayer *)circleLayer {
    if (!_circleLayer) {
        
        _circleLayer = [[CircleLayer alloc] init];
    }
    
    return _circleLayer;
}
- (void)addCircleLayer {
    
    [_circleLayer setNeedsDisplay];
    
    [self.layer addSublayer:self.circleLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(wobbleCircleLayer) userInfo:nil repeats:NO];
}
- (void)wobbleCircleLayer {
    [_circleLayer wobbleAnimation];
}


- (void)initCALayer{
    _caLayer = [[PHCALayer alloc]init];

//    _caLayer.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _caLayer.position=CGPointMake(160,284);
//    _caLayer.backgroundColor = [UIColor blackColor].CGColor;
    [_caLayer setNeedsDisplay];
    [self.layer addSublayer:_caLayer];
    
    _caLayer1 = [[PHCALayer alloc]init];
    [_caLayer1 setNeedsDisplay];
    [self.layer addSublayer:_caLayer1];
    
    _caLayer2 = [[PHCALayer alloc]init];
    [_caLayer2 setNeedsDisplay];
    [self.layer addSublayer:_caLayer2];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(wobbleCircleLayer) userInfo:nil repeats:NO];
}
//- (void)wobbleCircleLayer {
//    //    1
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
//    animation1.fromValue = (__bridge id _Nullable)([_caLayer circleBigPath].CGPath);
//    animation1.toValue = (__bridge id _Nullable)([_caLayer1 circleVerticalSquishPath].CGPath);
//    animation1.beginTime = KAnimationBeginTime;
//    animation1.duration = KAnimationDuration;
//    //    2
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
//    animation2.fromValue = (__bridge id _Nullable)([_caLayer1 circleVerticalSquishPath].CGPath);
//    animation2.toValue = (__bridge id _Nullable)([_caLayer2 circleHorizontalSquishPath].CGPath);
//    animation2.beginTime = animation1.beginTime + animation1.duration;
//    animation2.duration = KAnimationDuration;
//    //    3
//    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"path"];
//    animation3.fromValue = (__bridge id _Nullable)([_caLayer2 circleHorizontalSquishPath].CGPath);
//    animation3.toValue = (__bridge id _Nullable)([_caLayer1 circleVerticalSquishPath].CGPath);
//    animation3.beginTime = animation2.beginTime + animation2.duration;
//    animation3.duration = KAnimationDuration;
//    //    4
//    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"path"];
//    animation4.fromValue = (__bridge id _Nullable)([_caLayer1 circleVerticalSquishPath].CGPath);
//    animation4.toValue = (__bridge id _Nullable)([_caLayer circleBigPath].CGPath);
//    animation4.beginTime = animation3.beginTime + animation3.duration;
//    animation4.duration = KAnimationDuration;
//    //    5
//    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
//    animationGroup.animations = @[animation1, animation2, animation3, animation4];
//    animationGroup.duration = 4 * KAnimationDuration;
//    animationGroup.repeatCount = HUGE_VALF;
//    [_caLayer addAnimation:animationGroup forKey:nil];
////    self.path = _circleBigPath.CGPath;
//}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"1-drawLayer:inContext:");
    NSLog(@"CGContext:%@",ctx);
    [super drawLayer:layer inContext:ctx];
//    if (layer == _caLayer) {
//        [_caLayer drawPath:_caLayer.circleBigPath withCtx:ctx];
//    }else if (layer == _caLayer1){
//        [_caLayer drawPath:_caLayer.circleVerticalSquishPath withCtx:ctx];
//    }else if (layer == _caLayer2){
//        [_caLayer drawPath:_caLayer.circleHorizontalSquishPath withCtx:ctx];
//    }
    
}
-(void)drawRect:(CGRect)rect{
    NSLog(@"2-drawRect:");
    NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递的
    [super drawRect:rect];
    
    
//     CGContextRef ctx = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(ctx);
//    //图形上下文形变，解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    UIImage *image=[UIImage imageNamed:@"photo1"];
//    CGContextTranslateCTM(ctx, 0, -image.size.height);
//    
//    //注意这个位置是相对于图层而言的不是屏幕
//    CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
//    
//    UIGraphicsPopContext();
    
}
@end
