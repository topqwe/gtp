//
//  STSegementButton.m
//  lover
//
//  Created by Cymbi on 16/4/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STSegementAutoView.h"
#define originBeginTag 10000
@interface STSegementAutoView()
@property(nonatomic,strong)NSMutableArray<UIButton*>        *butArray;
@property(nonatomic,strong)UIView                           *lineView;
@property(nonatomic,copy)STSegementAutoViewSlectedAction      action;
@property(nonatomic)NSInteger                               selectedNum;
@property(nonatomic,strong)UIScrollView                     *scrollView;
@property(nonatomic, strong) UIView                     *maskView;/**< <##> */
@end
@implementation STSegementAutoView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray *)titles handle:(STSegementAutoViewSlectedAction)handle
{
    if (self = [super initWithFrame:frame]) {
        self.isShowSpringAnimation = YES;
        self.butArray = [NSMutableArray new];
        if (handle) {
            _action = handle;
        }
        [self initSubViewWithTitles:titles];
    }
    return self;
}
- (void)initSubViewWithTitles:(NSArray *) titles
{
    //布局
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (([UIDevice currentDevice].systemVersion.floatValue > 11.0) && [self.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        [self.scrollView setContentInsetAdjustmentBehavior:@(2)];
    }
    [self addSubview:self.scrollView];
    for (int i = 0; i < titles.count; i++) {
        UIButton * but = [ [UIButton alloc] initWithFrame:CGRectMake(i*self.frame.size.width/titles.count,
                                                                     2,
                                                                     self.frame.size.width/titles.count,
                                                                     self.frame.size.height-5)];
        if (i == 0) {
            but.selected = YES;
        }
        but.tag = i + originBeginTag;
        but.backgroundColor = [UIColor whiteColor];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [but setTitle:titles[i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.butArray addObject:but];
        
        [self.scrollView addSubview:but];
    }
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, self.frame.size.width, 3)];
    self.lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lineView];
    
    self.lineSelectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, 40, 1)];
    self.lineSelectedView.backgroundColor = [UIColor blackColor];
    self.lineSelectedView.center = CGPointMake(self.frame.size.width/titles.count/2, self.lineSelectedView.center.y);
    [self.scrollView addSubview:self.lineSelectedView];
    
    self.lineColor = [UIColor whiteColor];
    self.lineSelectedColor = [UIColor orangeColor];
    self.butTitleSelectedColor = [UIColor orangeColor];
    self.butTitleColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
    //
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [self.layer addSublayer:gradientLayer];
//    gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
//    gradientLayer.colors = @[ (__bridge id)FlatMint.CGColor, (__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor clearColor].CGColor, ];
//    gradientLayer.locations = @[@0.25,@0.5,@0.75];
//    
//    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
//    
//    gradientLayer.endPoint = CGPointMake(1.0f, 0.0f);
    
    // 添加部分
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
//    basicAnimation.fromValue = @[@0, @0, @0.25];
//    basicAnimation.toValue = @[@0.75, @1, @1];
//    basicAnimation.duration = 2.5;
//    basicAnimation.repeatCount = HUGE;
//    [gradientLayer addAnimation:basicAnimation forKey:nil];
//
//    gradientLayer.mask = self.scrollView.layer;
//    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(self.scrollView.contentSize.width/2, 0, self.scrollView.contentSize.width/2, self.scrollView.height)];
//    self.maskView.backgroundColor = UIColor.clearColor;
//    self.scrollView.maskView = self.maskView;
    
}
- (void)layoutSubviews{
    [self.scrollView bringSubviewToFront:self.lineSelectedView];
}
#pragma mark --Getter And Setter
- (void)setCureentIndex:(NSInteger)cureentIndex
{
    for (UIButton* but in _butArray) {
        but.selected = NO;
        if (but.tag - originBeginTag == cureentIndex) {
            but.selected = YES;
            self.lineSelectedView.center = CGPointMake(but.center.x, self.lineSelectedView.center.y);
        }
        
    }
    _cureentIndex = cureentIndex;
}
- (void)setButtonBackGroundColor:(UIColor *)buttonBackGroundColor{
    _buttonBackGroundColor = buttonBackGroundColor;
    for (UIButton* but in _butArray) {
        if (!but.selected) {
             but.backgroundColor = buttonBackGroundColor;
        }
       
    }
}
- (void)setButtonSelctedBackGroundColor:(UIColor *)buttonSelctedBackGroundColor{
    _buttonSelctedBackGroundColor = buttonSelctedBackGroundColor;
    for (UIButton* but in _butArray) {
        if (but.selected) {
            but.backgroundColor = buttonSelctedBackGroundColor;
        }
    }
}
- (void)setLineColor:(UIColor *)lineColor
{
    if (lineColor) {
        self.lineView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
- (void)setLineSelectedColor:(UIColor *)lineSelectedColor
{
    if (lineSelectedColor) {
        _lineSelectedColor = lineSelectedColor;
        self.lineSelectedView.backgroundColor = lineSelectedColor;
    }
}
- (void)setButTitleColor:(UIColor *)butTitleColor
{
    if (butTitleColor) {
        for (int i = 0; i<_butArray.count; i++) {
            
            [_butArray[i] setTitleColor:butTitleColor forState:UIControlStateNormal];
            
        }
        _butTitleColor=butTitleColor;
    }
    
    
}
- (void)setButTitleSelectedColor:(UIColor *)butTitleSelectedColor
{
    if (butTitleSelectedColor) {
        _butTitleSelectedColor = butTitleSelectedColor;
        for (int i = 0; i<_butArray.count; i++) {
            [_butArray[i] setTitleColor:butTitleSelectedColor forState:UIControlStateSelected];
        }
    }
}
- (void)setButonWith:(CGFloat)butonWith{
    _butonWith = butonWith;
    if (butonWith) {
        for (NSInteger i = 0; i < self.butArray.count; i ++) {
            UIButton * button = self.butArray[i];
            CGRect originFram = button.frame;
            button.frame = CGRectMake(i * butonWith, originFram.origin.y, butonWith, originFram.size.height);

        }
        UIButton * button = self.butArray.lastObject;
        CGFloat maxRight = button.frame.size.width + button.frame.origin.x;
        self.scrollView.contentSize = CGSizeMake(maxRight, 0);
        [self setCureentIndex:0];
    }
}
#pragma mark --Action Method
-(void)clicAction:(UIButton*)sender
{
    _cureentIndex = sender.tag - originBeginTag;
    for (int i = 0; i<_butArray.count; i++) {
        UIButton * button = _butArray[i];
        button.selected = NO;
        sender.selected = YES;
        if (button.selected) {
            button.backgroundColor = self.buttonSelctedBackGroundColor;
        }else{
            button.backgroundColor = self.buttonBackGroundColor;
        }
    }
    
    if (self.action) {
        self.action(self,sender);
    }
    
    if (self.butonWith) {
        //判断是否需要滑动 超过 屏幕一半 就滑动到最左边
        CGFloat buttonRight =  sender.frame.size.width + sender.frame.origin.x;
        if (buttonRight > self.width / 2) {
            CGFloat contentoffSetx  =  sender.frame.origin.x ;
            CGFloat maxContentoffSetx  =  self.scrollView.contentSize.width - self.scrollView.frame.size.width ;
            if (contentoffSetx > maxContentoffSetx) {
                contentoffSetx = maxContentoffSetx;
            }
            if (contentoffSetx) {
                [self.scrollView setContentOffset:CGPointMake(contentoffSetx, 0) animated:YES];
            }
        }
    }

    if (!self.autoMoveWithClic) {
        return;
    }
    //动画
    if (self.isShowSpringAnimation) {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.lineSelectedView.center = CGPointMake(sender.center.x, self.lineSelectedView.center.y);
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
    if (!self.isShowSpringAnimation) {
        [UIView animateWithDuration:0.15 animations:^{
            self.lineSelectedView.center = CGPointMake(sender.center.x, self.lineSelectedView.center.y);
        }];
    }
  
}
@end

