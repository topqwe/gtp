//
//  PostAdsVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsVC.h"
#import "PostAdsView.h"
#import "PostAdsVM.h"

#import "SlideTabBarVC.h"
#import "PostAdsDetailVC.h"
@interface PostAdsVC () <PostAdsViewDelegate>
@property (nonatomic, strong) PostAdsView *mainView;
@property (nonatomic, strong) PostAdsVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation PostAdsVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    PostAdsVC *vc = [[PostAdsVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
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
    
    
    self.mainView.clickGridRowBlock = ^(NSDictionary *  dataModel) {
        IndexSectionType type = IndexSectionZero;
        type = [dataModel[kType] integerValue];
        switch (type) {
            case IndexSectionOne:
            {
                PostAdsDetailVC *moreVc = [[PostAdsDetailVC alloc] init];
                [weakSelf.navigationController pushViewController:moreVc animated:YES];
            }
                break;
            default:
                
                break;
        }
        
    };
    
    
    [self.mainView actionBlock:^(id data) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag3:
            {//web
//                SlideTabBarVC *moreVc = [[SlideTabBarVC alloc] init];
//                [weakSelf.navigationController pushViewController:moreVc animated:YES];
            }
                break;
            case EnumActionTag4:
            {//post
                PostAdsDetailVC *moreVc = [[PostAdsDetailVC alloc] init];
                [weakSelf.navigationController pushViewController:moreVc animated:YES];
            }
                break;
                
            default:
                
                break;
        }
    }];
}

#pragma mark - HomeViewDelegate

- (void)postAdsView:(PostAdsView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getPostAdsListWithPage:page WithRequestParams:self.requestParams success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (PostAdsView *)mainView {
    if (!_mainView) {
        _mainView = [PostAdsView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PostAdsVM *)vm {
    if (!_vm) {
        _vm = [PostAdsVM new];
    }
    return _vm;
}

@end
