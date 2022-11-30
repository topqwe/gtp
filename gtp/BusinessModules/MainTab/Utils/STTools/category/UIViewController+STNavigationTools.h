//
//  UIViewController+STNavigationTools.h
//  SportHome
//
//  Created by 石轩磊 on 17/1/11.
//  Copyright © 2017年 stoneobs. All rights reserved.
//  此类别是用于被navVC包装的UIviewcontrol 扩展类，主要功能是负责提供方法，修改导航Items,部分需要完善

#import <UIKit/UIKit.h>

@interface UIViewController (STNavigationTools)

- (void)st_setLeftItemWithTitle:(NSString*)title;
- (void)st_setLeftItemWithTitle:(NSString *)title titleColor:(UIColor*)color;
- (void)st_setLeftItemWithImage:(UIImage *)image;
- (void)st_setLeftItemWithImage:(UIImage *)image andwithTitle:(NSString *)title  titleColor:(UIColor*)titleColor;
- (void)st_setLeftItemWithView:(UIView*)view;

- (void)st_setRightItemWithTitle:(NSString*)title;
- (void)st_setRightItemWithTitle:(NSString *)title titleColor:(UIColor*)color;
- (void)st_setRightItemWithImage:(UIImage*)image;
- (void)st_setRightItemWithImage:(UIImage*)image andwithTitle:(NSString*)title;
- (void)st_setRightItemWithView:(UIView*)view;

- (void)st_setNavgationTitleColor:(UIColor*)titleColor;
- (void)st_setNavgationBarColor:(UIColor*)barColor;

- (void)st_rightBarAction:(id)sender;
- (void)st_leftBarAction:(id)sender;
//黑线 view传navbar
- (UIImageView *)st_findHairlineImageViewUnder:(UIView *)view;
//隐藏和显示导航栏。
//两个都隐藏了导航的vc 之间的切换 建议 animated = NO，就会正常
- (void)st_showNavagationbarAnimated:(BOOL)animated;
- (void)st_hideNavagetionbarAnimated:(BOOL)animated;

- (UINavigationController*)st_currentNavgationController;

- (UIViewController *)st_getCurrentVC;
@end
