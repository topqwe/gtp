//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "HomeVC.h"
#import "HomeView.h"
#import "HomeVM.h"


#import "PostAdsVC.h"
#import "OrdersVC.h"

#import "ExchangeVC.h"
#import "OrderDetailVC.h"
@interface HomeVC () <HomeViewDelegate>
@property (nonatomic, strong) HomeView *mainView;
@property (nonatomic, strong) HomeVM *vm;

@end

@implementation HomeVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
    [self homeView:self.mainView requestHomeListWithPage:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    
//    __block
    [self.mainView actionBlock:^(id data, id data2) {
        
//        NSDictionary *dataModel = (NSDictionary *)data2;
//        IndexSectionType type = [dataModel[kType] integerValue];
        EnumActionTag type = [data integerValue];
        switch (type) {
            case EnumActionTag0:
            {
                [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeCreate) success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag1:
            {
                [OrdersVC pushFromVC:self];
            }
                break;
            case EnumActionTag2:
            {
                
            }
                break;
            case EnumActionTag3:
            {
                [ExchangeVC pushFromVC:self];
            }
                break;
            case EnumActionTag4:
            {
                OrderDetailVC *moreVc = [[OrderDetailVC alloc] init];
                [weakSelf.navigationController pushViewController:moreVc animated:YES];
//                [OrderDetailVC pushViewController:self requestParams:data2 success:^(id data) {
//
//                }];
            }
                break;
            default:
                
                break;
        }
        
    }];
    
}
-(void)netwoekingErrorDataRefush{
    [self homeView:self.mainView requestHomeListWithPage:1];
}
#pragma mark - HomeViewDelegate

- (void)homeView:(HomeView *)view requestHomeListWithPage:(NSInteger)page {
   kWeakSelf(self);
//    [self.vm network_getHomeListWithPage:page success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
//        kStrongSelf(self);
//        [self.mainView requestHomeListSuccessWithArray:dataArray WithPage:page];
//    } failed:^(id model){
//        kStrongSelf(self);
////        [self.mainView requestHomeListSuccessWithArray:model WithPage:page];
//        [self.mainView requestHomeListFailed];
//    }];
}

#pragma mark - getter

- (HomeView *)mainView {
    if (!_mainView) {
        _mainView = [HomeView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

@end
