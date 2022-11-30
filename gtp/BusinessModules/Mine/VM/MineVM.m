//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "MineVM.h"

@interface MineVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) NSMutableArray* lastSectionSumArr;
@property (nonatomic,strong) UserInfoModel*userInfoModel;
@property (nonatomic,strong) HomeModel* model;
@property (nonatomic,strong) NSMutableDictionary* zeroSectionDic;

@end

@implementation MineVM
- (void)network_postQueryLevelWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"order_id":requestParams};
    
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType42] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            NSArray* arr = @[];
//            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
//            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kNotify_LevRefresh object:@{@"p":@""}];
            
            success(weakSelf.model);
        }
        else{
            
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}
- (void)network_postFinalLevelMethodSureWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = requestParams;
    
    [SVProgressHUD showWithStatus:@"好的中， 请勿重复提交"];
//    [YKToastView showToastText:[NSString stringWithFormat:@"%@",@"好的中， 请勿重复提交"]];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType41] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            NSArray* arr = @[];
//            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
//            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:kNotify_LevRefresh object:@{@"p":@""}];
            
            success(weakSelf.model);
        }
        else{
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}

- (void)network_postLevelMethodSureWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    NSDictionary* resDic = requestParams;
    id obj = resDic.allValues[0];
    if ([obj isKindOfClass:[HomeList class]]) {
        HomeList* list = obj;
        dic  = @{
//            @"rechargeType":@([resDic.allKeys[0] integerValue]),
            @"type":@"1",
            @"goods_id":[NSString stringWithFormat:@"%@",@(list.ID)],
            @"time":[NSString getCurrentTimestamp]
//            @"amount":[NSString stringWithFormat:@"%@",list.valid_period>0 ? list.real_value: list.value]
        };
    }
    else if ([obj isKindOfClass:[HomeItem class]]) {
        HomeItem* item = obj;
        dic  = @{
//        @"rechargeType":@([resDic.allKeys[0] integerValue]),
        @"type":@"2",
        @"goods_id":[NSString stringWithFormat:@"%@",@(item.ID)],
        @"time":[NSString getCurrentTimestamp]
//        @"amount":[NSString stringWithFormat:@"%@",item.money]
        };
    }
//    [SVProgressHUD showWithStatus:@"好的中， 请勿重复提交"];
//    [YKToastView showToastText:[NSString stringWithFormat:@"%@",@"好的中， 请勿重复提交"]];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType40] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            NSArray* arr = @[];
//            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
//            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_LevRefresh object:@{@"p":@""}];
            
            success(weakSelf.model);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}
- (void)network_getLevelMethodWithRequestParams:(id)requestParams  success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    [SVProgressHUD showInfoWithStatus:@""];
    WS(weakSelf);
    NSDictionary* dic = requestParams;
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType39] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            NSArray* arr = @[];
            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            
            success(arr);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}
- (void)network_getLevelInfoWithRequestParams:(id)requestParams  success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi: [requestParams intValue] == 0? ApiType37:ApiType38] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            NSArray* arr = @[];
            if ([requestParams intValue] == 0) {
                arr =[HomeList mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
            }else{
                arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            }
            
            success(arr);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}
- (void)network_getUserExtendInfoWithRequestParams:(id)requestParams  success:(void(^)(HomeModel *model))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType36] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            
            success(weakSelf.model);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}


- (void)network_postBindInviteCodeWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed{
    
    
    
    _listData = [NSMutableArray array];
//    if (s != EditRecordSourceAvatar) {
//        [SVProgressHUD showWithStatus:@"修改中..." maskType:SVProgressHUDMaskTypeNone];
//    }
    
    
//    WS(weakSelf);
    NSDictionary* dic = @{@"code":requestParams};
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType31] andType:All andWith:dic success:^(NSDictionary *dic) {
        
        
        UserInfoModel* userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
        [YKToastView showToastText:[NSString stringWithFormat:@"%@",userInfoModel.msg]];
        
        if ([NSString getDataSuccessed:dic]) {
            //接口一次
            
            success(userInfoModel);
        }
        else{
//               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            
            [YKToastView showToastText:[NSString stringWithFormat:@"%@",error.description]];
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
        
        
}

- (void)network_postShareWithRequestParams:(id)requestParams  success:(void(^)(HomeModel *model))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType29] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            
            success(weakSelf.model);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}

