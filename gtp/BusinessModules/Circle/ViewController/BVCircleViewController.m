//
//  BVCircleViewController.m
//  BannerVideo
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCircleViewController.h"
#import "BVMineCircleViewController.h"
#import "TMDynamicViewController.h"
#import "BVAddDynamicViewController.h"
@interface BVCircleViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) STSegementAutoView                     *autoView;/**<  */
@property(nonatomic, strong) NSArray                     *allMenuArray;/**<  */
@end

@implementation BVCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController * vc in self.childViewControllers) {
        [vc viewWillAppear:animated];
    }
}
#pragma mark --subView
- (void)configSubView{
    self.view.backgroundColor = UIColor.whiteColor;
    __weak typeof(self) weakSelf =  self;
    NSArray * titles = @[@"圈子",@"我的"];
    self.allMenuArray = titles;
    self.autoView = [[STSegementAutoView alloc] initWithFrame:CGRectMake(0, TMUtils.navgationBarBootom-1, 200 , 43) andTitle:titles handle:^(STSegementAutoView *sender, UIButton *currentSelctedButton) {
        
        [weakSelf.scrollView setContentOffset:CGPointMake(UIScreenWidth * sender.cureentIndex, 0) animated:YES];
        
        
    }];
    [self.view addSubview:self.autoView];
    self.autoView.lineSelectedColor = TM_ThemeBackGroundColor;
    
    
    self.autoView.butTitleColor = SecendTextColor;
    self.autoView.butTitleSelectedColor = TM_ThemeBackGroundColor;
    self.autoView.lineColor = UIColor.clearColor;
    self.autoView.autoMoveWithClic = NO;
    
    
    self.autoView.buttonBackGroundColor = UIColor.clearColor;
    self.autoView.buttonSelctedBackGroundColor = UIColor.clearColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TMUtils.navgationBarBootom, UIScreenWidth, TMUtils.tabBarTop - TMUtils.navgationBarBootom)];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.backgroundColor = UIColor.whiteColor;
    if (ios11 && [self.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        [self.scrollView setContentInsetAdjustmentBehavior:@(2)];
    }
    //    self.tableView.scrollEnabled = NO;
    self.navigationItem.titleView = self.autoView;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    //配子5个自控制
    NSInteger index = 0;
    ({
        TMDynamicViewController * vc = [[TMDynamicViewController alloc] init];
        [self addChildViewController:vc];
        vc.view.left = UIScreenWidth * index;
        [self.scrollView addSubview:vc.view];
        self.scrollView.contentSize = CGSizeMake(vc.view.right, 0);
        index ++ ;
    });
    ({
        BVMineCircleViewController * vc = [[BVMineCircleViewController alloc] init];
        [self addChildViewController:vc];
        vc.view.left = UIScreenWidth * index;
        [self.scrollView addSubview:vc.view];
        self.scrollView.contentSize = CGSizeMake(vc.view.right, 0);
        index ++ ;
    });

    
    STButton * button = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)
                                                  title:nil
                                             titleColor:nil
                                              titleFont:0
                                           cornerRadius:0
                                        backgroundColor:nil
                                        backgroundImage:nil
                                                  image:[UIImage imageNamed:@"发布"]];
    button.right = UIScreenWidth - 15;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.bottom = TMUtils.tabBarTop - 60;
    [self.view addSubview:button];
    
    [button setClicAction:^(UIButton *sender) {
        [weakSelf.navigationController pushViewController:BVAddDynamicViewController.new animated:YES];
    }];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = self.scrollView.contentOffset.x / UIScreenWidth;
        [self.autoView setCureentIndex:index];
        
        CGFloat maxWith = self.autoView.width / self.allMenuArray.count;
        CGFloat bilie =  self.scrollView.contentOffset.x / UIScreenWidth;
        self.autoView.lineSelectedView.centerX = maxWith * bilie + 0.5 * self.autoView.width/self.allMenuArray.count ;
    }
}


@end
