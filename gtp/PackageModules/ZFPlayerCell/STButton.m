//
//  STButton.m
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STButton.h"

@interface STButton()
@property(nonatomic, strong) UILabel                     *badgeValueLable;
@property(nonatomic, strong) CALayer                     *shadowLayer;/**< 阴影 */
@end

@implementation STButton

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
//        [self addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
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

@end
