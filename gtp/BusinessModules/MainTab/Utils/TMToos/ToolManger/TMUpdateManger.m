//
//  TMUpdateManger.m
//  WorthWhile
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018年 stoneobs.icloud.com. All rights reserved.
//

#import "TMUpdateManger.h"
#import "NSBundle+STSystemTool.h"
@interface TMUpdateManger()
@property(nonatomic, strong) NSDictionary                     *originDic;/**< 初始字典 */
@end
@implementation TMUpdateManger
+ (TMUpdateManger *)manger{
    static TMUpdateManger * manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = TMUpdateManger.new;
    });
    return manger;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sendUpdateVersionRequest];
    }
    return self;
}
- (BOOL)shouldDealWithTheAudit{
    if (!self.originDic) {
        return YES;
    }else{
        NSString * ios_debug_version =  [self.originDic[@"ios_debug_version"] description];
        NSString * is_appstore_review =  [self.originDic[@"is_appstore_review"] description];
        NSString * currentVersion = NSBundle.st_applictionVersin;
        if (ios_debug_version.floatValue == currentVersion.floatValue && is_appstore_review.boolValue) {
            return YES;
        }
        return NO;
    }
    
}
- (BOOL)judgeShouldUpdate{
    if (self.originDic) {
        NSString * ios_release_version =  [self.originDic[@"ios_release_version"] description];
        NSString * currentVersion = NSBundle.st_applictionVersin;
        if (ios_release_version.floatValue > currentVersion.floatValue) {
            //需要更新
            NSString * updateContent = [self.originDic[@"updateContent"] description];
            updateContent =  [updateContent stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
            UIViewController * vc  = UIViewController.new.st_currentNavgationController;
            
            UIWindow * window = UIApplication.sharedApplication.delegate.window;
            
            bool shouldForceUpdate = [self.originDic[@"shouldForceUpdate"] boolValue];
            if (!shouldForceUpdate) {
                [vc st_showAlertWithTitle:@"检测到更新"
                            titleColor:FlatBlack
                               message:updateContent
                          messageColor:SecendTextColor
                             leftTitle:@"取消"
                        leftTitleColor:ThirdTextColor
                            rightTitle:@"去更新"
                       rightTitleColor:FlatRed
                                handle:^(NSString *name) {
                                    if ([name isEqualToString:@"去更新"]) {
                                        NSString * updateUrl = [self.originDic[@"updateUrl"] description];
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                                        
                                    }
                                    
                                }];
                return YES;
            }else{
                //强制更新
                [vc st_showAlertWithTitle:@"检测到更新(必须更新,否则无法使用)"
                            titleColor:FlatBlack
                               message:updateContent
                          messageColor:SecendTextColor
                             leftTitle:@""
                        leftTitleColor:ThirdTextColor
                            rightTitle:@"去更新"
                       rightTitleColor:FlatRed
                                handle:^(NSString *name) {
                                    [UIView animateWithDuration:0.6 animations:^{
                                        
                                        window.rootViewController.view.frame = CGRectMake(0, 0, 0, 0);
                                        window.rootViewController.view.alpha = 0.1;
                                        window.rootViewController.view.center = window.center;
                                        
                                    } completion:^(BOOL finished) {
                                        if ([name isEqualToString:@"去更新"]) {
                                            NSString * updateUrl = [self.originDic[@"updateUrl"] description];
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                                            exit(0);
                                        }
                                    }];
                                    
                                }];
                 return YES;
            }
            
            
        }else{
             return NO;

        }
    }else{
        [self sendUpdateVersionRequest];
    }
    return NO;
}
#pragma mark --NetWork Method
- (void)sendUpdateVersionRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"/ios/version"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.requestSerializer.timeoutInterval = 20;
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manger GET:url parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dataDic = responseObject;
        self.originDic = dataDic;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        

    }];
    
}
@end

