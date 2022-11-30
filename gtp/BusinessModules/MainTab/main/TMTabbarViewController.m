//
//  GHTabbarViewController.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMTabbarViewController.h"
#import "BVVideoHomeViewController.h"
#import "BVMovieViewController.h"
#import "BVCateViewController.h"
#import "BVCircleViewController.h"
#import "BVMineViewController.h"
#import "TMDynamicViewController.h"
#define didShowGuideKey @"didShowGuideKey"

@interface TMTabbarViewController ()
@property(nonatomic, strong) NSArray                     *imageArray;/**<  */
@property(nonatomic, strong) UIImageView                     *imageView;/**< <##> */
@property(nonatomic, assign) NSInteger                     index;/**< <##> */
@end

@implementation TMTabbarViewController
//
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tabBar.backgroundColor = UIColor.whiteColor;
        self.tabBar.barTintColor =  UIColor.whiteColor;
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:11.f], NSForegroundColorAttributeName : TM_thirdTextColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:TM_ThemeBackGroundColor} forState:UIControlStateSelected];
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self confiChildVC];
    [UITabBar appearance].translucent = YES;
    return;
    BOOL didSHow = [[NSUserDefaults standardUserDefaults] boolForKey:didShowGuideKey];
//    didSHow = NO;
    if (!didSHow) {
        self.imageArray = @[@"01--引导",@"02--引导",@"03--引导",@"04--引导",@"05--引导"];
        self.index = 0;
//        CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * 1334.0 / 750)
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.imageView setImage:[UIImage imageNamed:self.imageArray[self.index]]];
        [self.view addSubview:self.imageView];
        UITapGestureRecognizer * tao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelctedImageView)];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:tao];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:didShowGuideKey];
    }
    
    // Do any additional setup after loading the view.
}
- (void)onSelctedImageView{
    if (self.index == (self.imageArray.count - 1)) {
        [self.imageView removeFromSuperview];
    }else{
        self.index ++ ;
        [self.imageView setImage:[UIImage imageNamed:self.imageArray[self.index]]];
        
    }
}

- (void)confiChildVC{
    

    [self setTabbarChildController:[BVVideoHomeViewController new]
                         itemTitle:@""
                         itemImage:[UIImage imageNamed:@""]
                       selectImage:[UIImage imageNamed:@""]
                           itemTag:10000];
    BVMovieViewController  * vc = [BVMovieViewController new];
    [self setTabbarChildController:vc
                         itemTitle:@""
                         itemImage:[UIImage imageNamed:@""]
                       selectImage:[UIImage imageNamed:@""]
                           itemTag:10001];
    [self setTabbarChildController:[BVCateViewController new]
                         itemTitle:@""
                         itemImage:[UIImage imageNamed:@""]
                       selectImage:[UIImage imageNamed:@""]
                           itemTag:10002];
    [self setTabbarChildController:[BVCircleViewController new]
                         itemTitle:@""
                         itemImage:[UIImage imageNamed:@""]
                       selectImage:[UIImage imageNamed:@""]
                           itemTag:10002];
    
    [self setTabbarChildController:[BVMineViewController new]
                         itemTitle:@""
                         itemImage:[UIImage imageNamed:@""]
                       selectImage:[UIImage imageNamed:@""]
                           itemTag:10003];
}

- (void)setTabbarChildController:(UIViewController *)controller itemTitle:(NSString *)title itemImage:(UIImage *)image selectImage:(UIImage *)simage itemTag:(NSInteger)tag {
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    simage = [simage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    STNavigationController *navi = [[STNavigationController alloc] initWithRootViewController:controller];
    navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:simage];
    navi.tabBarItem.tag = tag;
    [self addChildViewController:navi];
}


@end

