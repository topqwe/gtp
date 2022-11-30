//
//  STSegementButton.m
//  lover
//
//  Created by Cymbi on 16/4/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STSegementButton.h"
@interface STSegementButton()

@property(nonatomic,strong)NSMutableArray<UIButton*>        *butArray;
@property(nonatomic,strong)UIView                           *lineView;
@property(nonatomic,copy)STSegementButtonSlectedAction      action;
@property(nonatomic)NSInteger                               selectedNum;
@property(nonatomic,strong)UIScrollView                     *scrollView;
@end
@implementation STSegementButton
-(void)setCureentIndex:(NSInteger)cureentIndex
{
    for (UIButton* but in _butArray) {
        but.selected = NO;
        if (but.tag == cureentIndex) {
            but.selected = YES;
            self.lineSelectedView.center = CGPointMake(but.center.x, self.lineSelectedView.center.y);
        }
       
    }
    _cureentIndex = cureentIndex;
}
- (void)setButtonBackGroundColor:(UIColor *)buttonBackGroundColor{
    _butTitleColor = buttonBackGroundColor;
    for (UIButton* but in _butArray) {
        but.backgroundColor = buttonBackGroundColor;
    }
}
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray *)titles handle:(STSegementButtonSlectedAction)handle
{
    if (self=[super initWithFrame:frame]) {
        self.isShowSpringAnimation = YES;
        self.butArray = [NSMutableArray new];
        if (handle) {
            _action = handle;
        }
        [self initSbviewWithTitles:titles];
    }
    return self;
}
- (void)initSbviewWithTitles:(NSArray *) titles
{
    //布局
    for (int i=0; i < titles.count; i++) {
        UIButton * but =[[UIButton alloc]initWithFrame:CGRectMake(i*self.frame.size.width/titles.count, 2,self.frame.size.width/titles.count , self.frame.size.height-5)];
        if (i == 0) {
            but.selected = YES;
        }
        but.tag = i;
        but.backgroundColor = [UIColor whiteColor];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [but setTitle:titles[i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.butArray addObject:but];
        
        
        [self addSubview:but];
    }
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-3, self.frame.size.width, 3)];
    self.lineView.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineView];
    
    self.lineSelectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, 40, 1)];
    self.lineSelectedView.backgroundColor = [UIColor blackColor];
    self.lineSelectedView.center = CGPointMake(self.frame.size.width/titles.count/2, self.lineSelectedView.center.y);
    [self addSubview:self.lineSelectedView];
    
    self.lineColor = [UIColor whiteColor];
    self.lineSelectedColor = [UIColor orangeColor];
    self.butTitleSelectedColor = [UIColor orangeColor];
    self.butTitleColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];

}
#pragma mark --Getter And Setter
-(void)setLineColor:(UIColor *)lineColor
{
    if (lineColor) {
        self.lineView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
-(void)setLineSelectedColor:(UIColor *)lineSelectedColor
{
    if (lineSelectedColor) {
        _lineSelectedColor = lineSelectedColor;
        self.lineSelectedView.backgroundColor = lineSelectedColor;
    }
}
-(void)setButTitleColor:(UIColor *)butTitleColor
{
    if (butTitleColor) {
        for (int i=0; i<_butArray.count; i++) {
            
            [_butArray[i] setTitleColor:butTitleColor forState:UIControlStateNormal];
            
        }
        _butTitleColor=butTitleColor;
    }
    
    
}
-(void)setButTitleSelectedColor:(UIColor *)butTitleSelectedColor
{
    if (butTitleSelectedColor) {
        _butTitleSelectedColor = butTitleSelectedColor;
        for (int i = 0; i<_butArray.count; i++) {
            
            [_butArray[i] setTitleColor:butTitleSelectedColor forState:UIControlStateSelected];
            
            
        }
    }
}
-(void)clicAction:(STSegementButton*)sender
{
    _cureentIndex = sender.tag;
    if (sender.tag != _selectedNum) {
        sender.selected = !sender.selected;
    }
    
    for (int i=0; i<_butArray.count; i++) {
        if (i != sender.tag) {
            _butArray[i].selected = NO;
        }
    }
    if (self.action) {
        self.action(sender);
        
    }
    _selectedNum = sender.tag;
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
