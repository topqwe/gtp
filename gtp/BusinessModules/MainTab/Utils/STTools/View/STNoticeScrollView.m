//
//  STNoticeScrollView.m
//  GrapeGold
//
//  Created by Mac on 2018/5/2.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STNoticeScrollView.h"

@interface STNoticeScrollView()<UIScrollViewDelegate>

#define subControlBeginTag   1000
#define titleLableTag        10001
#define timeLableTag         10002
#define item_height             44
#define item_Font             16
@property (nonatomic,strong) UIScrollView            *scrollView;

@property (nonatomic,strong) NSTimer                 *timer;
@end
@implementation STNoticeScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
        self.during = 4;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark --Geter And Seter
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (void)setDataSouce:(NSArray<STNewsModel *> *)dataSouce{
    
    //移除之前View
    [self removeAllControll];
    NSMutableArray * dealArray = [NSMutableArray arrayWithArray:dataSouce];
    if (dealArray.firstObject) {
        [dealArray addObject:dealArray.firstObject];
    }
    _dataSouce = dealArray;
    self.scrollView.contentSize = CGSizeMake(0, item_height * _dataSouce.count);
    [self addAllControll];
    //添加新View
    //如果只有1条，不滚动
    if (dataSouce.count == 1) {
        [self.timer invalidate];
    }
}
- (void)setDuring:(NSInteger)during{
    _during = during;
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:_during target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        //当滑动到最后一个，悄无声息换到第一个
        CGFloat currentContentY = self.scrollView.contentOffset.y;
        if (currentContentY == self.frame.size.height * (_dataSouce.count - 1)) {
            currentContentY = 0;
            [self.scrollView setContentOffset:CGPointMake(0, currentContentY) animated:NO];
        }
    }
    
}
#pragma mark --SubView
- (void)configSubView{
    [self addSubview:self.scrollView];
}
#pragma mark --Private Method
- (void)removeAllControll{
    
    NSInteger beiginNum = subControlBeginTag;
    do {
        UIView * sub = [self viewWithTag:beiginNum];
        [sub removeFromSuperview];
        beiginNum ++;
    } while (beiginNum == subControlBeginTag + _dataSouce.count);
    
}
- (void)addAllControll{
    
    CGFloat biginTop = 0;
    for (int i = subControlBeginTag; i < subControlBeginTag + _dataSouce.count; i++) {
        
        UIControl* control = [self makeControlFromModel:_dataSouce[i - subControlBeginTag]];
        control.st_top = biginTop;
        control.tag = i;
        [self.scrollView addSubview:control];
        biginTop = biginTop + control.st_height;
    }
    
}

- (UIControl*)makeControlFromModel:(STNewsModel*)model{
    
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.st_width - 70, item_height)];
    control.backgroundColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(controlDidClic:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 26, 13)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 3;
    imageView.image = [UIImage imageNamed:@"PMD-1"];
    imageView.st_centerY = control.st_height / 2;
    [control addSubview:imageView];
    
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, 0, self.st_width  ,item_height)
                                                     text:model.title
                                                textColor:FirstTextColor
                                                     font:item_Font
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    titleLable.tag = titleLableTag;
    titleLable.numberOfLines = 1;
    [control addSubview:titleLable];
    
    
    
    return control;
}
- (NSString*)timeStringWithTime:(NSInteger)time{
    
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    NSInteger cha = now - time;
    
    if (cha/3600) {
        return [NSString stringWithFormat:@"%ld小时前",cha/3600];
    }
    return [NSString stringWithFormat:@"%ld分钟前",cha/60];
    
    
}
- (void)updateModelTime{
    
    
    for (int i = subControlBeginTag; i < subControlBeginTag + _dataSouce.count; i++) {
        
        UIControl* control = [self viewWithTag:i];
        
        UILabel * timeLable = [control viewWithTag:timeLableTag];
        
        STNewsModel * model = self.dataSouce[ i - subControlBeginTag];
        
        timeLable.text = [self timeStringWithTime:10];
        
    }
}
#pragma mark --Action Method
- (void)timerAction{
    
    //  [self updateModelTime];
    
    CGFloat currentContentY = self.scrollView.contentOffset.y;
    
    currentContentY = currentContentY + item_height;
    if (currentContentY >= item_height * (_dataSouce.count - 1)) {
        currentContentY = 0;
        
    }
    [self.scrollView setContentOffset:CGPointMake(0, currentContentY) animated:YES];
    
    
}

- (void)controlDidClic:(UIControl*)control{
    
    
    if (self.clicActionHandel) {
        NSInteger index = control.tag - subControlBeginTag;
        STNewsModel * model = self.dataSouce[index];
        self.clicActionHandel(model);
    }
}

@end

@implementation STNewsModel
@end
