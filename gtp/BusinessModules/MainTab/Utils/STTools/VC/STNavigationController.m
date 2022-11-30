//
//  STNavigationController.m
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STNavigationController.h"
#import "UIImage+STTools.h"
@interface STNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation STNavigationController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    
    if (self = [super initWithRootViewController:rootViewController]) {
        self.interactivePopGestureRecognizer.delegate=(id)self;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [VHLNavigation vhl_setDefaultNavBackgroundColor:UIColor.whiteColor];
            [VHLNavigation vhl_setDefaultNavBarShadowImageHidden:YES];
            [VHLNavigation vhl_setDefaultNavBarTitleColor:TM_ThemeBackGroundColor];
            [VHLNavigation vhl_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
        });

        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:TM_ThemeBackGroundColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //解决rootviewcontroller 出发又滑手势 卡死问题
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}
- (void)viewWillLayoutSubviews
{
    if ([[NSThread currentThread] isMainThread]) {
        [super viewWillLayoutSubviews];
    } else {
        NSLog(@"back ground thread");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self viewWillLayoutSubviews];
        });
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    if (self.childViewControllers.count > 0) {
        self.hidesBottomBarWhenPushed = YES;
        //设置返回键
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back)  forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.frame = CGRectMake(0, 0, 44, 44);
        viewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.hidesBottomBarWhenPushed = YES;
        self.delegate = self;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
static NSString * const  overlayKey = @"overlay";
#pragma mark --UINavigationBar categeory
@implementation UINavigationBar (STColor)
- (UIView *)overlay{
    return objc_getAssociatedObject(self, &overlayKey);
}
- (void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)st_setBackgroundColor:(UIColor *)backgroundColor{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        UIView *backgroundView = [self st_getBackgroundView];
        self.overlay = [[UIView alloc] initWithFrame:backgroundView.bounds];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [backgroundView insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (UIView*)st_getBackgroundView{
    //iOS10之前为 _UINavigationBarBackground, iOS10为 _UIBarBackground
    //_UINavigationBarBackground实际为UIImageView子类，而_UIBarBackground是UIView子类
    //之前setBackgroundImage直接赋值给_UINavigationBarBackground，现在则是设置后为_UIBarBackground增加一个UIImageView子控件方式去呈现图片
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UIView *_UIBackground;
        NSString *targetName = @"_UIBarBackground";
        Class _UIBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UIBarBackgroundClass.class]) {
                _UIBackground = subview;
                break;
            }
        }
        return _UIBackground;
    }
    else {
        UIView *_UINavigationBarBackground;
        NSString *targetName = @"_UINavigationBarBackground";
        Class _UINavigationBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UINavigationBarBackgroundClass.class]) {
                _UINavigationBarBackground = subview;
                break;
            }
        }
        return _UINavigationBarBackground;
    }
}

#pragma mark - shadow view
- (void)st_hideShadowImageOrNot:(BOOL)bHidden{
    UIView *bgView = [self st_getBackgroundView];
    //shadowImage应该是只占一个像素，即1.0/scale
    for (UIView *subview in bgView.subviews) {
        if (CGRectGetHeight(subview.bounds) <= 1.0) {
            subview.hidden = bHidden;
        }
    }
}
@end

