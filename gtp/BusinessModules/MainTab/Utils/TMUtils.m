//
//  GHUtils.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMUtils.h"
#import "BVCateActorDetailViewController.h"
#import "STWebViewController.h"
#import "BVVideoDetailViewController.h"
#import "LGShareViewController.h"
#import "SVPushCodeViewController.h"
@implementation TMUtils
+ (BOOL)isIphoneX{
    if (ios11) {
        if (UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom) {
            return YES;
        }
    }
    return NO;
}
+ (void)netWorkMonitorinCanUseWithHandle:(void (^)())handle{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            if (handle) {
                handle();
            }
        }
    }];
    [manager startMonitoring];
}
+ (UIView*)headerViewWithTitle:(NSString*)title{
    UIView * sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(15, 0, UIScreenWidth - 30, 44)
                                                     text:title
                                                textColor:TM_firstTextColor
                                                     font:14
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    
    [sectionHeader addSubview:titleLable];
    return sectionHeader;
}
+ (UINavigationBar *)navigationBar{
    UINavigationController* nav = (id)[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers.firstObject;
    return nav.navigationBar;
}
+  (UITabBar *)tabbar{
    UITabBarController* tab = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    return tab.tabBar;
}
+ (CGFloat)navgationBarBootom{
    if (ios11) {
        UIWindow * window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.bottom) {
            return 88;
        }
    }

    return 64;
}
+ (CGFloat)tabBarTop{
    if (ios11) {
        UIWindow * window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.bottom) {
            return (UIScreenHeight - 83);
        }
    }
    return (UIScreenHeight - 49);
}
+ (void)debugSimulationNetWorkWithHadle:(void (^)(NSInteger, NSMutableArray *))handle{
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSInteger num = 0.5;
    NSInteger randrom = arc4random()%15;
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i < randrom; i ++) {
        [array addObject:@(i)];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(num * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (handle) {
            handle(num,array);
        }
    });
}
+ (void)sendNoJsonRequestWithUrl:(NSString *)url params:(NSDictionary *)params isPost:(BOOL)isPost handle:(void (^)(BOOL, NSString *))handle{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger.requestSerializer setValue:@"" forHTTPHeaderField:@"app-token"];
    if (STUserManger.defult.noLoginToken.length) {
        NSString *value = STUserManger.defult.noLoginToken;
        [manger.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
        [manger.requestSerializer setValue:value forHTTPHeaderField:@"token"];
    }else{
        if (STUserManger.defult.loginedUser.token.length) {
            NSString *value = STUserManger.defult.loginedUser.token;
            [manger.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
            [manger.requestSerializer setValue:value forHTTPHeaderField:@"token"];
        }
    }
    
    
    manger.requestSerializer.timeoutInterval = 20;
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    if (isPost) {
        [manger PUT:url parameters:params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (handle) {
                handle(YES,string);
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (handle) {
                handle(NO,nil);
            }
            [SVProgressHUD dismiss];
        }];
    }else{
        [manger GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (handle) {
                handle(YES,string);
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (handle) {
                handle(NO,nil);
            }
            [SVProgressHUD dismiss];
        }];
    }
    
    
}
+ (STButton *)titleButtonViewWithTile:(NSString *)title showRightGo:(BOOL)showRightGo handle:(void (^)())handle{
    STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)
                                                     title:title
                                                titleColor:FirstTextColor
                                                 titleFont:16
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:nil];
    buyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    buyButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [buyButton setClicAction:^(UIButton *sender) {
        if (handle) {
            handle();
        }
    }];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的_16"]];
    imageView.right = UIScreenWidth - 10;
    imageView.centerY = 22;
    imageView.userInteractionEnabled = NO;
    [buyButton addSubview:imageView];
    imageView.hidden = !showRightGo;
    return buyButton;
}
+ (STButton *)titleThemeButtonViewWithTile:(NSString *)title showRightGo:(BOOL)showRightGo handle:(void (^)())handle{
    STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)
                                                     title:title
                                                titleColor:UIColor.whiteColor
                                                 titleFont:14
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:nil];
    buyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15 , 0, 0);
    [buyButton setClicAction:^(UIButton *sender) {
        if (handle) {
            handle();
        }
    }];
    buyButton.tag = 20000;
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 8, 20)];
    greenView.backgroundColor = TM_YellowBackGroundColor;
//    [buyButton addSubview:greenView];
    greenView.centerY = buyButton.height/2;
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)
                                                     text:@"更多"
                                                textColor:ThirdTextColor
                                                     font:13
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentRight];
    [buyButton addSubview:titleLable];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_right_brown"]];
    imageView.right = UIScreenWidth - 10;
    imageView.centerY = 22;
    [buyButton addSubview:imageView];
    imageView.hidden = !showRightGo;
    titleLable.right = imageView.left - 10;
    
    if (!showRightGo) {
        imageView.hidden = YES;
        titleLable.hidden = YES;
    }
    return buyButton;
}

