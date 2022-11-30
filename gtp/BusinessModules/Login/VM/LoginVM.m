//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "LoginVM.h"

@interface LoginVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) LoginModel* model;
@property (nonatomic,strong) UserInfoModel* userInfoModel;
@property (nonatomic, strong) NSDictionary* requestParams;
@end

@implementation LoginVM

- (void)network_getLoginWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    self.requestParams = requestParams;
    _listData = [NSMutableArray array];
    
    NSString* n =  self.requestParams.allKeys[0];
    NSString* p =  self.requestParams.allValues[0];
    NSDictionary* proDic =@{@"loginname":n,@"pwd":p};
    
    
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType12] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [LoginModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
        [YKToastView showToastText:self.model.msg];
        
    } error:^(NSError *error) {
        err(error);
        [YKToastView showToastText:error.description];
    }];
    
}

- (void)network_postLoginWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    self.requestParams = requestParams;
    _listData = [NSMutableArray array];
    
    NSString *uuid = [YBSystemTool getUUIDString];
    
    NSMutableDictionary* proDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary* env = [NSMutableDictionary dictionary];
    [env addEntriesFromDictionary:@{@"version":[YBSystemTool appVersion]}];
    [proDic addEntriesFromDictionary:@{@"env":env}];
    
    NSMutableDictionary* dev = [NSMutableDictionary dictionary];
    [dev addEntriesFromDictionary:@{@"model":[YBSystemTool deviceModel]}];
    [dev addEntriesFromDictionary:@{@"system":[YBSystemTool deviceModelName]}];
    [dev addEntriesFromDictionary:@{@"language":[YBSystemTool localPhoneModel]}];
    [dev addEntriesFromDictionary:@{@"platform":@"ios"}];
    [dev addEntriesFromDictionary:@{@"deviceId":uuid}];
    [proDic addEntriesFromDictionary:@{@"dev":dev}];
    
    
    NSInteger t = 1;
    NSString* n = @"";
    
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    if (userInfoModel.data.account.length>0) {
        t = 2;
        n = [NSString stringWithFormat:@"%@",userInfoModel.data.account];
    }
    [proDic addEntriesFromDictionary:@{@"type":@(t),@"did":uuid,@"name":n}];
//    [proDic addEntriesFromDictionary:@{@"test":@(1)}];
    
//    NSString* p =  self.requestParams.allValues[0];
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType12] andType:All andWith:proDic success:^(NSDictionary *dic) {
//        self.model = [LoginModel mj_objectWithKeyValues:dic];
        
//        self.userInfoModel = [UserInfoManager GetNSUserDefaults];
        self.userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            
            self.userInfoModel.isLogin = true;
            [UserInfoManager SetNSUserDefaults:self.userInfoModel];
            success(weakSelf.userInfoModel);
        }
        else{
//            failed(weakSelf.userInfoModel);
            NSLog(@".......dataErr");
            failed(@"dataErr");
//            [YKToastView showToastText:weakSelf.userInfoModel.msg];
        }
        
        
    } error:^(NSError *error) {
        err(error);
//        [YKToastView showToastText:error.description];
    }];
//    
    
    
}
@end
