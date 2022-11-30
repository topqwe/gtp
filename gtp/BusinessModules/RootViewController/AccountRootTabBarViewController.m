//
//  YBRootTabBarViewController.m
//  YBArchitectureDemo
//
//  Created by ML on 2018/11/19.
//  Copyright © 2018 ML. All rights reserved.
//

#import "AccountRootTabBarViewController.h"
#import "YBNaviagtionViewController.h"

#import "YBTrendsViewController.h"
#import "YBMsgViewController.h"

#import "AdsVC.h"
#import "FaceQRVC.h"
#import "AccountingView.h"
#import "AccountingVC.h"
#import "AccountStatedVC.h"
#import "AccountPurseVC.h"
#import "UIViewController+YCPopover.h"


@interface AccountRootTabBarViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
    //最近一次选择的Index
@property(nonatomic, readonly) NSUInteger lastSelectedIndex;

@property (nonatomic, strong) AccountStatedVC *accountStatedVC;
@property (nonatomic, strong) AccountingVC *accountingVC;
@property (nonatomic, strong) AccountPurseVC *accountPurseVC;
@property (nonatomic, strong) AdsVC *adVC;
@property (nonatomic, strong) YBTrendsViewController *trendsVC;
@property (nonatomic, strong) YBMsgViewController *msgVC;

@property (nonatomic, strong) FaceQRVC *fQRVC;

@end

@implementation AccountRootTabBarViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;
    self.tabBar.shadowImage = [UIImage new];
    [self configSubViewControllers];
}

#pragma mark - private
- (void)configSubViewControllers {
    self.viewControllers = @[
        [self getViewControllerWithVC:self.accountStatedVC title:@"明细" normalImage:[UIImage imageNamed:@"icon_home_gray"] selectImage:[UIImage imageNamed:@"icon_home_blue"]],
        [self getViewControllerWithVC:self.adVC title:@"" normalImage:[UIImage imageNamed:@"icon_deal_gray"] selectImage:[UIImage imageNamed:@"icon_deal_gray"]],
        [self getViewControllerWithVC:self.accountPurseVC title:@"钱包" normalImage:[UIImage imageNamed:@"icon_massage_gray"] selectImage:[UIImage imageNamed:@"icon_massage_blue"]]
        
    ];
}
- (UIViewController *)getViewControllerWithVC:(UIViewController *)vc title:(NSString *)title normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage {
    
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.tabBarTitleSelectedColor} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.tabBarTitleNormalColor} forState:UIControlStateNormal];
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    [self.tabBar setTintColor:YBGeneralColor.themeColor];
    if (@available(iOS 10.0, *)) {
        [self.tabBar setUnselectedItemTintColor:YBGeneralColor.tabBarTitleNormalColor];
    }
    if (@available(iOS 15.0, *)) {
           UITabBarAppearance * appearance = [[UITabBarAppearance alloc] init];
           [appearance configureWithOpaqueBackground];
           appearance.backgroundColor = UIColor.whiteColor;
//        appearance.shadowColor = [UIColor clearColor];
           [UITabBar appearance].scrollEdgeAppearance = appearance;
           [UITabBar appearance].standardAppearance = appearance;
       }
       [UITabBar appearance].backgroundColor = UIColor.whiteColor;
    vc.navigationItem.title = title;
    YBNaviagtionViewController *nav = [[YBNaviagtionViewController alloc] initWithRootViewController:vc];
    return nav;
}


-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex  && self.selectedIndex != 1) {
        //设置最近一次
        _lastSelectedIndex = self.selectedIndex;
    }
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
}
 
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex && self.selectedIndex != 1) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex ==1) {
//        AccountingView* popupView = [[AccountingView alloc]init];
//        [popupView richElementsInViewWithModel:@(1)];
//        [popupView showInApplicationKeyWindow];
//        [popupView actionBlock:^(id data) {
//
//        }];
        
        YBNaviagtionViewController* naviC = (YBNaviagtionViewController*)viewController;
        
        NSArray *viewControllers = naviC.viewControllers;
        
        for (int i=0; i<viewControllers.count; i++) {
            BaseVC* vc = (BaseVC*)viewControllers[i];
            [vc locateTabBar:_lastSelectedIndex];
            
            [vc yc_bottomPresentController:self.accountingVC presentedHeight:MAINSCREEN_HEIGHT - 60 completeHandle:^(BOOL presented) {
                NSLog(@"YYYYC:%d", presented);
            }];//presentC != tabNaviC
        }
    }//2.UIView push UIViewController
    /*
     id object = [self nextResponder];
     while (![object isKindOfClass:[UIViewController class]] && object != nil) {
         object = [object nextResponder];
     }
     UIViewController *superController = (UIViewController*)object;
     [superController.navigationController  showViewController:vc sender:nil];
     */
}
#pragma mark - getter


- (AccountStatedVC *)accountStatedVC {
    if (!_accountStatedVC) {
        _accountStatedVC = [AccountStatedVC new];
    }
    return _accountStatedVC;
}

- (AccountingVC *)accountingVC {
    if (!_accountingVC) {
        _accountingVC = [AccountingVC new];
    }
    return _accountingVC;
}

- (AccountPurseVC *)accountPurseVC {
    if (!_accountPurseVC) {
        _accountPurseVC = [AccountPurseVC new];
    }
    return _accountPurseVC;
}
- (AdsVC *)adVC {
    if (!_adVC) {
        _adVC = [AdsVC new];
    }
    return _adVC;
}

- (FaceQRVC*)fQRVC{
    if (!_fQRVC) {
        _fQRVC = [FaceQRVC new];
    }
    return _fQRVC;
}
- (YBTrendsViewController *)trendsVC {
    if (!_trendsVC) {
        _trendsVC = [YBTrendsViewController new];
    }
    return _trendsVC;
}

- (YBMsgViewController *)msgVC {
    if (!_msgVC) {
        _msgVC = [YBMsgViewController new];
    }
    return _msgVC;
}

@end
