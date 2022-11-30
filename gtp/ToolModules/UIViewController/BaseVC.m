
//
//  BaseVC.m


#import "BaseVC.h"
#import "LoginVC.h"
#import "NetworkingErrorView.h"
#import "ChangeURLEnvironment.h"
@interface BaseVC ()
@property(nonatomic,strong)NetworkingErrorView *netErrorView;
@property(nonatomic)managerAFNetworkStatus lastNetStatus;
@end

@implementation BaseVC
-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_configBackItem];
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(levSuccessMethod) name:kNotify_LevRefresh object:nil];
    [self setErrorViewDetial];
}

- (void)levSuccessMethod{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNetworkStatusRefush:) name:kNotify_NetWorkingStatusRefresh object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = true;
}

-(void)setErrorViewDetial{
    self.netErrorView = [[NetworkingErrorView alloc]init];
    [self.view addSubview:self.netErrorView];
    [self.netErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.netErrorView.refushBnt addTarget:self action:@selector(didNetworkingErrorRefushClicked:) forControlEvents:UIControlEventTouchUpInside];
}
//重新加载点击事件
-(void)didNetworkingErrorRefushClicked:(UIButton *)sender{
    [self netwoekingErrorDataRefush];
}

-(void)netwoekingErrorDataRefush{
    
}

#pragma mark - 点击事件

-(void)didNetworkStatusRefush:(NSNotification *)noti{
    NSDictionary *dicaa = noti.object;
    managerAFNetworkStatus status = [[dicaa objectForKey:@"status"] integerValue];
    switch (status) {
        case managerAFNetworkNotReachable:     // 无连线
            self.netErrorView.hidden = NO;
            [self.netErrorView setNetWorkingDetialWith:0];
            [self.view bringSubviewToFront:self.netErrorView];
            break;
        case managerAFNetworkReachableViaWWAN: // 手机自带网络
            if (self.lastNetStatus==managerAFNetworkNotReachable) {
                [self netwoekingErrorDataRefush];
            }
            self.netErrorView.hidden = YES;
            [self.view sendSubviewToBack:self.netErrorView];
            break;
        case managerAFNetworkReachableViaWiFi: // WiFi
            if (self.lastNetStatus==managerAFNetworkNotReachable) {
                [self netwoekingErrorDataRefush];
            }
            self.netErrorView.hidden = YES;
            [self.view sendSubviewToBack:self.netErrorView];
            break;
        case managerAFNetworkOutTime: // 接口超时
            self.netErrorView.hidden = NO;
            [self.netErrorView setNetWorkingDetialWith:1];
            [self.view bringSubviewToFront:self.netErrorView];
            break;
        case managerAFNetworkServiceError: // 接口报错
            self.netErrorView.hidden = NO;
            [self.netErrorView setNetWorkingDetialWith:1];
            [self.view bringSubviewToFront:self.netErrorView];
            break;
        case managerAFNetworkUnknown:          // 未知网络
        default:
            self.netErrorView.hidden = YES;
            [self.view sendSubviewToBack:self.netErrorView];
            break;
    }
    self.lastNetStatus = status;
}

- (BOOL)isloginBlock {
    WS(weakSelf);
    BOOL valueLogin = GetUserDefaultBoolWithKey(kIsLogin);
    if(!valueLogin){
        
//        LoginVC *loginCon = [[LoginVC alloc]init];
//        loginCon.loginSuccessBlock = ^{
//            [weakSelf loginSuccessBlockMethod];
//        };
//        UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
//        [self presentViewController:reNavCon animated:YES completion:nil];
        
//        [[ChangeURLEnvironment sharedInstance]changeEnvironment:^(id data) {
//            [LoginVC pushFromVC:self requestParams:@(0) success:^(id data) {
//                [weakSelf loginSuccessBlockMethod];
//            }];
//        }];
        
        [LoginVC pushFromVC:self requestParams:@(0) success:^(id data) {
            [weakSelf loginSuccessBlockMethod];
        }];
        return YES;
        
    }
    return NO;
}

- (void)loginSuccessBlockMethod{
//    NSLog(@",,,,");
}

-(void)locateTabBar:(NSInteger)index{//backHome
    
    if (self.navigationController.tabBarController.selectedIndex == index) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        
        self.navigationController.tabBarController.selectedIndex = index;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)changeUrlEnvironment{
    [[ChangeURLEnvironment sharedInstance]changeEnvironment:^(id data) {
        UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
        userInfoModel.data.account = @"";
        [UserInfoManager SetNSUserDefaults:userInfoModel];
            
//                [[UserInfoModel new] setDefaultDataIsForceInit:YES];
//            [UserInfoManager DeleteNSUserDefaults];
            
            [[LoginVM new]network_postLoginWithRequestParams:@{} success:^(id data) {
                exit(0);
                            
            } failed:^(id data) {
                
            } error:^(id data) {
                
            }];
        
    }];
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 50, 44);
        
        [_rightBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(naviRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)naviRightBtnEvent:(UIButton *)sender{
    
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}
@end

