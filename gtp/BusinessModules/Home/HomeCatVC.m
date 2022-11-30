
#import "HomeCatVC.h"

#import "AnnouncePopUpView.h"
#import "BannerPopUpView.h"
#import "HomeVM.h"

#import "HomeLVC.h"
#import "LoginVM.h"
#import "ZMCusCommentView.h"
@interface HomeCatVC ()< UINavigationControllerDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView                *titleView;
@property (nonatomic, strong) JXCategoryTitleView                *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *listVCArray;

@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *selectedIDs;
@property (nonatomic, strong) LoginVM* loginVM;
@property (nonatomic, assign) BOOL isShowActivityAdView;
@end

@implementation HomeCatVC
- (void)configView{
    ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
    if (configModel.announcement.length>0) {
        NSArray* arr = @[
            @[
                configModel.announcement
            ]
        ];
        AnnouncePopUpView* popupView = [[AnnouncePopUpView alloc]init];
        [popupView richElementsInViewWithModel:arr];
        [popupView showInApplicationKeyWindow];
        [popupView actionBlock:^(NSNumber* data) {
            if ([data integerValue] == 0) {
                [self activityAdView];
                
            }else{
                
                if (configModel.anActionType == BannerTypeVideo) {
                    [popupView disMissView];
                    self.isShowActivityAdView = YES;
                    HomeItem* item = [HomeItem new];
                    item.ID = configModel.videoId;
                    [ShowFilmVC pushFromVC:self requestParams:item success:^(id data) {
                        [self levSuccessMethod];
                    }];
                }
                if (configModel.anActionType == BannerTypeJumpPW) {
                    [popupView disMissView];
                    self.isShowActivityAdView = YES;
                    [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                        [self levSuccessMethod];
                    }];
                }
                if (configModel.anActionType == BannerTypeForV) {
                    [popupView disMissView];
                    self.isShowActivityAdView = YES;
                    [LevelVC pushFromVC:self
                           requestParams:@0
                                 success:^(id data) {
                        [self levSuccessMethod];
                    }];
                }
                if (configModel.anActionType == BannerTypeForB) {
                    [popupView disMissView];
                    self.isShowActivityAdView = YES;
                    [LevelVC pushFromVC:self
                           requestParams:@1
                                 success:^(id data) {
                        [self levSuccessMethod];
                    }];
                }
                if (configModel.obUrl.length > 0 && configModel.anActionType == BannerTypeH5? true : false) {

                    NSURL *url = [NSURL URLWithString:configModel.obUrl];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            
        }];
    }else{
        [self activityAdView];
    }
}

- (void)activityAdView{
    ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
    if (configModel.activity_ads.count>0) {
        NSArray* arr = @[
            @[
                configModel.activity_ads
            ]
        ];
        BannerPopUpView* popupView = [[BannerPopUpView alloc]init];
        [popupView richElementsInViewWithModel:arr];
        [popupView showInApplicationKeyWindow];
        [popupView actionBlock:^(ConfigItem* data) {
            if (data.url.length > 0 && data.type == BannerTypeH5? true : false) {
                NSURL *url = [NSURL URLWithString:data.url];
                [[UIApplication sharedApplication] openURL:url];
            }
            if (data.type == BannerTypeVideo) {
                [popupView disMissView];
                HomeItem* item = [HomeItem new];
                item.ID = data.videoId? data.videoId : configModel.videoId;
                [ShowFilmVC pushFromVC:self requestParams:item success:^(id data) {
                    [self levSuccessMethod];
                }];
            }
            
            if (data.type == BannerTypeJumpPW) {
                [popupView disMissView];
                [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                    [self levSuccessMethod];
                }];
            }
            if (data.type == BannerTypeForV) {
                [popupView disMissView];
                [LevelVC pushFromVC:self
                       requestParams:@0
                             success:^(id data) {
                    [self levSuccessMethod];
                }];
            }
            if (data.type == BannerTypeForB) {
                [popupView disMissView];
                [LevelVC pushFromVC:self
                       requestParams:@1
                             success:^(id data) {
                    [self levSuccessMethod];
                }];
            }
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isShowActivityAdView) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self activityAdView];
//            });
        self.isShowActivityAdView =  NO;
        
    }
    
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [[ZMCusCommentManager shareManager] showCommentWithSourceId:nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotify_DesMovieTimer object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)levSuccessMethod{
    [self requestList];
}

- (void)requestList{
    self.selectedIDs = [NSMutableArray array];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    self.arr = [NSMutableArray array];
    
    [self.view addSubview:self.titleView];
    
    [self.titleView addSubview:self.categoryView];
//    self.titleView.backgroundColor = [UIColor greenColor];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([YBFrameTool statusBarHeight]);//
        make.height.mas_equalTo([YBFrameTool navigationBarHeight]);
    }];
    
    self.listVCArray = [NSMutableArray array];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView);
        make.centerX.equalTo(self.titleView);
        make.height.equalTo(self.titleView);
        make.left.equalTo(self.titleView);
    }];

    self.scrollView = [[UIScrollView alloc] init];
    [self.view  insertSubview:self.scrollView atIndex:0];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([YBFrameTool safeAdjustNavigationBarHeight]+5);
        make.bottom.equalTo(self.view).offset(0);
        //-[YBFrameTool safeAdjustTabBarHeight]
    }];

    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //FIXME:如果和自定义UIScrollView联动，删除纯UIScrollView示例
    self.categoryView.contentScrollView = self.scrollView;

    [self requestList];
    
    [self configView];
    //监听程序进入前台
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidBecomeActive:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//    addObserver:self selector:@selector(getNotificationAction:) name:@"ThisIsANoticafication" object:nil];
}
- (void)getNotificationAction:(NSNotification *)notification{
//    NSDictionary * infoDic = [notification object];
//    // 这样就得到了我们在发送通知时候传入的字典了
    NSURL *url = [NSURL URLWithString:@""];
    [[UIApplication sharedApplication] openURL:url];
//    [self requestData];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    [_tableView reloadData];
//    [self requestData];
}
- (void)requestData {
    kWeakSelf(self);
    
//    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    if ([UserInfoManager GetNSUserDefaults].data.expires_at == nil||
        [NSString compareYMDHMSDate:[NSString getCurrentTimeYMDHMS] withDate:[UserInfoManager GetNSUserDefaults].data.expires_at] != 1) {
        
//        UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
//        userInfoModel.data.account = @"";
//        [UserInfoManager SetNSUserDefaults:userInfoModel];
        
        [self.loginVM network_postLoginWithRequestParams:@{}
            success:^(UserInfoModel* model) {
                kStrongSelf(self);
    //            NSLog(@"segege%@",model);
        //            if (self.block) {
        //                self.block(model);
        //            }
                [self.vm network_getCategoryWithPage:1 success:^(NSArray * data) {
//                    [self reloadSubData:data];//imodel
                    
                } failed:^(id data) {
                    
                }];
            }
            failed:^(id model){
            }
            error:^(id model){
            }];
    }else{
        [self.vm network_getCategoryWithPage:1 success:^(NSArray * data) {
            [self reloadSubData:data];
            
            
        } failed:^(id data) {
            
        }];
    }
    
}
/**
重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
*/
- (void)reloadSubData:(NSArray*)arr {
    [self.arr addObjectsFromArray:arr];
    
    NSMutableArray* names = [NSMutableArray array];
    for (HomeItem* data in arr) {
        [names addObject:data.name];
    }
    NSArray *titles = names;
    for (UIViewController *vc in self.listVCArray) {
        [vc.view removeFromSuperview];
    }
    [self.listVCArray removeAllObjects];

    
    [self.view layoutIfNeeded];
    
    [self.scrollView layoutIfNeeded];
    
    for (int i=0; i<titles.count ; i++) {
        HomeLVC *listVC = [[HomeLVC alloc] init];
        listVC.view.backgroundColor = [UIColor orangeColor];
        listVC.view.frame = CGRectMake(i*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self addChildViewController:listVC];
        [self.listVCArray addObject:listVC];
        [self.scrollView addSubview:listVC.view];
    }
    
//    BaseVC *rightVC = [[BaseVC alloc] init];
//    rightVC.view.frame = CGRectMake(2*self.scrollView.bounds.size.width, CGRectGetMaxY(self.titleView.frame), self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
//    rightVC.view.backgroundColor = [UIColor blueColor];
//    [self addChildViewController:rightVC];
//    [self.listVCArray addObject:rightVC];
//    [self.scrollView addSubview:rightVC.view];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*titles.count, self.scrollView.bounds.size.height);

    //触发首次加载
    HomeItem* data = arr[0];
    [self.listVCArray.firstObject requestHomeListWithPage:1 WithCid:data.ID];

    [self.selectedIDs addObject:@(data.ID)];
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    HomeItem* data = self.arr[index];
    if (![self.selectedIDs containsObject:@(data.ID)]) {
        [self.listVCArray[index] requestHomeListWithPage:1 WithCid:data.ID];
        [self.selectedIDs addObject:@(data.ID)];
    }
    
}
//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.delegate = self;
        _categoryView.titleColor = HEXCOLOR(0x8FAEB7);
        _categoryView.titleSelectedColor = [UIColor blackColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleColorGradientEnabled = YES;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = YBGeneralColor.themeColor;
        lineView.indicatorWidth = 6;//JXCategoryViewAutomaticDimension;
        lineView.indicatorHeight = 6;
        lineView.indicatorCornerRadius = 6/2;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [UIView new];
    }
    return _titleView;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

- (LoginVM *)loginVM {
    if (!_loginVM) {
        _loginVM = [LoginVM new];
    }
    return _loginVM;
}

- (void)dealloc {
    // 点击返回 或 侧滑返回
    //NSLog(@"playerVC dealloc");
}
@end

