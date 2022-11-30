//
//  BMSegmentedView.m
//  bigmama
//
//  Created by ganguo on 13-1-29.
//  Copyright (c) 2013年. All rights reserved.
//

#import "BMSegmentedView.h"

#define leftbutton_tag 0
#define rightbutton_tag 1

@implementation BMSegmentedView{
    UIButton *leftButton;
    UIButton *rightButton;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithImage:frame leftBgImg:@"tableft.png" leftSetImg:@"tablefton.png" rightBgImg:@"tabright.png" rightSetImg:@"tabrighton.png"];
}

- (id)initWithImage:(CGRect)frame leftBgImg:(NSString *)leftBgImg leftSetImg:(NSString *)leftSetImg rightBgImg:(NSString *)rightBgImg rightSetImg:(NSString *)rightSetImg{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        // Initialization code
        //leftButton
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundImage:[UIImage imageNamed:leftBgImg] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:leftBgImg] forState:UIControlStateHighlighted];
        [leftButton setBackgroundImage:[UIImage imageNamed:leftSetImg] forState:UIControlStateSelected];
        leftButton.tag = leftbutton_tag;
        [leftButton setTitle:nil forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        [self addSubview:leftButton];
        
        //rightButton
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:[UIImage imageNamed:rightBgImg] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:rightBgImg] forState:UIControlStateHighlighted];
        [rightButton setBackgroundImage:[UIImage imageNamed:rightSetImg] forState:UIControlStateSelected];
        rightButton.tag = rightbutton_tag;
        [rightButton setTitle:nil forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)];
        [self addSubview:rightButton];
    }
    return self;
}


- (void)leftAction:(UIButton *)sender{
    if (leftButton.selected) {
        return;
    }
    sender.selected = YES;
    sender.adjustsImageWhenHighlighted=NO;
    self.currentIndex = leftbutton_tag;
//    if (self.block) {
//        self.block(self.currentIndex);
//    }
    rightButton.selected = NO;
}

- (void)rightAction:(UIButton *)sender{
    if (rightButton.selected) {
        return;
    }
    sender.selected = YES;
    sender.adjustsImageWhenHighlighted=NO;
    self.currentIndex = rightbutton_tag;
//    if (self.block) {
//        self.block(self.currentIndex);
//    }
    leftButton.selected = NO;
}

- (void)setLeftText:(NSString *)leftText{
    leftButton.titleLabel.text = leftText;
    [leftButton setTitle:leftText forState:UIControlStateNormal];
}

- (void)setRightText:(NSString *)rightText{
    [rightButton setTitle:rightText forState:UIControlStateNormal];
}

- (void)setFont:(UIFont *)font{
    leftButton.titleLabel.font = font;
    rightButton.titleLabel.font = font;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (currentIndex == leftbutton_tag) {
        leftButton.selected = YES;
        leftButton.adjustsImageWhenHighlighted=NO;
    }else if (currentIndex == rightbutton_tag){
        rightButton.selected = YES;
        rightButton.adjustsImageWhenHighlighted=NO;
    }
    if (self.block) {
        self.block(currentIndex);
    }

}


-(void)setLeftBtnSelected:(BOOL)isLeft
{
     leftButton.selected = isLeft;
    rightButton.selected = !isLeft;
}

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state{
    [leftButton setTitleColor:titleColor forState:state];
    [rightButton setTitleColor:titleColor forState:state];
}


- (void)setLeftBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [leftButton setBackgroundImage:image forState:state];
}
- (void)setRightBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [rightButton setBackgroundImage:image forState:state];
}

- (void)setLeftImage:(UIImage *)image forState:(UIControlState)state{
    [leftButton setImage:image forState:state];
}
- (void)setRightImage:(UIImage *)image forState:(UIControlState)state{
    [rightButton setImage:image forState:state];
}


@end
