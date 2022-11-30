//
//  ChangeURLEnvironment.m
//  gt
//
//  Created by GT on 2019/3/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import "ChangeURLEnvironment.h"
#import "AppDelegate.h"
#import "IQUIWindow+Hierarchy.h"

#define kServerFBKey @"kServerFBKey"
//TEST
static NSString *const testConfig = @"0";

//预生产
static NSString *const productConfig = @"1";

//生产
static NSString *const distributeConfig = @"2";

@implementation ChangeURLEnvironment
MACRO_SHARED_INSTANCE_IMPLEMENTATION(ChangeURLEnvironment)

//切换环境
- (void)changeEnvironment:(ActionBlock)block {
    self.block = block;
    
    NSLog(@"change environment start");
    NSString *title=@"切换环境";
    
    NSString *subTitle=@"重启后生效, 非测试人员请点击cancel";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleActionSheet];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    //    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, alertControllerStr.length)];
    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:subTitle];
    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, alertControllerMessageStr.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, alertControllerMessageStr.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    NSString *currentEnvironment=@"";
    if ([[self currentEnvironment] isEqualToString:testConfig]) {
        currentEnvironment=@"当前环境为 TEST";
        [alert addAction:[UIAlertAction actionWithTitle:@"TEST" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //测试环境
            [[NSUserDefaults standardUserDefaults] setObject:testConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"预生产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //预生产环境
            [[NSUserDefaults standardUserDefaults] setObject:productConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"正式发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //生产环境
            [[NSUserDefaults standardUserDefaults] setObject:distributeConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
    } else if ([[self currentEnvironment] isEqualToString:productConfig]) {
        
        currentEnvironment=@"当前环境为 预生产";
        
        [alert addAction:[UIAlertAction actionWithTitle:@"TEST" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //测试环境
            [[NSUserDefaults standardUserDefaults] setObject:testConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"预生产" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //预生产环境
            [[NSUserDefaults standardUserDefaults] setObject:productConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"正式发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //生产环境
            [[NSUserDefaults standardUserDefaults] setObject:distributeConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
    }else if ([[self currentEnvironment] isEqualToString:distributeConfig]) {
        
        currentEnvironment=@"当前环境为 正式发布";
        
        [alert addAction:[UIAlertAction actionWithTitle:@"TEST" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //测试环境
            [[NSUserDefaults standardUserDefaults] setObject:testConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"预生产" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //预生产环境
            [[NSUserDefaults standardUserDefaults] setObject:productConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"正式发布" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //生产环境
            [[NSUserDefaults standardUserDefaults] setObject:distributeConfig forKey:kServerFBKey];
            //重置请求的基url
            [self resetRequestBaseUrl];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    
    NSLog(@"currentEnvironment = %@", currentEnvironment);
    //当前选择的视图控制器需要自己赋值，比如tabbar的didSelectViewController里
    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:YES completion:^{
    }];
    [YKToastView showToastText:currentEnvironment];
}


//获得当前环境
- (NSString *)currentEnvironment{
    //默认测试环境
    NSString *currentEnvironment = distributeConfig;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kServerFBKey]) {
        currentEnvironment = [[NSUserDefaults standardUserDefaults] objectForKey:kServerFBKey];
    }
    return currentEnvironment;
}

#pragma mark - 切换测试线和预生产环境
- (void)resetRequestBaseUrl {
    NSString *resetEnvironment=@"";
    if ([[ChangeURLEnvironment sharedInstance].currentEnvironment isEqualToString:testConfig]) {
        //测试环境
        SetUserDefaultKeyWithObject(URL_IP,@"https://test.com/");
        UserDefaultSynchronize;
        resetEnvironment = @"已切到测试环境";
        NSLog(@"测试环境。。。。。。。");
    }
    else if ([[ChangeURLEnvironment sharedInstance].currentEnvironment isEqualToString:productConfig]) {
        //预生产环境
        SetUserDefaultKeyWithObject(URL_IP,@"https://developer.com/" );
        UserDefaultSynchronize;
        resetEnvironment = @"已切到预生产环境";
        NSLog(@"预生产环境.........");
    }
    else if ([[ChangeURLEnvironment sharedInstance].currentEnvironment isEqualToString:distributeConfig]) {
        //正式发布环境
        SetUserDefaultKeyWithObject(URL_IP,@"https:// formal.com/api/" );
        UserDefaultSynchronize;
        resetEnvironment = @"已切到正式发布环境";
        NSLog(@"正式发布环境.........");
    }
    [YKToastView showToastText:resetEnvironment];
    if (self.block) {
        self.block(@1);
    }
}
@end
