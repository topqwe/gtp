//
//  BSLCalendar.m
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "CalendarView.h"
#import "WeeksView.h"
#import "BSLMonthCollectionView.h"
#import "CalendarModel.h"

@interface CalendarView ()

@property (nonatomic, strong)WeeksView *weeks;
@property (nonatomic, strong)BSLMonthCollectionView *dayView;

@end




@implementation CalendarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showChineseCalendar = NO;

        [self bsl_controls];
        
    }
    return self;
}
- (void)setShowChineseCalendar:(BOOL)showChineseCalendar{
    _showChineseCalendar = showChineseCalendar;
    self.dayView.showChineseCalendar = _showChineseCalendar;
}


- (void)selectDateOfMonth:(void (^)(NSInteger, NSInteger, NSInteger))selectBlock{
    [self.dayView setSelectDateBlock:selectBlock];
}
- (void)bsl_controls{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 0;//5
    self.layer.borderWidth = 0;//1
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self addSubview:self.weeks];
    [self addSubview:self.dayView];
    
    __weak typeof(self) weakSelf = self;
    [self.dayView calendarContainerWhereMonth:0 month:^(MonthModel *month) {
        weakSelf.weeks.year = [NSString stringWithFormat:@"%ld-%ld",month.year,month.month];
    }];

    [self.weeks selectMonth:^(BOOL increase) {
       static NSInteger selectNumber = 0;
       static UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCurlUp;
        if (increase) {
            selectNumber = selectNumber + 1;
            animationOption = UIViewAnimationOptionTransitionCurlUp;
        }
        else{
            selectNumber = selectNumber - 1;
            animationOption = UIViewAnimationOptionTransitionCurlDown;

        }
        [UIView transitionWithView:weakSelf.dayView duration:0.8 options:animationOption animations:^{
            [weakSelf.dayView calendarContainerWhereMonth:selectNumber month:^(MonthModel *month) {
                weakSelf.weeks.year = [NSString stringWithFormat:@"%ld-%ld",month.year,month.month];
            }];
        } completion:nil];
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat w = CGRectGetWidth(self.frame);
    self.weeks.frame = CGRectMake(0, 0, w, 90);
    CGFloat dayView_w = CGRectGetWidth(self.weeks.frame);
    CGFloat dayView_h = h - CGRectGetHeight(self.weeks.frame);
    self.dayView.frame = CGRectMake(0, CGRectGetMaxY(self.weeks.frame), dayView_w, dayView_h);
}


- (WeeksView*)weeks{
    if (!_weeks) {
        _weeks = [[WeeksView alloc]initWithFrame:CGRectZero];
        _weeks.backgroundColor = YBGeneralColor.themeColor;
    }
    return _weeks;
}
- (BSLMonthCollectionView *)dayView{
    if (!_dayView) {
        _dayView = [[BSLMonthCollectionView alloc]initWithFrame:CGRectZero];
        _dayView.backgroundColor = [UIColor whiteColor];
    }
    return _dayView;
}
@end

