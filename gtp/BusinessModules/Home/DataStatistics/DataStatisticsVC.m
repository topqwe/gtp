//
//  HomeViewController.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "DataStatisticsVC.h"
#import "DataStatisticsView.h"
#import "DataStatisticsVM.h"

#import "SlideTabBarVC.h"
@interface DataStatisticsVC () <DataStatisticsViewDelegate>
@property (nonatomic, strong) DataStatisticsView *mainView;
@property (nonatomic, strong) DataStatisticsVM *vm;

@end

@implementation DataStatisticsVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    DataStatisticsVC *vc = [[DataStatisticsVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"数据统计";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - HomeViewDelegate

- (void)dataStatisticsView:(DataStatisticsView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getDataStatisticsListWithPage:page success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (DataStatisticsView *)mainView {
    if (!_mainView) {
        _mainView = [DataStatisticsView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (DataStatisticsVM *)vm {
    if (!_vm) {
        _vm = [DataStatisticsVM new];
    }
    return _vm;
}

@end
