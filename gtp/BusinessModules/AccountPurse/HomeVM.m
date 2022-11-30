//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "HomeVM.h"

@interface HomeVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) NSMutableArray* lastSectionSumArr;
@property (nonatomic,strong) HomeModel* model;
@end

@implementation HomeVM
- (void)network_getTrendsListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    NSArray* gridSectionNames = @[@"Location",@"Quickening",@"CircleAnimation",@"TagRun",@"ModelFilter",@"WKPopUpView",@"AppListInfo"];
    NSMutableArray* gridParams = [NSMutableArray array];
    
    for (int i=0; i<gridSectionNames.count; i++) {
        
        NSDictionary * param = @{kArr:gridSectionNames[i],
                                 kImg:[NSString stringWithFormat:@"home_grid_%i",i],
                                 kUrl:@""};
        [gridParams addObject:param];
    }
    
    [self removeContentWithType:IndexSectionTwo];
    [self.listData addObject: gridParams];
    success(self.listData);
//    NSString* v =  [YBSystemTool appVersion];
//    NSString* s =  [YBSystemTool appSource];
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
//    
//    
//    WS(weakSelf);
//    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:API_HOMES andType:All andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
//        NSDictionary* result = dic[@"result"];
//        if ([NSString getDataSuccessed:result]) {
//            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            [self assembleApiData:weakSelf.model.result.data];
//            success(weakSelf.listData);
//        }
//        [SVProgressHUD dismiss];
//    }];
}

- (void)network_getHomeListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull,NSArray * _Nonnull,NSArray * _Nonnull))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    NSString* v =  [YBSystemTool appVersion];
    NSString* s =  [YBSystemTool appSource];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType3] andType:LNService andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
        NSDictionary* result = dic[@"result"];
        if ([NSString getLNDataSuccessed:result]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            NSArray* arr =[WItem mj_objectArrayWithKeyValuesArray:weakSelf.model.result.data.returnData.rankinglist];
            if (page ==3) {
                arr = @[];
            }
            [self assembleApiData:arr WithPage:page];
            success(weakSelf.listData,arr,self.lastSectionSumArr);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeModelReturn" object:nil];
        }
        else{
            NSLog(@".......netErr");
            failed(@"netErr");
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)assembleApiData:(NSArray*)data WithPage:(NSInteger)page{
//    if (page ==3) {
//        return;
//    }
    [self removeContentWithType:IndexSectionZero];
//    if (data.returnData !=nil && data.returnData.rankinglist.count>0 &&page==1) {
        [self.listData addObject:@{
                   kIndexSection: @(IndexSectionZero),
                   kIndexRow: @[data]}];
//    }
    
    [self removeContentWithType:IndexSectionOne];
    NSArray* gridSectionNames = @[@"SLMIA",@"我的🌹",@"数据统计",@"哥哥MIA",@"🐟"];//,@"🐟"
    NSMutableArray* gridParams = [NSMutableArray array];
    NSArray* gridTypes = @[@(EnumActionTag0),@(EnumActionTag1),@(EnumActionTag2),@(EnumActionTag3),@(EnumActionTag4)];//,@(IndexSectionFour)
    for (int i=0; i<gridSectionNames.count; i++) {
        NSDictionary * param = @{kArr:gridSectionNames[i],
                                 kImg:[NSString stringWithFormat:@"home_grid_%i",i],
                                 kType:gridTypes[i]
                                 };
        [gridParams addObject:param];
    }
//    if (page==1){
        [self.listData addObject:@{kIndexSection: @(IndexSectionOne),
                                   
                                   kIndexRow: @[gridParams]}];
//    }
    
    [self removeContentWithType:IndexSectionTwo];

    NSArray* scrollArr = data;
    [self.listData addObject:@{
                   kIndexSection: @(IndexSectionTwo),
                   kIndexRow: @[[self autoScrollArr:scrollArr]]}];

    
    [self removeContentWithType:IndexSectionThree];
    
    if (data !=nil && data.count>0 ) {
        NSMutableArray *times = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < data.count; i ++) {
            NSInteger time = arc4random()%3600;
            [times addObject:@(time)];
        }
        [_lastSectionSumArr addObjectsFromArray:times];//拼接接口分页数据=data.returnData.rankinglist
    }
    [self.listData addObject:@{
            
            kIndexSection: @(IndexSectionThree),
            kIndexInfo:@[@"待处理🌹",@"icon_bank"],
            kIndexRow: _lastSectionSumArr}//data.t.arr
     ];
    
    [self sortData];
}

- (NSAttributedString*)autoScrollArr:(NSArray*)models{
    NSArray* txTimeArr = @[
        @{@"List":@""},
        @{@"时间                             漂亮":@"                                  天数"}
        
    ];
    
    NSMutableArray *times = [NSMutableArray new];
    
    for (int i =0; i<txTimeArr.count; i++) {
        
        NSDictionary* dic = txTimeArr[i];
        
        NSString* kStr = dic.allKeys[0];
        NSMutableAttributedString *firstM = [[NSMutableAttributedString alloc]initWithString:kStr];
        
        [firstM addAttributes:@{NSFontAttributeName:i==0?[UIFont systemFontOfSize:12]:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:i==0? HEXCOLOR(0xFFFFFF):HEXCOLOR(0xA1747B)} range:NSMakeRange(0, kStr.length)];
        
        
        NSString* vStr = dic.allValues[0];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:vStr];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:HEXCOLOR(0xA1747B)} range:NSMakeRange(0, vStr.length)];
        
        [firstM appendAttributedString:attributedString];
        [times addObject:firstM];
    }
    
    NSMutableArray* txArr = [NSMutableArray array];//[WItem mj_objectArrayWithKeyValuesArray:models]
    for (WItem* model in models) {
        NSString* name = [NSString stringWithFormat:@"%@",model.title];
        
        if( name.length>1){
            NSString* chName =  [name  substringToIndex:2];
            if ([NSString isChinese:chName]) {
                if(name.length>3){
                    name =  [name  substringToIndex:4];
                }
            }else{
                if( name.length>6){
                    name =  [name  substringToIndex:7];
                }
            }
        }
        NSDictionary* dic = @{[NSString stringWithFormat:@"%@                   %@...",@"2021/00/00",name]:[NSString stringWithFormat:@"                              %@天",model.argValue]};
        [txArr addObject:dic];
    }
    
    for (NSDictionary* dic in txArr) {
        
        NSAttributedString* attrStr = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",dic.allKeys[0]] stringColor:HEXCOLOR(0xffffff) stringFont:kFontSize(10) subString:[NSString stringWithFormat:@"%@",dic.allValues[0]] subStringColor:HEXCOLOR(0xFDDD56) subStringFont:kFontSize(10) paragraphStyle:NSTextAlignmentLeft];
        
        [times addObject:attrStr];
    }
    
    
    NSMutableArray *addTimes = [NSMutableArray new];
    for (int i =1; i<times.count; i++) {
        
        NSAttributedString* attS = times[i];
        NSMutableAttributedString *oriS = [[NSMutableAttributedString alloc]initWithString:@"      "];
        [oriS appendAttributedString:attS];
        
        [addTimes addObject:oriS];
    }
    [addTimes insertObject:times[0] atIndex:0];
    
    return  [addTimes copy];
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
