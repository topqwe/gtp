//
//  PostAdsVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAppealVC.h"
#import "PostAppealView.h"
#import "PostAppealVM.h"


@interface PostAppealVC () <PostAppealViewDelegate>
@property (nonatomic, strong) PostAppealView *mainView;
@property (nonatomic, strong) PostAppealVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation PostAppealVC

#pragma mark - life cycle
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    PostAppealVC *vc = [[PostAppealVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"提交粮农";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
    [self.mainView actionBlock:^(id data, id data2) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag0:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case EnumActionTag1:
            {
                [YKToastView showToastText:@"粮农成功"];
            }
                break;
                
            default:
                
                break;
        }
    }];
}

#pragma mark - HomeViewDelegate

- (void)postAppealView:(PostAppealView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getPostAppealListWithPage:page WithRequestParams:self.requestParams success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (PostAppealView *)mainView {
    if (!_mainView) {
        _mainView = [PostAppealView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PostAppealVM *)vm {
    if (!_vm) {
        _vm = [PostAppealVM new];
    }
    return _vm;
}

@end
