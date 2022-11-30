//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "PostAdsVM.h"

@interface PostAdsVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) PostAdsModel* model;
@property (nonatomic, strong) id requestParams;
@end

@implementation PostAdsVM

- (void)network_getPostAdsListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    _requestParams = requestParams;
    _listData = [NSMutableArray array];
    
    
//    NSString* v =  [YBSystemTool appVersion];
//    NSString* s =  [YBSystemTool appSource];
//    
    
    
    WS(weakSelf);
//    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:API_HOMES andType:All andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
//        NSDictionary* result = dic[@"result"];
//        if ([NSString getDataSuccessed:result]) {
//            weakSelf.model = [PostAdsModel mj_objectWithKeyValues:dic];
            [self assembleApiData:weakSelf.model.result.data];
            success(weakSelf.listData);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeModelReturn" object:nil];
//        }
//        else{
//            NSLog(@".......tttttt");
//        }
//        
//    }];
}

- (void)assembleApiData:(PostAdsData*)data{
    [self removeContentWithType:IndexSectionZero];
//    if (data.r !=nil && data.r.arr.count>0) {
        [self.listData addObject:@{
                   kIndexSection: @(IndexSectionZero),
                   kIndexRow: @[@"1"]}];//@[data.r]
//    }
    
    [self removeContentWithType:IndexSectionOne];
    NSArray* fixeds = @[@"10",@"100",@"1000",@"11999"];
    //        NSArray * array = [NSArray arrayWithArray:mutableArray];
    SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,fixeds);
    UserDefaultSynchronize;
    [self.listData addObject:@{
                               kIndexSection: @(IndexSectionOne),
                               kIndexRow: @[
                                   @{kIndexInfo:
                                @{kType:self.requestParams,
                                    kArr:fixeds},
                                     
                                     }
                                            ]
                                     
                                     }];
    
    [self removeContentWithType:IndexSectionTwo];
    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
    NSDictionary* dic1 = @{kImg:@"icon_zhifubao",kTit:@"😊",kType:@"2",kIsOn:@"1"};
    NSDictionary* dic2 = @{kImg:@"icon_weixin",kTit:@"😄",kType:@"1",kIsOn:@"1"};
    NSDictionary* dic3 = @{kImg:@"icon",kTit:@"",kType:@"3",kIsOn:@"1"};
    [pays addObjectsFromArray:@[dic1,dic2,dic3]];
    
    if (pays !=nil && pays.count>0) {
        [self.listData addObject:@{
                
                kIndexSection: @(IndexSectionTwo),
                kIndexInfo:@[@"靓：",@""],
                kIndexRow: pays}//data.t.arr
         ];
    }
    
    [self removeContentWithType:IndexSectionThree];
    
    [self.listData addObject:@{
                                   
                           kIndexSection: @(IndexSectionThree),
                           kIndexInfo:@[@"快捷回复：",@""],
                           kIndexRow: @[@{kTit:@"靓靓🐟"}]}//data.t.arr
    ];
    
    [self removeContentWithType:IndexSectionFour];

    [self.listData addObject:@{
                               
                               kIndexSection: @(IndexSectionFour),
                               kIndexInfo:@[@"可可家限制：",@""],
                               kIndexRow: @[@{kTit:@"通过"},@{kTit:@"其他"}]}//data.t.arr
     ];
    
    [self sortData];
}
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}

@end
