//
//  OrderDetailVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeDetailVC.h"
#import "ExchangeDetailView.h"
#import "ExchangeDetailVM.h"


@interface ExchangeDetailVC () <ExchangeDetailViewDelegate>
@property (nonatomic, strong) ExchangeDetailView *mainView;
@property (nonatomic, strong) ExchangeDetailVM *vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation ExchangeDetailVC
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    ExchangeDetailVC *vc = [[ExchangeDetailVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"哥哥详情";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
   
    
    
    
    self.mainView.clickSectionBlock = ^(IndexSectionType sec, NSString * _Nonnull btnTit) {
        IndexSectionType btnType  = sec;
        switch (btnType) {
            case IndexSectionFour:
            {//web
//                SlideTabBarVC *moreVc = [[SlideTabBarVC alloc] init];
//                [weakSelf.navigationController pushViewController:moreVc animated:YES];
            }
                break;
            case IndexSectionFive:
            {
                
            }
                break;
                
            default:
                
                break;
        }
    };
}

#pragma mark - HomeViewDelegate

- (void)exchangeDetailView:(ExchangeDetailView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getExchangeDetailListWithPage:page WithRequestParams:self.requestParams success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (ExchangeDetailView *)mainView {
    if (!_mainView) {
        _mainView = [ExchangeDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (ExchangeDetailVM *)vm {
    if (!_vm) {
        _vm = [ExchangeDetailVM new];
    }
    return _vm;
}

@end
