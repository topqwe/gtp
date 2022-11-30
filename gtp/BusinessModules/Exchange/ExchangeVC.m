//
//  PostAdsVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeVC.h"
#import "ExchangeView.h"
#import "ExchangeVM.h"
#import "ExchangeDetailVC.h"

@interface ExchangeVC () <ExchangeViewDelegate>
@property (nonatomic, strong) ExchangeView *mainView;
@property (nonatomic, strong) ExchangeVM *vm;

@end

@implementation ExchangeVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    ExchangeVC *vc = [[ExchangeVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"哥哥MIA";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    [self.mainView actionBlock:^(id data) {
        if ([data isKindOfClass:[NSArray class]]) {
            [self.vm network_getExchangeApplyWithResquestParams:data Success:^(id data) {
                [self exchangeView:weakSelf.mainView requestListWithPage:1];
            } failed:^(id data) {
                
            } error:^(id data) {
                
            }];
        }
        else{
            [ExchangeDetailVC pushViewController:self requestParams:data success:^(id data) {
                
            }];
        }
        
    }];
    
}

#pragma mark - HomeViewDelegate

- (void)exchangeView:(ExchangeView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getExchangeListWithPage:page WithExchangeType:ExchangeTypeAll success:^(id data) {
        NSArray * dataArray = data;
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray WithPage:page];
    } failed:^(id data){
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data){
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }
     ];
}

#pragma mark - getter

- (ExchangeView *)mainView {
    if (!_mainView) {
        _mainView = [ExchangeView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (ExchangeVM *)vm {
    if (!_vm) {
        _vm = [ExchangeVM new];
    }
    return _vm;
}

@end
