//
//  BVCircleDataController.m
//  BannerVideo
//
//  Created by Mac on 2019/3/29.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCircleDataController.h"

@implementation BVCircleDataController
//获取banner
+ (void)sendGetCircleBannerRequestWithHandle:(void(^)(NSArray<BVAdverModel*> * array))handle{
    
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/getSlide"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"banners"];
                                                 NSArray * banners = [BVAdverModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (handle) {
                                                     handle(banners);
                                                 }
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 if (handle) {
                                                     handle(@[]);
                                                 }
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}

//获取区域包括全部
+ (void)sendGetGeginRequestWithHandle:(void(^)(NSArray * reginArray))handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/regions"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 NSMutableArray * array = [[responseObject valueForKey:@"data"][@"regions"] mutableCopy];
                                                 if (array.count) {
                                                     [array insertObject:@{@"id":@"",@"name":@"全部"} atIndex:0];
                                                 }
                                                 if (handle) {
                                                     handle(array);
                                                 }
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 if (handle) {
                                                     handle(@[]);
                                                 }
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}

//组获取 区域和banner
+ (void)sendGroupGetReginAndBannerRequestWithHandle:(void(^)(NSArray<BVAdverModel*> * banerArray,NSArray * reginArray))handle{
    dispatch_group_t group = dispatch_group_create();
    
    __block NSArray * realbannerArray;
    __block NSArray * realreginArray;
    dispatch_group_enter(group);
    [self sendGetCircleBannerRequestWithHandle:^(NSArray<BVAdverModel *> * _Nonnull array) {
        realbannerArray = array.copy;
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    [self sendGetGeginRequestWithHandle:^(NSArray * _Nonnull reginArray) {
        realreginArray = reginArray.copy;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (handle) {
            handle(realbannerArray,realreginArray);
        }
    });
}

//点赞
+ (void)sendGoodRequestWithD_id:(NSString*)d_id handle:(STDataControllerHandle)handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (d_id.length) {
        [paramDic setObject:d_id forKey:@"id"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/loveCircle"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 
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

//
+ (void)senGoodCommentRequestWithc_id:(NSString*)c_id handle:(STDataControllerHandle)handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (c_id.length) {
        [paramDic setObject:c_id forKey:@"id"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/loveComment"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 
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

//评论内容
+ (void)sendAddCommentRequestWithd_id:(NSString*)d_id content:(NSString*)content handle:(STDataControllerHandle)handle{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (d_id.length) {
        [paramDic setObject:d_id forKey:@"circle_id"];
        
    }
    if (content.length) {
        [paramDic setObject:content forKey:@"content"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/commentCircle"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 
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

