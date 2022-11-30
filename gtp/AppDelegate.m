//
//  AppDelegate.m

#import "AppDelegate.h"
#import "YBRootTabBarViewController.h"
#import "AccountRootTabBarViewController.h"
#import "FRootTabBarViewController.h"
#import "LoginVC.h"
#import "LoginModel.h"
#import "NSObject+LBLaunchImage.h"
#import "SplashView.h"
#import "FirstMovieGuiderVC.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)initRootUI {
    [self setNetWorkErrInfo];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

//    [self handleFirstGuider];
    [self configLanchImage];
    
    _window.backgroundColor = [UIColor blackColor];
    [_window makeKeyAndVisible];
    
//    [self addSplashView];
    
    [self svPreferrenceConf];
    [self _settingVideoPlayer];
    
    
    return;
    if ([GetUserDefaultWithKey(kIsLogin) boolValue]==YES) {
        _window.rootViewController = [FRootTabBarViewController new];
    }else{
//        LoginVC* logVC = [LoginVC new];
//        _window.rootViewController = logVC;
//        WS(weakSelf);
//        [logVC actionBlock:^(id data) {
//            LoginModel* model =data;
//            if ([model.userinfo.valigooglesecret integerValue]==1
//                &&[model.userinfo.safeverifyswitch integerValue]==1) {
//                [VertifyVC pushFromVC:logVC requestParams:data success:^(id data) {
//                    NSLog(@"na pw vw%@",data);
//                    return ;
//                }];
//            }
//             SetUserBoolKeyWithObject(kIsLogin, YES);
//             UserDefaultSynchronize;
//             weakSelf.window.rootViewController = [YBRootTabBarViewController new];
//        }];
    }
    
}
- (void)handleFirstGuider{
    NSString *versionCache = [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionCache"];//本地缓存的版本号  第一次启动的时候本地是没有缓存版本号的。
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//当前应用版本号
    
    if (![versionCache isEqualToString:version]) //如果本地缓存的版本号和当前应用版本号不一样，则是第一次启动（更新版本也算第一次启动）
    {
        FirstMovieGuiderVC *wsCtrl = [[FirstMovieGuiderVC alloc]init];
        [wsCtrl actionBlock:^(id data) {
            [self configLanchImage];
        }];
        self.window.rootViewController = wsCtrl;
        
        //设置上下面这句话，将当前版本缓存到本地，下次对比一样，就不走启动视屏了。
        //也可以将这句话放在WSMovieController.m的进入应用方法里面
        //为了让每次都可以看到启动视屏，这句话先注释掉
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"VersionCache"];

    }else{
        //不是首次启动
        [self configLanchImage];
    }
}

- (void)addSplashView {
    SplashView *splashView = [[SplashView alloc] initWithFrame:self.window.bounds];
    __weak SplashView *weakSplashView = splashView;
    [splashView showOnView:self.window withAnimationCompleter:^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSplashView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSplashView removeFromSuperview];
        }];
    }];
}

- (void)configLanchImage{//@"750X1334"
    [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
        //设置广告的类型
        imgAdView.getLBlaunchImageAdViewType(FullScreenAdType);
        //自定义跳过按钮
        imgAdView.skipBtn.backgroundColor = [UIColor lightGrayColor];
        imgAdView.skipBtn.alpha = 0;
        [imgAdView.skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        __block LBLaunchImageAdView *adView = imgAdView;
        imgAdView.clickBlock = ^(const clickType type) {
            switch (type) {
                case clickAdType:{
//                    self.window.rootViewController = [FRootTabBarViewController new];
                    if (adView.advertUrl.length > 0 && adView.isClickAdView) {

                        NSURL *url = [NSURL URLWithString:adView.advertUrl];
                        [[UIApplication sharedApplication] openURL:url];
                        
//                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//                            self.window.rootViewController = [FRootTabBarViewController new];
//                            [[NSNotificationCenter defaultCenter]
//                             postNotificationName:@"ThisIsANoticafication" object:@{@"p":adView.advertUrl}];
//                        }];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.window.rootViewController = [FRootTabBarViewController new];
                            });
                    }else{
                        self.window.rootViewController = [FRootTabBarViewController new];
                    }
                }
                break;
                case skipAdType:
                    self.window.rootViewController = [FRootTabBarViewController new];
                break;
                case overtimeAdType:
                    self.window.rootViewController = [FRootTabBarViewController new];
                break;
                default:
                    self.window.rootViewController = [FRootTabBarViewController new];
                break;
            }
        };
//        [[HomeVM new]network_getConfigWithPage:1 success:^(id model) {
//            ConfigModel* cModel = model;
//            //设置网络启动图片URL
//            NSArray* arr =[ConfigItem mj_objectArrayWithKeyValuesArray:cModel.open_screen_ads];
//            if (arr.count==0) {
//                imgAdView.adTime = 0;//过时overtimeAdType类型直接进
//                return;
//            }
//            ConfigItem* cItem = arr.firstObject;
//            imgAdView.skipBtn.alpha = 0.5;
//            imgAdView.imgUrl = cItem.img;
//            //点击响应的url
//            imgAdView.advertUrl =  cItem.url;
//            imgAdView.adTime =  cModel.adTime;
//            
//            //是否能点击
//            imgAdView.isClickAdView = cItem.type == BannerTypeH5? true : false;
//        } failed:^(id data) {
//            
//        }];
  }];
}

/// 全局配置播放器样式. 所有播放器对象均采用此`setting`.
- (void)_settingVideoPlayer {

    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
        // note: 注意这个block 是在子线程进行.
        
        /// 设置占位图
        commonSettings.placeholder = [UIImage imageNamed:@"placeholder"];
        
        // 也可以设置其他部分的.
        
        /// 设置 更多页面中`slider`的样式.
        commonSettings.more_trackColor = [UIColor whiteColor];
        commonSettings.progress_trackColor = [UIColor colorWithWhite:0.4 alpha:1];
        commonSettings.progress_bufferColor = [UIColor whiteColor];
    });
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[AccountingModel new] setDefaultDataIsForceInit:NO];
    //    [UserInfoSingleton sharedUserInfoContext].userInfo= [UserInfoManager GetNSUserDefaults];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    //View controller-based status bar appearance NO
//    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UserInfoModel new] setDefaultDataIsForceInit:NO];
    
    [self initRootUI];

    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条  这个地方注意哦⚠️默认是yes
    
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    return YES;
}
#pragma mark --- SVProgressHUD 偏好设置
- (void)svPreferrenceConf {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setInfoImage:[UIImage imageWithGIFNamed:@"M_loading"]];
    
    
//    UIImageView *svImgView = [[SVProgressHUD sharedView] valueForKey:@"imageView"];
//    CGRect imgFrame = svImgView.frame;
//
//    // 设置图片的显示大小
//    imgFrame.size = CGSizeMake(68, 68);
//    svImgView.frame = imgFrame;
    [SVProgressHUD setImageViewSize:CGSizeMake(55, 55)];
}
#pragma mark--设置网络错误回调
-(void)setNetWorkErrInfo{
    [[YTSharednetManager sharedNetManager] setAFNetStatusChangeBlock:^(managerAFNetworkStatus status) {
        NSMutableDictionary *notiDic = [NSMutableDictionary dictionary];
        [notiDic setObject:[NSString stringWithFormat:@"%ld",status] forKey:@"status"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_NetWorkingStatusRefresh object:notiDic];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    
//}
@end

