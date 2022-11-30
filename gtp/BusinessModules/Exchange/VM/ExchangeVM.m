//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "ExchangeVM.h"

@interface ExchangeVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) ExchangeModel* model;
@property (nonatomic,strong) ExchangeRateItem* item;
@property (nonatomic,strong) ExchangeApplyItem* applyItem;
@end

@implementation ExchangeVM
- (void)network_getExchangeApplyWithResquestParams:(NSArray*)resquestParams Success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSString* rate = resquestParams[0];
    NSString* number = resquestParams[1];
    NSString* btcnumber = resquestParams[2];
    NSString* btcaddress = resquestParams[3];
    NSDictionary* proDic =@{@"rate":rate,@"number":number,@"btcnumber":btcnumber,@"btcaddress":btcaddress};
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType1003] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.applyItem = [ExchangeApplyItem mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.applyItem);
        }
        else{
            failed(weakSelf.applyItem);
        }
        [YKToastView showToastText:weakSelf.applyItem.msg];
        
    } error:^(NSError *error) {
        err(error);
        [YKToastView showToastText:error.description];
        
    }];
        
}

- (void)network_getExchangeCheckSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType1002] andType:All andWith:@{} success:^(NSDictionary *dic) {
        self.item = [ExchangeRateItem mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.item);
        }
        else{
            failed(weakSelf.item);
        }
//        [YKToastView showToastText:weakSelf.item.msg];
        
    } error:^(NSError *error) {
        err(error);
//        [YKToastView showToastText:error.description];
        
    }];
//    
}
- (void)network_getExchangeListWithPage:(NSInteger)page WithExchangeType:(ExchangeType)type success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    NSString* p =  [NSString stringWithFormat:@"%ld",page];
    NSString* t =  [NSString stringWithFormat:@"%ld",type];
    NSString* pagesize =  @"10";
    NSDictionary* proDic =@{@"pageno":p,@"type":t,@"pagesize":pagesize};
    
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType1005] andType:All andWith:proDic success:^(NSDictionary *dic) {
        
        
        [self network_getExchangeCheckSuccess:^(id data) {
            ExchangeRateItem* item = data;
            self.model = [ExchangeModel mj_objectWithKeyValues:dic];
            if ([NSString getDataSuccessed:dic]) {
                self.model = [ExchangeModel mj_objectWithKeyValues:dic];
                //success(weakSelf.model);
                [weakSelf assembleApiData:self.model withExchangeRate:page>1?nil:item.exchangeRate];
                success(weakSelf.listData);
            }
            else{
                failed(weakSelf.model);
                [YKToastView showToastText:weakSelf.model.msg];
            }
            
        } failed:^(id data) {
            if ([NSString getDataSuccessed:dic]) {
                //success(weakSelf.model);
                [weakSelf assembleApiData:weakSelf.model withExchangeRate:nil];
                success(weakSelf.listData);
            }
            else{
                failed(weakSelf.model);
                [YKToastView showToastText:weakSelf.model.msg];
            }
        } error:^(id data) {
            if ([NSString getDataSuccessed:dic]) {
                //success(weakSelf.model);
                [weakSelf assembleApiData:weakSelf.model withExchangeRate:nil];
                success(weakSelf.listData);
            }
            else{
                failed(weakSelf.model);
                [YKToastView showToastText:weakSelf.model.msg];
            }
        }];
        
//        [YKToastView showToastText:weakSelf.model.msg];
        
    } error:^(NSError *error) {
        err(error);
        [YKToastView showToastText:error.description];
        
    }];
    
}

- (void)assembleApiData:(ExchangeModel*)model withExchangeRate:(NSString*)exchangeRate{
    [self removeContentWithType:IndexSectionZero];
    if (exchangeRate !=nil ) {
        [self.listData addObject:@{
                   kIndexInfo:@"我的申请",
                   kIndexSection: @(IndexSectionZero),
                   kIndexRow: @[exchangeRate]}];
    }
    
    [self removeContentWithType:IndexSectionOne];
    if (model.exchangeBTC!=nil||model.exchangeBTC.count>0) {
        
        [self.listData addObject:@{
                                       
                                       kIndexSection: @(IndexSectionOne),
                                       
                                       kIndexRow: model.exchangeBTC}
             
         ];
    }
    
    
    
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
