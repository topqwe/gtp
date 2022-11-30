//
//  PageViewController.m
//  TestTabTitle
//
//  Created by WIQ on 2018/12/20..
//  Copyright © 2018年 WIQ. All rights reserved.
//

#import "OrdersPageVC.h"
#import "OrdersPageListView.h"
#import "OrdersPageVM.h"
#import "OrderDetailVC.h"

@interface OrdersPageVC ()<OrdersPageListViewDelegate>
@property (nonatomic, strong) OrdersPageListView *mainView;
@property (nonatomic, strong) OrdersPageVM *vm;
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic, copy) TwoDataBlock block;
@end

@implementation OrdersPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    _isFrist=false;
    [self initView];
}

- (void)initView {
    if (_mainView) {
        [_mainView removeFromSuperview];
    }
    _mainView = [OrdersPageListView new];
    _mainView.delegate = self;
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    [self.mainView actionBlock:^(id data,id data2) {
        if (weakSelf.block) {
            weakSelf.block(data,data2);
        }
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    
    if(!_isFrist){
        //第一次进入,自动加载数据
//        NSLog(@"第一次进入--%@",_tag);
        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
//        NSLog(@"第二次进入--%@",_tag);
    }
//    [self initView];
    
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
#pragma mark - PageViewDelegate

- (void)ordersPageListView:(OrdersPageListView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getOrdersPageListWithPage:page success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter
//- (OrdersPageListView *)mainView {
//    if (!_mainView) {
//        _mainView = [OrdersPageListView new];
//        _mainView.delegate = self;
//    }
//    return _mainView;
//}

- (OrdersPageVM *)vm {
    if (!_vm) {
        _vm = [OrdersPageVM new];
    }
    return _vm;
}

@end
