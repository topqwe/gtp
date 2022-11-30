//
//  TestPageViewController.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/2/3.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "TestPageViewController.h"
#import "UIViewController+TestAdd.h"
#import <objc/message.h>
#import <Masonry.h>
#import "SJScrollEntriesView.h"
#import "TestItem.h"
#import "UIViewController+SJVideoPlayerAdd.h"
#import "SJVideoListViewController.h"

static NSInteger const vcCount = 9;

@interface TestPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, SJScrollEntriesViewDelegate>

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, strong, readonly) SJScrollEntriesView *titlesView;

@end

@implementation TestPageViewController

@synthesize pageViewController = _pageViewController;
@synthesize titlesView = _titlesView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.titlesView];
    [self.titlesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.height.offset(44);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlesView.mas_bottom).offset(1);
        make.leading.bottom.trailing.offset(0);
    }];
    
    [self.pageViewController setViewControllers:@[[self _viewControllerWithIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Do any additional setup after loading the view.
}

- (SJScrollEntriesView *)titlesView {
    if ( _titlesView ) return _titlesView;
    SJScrollEntriesViewSettings *settins = [SJScrollEntriesViewSettings defaultSettings];
    settins.lineColor = settins.selectedColor = [UIColor blueColor];
    _titlesView = [[SJScrollEntriesView alloc] initWithSettings:settins];
    _titlesView.backgroundColor = [UIColor whiteColor];
    NSMutableArray<TestItem *> *arrM = [NSMutableArray array];
    for ( int i = 0 ; i < vcCount ; ++ i ) [arrM addObject:[[TestItem alloc] initWithTitle:[NSString stringWithFormat:@"%zd", i]]];
    [_titlesView setValue:arrM forKey:@"items"];
    _titlesView.delegate = self;
    return _titlesView;
}

- (void)scrollEntriesView:(SJScrollEntriesView *)view currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex {
    NSInteger vcIndex = self.pageViewController.viewControllers.firstObject.index;
    if ( currentIndex == vcIndex ) return;
    UIPageViewControllerNavigationDirection direction = (vcIndex > currentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[[self _viewControllerWithIndex:currentIndex]] direction:direction animated:YES completion:nil];
}

#pragma mark -

- (BOOL)prefersStatusBarHidden {
    return self.pageViewController.viewControllers.firstObject.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.pageViewController.viewControllers.firstObject.preferredStatusBarStyle;
}

- (UIPageViewController *)pageViewController {
    if ( _pageViewController ) return _pageViewController;
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(2)}];
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    return _pageViewController;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self _viewControllerWithIndex:viewController.index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self _viewControllerWithIndex:viewController.index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *vc = pageViewController.viewControllers.firstObject;
    [self.titlesView changeIndex:[vc index]];
}
- (UIViewController *)_viewControllerWithIndex:(NSInteger)index {
    if ( index >= vcCount ) return nil;
    if ( index < 0 ) return nil;
    
    UIViewController *vc = self.dataViewControllersDictM[@(index)];
    if ( vc ) return vc;
    vc = [SJVideoListViewController new];
    vc.index = index;
    self.dataViewControllersDictM[@(index)] = vc;
    return self.dataViewControllersDictM[@(index)];
}
- (NSMutableDictionary< NSNumber *, UIViewController *> *)dataViewControllersDictM {
    NSMutableDictionary< NSNumber *, UIViewController *> *dataViewControllersDictM = objc_getAssociatedObject(self, _cmd);
    if ( dataViewControllersDictM ) return dataViewControllersDictM;
    dataViewControllersDictM = [NSMutableDictionary new];
    objc_setAssociatedObject(self, _cmd, dataViewControllersDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dataViewControllersDictM;
}
@end