+ (UITextField*)textFiledWithLeftImage:(NSString*)leftImage placeHolader:(NSString*)placeHolader  rightView:(UIView*)rightView{
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
    STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, textFiled.height, textFiled.height)
                                                     title:nil
                                                titleColor:nil
                                                 titleFont:0
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:[UIImage imageNamed:leftImage]];
    buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textFiled.leftView = buyButton;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textFiled.placeholder = placeHolader;
    
    textFiled.rightView = rightView;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    return textFiled;
}
+ (UITextField*)textFiledWithLeftTitle:(NSString*)leftTitle placeHolader:(NSString*)placeHolader  rightView:(UIView*)rightView{
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
    STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, textFiled.height, textFiled.height)
                                                     title:leftTitle
                                                titleColor:FirstTextColor
                                                 titleFont:14
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:nil];
    buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textFiled.leftView = buyButton;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textFiled.placeholder = placeHolader;
    
    textFiled.rightView = rightView;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    return textFiled;
}
+ (NSURL *)placeHolderImageUrlFromFakeimgPlWithHeight:(NSString *)height witdh:(NSString *)witdh chineseAlsert:(NSString *)chineseAlsert color:(NSString *)color handle:(void (^)(UIImage *))handle{
    NSString * originUrl = @"https://fakeimg.pl";
    if (color.length) {
        originUrl =  [NSString stringWithFormat:@"%@/%@",originUrl,color];
    }
    if (height.floatValue && witdh.floatValue) {
        originUrl =  [NSString stringWithFormat:@"%@/%@x%@",originUrl,witdh,height];
    }else{
        originUrl =  [NSString stringWithFormat:@"%@/%@x%@",originUrl,@"200",@"200"];
    }
    if (chineseAlsert.length) {
        originUrl =  [NSString stringWithFormat:@"%@/?text=%@&font=noto",originUrl,chineseAlsert];
    }
    NSString *strUrl = originUrl;
    NSURL *url = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (handle) {
            handle(image);
        }
    }];
    return url;
    
}

+ (void)makeViewToThemeGrdualColor:(UIView *)view{
//    view.backgroundColor = TM_ThemeBackGroundColor;
//    return;
    view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:view.bounds andColors:@[TM_ThemeBackGroundColor,UIColorFromRGBA(0xDF6DB7)]];
}


//随即一个数字，出现偶数和奇数
+ (void)randNumberWithOuHandle:(void(^)(void))oushuHandle jiHandle:(void(^)(void))jiHandle{
    NSInteger num = arc4random()%1000;
    if (num%2 == 0) {
        if (oushuHandle) {
            oushuHandle();
        }
    }else{
        if (jiHandle) {
            jiHandle();
        }
    }
}
//上传图片
+ (void)uploadImage:(UIImage*)image handle:(void (^)(BOOL, NSString *, NSString *))handle{
    if (!image) {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"User/uploadImage"];
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    [[STNetWrokManger defaultClient] imageRequestWithPath:url parameters:paramDic image:image imageName:@"file" progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary * dic = responseObject[@"data"];
        NSString * url = dic[@"path"];
        NSString * thumbnail = dic[@"thumbnail"];
        
        if (handle) {
            handle(YES,url,thumbnail);
        }
        
    } failure:^(NSString *stateCode, STError *error, NSError *originError) {
        if (handle) {
            handle(NO,nil,@"");
        }
    }];
}
//上传图片
+ (void)uploadCircleImage:(UIImage*)image handle:(void (^)(BOOL, NSString *, NSString *))handle{
    if (!image) {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/uploadImage"];
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    [[STNetWrokManger defaultClient] imageRequestWithPath:url parameters:paramDic image:image imageName:@"file" progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary * dic = responseObject[@"data"];
        NSString * url = dic[@"path"];
        NSString * thumbnail = dic[@"thumbnail"];
        
        if (handle) {
            handle(YES,url,thumbnail);
        }
        
    } failure:^(NSString *stateCode, STError *error, NSError *originError) {
        if (handle) {
            handle(NO,nil,@"");
        }
    }];
}
//上传多张图片
+ (void)uploadMoreImage:(NSArray<UIImage*>*)imageArray handle:(void (^)(BOOL, NSArray *))handle{
    NSMutableArray * imageurlArray = NSMutableArray.new;
    dispatch_group_t group = dispatch_group_create();
    for (UIImage * image in imageArray) {
        dispatch_group_enter(group);
        [TMUtils uploadCircleImage:image handle:^(BOOL success, NSString *imageUrl,NSString *thumbnail) {
            if (imageUrl.length) {
//                TMDynamicImageModel * model = TMDynamicImageModel.new;
//                model.max = imageUrl;
//                model.min = thumbnail;
                if (imageUrl.length && thumbnail.length) {
                    NSDictionary * dic = @{@"max":imageUrl,@"min":thumbnail};
                    [imageurlArray addObject:dic];
                }

            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (handle) {
            handle(YES,imageurlArray);
        }
    });
}


//逻辑
+ (void)gotoVideoDetailWithVideoId:(NSString*)video_id{
    BVVideoDetailViewController * vc = BVVideoDetailViewController.new;
    vc.v_id = video_id;
    [vc.st_currentNavgationController pushViewController:vc animated:YES];
}
+ (void)gotoActorDetailWithActorID:(NSString*)actor_id{
    BVCateActorDetailViewController * vc = BVCateActorDetailViewController.new;
    vc.actor_id = actor_id;
    [vc.st_currentNavgationController pushViewController:vc animated:YES];
}
//去广告
+ (void)gotoAdverController:(BVAdverModel*)model{
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:model.link]];
}
+ (void)gotoAllcateWithSting:(NSString *)cate{
    BVAllCateVideoViewController * vc = BVAllCateVideoViewController.new;
    vc.cateName = cate;
    [UIViewController.new.st_currentNavgationController pushViewController:vc animated:YES];
}
//分享
+ (void)onSelctedShareButton{
    SVPushCodeViewController * vc = SVPushCodeViewController.new;
    [vc.st_currentNavgationController pushViewController:vc animated:YES];
}
//弹出登录
+ (void)presentLoginViewController{
    UITabBarController *  vc = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController * curNav = (id)vc.selectedViewController;
    STNavigationController * nav = [[STNavigationController alloc] initWithRootViewController:TMLoginViewController.new];
    [vc presentViewController:nav animated:YES completion:^{
        [curNav popToRootViewControllerAnimated:NO];
        [vc setSelectedIndex:0];
    }];
}
@end
