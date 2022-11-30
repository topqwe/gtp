//
//  PHAnimationLabel.h
//  PregnancyHelper
//
//  Created by mamawang on 15/3/17.
//  Copyright (c) 2015年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalScrollLabel : UIView

@property(nonatomic,strong) UILabel *lbl1;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMutableArray *arrayText;
@property(nonatomic) NSUInteger i;
@property(nonatomic) float randomTimeDur;
-(void)startTimer;
-(void)stopTimer;

@end
