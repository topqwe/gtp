//
//  YBTrendsViewController.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBTrendsViewController.h"

#import "BMSegmentedView.h"
#import "CollectionViewController.h"

@interface YBTrendsViewController ()
@property(nonatomic,strong)BMSegmentedView* segmentedView;
@property(nonatomic,strong)CollectionViewController* collectionVC;
@property(nonatomic,strong)CollectionViewController* quiltVC;
@end

@implementation YBTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    [self initChildView];
    
    [self initSegmentedView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:self.segmentedView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.segmentedView removeFromSuperview];
}
-(void)initChildView{
    self.collectionVC = [[CollectionViewController alloc]init];
    [self addChildViewController:self.collectionVC];
    
    self.quiltVC = [[CollectionViewController alloc]init];
    
    [self addChildViewController:self.quiltVC];
    
    [self.view addSubview:self.collectionVC.view];
    [self.view addSubview:self.quiltVC.view];
}
-(void)initSegmentedView{
    self.segmentedView = [[BMSegmentedView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH-150)/2, 3, 150, 38)];
//    self.segmentedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.segmentedView setLeftText:@"ColA"];
    [self.segmentedView setRightText:@"ColB"];
    [self.segmentedView setFont:[UIFont systemFontOfSize:15.0f]];
    [self.segmentedView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.segmentedView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentedView setTitleColor:COLOR_RGB(253, 125, 172, 1) forState:UIControlStateSelected];
    WS(weakSelf);
    [self.segmentedView setBlock:^(NSInteger currentIndex) {
        if (currentIndex==0) {
            [weakSelf transitionFromViewController:weakSelf.quiltVC toViewController:weakSelf.collectionVC duration:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }else{
            //            if (!GetUserDefaultBoolWithKey(USER_IS_LOGIN)) {
            //                [PHLoginViewController pushToLoginViewWithViewController:blockSelf];
            ////                [blockSelf.segmentedView setCurrentIndex:0];
            //                return;
            //            }
            [weakSelf transitionFromViewController:weakSelf.collectionVC toViewController:weakSelf.quiltVC duration:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    [self.segmentedView setCurrentIndex:0];
    //    [self.navigationController.navigationBar addSubview:self.segmentedView];
}

@end
