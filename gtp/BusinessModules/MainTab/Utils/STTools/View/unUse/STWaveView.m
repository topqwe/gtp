//
//  BBHyperbolic.m
//  BBHyperbolicWaveAnimation
//
//  Created by Biao on 16/7/1.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "STWaveView.h"


@interface STWaveView ()

@property (nonatomic,strong) NSTimer * myTimer;
//初始frame
@property (nonatomic,assign) CGRect originFrame;

@property (nonatomic,assign) CGFloat fa;

@property (nonatomic,assign) CGFloat bigNumber;
//高精度刷新
@property(nonatomic, strong) CADisplayLink               *displayLink;
@end

@implementation STWaveView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _originFrame = frame;
        _wavePresent = 1;
        _present = 0.6;
    }
    return self;
}

- (void)createTimer{
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
    self.displayLink.frameInterval = 3;//3倍屏幕刷新的时间 响应一次createTimer
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
- (void)timerAction{
    //让波浪移动效果
    _fa = _fa+10;
    if (_fa >= _originFrame.size.width * 2.0) {
        _fa = 0;
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);

    CGContextSetFillColorWithColor(context, self.waveTopColor.CGColor);
    
    float y= (1 - self.present) * rect.size.height;
    float y1= (1 - self.present) * rect.size.height;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=rect.size.width * 3.0;x++){
        //正弦函数
        y=  sin( x/rect.size.width * M_PI + _fa/rect.size.width *M_PI ) *_bigNumber + (1 - self.present) * rect.size.height ;
        y  = _wavePresent * y;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height );
    CGPathAddLineToPoint(path, nil, 0, rect.size.height );
    // CGPathAddLineToPoint(path, nil, 0, 200);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    //  float y1=200;
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context,self.waveBootomColor.CGColor);
    
    
    //  float y1= 200;
    CGPathMoveToPoint(path1, NULL, 0, y1);
    for(float x=0;x<=rect.size.width;x++){
        
        y1= sin( x/rect.size.width * M_PI + _fa/rect.size.width *M_PI  +M_PI ) *_bigNumber + (1 - self.present) * rect.size.height ;
         y1  = _wavePresent * y1;
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    
    CGPathAddLineToPoint(path1, nil, rect.size.height, rect.size.width );
    CGPathAddLineToPoint(path1, nil, 0, rect.size.height );
    //CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path1);
}


- (void)setPresent:(CGFloat)present{
    _present = present;
    //启动定时器
    [self createTimer];
    //修改波浪的幅度
    if (present <= 0.5) {
        _bigNumber = _originFrame.size.height * 0.1 * present * 2;
    }else{
        _bigNumber = _originFrame.size.height * 0.1 * (1 - present) * 2;
    }
}
- (void)setPresent:(CGFloat)present withAnimation:(BOOL)animation{
    if (!animation) {
        [self setPresent:present];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            [self setPresent:present];
        }];
        [self animationWithFinshPresent:present];
    }
}
- (void)animationWithFinshPresent:(CGFloat)finshPrest{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.present = self.present  + 0.01;
        if (_present <finshPrest) {
            [self animationWithFinshPresent:finshPrest];
        }
    });
}
#pragma mark --Private Method
- (void)pause{
    [self.displayLink invalidate];
    self.displayLink = nil;
}
- (void)begin{
    [self createTimer];
}
@end

