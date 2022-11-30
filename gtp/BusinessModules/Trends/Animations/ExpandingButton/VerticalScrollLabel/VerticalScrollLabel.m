//
//  PHAnimationLabel.m
//  PregnancyHelper
//
//  Created by mamawang on 15/3/17.
//  Copyright (c) 2015年 ShengCheng. All rights reserved.
//

#import "VerticalScrollLabel.h"

#define FONT_SIZE_LBL 15
@implementation VerticalScrollLabel

@synthesize lbl1,timer,i;
@synthesize arrayText;
@synthesize randomTimeDur;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[ super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.lbl1= [[UILabel alloc] init];
        [self.lbl1 setTextColor:[UIColor redColor]];
        [self.lbl1 setFrame:self.frame];
        [self.lbl1 setFont:[UIFont systemFontOfSize:FONT_SIZE_LBL]];
        [lbl1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lbl1];
        i = 0;
        self.arrayText = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)startTimer
{
    self.randomTimeDur = (arc4random() % 2) + 1.8 +2;
    timer = [NSTimer scheduledTimerWithTimeInterval:randomTimeDur/1.0 -0.2 target:self selector:@selector(animationView) userInfo:nil repeats:YES];
    //立即触发定时器
    [timer fire];
}


-(void)animationView
{
    NSInteger count = [self.arrayText count];
    if (count >1) {
        NSInteger t = i % count;
        [self animationWithIndex:t];
        i++;
    }else if(count == 1)
    {
        [self.lbl1 setFrame:self.bounds];
        [self.lbl1 setText:[arrayText objectAtIndex:0]];
        self.lbl1.alpha = 1.0;
    }else
    {
        [self.lbl1 setText:@""];
    }
    
}

-(void) animationWithIndex:(NSUInteger) index
{
    //MMLog(@"index is %i",index);
    [self.lbl1 setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    if (index <[arrayText count]) {
        [self.lbl1 setText:[arrayText objectAtIndex:index]];
//        NSLog(@"显示标签内容%@",arrayText[index]);
    }
    
    self.lbl1.alpha = 0.5;
    
    [UIView animateWithDuration:(randomTimeDur - 1.8)/2.0 animations:^
     {
         
         [self.lbl1 setFrame:self.bounds];
         self.lbl1.alpha = 1;
         
     }
                     completion:^(BOOL finished)
     {
         [self performSelector:@selector(secondAnimationWithDur) withObject:nil afterDelay:2];
         
     }];
    
}

- (void)secondAnimationWithDur
{
    [UIView animateWithDuration:(randomTimeDur -1.8)/2.0 animations:^
     {
         [self.lbl1  setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
         self.lbl1.alpha = 0.5;
     }
                     completion:^(BOOL finished)
     {
         
     }];
    
}

-(void)stopTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [self.lbl1 setText:@""];
}


@end
