//
//  BVCateDataController.m
//  BannerVideo
//
//  Created by apple on 2019/3/31.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCateDataController.h"

@implementation BVCateDataController
//获取演员信息
+ (void)sendFetchActorRequestWith:(NSString*)actor_id handle:(void(^)(bool success, BVActorModel*model))handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    if (actor_id.length) {
        [paramDic setObject:actor_id forKey:@"id"];
    }
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/performerInfo"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSDictionary * modeldic = responseObject[@"data"][@"performer"];
                                                 BVActorModel * model = [BVActorModel mj_objectWithKeyValues:modeldic];
                                                 if (handle) {
                                                     handle(YES,model);
                                                 }
                                                 
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 if (handle) {
                                                     handle(NO,nil);
                                                 }
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
+ (void)sendCollectActorRequestWithActor_id:(NSString *)actor_id handle:(STDataControllerHandle)handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (actor_id.length) {
        [paramDic setObject:actor_id forKey:@"id"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/doCollection"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 if (handle) {
                                                     handle(nil,YES,responseObject);
                                                 }
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 if (handle) {
                                                     handle(originError,NO,error.resp);
                                                 }
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end
