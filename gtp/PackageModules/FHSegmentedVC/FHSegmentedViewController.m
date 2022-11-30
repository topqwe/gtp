//
//  KPSegmentedViewController.m

//  Created by Johnny iDay on 13-12-14.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "FHSegmentedViewController.h"

@interface FHSegmentedViewController ()

@end

@implementation FHSegmentedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 150, 38)];
        _segmentedControl.layer.cornerRadius = _segmentedControl.frame.size.height/2;
        _segmentedControl.layer.borderColor = [UIColor orangeColor].CGColor;
        _segmentedControl.layer.borderWidth = 2;
        _segmentedControl.clipsToBounds = YES;
        _segmentedControl.tintColor = [YBGeneralColor themeColor];
        NSDictionary * normalAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor greenColor]};
        [_segmentedControl setTitleTextAttributes:normalAttributes
                                   forState:UIControlStateNormal];

        NSDictionary * selectedAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName:[UIColor redColor]};
        [_segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        
        
        self.navigationItem.titleView = _segmentedControl;
        
    } else {
        [_segmentedControl removeAllSegments];
    }
    [_segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:titles[i]];
        [_segmentedControl setWidth:_segmentedControl.size.width/2 forSegmentAtIndex:i];
        
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
    
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];
        [_segmentedControl setWidth:_segmentedControl.size.width/2 forSegmentAtIndex:i];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController title:viewController.title];
}
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentedControl insertSegmentWithTitle:title atIndex:_segmentedControl.numberOfSegments animated:NO];
    [self addChildViewController:viewController];
//    [_segmentedControl sizeToFit];
}

- (void)segmentedControlSelected:(id)sender
{
    self.selectedViewControllerIndex = _segmentedControl.selectedSegmentIndex;
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        _selectedViewController = self.childViewControllers[index];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            CGFloat deltaTop = 20.0f;
            if (self.navigationController && !self.navigationController.navigationBar.translucent) {
                deltaTop = self.navigationController.navigationBar.frame.size.height;
            }
            CGRect frame = self.view.frame;
            [_selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - deltaTop, frame.size.width, frame.size.height);
//            [[_selectedViewController view] sizeToFit];
        } else {
            [_selectedViewController view].frame = self.view.frame;
        }
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            [self.childViewControllers[index] view].frame = self.view.frame;
        }
        if ([self.childViewControllers[index] isEqual:_selectedViewController]) {
            return;
        }
        WS(weakSelf);
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            weakSelf.selectedViewController = self.childViewControllers[index];
            weakSelf.selectedViewControllerIndex = index;
        }];
    }
}

@end
