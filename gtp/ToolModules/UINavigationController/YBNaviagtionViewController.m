//
//  YBNaviagtionViewController.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBNaviagtionViewController.h"


@interface YBNaviagtionViewController ()

@end

@implementation YBNaviagtionViewController

#pragma mark - life cycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self configNavigationBar];
    }
    return self;
}
#pragma mark - private

- (void)configNavigationBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = YBGeneralColor.navigationBarColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.navigationBarTitleColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [self setNavBg:YBGeneralColor.navigationBarColor];
}

-(void)setNavBg:(UIColor *)bgColor{
 if(@available(iOS 15, *)) {
 UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
 [appearance configureWithOpaqueBackground];
 appearance.backgroundColor = bgColor;
 appearance.shadowColor = [UIColor clearColor];
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.navigationBarTitleColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
 self.navigationBar.standardAppearance = appearance;
 self.navigationBar.scrollEdgeAppearance=self.navigationBar.standardAppearance;
 }
 else{
// [self.navigationBar setBackgroundImage:[UIImage imageWithColor:bgColor] forBarMetrics:UIBarMetricsDefault];
     [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
 }
}
#pragma mark - overwrite

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
+(UINavigationController *)rootNavigationController {
    UITabBarController *tabC = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    UINavigationController *navigationController = (UINavigationController *)tabC.selectedViewController;
    return navigationController;
}
@end
