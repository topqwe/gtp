//
//  TMGGuideViewController.m
//  TMGold
//
//  Created by Mac on 2018/3/19.
//  Copyright © 2018年 tangmu. All rights reserved.
//

#import "TMGuideViewController.h"
#import "TMLoginViewController.h"
#import "TMGuideViewController.h"
#import "TMTabbarViewController.h"
@interface TMGuideViewController ()
@property(nonatomic, strong) STAdvertingScrollView                     *adverView;
@end

@implementation TMGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self vhl_setNavBarHidden:YES];
    [self configSubView];
    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{

    self.adverView = [[STAdvertingScrollView alloc] initWithFrame:UIScreenFrame andWithArray:@[@"luancher_1",@"luancher_2",@"luancher_3",@"luancher_4"] handle:^(NSInteger num) {
        if (num == 10003) {
              [UIApplication sharedApplication].keyWindow.rootViewController = TMTabbarViewController.new;
            [[UIApplication sharedApplication].keyWindow st_showAnimationWithType:STAnimationTypekCATransitionFade];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isShowGuideKey];
        }
    }];
    self.adverView.pageControll.bottom = self.adverView.height - 30;
    self.adverView.pageControll.currentPageIndicatorTintColor = FlatGray;
    self.adverView.pageControll.pageIndicatorTintColor = FlatYellow;
    self.adverView.pageControll.centerX = UIScreenWidth / 2;
//    self.adverView.pageControll.hidden = YES;
    self.adverView.canAutoScroll = NO;
    [self.view addSubview:self.adverView];
}

@end
