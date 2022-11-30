//
//  OrderDetailVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailView.h"
#import "OrderDetailVM.h"

#import "DistributePopUpView.h"
#import "InputPWPopUpView.h"

#import "PostAppealVC.h"
@interface OrderDetailVC () <OrderDetailViewDelegate>
@property (nonatomic, strong) OrderDetailView *mainView;
@property (nonatomic, strong) OrderDetailVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation OrderDetailVC

#pragma mark - life cycle
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    OrderDetailVC *vc = [[OrderDetailVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"🌹详情";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
    [self.mainView actionBlock:^(id data,id data2) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag0:
            {
                DistributePopUpView* popupView = [[DistributePopUpView alloc]init];
                [popupView richElementsInViewWithModel:data2];
                [popupView showInApplicationKeyWindow];
                [popupView actionBlock:^(id data) {
                    EnumActionTag tag = (EnumActionTag)[data integerValue];
                    switch (tag) {
                        case EnumActionTag1:
                        {//post
                            InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                            [popupView showInView:self.view];
                            [popupView actionBlock:^(id data) {
                                [YKToastView showToastText:@"已symbolic"];
                            }];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
                break;
            case EnumActionTag1:
            {
                [PostAppealVC pushViewController:self requestParams:data2 success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag2:
            {
                NSLog(@"contact");
            }
                break;
            default:
                
                break;
        }
    }] ;
}

#pragma mark - HomeViewDelegate

- (void)orderDetailView:(OrderDetailView *)view requestListWithPage:(NSInteger)page{
   kWeakSelf(self);
    [self.vm network_getOrderDetailListWithPage:page WithRequestParams:self.requestParams success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (OrderDetailView *)mainView {
    if (!_mainView) {
        _mainView = [OrderDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (OrderDetailVM *)vm {
    if (!_vm) {
        _vm = [OrderDetailVM new];
    }
    return _vm;
}

@end
