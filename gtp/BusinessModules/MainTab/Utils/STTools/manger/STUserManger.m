//
//  STUserManger.m
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STUserManger.h"
#import "NSBundle+STSystemTool.h"
#define TM_USER_JSON_KEY @"TM_USER_JSON_KEY"
#define TM_USER_ACCOUNT_KEY @"TM_USER_ACCOUNT_KEY"
#define TM_USER_PWD_KEY @"TM_USER_PWD_KEY"

#define TM_USER_NO_LOGIN_TOKEN @"TM_USER_NO_LOGIN_TOKEN"
@implementation STUserManger
+ (STUserManger *)defult{
    static STUserManger * deflut = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deflut = [STUserManger new];
    });
    return deflut;
}
- (NSString *)noLoginToken{
//    NSString * key = [NSBundle st_readUUIDFromKeyChain];
    //更改 不从钥匙串，只存沙盒
    NSString * key = [[NSUserDefaults standardUserDefaults] valueForKey:TM_USER_NO_LOGIN_TOKEN];
    return key;
}
- (void)removeUserPreferce{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TM_USER_JSON_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TM_USER_ACCOUNT_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TM_USER_PWD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)updateUserModel:(BVUserModel *)userModel{
    if (userModel) {
        if ([self loginedUser].token.length) {
            //不更新token
            userModel.token = [self loginedUser].token;
        }
        
        NSString * userString = userModel.mj_JSONString;
        [[NSUserDefaults standardUserDefaults] setValue:userString forKey:TM_USER_JSON_KEY];
    }else{
        NSLog(@"user 不能为空");
    }
}
- (BVUserModel *)loginedUser{
    NSString * jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:TM_USER_JSON_KEY];
    NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonStr.length) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        BVUserModel *loginedUser = [BVUserModel mj_objectWithKeyValues:dic];
        return loginedUser;
    }
    return nil;
}

- (void)updateAccount:(NSString *)account pwd:(NSString *)pwd{
    if (account.length && pwd.length) {
        [[NSUserDefaults standardUserDefaults] setValue:account forKey:TM_USER_ACCOUNT_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:TM_USER_PWD_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
- (NSString*)account{
    NSString * account = [[NSUserDefaults standardUserDefaults] valueForKey:TM_USER_ACCOUNT_KEY];
    return account;
}
- (NSString*)pwd{
    NSString * pwd = [[NSUserDefaults standardUserDefaults] valueForKey:TM_USER_PWD_KEY];
    return pwd;
}
- (void)fetchNoLoginToken{
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"user/init"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypeGet
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSDictionary * modelDic = [responseObject valueForKey:@"data"];
                                                 NSString * nologintoken = [modelDic[@"app-token"] description];
//                                                 [NSBundle st_saveUUIDToKeyChain:nologintoken];
                                                 [[NSUserDefaults standardUserDefaults] setObject:nologintoken forKey:TM_USER_NO_LOGIN_TOKEN];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:FIRST_INIT_NOTIFACATION object:nologintoken];
                                                 self.noLoginInviteCode = [modelDic[@"invite_code"] description];
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
//                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                     [self fetchNoLoginToken];
                                                 });
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end

