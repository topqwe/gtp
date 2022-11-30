//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "DataStatisticsVM.h"

@interface DataStatisticsVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) DataStatisticsModel* model;
@end

@implementation DataStatisticsVM

- (void)network_getDataStatisticsListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    
    
//    NSString* v =  [YBSystemTool appVersion];
//    NSString* s =  [YBSystemTool appSource];
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    
    WS(weakSelf);
//    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:API_HOMES andType:All andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
//        NSDictionary* result = dic[@"result"];
//        if ([NSString getDataSuccessed:result]) {
//            weakSelf.model = [DataStatisticsModel mj_objectWithKeyValues:dic];
            [self assembleApiData:weakSelf.model.result.data];
            success(weakSelf.listData);
            
//        }
//
//        [SVProgressHUD dismiss];
//    }];
}

- (void)assembleApiData:(DataStatisticsData*)data{

    NSDictionary* dic1 = @{kImg:@"icon_zhifubao",kTit:@"总🎂    ",kSubTit:[NSString stringWithFormat:@"%@🐶",@"99999"],kIndexInfo:@[[NSString stringWithFormat:@"%@",@"12月1日"],[NSString stringWithFormat:@"%@",@"12月7日"]],
                           kArr:
                               @[
                                   @{@(7): @[@(7),@(1),@(18),@(30),@(20),@(122),@(922)]}
//                                   ,
//                                   @{@(30): @[@(3),@(922),@(3),@(4),@(533),@(644),@(755),@(8),@(9),@(910),@(1111)]},
//                                   @{@(90): @[@(9),@(922),@(3),@(4),@(533),@(644),@(755),@(8),@(9),@(910),@(1111)]}
                           ]
                           
                           };
    NSDictionary* dic2 = @{kImg:@"icon_weixin",kTit:@"总🌹数    ",kSubTit:[NSString stringWithFormat:@"%@个",@"999"],kIndexInfo:@[[NSString stringWithFormat:@"%@",@"1月1日"],[NSString stringWithFormat:@"%@",@"1月7日"]],
                           kArr:
                               @[
                                   @{@(7): @[@(7),@(1),@(18),@(30),@(20),@(122),@(922)]},
                                   @{@(30): @[@(7),@(1),@(18),@(30),@(20),@(122),@(922),@(30),@(922),@(3),@(4),@(533),@(644),@(755),@(8),@(9),@(910),@(1111)]},
//                                   @{@(90): @[@(90),@(922),@(3),@(4),@(533),@(644),@(755),@(8),@(9),@(910),@(1110)]}
                           ]
                           };
    
    [self.listData addObjectsFromArray:@[@[dic1],@[dic2]]];//
    
}

@end
