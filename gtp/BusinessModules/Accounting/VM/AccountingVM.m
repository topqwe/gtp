//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "AccountingVM.h"

@interface AccountingVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) AccountingModel* model;
@end

@implementation AccountingVM

- (void)network_getDataStatisticsListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    
    
//    NSString* v =  [YBSystemTool appVersion];
//    NSString* s =  [YBSystemTool appSource];
//    
    
    
    WS(weakSelf);
//    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:API_HOMES andType:All andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
//        NSDictionary* result = dic[@"result"];
//        if ([NSString getDataSuccessed:result]) {
//            weakSelf.model = [DataStatisticsModel mj_objectWithKeyValues:dic];
            [self assembleApiData:weakSelf.model];
            success(weakSelf.listData);
            
//        }
//
//        
//    }];
}

- (void)assembleApiData:(AccountingModel*)data{
    
}

@end
