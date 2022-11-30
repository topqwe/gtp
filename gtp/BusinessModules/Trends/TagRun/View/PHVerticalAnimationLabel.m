//
//  PHAnimationLabel.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHVerticalAnimationLabel.h"

#define FONT_SIZE_LBL 12
@implementation PHVerticalAnimationLabel

@synthesize lbl1,timer,i;
@synthesize arrayText;
@synthesize randomTimeDur;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[ super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.lbl1= [[UILabel alloc] init];
        [self.lbl1 setTextColor:RGBSAMECOLOR(153)];
        [self.lbl1 setFrame:self.frame];
        [self.lbl1 setFont:[UIFont systemFontOfSize:13]];
        [lbl1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lbl1];
        i = 0;
        self.arrayText = [[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withTextFont:(NSInteger)fontSize withTextColor:(UIColor*)color{
    if (self =[ super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.lbl1= [[UILabel alloc] init];
        [self.lbl1 setTextColor:color];
        [self.lbl1 setFrame:self.frame];
        [self.lbl1 setFont:kFontSize(fontSize)];
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
        //MMLog(@"显示标签内容%@",[arrayText objectAtIndex:index]);
    }
    
    self.lbl1.alpha = 0.0;
    
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
         self.lbl1.alpha = 0.0;
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
