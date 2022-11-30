//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ModifyAdsVM.h"

@interface ModifyAdsVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) ModifyAdsModel* model;
@end

@implementation ModifyAdsVM

- (void)network_getModifyAdsListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
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

- (void)assembleApiData:(ModifyAdsData*)data{
    [self removeContentWithType:IndexSectionZero];
    NSDictionary* dic0 = @{kType:@(OrderTypeFinished),kImg:@"iconSucc",kTit:@"状态",kSubTit:[NSString stringWithFormat:@"%@",@"已上线"], kIndexSection:@(IndexSectionZero),
                           kIndexRow:
                               @[
                                   @{@"勃勃生机ID：":@"3485ifjk"},
                                   @{@"勃勃生机类型：":@"SL出 AB MIA"},
                                   @{@"货MIA类型：":@"🎂MIA KKL"},
                                   @{@"暨起：":@"100 KKL = 1 AB"},
                                   @{@"SL：":@"590 AB"},
                                   @{@"是：":@" 12:00:12"},@{@"靓靓🐟：":@"20分钟"},
                                   @{@"收🐟心号：":@"😊"}
                                   
                                   ]
                           
                           };
    [self.listData addObject:dic0];
    
    [self removeContentWithType:IndexSectionOne];
    NSDictionary* dic1 = @{kImg:@"iconSucc",kTit:@"自动回复：",kSubTit:[NSString stringWithFormat:@"%@",@""], kIndexSection:@(IndexSectionOne),
                           kIndexRow:
                               @[
                                   @{kTit:@"可"}
                                   
                                   ]
                           
                           };
    [self.listData addObject:dic1];
    
    [self removeContentWithType:IndexSectionTwo];
    NSDictionary* dic2 = @{kImg:@"iconSucc",kTit:@"可可家限制：",kSubTit:[NSString stringWithFormat:@"%@",@""], kIndexSection:@(IndexSectionTwo),
                           kIndexRow:
                               @[
                                   @{@"收🐟心号：":@"😊"}
                                   ]
                           };
    
    [self.listData addObject:dic2];
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
