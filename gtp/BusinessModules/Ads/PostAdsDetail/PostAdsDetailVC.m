//
//  OrderDetailVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsDetailVC.h"
#import "PostAdsDetailView.h"
#import "PostAdsDetailVM.h"

#import "ModifyAdsVC.h"

@interface PostAdsDetailVC () <PostAdsDetailViewDelegate>
@property (nonatomic, strong) PostAdsDetailView *mainView;
@property (nonatomic, strong) PostAdsDetailVM *vm;

@end

@implementation PostAdsDetailVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"发布勃勃生机";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    
    [self.mainView actionBlock : ^(id data) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag0:
            {
                if (self.navigationController.tabBarController.selectedIndex == 0) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
                self.navigationController.tabBarController.selectedIndex=0;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
                break;
            case EnumActionTag1:
            {
                ModifyAdsVC *moreVc = [[ModifyAdsVC alloc] init];
                [weakSelf.navigationController pushViewController:moreVc animated:YES];

            }
                break;
                
            default:
                
                break;
        }
    }];
}

#pragma mark - HomeViewDelegate

- (void)postAdsDetailView:(PostAdsDetailView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getPostAdsDetailListWithPage:page success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (PostAdsDetailView *)mainView {
    if (!_mainView) {
        _mainView = [PostAdsDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PostAdsDetailVM *)vm {
    if (!_vm) {
        _vm = [PostAdsDetailVM new];
    }
    return _vm;
}

@end
