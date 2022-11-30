//
//  UINavigationItem+Extras.h
//  PhoneZhuan
//
//  Created by WIQ on 14-2-17.
//  Copyright (c) 2014年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Extras)

- (void)addNavTitle:(NSString *)title withTitleColor:(UIColor*)titleColor;

-(void)addCenterSearchNav:(id)target keyWord:(NSString*)keyword actionMethod:(SEL)actionMethod;
-(void)addCenterAligSearchNav:(id)target actionMethod:(SEL)actionMethod withPalaceholdTitle:(NSString*)palaceHoldString;

- (void)addDefaultBackButton:(id)viewController actionMethod:(SEL)actionMethod andImage:(UIImage *)titImg;
- (void)addDefaultRightButton:(id)viewController actionMethod:(SEL)actionMethod;

-(void)addRightButtons:(id)target withFirstBtnImage:(UIImage *)image1 andFirstBtnTitle:(NSString *)title1 withSecondBtnImage:(UIImage *)image2 andSecondBtnTitle:(NSString *)title2;
- (void)firstRightButtonEvent:(UIButton*)sender;
- (void)secondRightButtonEvent:(UIButton*)sender;
- (void)addCustomLeftButton:(id)target withImage:(UIImage*)image andTitle:(NSString *)title;
- (void)addCustomRightButton:(id)target withImage:(UIImage*)image andTitle:(NSString *)title;
- (void)leftButtonEvent;
- (void)rightButtonEvent;

- (void)addCustomNaviButtonWithIsRight:(BOOL)isRight image:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

- (void)addSimpleTitleView:(NSString *)title FontSize:(UIFont *)font MaxWidth:(float)maxWidth MaxHeight:(float)maxHeight;

- (void)addForumContentNavTitleView:(id)owner selector:(SEL)selector title:(NSString *)title;
@end