- (void)network_postEditUserInfosWithRequestParams:(id)requestParams WithSource:(EditRecordSource)s
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed{
    
    
    
    _listData = [NSMutableArray array];
//    if (s != EditRecordSourceAvatar) {
//        [SVProgressHUD showWithStatus:@"修改中..." maskType:SVProgressHUDMaskTypeNone];
//    }
    
    
    WS(weakSelf);
    NSDictionary* dic ;
    self.userInfoModel = [UserInfoManager GetNSUserDefaults];
    
    switch (s) {
        case EditRecordSourceAvatar:
        {
            dic = @{@"avatar":requestParams};
            self.userInfoModel.data.avatar = [requestParams integerValue];
        }
            break;
        case EditRecordSourceNickName:
        {
            dic = @{@"nickname":requestParams};
            self.userInfoModel.data.nickname = requestParams;
        }
            break;
        case EditRecordSourceGender:
        {
            dic = @{@"sex":requestParams};
            self.userInfoModel.data.sex = [requestParams integerValue];
            
        }
            break;
        case EditRecordSourcePhoneNumber:
        {
            dic = @{@"phone_number":requestParams};
        }
            break;
        default:
            break;
    }
    
    //本地一次
    [UserInfoManager SetNSUserDefaults:self.userInfoModel];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType28] andType:All andWith:dic success:^(NSDictionary *dic) {
//        self.userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
        
//        self.userInfoModel = [UserInfoManager GetNSUserDefaults];
        
        UserInfoModel* userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
        [YKToastView showToastText:[NSString stringWithFormat:@"%@",userInfoModel.msg]];
        
        if ([NSString getDataSuccessed:dic]) {
            self.userInfoModel.data.avatar = userInfoModel.data.avatar;
            self.userInfoModel.data.nickname = userInfoModel.data.nickname;
            self.userInfoModel.data.sex = userInfoModel.data.sex;
            //接口一次
            [UserInfoManager SetNSUserDefaults:self.userInfoModel];
            
            success(weakSelf.userInfoModel);
        }
        else{
//               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            
            [YKToastView showToastText:[NSString stringWithFormat:@"%@",error.description]];
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
        
        
}
- (void)network_postPWCode:(id)res WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    WS(weakSelf);
    NSArray* arr =res;
    NSDictionary* dic = @{
        @"phone":arr.firstObject,
//            arr.firstObject,
//            [NSString stringWithFormat:@"%@",arr.firstObject],
        @"areaNum":arr.lastObject,
//        [NSString stringWithFormat:@"%@",arr.lastObject]
        
    };
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType46] andType:All andWith:dic success:^(NSDictionary *dic) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            
            success(@[]);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
//            [YKToastView showToastText:[NSString stringWithFormat:@"%@",error.description]];
            failed(@"servicerErr");
        }];
}

- (void)network_postPW:(NSArray*)arr WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    WS(weakSelf);
    NSDictionary* dic = @{
        @"phone":@([arr[0] integerValue]),
                         
        @"code":@([arr[1] integerValue])
//        [NSString stringWithFormat:@"%@",arr[1]]
        
    };
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:s == 0?ApiType47 :ApiType48] andType:All andWith:dic success:^(NSDictionary *dic) {
//        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        
        if ([NSString getDataSuccessed:dic]) {
            if (s == 1) {
                UserInfoModel* userInfoModel = [UserInfoModel mj_objectWithKeyValues:dic];
                userInfoModel.isLogin = true;
                
                [UserInfoManager SetNSUserDefaults:userInfoModel];
                success(userInfoModel);
            }else{
                success(@[]);
            }
            
        }
        else{
            NSLog(@".......dataErr");
            failed(@"dataErr");

        }
//        if ([NSString getDataSuccessed:dic]) {
//
//
//            success(@[]);
//        }
//        else{
//               NSLog(@".......dataErr");
//               failed(@"dataErr");
//            }
        [YKToastView showToastText:[NSString stringWithFormat:@"%@",dic[@"msg"]]];
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}
- (void)network_getDeteleEditRecord:(NSArray*)arr WithSource:(EditRecordSource)s success:(void(^)(NSArray *dataArray))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"delete":@(1),@"vid":arr};
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:s == EditRecordSourcViewHistory?ApiType26 :ApiType27] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
            success(@[]);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
}

- (void)network_getEditRecordPage:(NSInteger)page WithSource:(EditRecordSource)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"page":@(page),@"pageSize":@(10)};
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:s == EditRecordSourcViewHistory?ApiType24 :ApiType25] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleMoreApiData:arr WithPage:page];

        success(weakSelf.listData,arr,self.lastSectionSumArr);
        }
        else{
               NSLog(@".......dataErr");
               failed(@"dataErr");
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr");
        }];
        
        
}

- (void)assembleMoreApiData:(NSArray*)data WithPage:(NSInteger)page{

//    [self removeContentWithType:IndexSectionOne];

    if (data !=nil && data.count>0 ) {
        [_lastSectionSumArr addObjectsFromArray:data];
        [self.listData addObjectsFromArray:_lastSectionSumArr];
//        [self.listData addObject:@{
//
//                kIndexSection: @(IndexSectionOne),
//                kIndexInfo:@[@"为你推荐",@(0),@""],
//                kIndexRow: @[_lastSectionSumArr]}//data.t.arr
//         ];
    }
    
//    [self sortData];
}

- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(NSInteger)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}

@end
