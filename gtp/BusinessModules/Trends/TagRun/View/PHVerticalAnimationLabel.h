//
//  PHAnimationLabel.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
@interface PHVerticalAnimationLabel : UIView

@property(nonatomic,strong) UILabel *lbl1;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMutableArray *arrayText;
@property(nonatomic) NSUInteger i;
@property(nonatomic) float randomTimeDur;
-(void)startTimer;
-(void)stopTimer;
-(instancetype)initWithFrame:(CGRect)frame withTextFont:(NSInteger)fontSize withTextColor:(UIColor*)color;
@end
