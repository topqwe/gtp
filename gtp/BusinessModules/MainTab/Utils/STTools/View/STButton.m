//
//  STButton.m
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STButton.h"
#import "UIResponder+STFeedbackGenerator.h"
#define roundBackViewTag  23423523525
@interface STButton()
@property(nonatomic, strong) UILabel                     *badgeValueLable;
@property(nonatomic, strong) CALayer                     *shadowLayer;/**< 阴影 */
@end

@implementation STButton
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    UIView * view = self.superview;
    UIView * editView = [view viewWithTag:roundBackViewTag];
    editView.center = self.center;
}
- (instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)titlecolor
                   titleFont:(CGFloat)fontsize
                cornerRadius:(CGFloat)radius
             backgroundColor:(UIColor *)backcolor
             backgroundImage:(UIImage *)backgroundimage
                       image:(UIImage *)image
{
    if (self == [super init]) {
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontsize]];
        self.layer.cornerRadius = radius;
        self.clipsToBounds = YES;
        self.backgroundColor = backcolor;
         self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setBackgroundImage:backgroundimage forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark --Get and Setter
- (void)setShowCloseButton:(BOOL)showCloseButton
{
    if (showCloseButton) {
        UIView  *view = [self viewWithTag:9998];
        [view removeFromSuperview];
        UIButton * closeButton =[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 0, 20, 20)];
        [closeButton setTitle:@"—" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeButton.backgroundColor = UIColor.redColor;
        closeButton.titleLabel.font = [UIFont systemFontOfSize:10];
        closeButton.layer.cornerRadius = 10;
        closeButton.tag = 9998;
        closeButton.clipsToBounds = YES;
        self.clipsToBounds = NO;
        [self bringSubviewToFront:closeButton];
        [closeButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        self.closeButton = closeButton;
    } else {
        UIView  *view = [self viewWithTag:9998];
        [view removeFromSuperview];
    }
    _showCloseButton = showCloseButton;
}
//添加badgeValue
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    if (badgeValue.length) {
        if (badgeValue.length > 2) {
            badgeValue = @"99";
        }
        if (!self.badgeValueLable) {
            UILabel * badgeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 14)];
            badgeLable.backgroundColor = [UIColor redColor];
            badgeLable.clipsToBounds = YES;
            badgeLable.layer.cornerRadius = 7;
            badgeLable.textColor = [UIColor whiteColor];
            badgeLable.font = [UIFont systemFontOfSize:8];
            badgeLable.textAlignment = NSTextAlignmentCenter;
            badgeLable.left = self.imageView.right - 6;
            badgeLable.bottom = self.imageView.top + 6;
            badgeLable.text = badgeValue;
            self.badgeValueLable = badgeLable;
            [self addSubview:self.badgeValueLable];
        }
        self.badgeValueLable.text = badgeValue;
        self.badgeValueLable.hidden = NO;
        if (badgeValue.integerValue == 0) {
            self.badgeValueLable.hidden = YES;
        }
        [self.badgeValueLable st_showAnimationWithType:STAnimationTypekCATransitionReveal duration:0.25];
    }
}


- (void)setClicAction:(STButtonTouchAction)clicAction
{
    if (clicAction) {
        _clicAction = clicAction;
    }
}
- (void)clicAction:(UIButton*)sender
{
    if (self.clicAction) {
        [self st_showImpactFeedbackGenerator:UIImpactFeedbackStyleLight];
        self.clicAction(sender);
    }
}
#pragma mark --Public Method
- (void)showRoundShadow{
    if (!self.superview) {
        //return;
    }
    CALayer *layer = [CALayer layer];
    layer.frame = self.frame;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.shadowColor = [UIColor grayColor].CGColor;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width + 5, self.frame.size.height + 5) cornerRadius:52.5].CGPath;
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(-3, -2);
    layer.cornerRadius = 3;
    //这里self表示当前自定义的view
    [self.superview.layer insertSublayer:layer below:self.layer];
}
- (void)hideRoundShadowLayer{
    [self.shadowLayer removeFromSuperlayer];
}
- (void)letImageViewAsright:(CGFloat)insetX
{
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    self.titleLabel.backgroundColor = self.titleLabel.backgroundColor;
    self.imageView.backgroundColor = self.imageView.backgroundColor;
    CGSize titleSize = self.titleLabel.bounds.size;
    CGFloat interval = insetX;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
}
- (void)makeImageRight{
    UIImage * image = self.imageView.image;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}
#pragma mark --selected Action
- (void)removeSelf
{
    if (self.closeAction) {
        self.closeAction(self);
    }
}
@end
