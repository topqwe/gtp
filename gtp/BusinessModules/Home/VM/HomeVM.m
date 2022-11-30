//
//  YBHomeDataCenter.m
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "HomeVM.h"
#import "BannerCell.h"
#import "StyleCell1.h"
#import "StyleCell4.h"
#import "StyleCell8.h"

#import "StyleCell5.h"
#import "MoreGridCell.h"//s6
#import "StyleCell7.h"

@interface HomeVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) NSMutableArray* lastSectionSumArr;
@property (nonatomic,strong) CategoryModel*cmodel;
@property (nonatomic,strong) BannerModel* bmodel;
@property (nonatomic,strong) HomeModel* model;
@property (nonatomic,strong) NSMutableDictionary* zeroSectionDic;

@end

@implementation HomeVM
- (void)network_getConfigWithPage:(NSInteger)page success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
//    NSString* v =  [YBSystemTool appVersion];

    

    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType11] andType:All andWith:nil success:^(NSDictionary *dic) {
//       NSDictionary* result = dic[@"result"];
       if ([NSString getDataSuccessed:dic]) {
           SetUserDefaultKeyWithObject(@"ConfigModel", dic[@"data"]);
           ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:dic[@"data"]];
//           NSArray* arr =[HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.cmodel.data];
           success(configModel);

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
- (void)network_getHomeListWithPage:(NSInteger)page WithParams:(id)param success:(void (^)(NSArray * _Nonnull,NSArray * _Nonnull,NSArray * _Nonnull))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    NSString* v =  [YBSystemTool appVersion];
    NSString* s =  [YBSystemTool appSource];
    [SVProgressHUD showInfoWithStatus:@""];
    
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType3] andType:LNService andWith:@{@"version":v,@"source":s} success:^(NSDictionary *dic) {
        NSDictionary* result = dic[@"data"];
        if ([NSString getLNDataSuccessed:dic]) {
            NSDictionary* returnData = result[@"returnData"];
//            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            
            NSArray* arr =[WItem mj_objectArrayWithKeyValuesArray:returnData[@"rankinglist"]];
            if (page ==3) {
                arr = @[];
            }
            [self assembleHVCApiData:arr WithPage:page];
            success(weakSelf.listData,arr,self.lastSectionSumArr);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeModelReturn" object:nil];
        }
        else{
            NSLog(@".......netErr");
            failed(@"netErr");
        }
    }error:^(NSError *error) {
        NSLog(@".......servicerErr");
        failed(@"servicerErr");
    }];
}
- (void)assembleHVCApiData:(NSArray*)data WithPage:(NSInteger)page{
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
            kIndexInfo:@[@"理会🌹",@"icon_bank"],
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
//
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
//        
//    }];
}

- (void)network_postCRListWithPage:(NSInteger)page WithHomeItem:(HomeItem*)item WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    
    
    if (s == 0) {
        
        dic  = @{
            
              @"vid":@(item.ID),
              @"page":@(page)
        };
    }
    else if (s == 1) {
        dic  = @{
            @"comment_id":@(item.ID),
            @"vid":@(item.vid),
            @"page":@(page)
        };
    }
    
    __block NSArray* arr = @[];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:item.style == 0?ApiType21:ApiType54] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
            [self assembleMyShareApiData:arr WithPage:page];
            
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

- (void)network_postCRWithRequestParams:(id)requestParams WithHomeItem:(HomeItem*)item WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSDictionary* dic = nil;
    
    
    if (s == 0) {
        
        dic  = @{
            @"vid":@(item.ID),
            @"content":[NSString stringWithFormat:@"%@",requestParams]
        };
    }
    else if (s == 1) {
        
        dic  = @{
        @"comment_id":@(item.ID),
        @"vid":@(item.vid),
        @"content":[NSString stringWithFormat:@"%@",requestParams]
        };
    }
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:s == 0? item.style ==0?ApiType23:ApiType53: item.style ==0?ApiType22:ApiType55]andType:All andWith:dic success:^(NSDictionary *dic) {
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
- (void)network_postShowFilmWithPage:(NSInteger)page WithFid:(NSInteger)fid success:(void(^)(HomeItem * data))success failed:(TwoDataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
//    [SVProgressHUD showInfoWithStatus:@""];
    
    NSDictionary* filmDic = @{@"id":@(fid)};
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType17] andType:All andWith:filmDic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
//        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
//       [self assembleFilmInfos:item WithPage:1];

        success(item);
        }
        else{
            NSString* str = [NSString stringWithFormat:@"%@",dic[@"msg"]];
            [YKToastView showToastText:str];
               NSLog(@".......dataErr");
            
            if ([str containsString:@""]) {
                HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
                failed(@(910),item);
            }if ([str containsString:@"没"]) {
                failed(@(920),@[]);
            }
               
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            failed(@"servicerErr",@[]);
        }];
}
- (void)network_postRecommendWithPage:(NSInteger)page WithHomeItem:(HomeItem*)item  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    [self assembleFilmInfos:item WithPage:page];
    
    WS(weakSelf);//@"cid":@(item.cid),
    NSDictionary* dic = @{@"vid":@(item.ID)};
    __block NSArray* arr = @[];
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType20] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
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
    
//    if (page == 1) {
//        NSDictionary* bRqdic = @{@"cid":@(item.cid)};
//        [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType14] andType:All andWith:bRqdic success:^(NSDictionary *bdic) {
//        //        NSDictionary* result = bdic[@"result"];
//                if ([NSString getDataSuccessed:bdic]) {
//                    weakSelf.bmodel = [BannerModel mj_objectWithKeyValues:bdic];
//                    NSArray* bArr =[HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.bmodel.data];
//                    [self assembleBanners:bArr WithPage:page];
//                    success(weakSelf.listData,arr,self.lastSectionSumArr);
//                }
//                else{
//                   NSLog(@".......dataErr");
//                   failed(@"dataErr");
//                }
//            } error:^(NSError *error) {
//                NSLog(@".......servicerErr");
//                failed(@"servicerErr");
//            }];
//    }else{
//        [self assembleBanners:@[] WithPage:page];
//    }
    
    
    
//    NSDictionary* filmDic = @{@"id":@(item.ID)};
//
//    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType17] andType:All andWith:filmDic success:^(NSDictionary *dic) {
//        if ([NSString getDataSuccessed:dic]) {
//        HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
//       [self assembleFilmInfos:item WithPage:page];
//
//        success(weakSelf.listData,arr,self.lastSectionSumArr);
//        }
//        else{
//               NSLog(@".......dataErr");
//               failed(@"dataErr");
//            }
//        } error:^(NSError *error) {
//            NSLog(@".......servicerErr");
//            failed(@"servicerErr");
//        }];
    
}
- (void)network_getSCPageResultWithPage:(NSInteger)page WithCid:(id)cid withPageClick:(BOOL)isPageClick WithSearchSource:(SearchRecordSource)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1||isPageClick) {
        _lastSectionSumArr = [NSMutableArray array];
    }
//    [SVProgressHUD showInfoWithStatus:@""];
    
    
    WS(weakSelf);
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:cid];
    [dic addEntriesFromDictionary: @{@"page":@(page)}];
    
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType34] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleSearchTagsApiData:arr WithPage:page];

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

- (void)network_getSCTagsWithPage:(NSInteger)page didAdd0Data:(BOOL)didAdd0Data didAddLastData:(BOOL)didAddLastData  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    WS(weakSelf);
    NSDictionary* dic = @{};
    __block NSArray* arr = @[];
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:didAddLastData?ApiType57:ApiType35] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
//        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        [self assembleSCTagsApiData:arr WithPage:page didAdd0Data:didAdd0Data didAddLastData:didAddLastData];

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
- (void)assembleSCTagsApiData:(NSArray*)data  WithPage:(NSInteger)page didAdd0Data:(BOOL)didAdd0Data didAddLastData:(BOOL)didAddLastData{

    [self removeContentWithType:IndexSectionOne];

    NSMutableArray* items0= [NSMutableArray array];
    if (data!=nil&&data.count>0) {
        
        if(didAdd0Data)[items0 addObject:[self getFirstItem]];
        
        NSMutableArray* items1= [NSMutableArray array];
        if(didAdd0Data)[items1 addObject:[self getFirstItem]];
        for (int i=0; i<data.count; i++) {
            HomeItem* data1 = data[i];
            
            if(didAddLastData){
                [items0 addObject:data1];
            }
            if (data1.childs !=nil && data1.childs.count>0 ) {
                if(!didAddLastData)[items0 addObject:data1];
                [items1 addObjectsFromArray:[HomeItem mj_objectArrayWithKeyValuesArray:data1.childs]];
            }
        }
        [self.listData addObjectsFromArray:items1];
        
        if(didAddLastData){
//            [items0 addObject:[self getLastItem]];
        }
        [_lastSectionSumArr addObject:items0]
             ;
        [_lastSectionSumArr addObject:items1
             ];
    }
    if(didAdd0Data){
    [self addSC2Datas];
    [self addSC3Datas];
    }
    
    
//    [self.listData addObjectsFromArray:_lastSectionSumArr];
    
//    [self sortData];
}
- (HomeItem*)getFirstItem{
    HomeItem* data2 = [HomeItem new];
    data2.ID = -1;
    data2.name = @"";
    return data2;
}
- (void)addSC2Datas{
    NSMutableArray* items2= [NSMutableArray array];
    [items2 addObject:[self getFirstItem]];
    NSArray* arr2 = @[@"",@"",@""];
    
    for (int i=0; i<arr2.count; i++) {
        HomeItem* data2 = [HomeItem new];
        data2.ID = i;
        data2.name = arr2[i];
        [items2 addObject:data2];
        
    }
    [_lastSectionSumArr addObject:items2]
         ;
}
- (void)addSC3Datas{
    NSMutableArray* items2= [NSMutableArray array];
    NSArray* arr2 = @[@"",@"",@"",@""];
    
    for (int i=0; i<arr2.count; i++) {
        HomeItem* data2 = [HomeItem new];
        data2.ID = i;
        data2.name = arr2[i];
        [items2 addObject:data2];
       
    }
    [_lastSectionSumArr addObject:items2
         ];
}
- (void)network_getSearchResultWithPage:(NSInteger)page WithCid:(id)cid  WithSearchSource:(SearchRecordSource)s isFromSF:(BOOL)isFromSF success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
//    [SVProgressHUD showInfoWithStatus:@""];
    
    
    WS(weakSelf);
    NSDictionary* dic =
    s == SearchRecordSourceTags ?
    @{isFromSF?@"tag_id":@"id":cid,@"page":@(page)}:
    @{isFromSF?@"keyword":@"words":cid,@"page":@(page)};
    
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:isFromSF?ApiType50: s == SearchRecordSourceTags ? ApiType33:ApiType34] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleSearchTagsApiData:arr WithPage:page];

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



- (void)network_getHotTagsWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    WS(weakSelf);
    NSDictionary* dic = @{};
    __block NSArray* arr = @[];
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType32] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
//        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        [self assembleSearchTagsApiData:arr WithPage:page];

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
        
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    if (userInfoModel.searchKeyArrs.count>0) {
        [self assembleSearchKeyArrs:userInfoModel.searchKeyArrs WithPage:page];
        success(weakSelf.listData,arr,self.lastSectionSumArr);
    }
    
        
}

- (void)assembleSearchKeyArrs:(NSArray*)sks WithPage:(NSInteger)page{
//    [self removeContentWithType:IndexSectionZero];
    
//    if (page==1&&sks!=nil&&sks.count>0) {
//
//        [self.listData addObject:@{
//            kIndexSection: @(IndexSectionZero),
//            kIndexInfo:@[@"搜索历史",@(0),@""],
//            kIndexRow: @[sks]}//data.t.arr
//         ];
//    }
    [self sortData];
}
- (void)network_postClearMyLevelWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{};
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType45] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleMyShareApiData:arr WithPage:page];

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
- (void)network_postMyLevelWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"page":@(page)};
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType44] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleMyShareApiData:arr WithPage:page];

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
- (void)network_getMyShareWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"pageSize":@(10),@"page":@(page)};
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType30] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleMyShareApiData:arr WithPage:page];

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

- (void)network_postHomeMoreWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
//    [SVProgressHUD showInfoWithStatus:@""];
    
    WS(weakSelf);
    NSDictionary* dic = @{@"cid":@(cid),@"page":@(page)};
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType16] andType:All andWith:dic success:^(NSDictionary *dic) {
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

- (void)assembleMyShareApiData:(NSArray*)data WithPage:(NSInteger)page{

    [self removeContentWithType:IndexSectionOne];

    if (data !=nil && data.count>0 ) {
        [_lastSectionSumArr addObjectsFromArray:data];
        [self.listData addObject:@{

                kIndexSection: @(IndexSectionOne),
                kIndexInfo:@[@"所有评论",@(0),@""],
                kIndexRow: _lastSectionSumArr}//data.t.arr
         ];
    }
    
    [self sortData];
}

- (void)assembleSearchTagsApiData:(NSArray*)data WithPage:(NSInteger)page{

    [self removeContentWithType:IndexSectionOne];

    if (data !=nil && data.count>0 ) {
        
        [_lastSectionSumArr addObjectsFromArray:data];
//        NSMutableArray* aa = [NSMutableArray  array];
        for (int i=0; i< _lastSectionSumArr.count; i++) {
            HomeItem* item = _lastSectionSumArr[i];
            item.parent_id = i;
//            [aa addObject:item];
        }
        [self.listData addObject:@{

                kIndexSection: @(IndexSectionOne),
                kIndexInfo:@[@"热门标签",@(0),@""],
                kIndexRow: @[_lastSectionSumArr]}//data.t.arr
         ];
    }
    
    [self sortData];
}

- (void)assembleMoreApiData:(NSArray*)data WithPage:(NSInteger)page{

    [self removeContentWithType:IndexSectionOne];

    if (data !=nil && data.count>0 ) {
        [_lastSectionSumArr addObjectsFromArray:data];
        [self.listData addObject:@{

                kIndexSection: @(IndexSectionOne),
                kIndexInfo:@[@"为你推荐",@(0),@""],
                kIndexRow: @[_lastSectionSumArr]}//data.t.arr
         ];
    }
    
    
//    [self removeContentWithType:IndexSectionZero];
    if (data!=nil&&data.count>0) {
        NSMutableArray* bitems = [NSMutableArray array];
        for (int i=0; i<data.count; i++) {
            HomeItem* data1 = data[i];
            
            if (data1.ad_list !=nil && data1.ad_list.count>0 ) {
                [bitems addObjectsFromArray:[HomeItem mj_objectArrayWithKeyValuesArray:data1.ad_list]];
            }
        }
        if (page == 1) {
            [self assembleBanners:bitems WithPage:page];
        }else{
            [self assembleBanners:@[] WithPage:page];
        }
        
            
    }
    [self sortData];
}

- (void)network_getCategoryWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
//    NSString* v =  [YBSystemTool appVersion];

    

    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType13] andType:All andWith:nil success:^(NSDictionary *dic) {
//       NSDictionary* result = dic[@"result"];
       if ([NSString getDataSuccessed:dic]) {
           weakSelf.cmodel = [CategoryModel mj_objectWithKeyValues:dic];
           NSArray* arr =[HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.cmodel.data];
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

- (void)network_getSVListWithPage:(NSInteger)page WithCid:(id)item WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    WS(weakSelf);
    NSMutableDictionary* redic = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(page)}];
    
    if (s == AwemeMain) {
        [redic  addEntriesFromDictionary: @{
            @"cate_id":item
        }];
    }
    else if (s == AwemeTargetPush) {
        [redic  addEntriesFromDictionary: @{
            @"tag_id":item
        }];
    }
    else if (s == AwemeKeywordPush) {
        [redic  addEntriesFromDictionary: @{
            @"keyword":item
        }];
    }
//    else if (s == 3) {
//        [redic  addEntriesFromDictionary: @{
//            @"start_id":[item stringValue]
//        }];
//    }
    //
    __block NSArray* arr = @[];
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:(s == AwemeLivi||s == AwemeLiviPush)?ApiType56:ApiType50] andType:All andWith:redic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
//            [self assembleMyShareApiData:arr WithPage:page];
            if (s == AwemeLivi) {
                [self assembleSearchTagsApiData:arr WithPage:page];
            }
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

- (void)network_postDynamicsListWithPage:(NSInteger)page WithCid:(id)cid withSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
//    [SVProgressHUD showInfoWithStatus:@""];
    
    WS(weakSelf);
    NSMutableDictionary * redic = [NSMutableDictionary dictionaryWithDictionary:cid];
    [redic addEntriesFromDictionary: @{@"page":@(page)}];
    
    __block NSArray* arr;
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:s==1?ApiType67:ApiType58] andType:All andWith:redic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            NSMutableArray* layoutsArr = [NSMutableArray array];
//
//            NSString *plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"moment%li",page-1] ofType:@"plist"];
//            if (plistPath) {
//                NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//
//                for (id dict in dataArray) {
//                    DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//                    NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//                    [layoutsArr addObject:layout];
//                }
//                arr = [layoutsArr mutableCopy];
//            }
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            if (page ==1&&s==1) {
                [self.lastSectionSumArr addObject:weakSelf.model.data.user_info];
            }
            NSArray * dataArray =  [DynamicsModel mj_objectArrayWithKeyValuesArray:weakSelf.model.data.bbs_list];
            for (DynamicsModel * model  in dataArray) {
                NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
                [layoutsArr addObject:layout];
            }
            arr = [layoutsArr mutableCopy];
            
            success(weakSelf.listData,arr,self.lastSectionSumArr);
        }
    } error:^(NSError *error) {
         NSLog(@".......servicerErr");
               failed(@"servicerErr");
    }];
}

- (void)network_postDynamicsDetailWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
//    [SVProgressHUD showInfoWithStatus:@""];
    
    WS(weakSelf);
    
    NSDictionary* dic  = @{
        
          @"bbs_id":@(cid),
          @"page":@(page)
    };
//7921
__block NSArray* arr = @[];
[[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType62] andType:All andWith:dic success:^(NSDictionary *dic) {
    if ([NSString getDataSuccessed:dic]) {
        
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleDynamicsCommentApiData:arr WithPage:page];
        
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
    
//    if (page == 1) {
    NSDictionary* dedic = @{@"id":@(cid),@"page":@(page)};
    __block NSArray* detailArrs;
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType59] andType:All andWith:dedic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            NSMutableArray* layoutsArr = [NSMutableArray array];

//            NSString *plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"moment%i",0] ofType:@"plist"];
//            if (plistPath) {
//                NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//
//                for (id dict in dataArray) {
//                    DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//                    NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//                    [layoutsArr addObject:layout];
//                }
//                detailArrs = [layoutsArr mutableCopy];
//            }
//            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            NSArray * dataArray =  @[[DynamicsModel mj_objectWithKeyValues:dic[@"data"]]];
            for (DynamicsModel * model  in dataArray) {
                NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
                [layoutsArr addObject:layout];
            }
            detailArrs = [layoutsArr mutableCopy];
            [self assembleDynamicsDetailApiData:detailArrs WithPage:page];
            success(weakSelf.listData,arr,self.lastSectionSumArr);
        }
    } error:^(NSError *error) {
         NSLog(@".......servicerErr");
               failed(@"servicerErr");
    }];
        
//    }
}
- (void)assembleDynamicsDetailApiData:(NSArray*)data WithPage:(NSInteger)page{

    [self removeContentWithType:IndexSectionZero];

    if (data !=nil && data.count>0 ) {
//        [_lastSectionSumArr addObjectsFromArray:data];
        [self.listData addObject:@{

                kIndexSection: @(IndexSectionZero),
                kIndexInfo:@[@"detail",@(0),@""],
                kIndexRow:data}//data.t.arr
         ];
    }
    
    [self sortData];
}
- (void)assembleDynamicsCommentApiData:(NSArray*)data WithPage:(NSInteger)page{

    [self removeContentWithType:IndexSectionOne];

    if (data !=nil && data.count>0 ) {
        [_lastSectionSumArr addObjectsFromArray:data];
    }
    [self.listData addObject:@{

            kIndexSection: @(IndexSectionOne),
            kIndexInfo:@[@"所有评论",@(0),@""],
            kIndexRow: _lastSectionSumArr}//data.t.arr
     ];//no more used previous data
    [self sortData];
}

- (void)network_getMyMsgHomeListWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
    
    
    WS(weakSelf);
    NSDictionary* dic = @{@"rand":[NSString getCurrentTimestamp],@"page":@(page)};
    
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType69] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        NSArray* arr = [HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleMyShareApiData:arr WithPage:page];

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
- (void)network_postMessageWithRequestParams:(id)requestParams WithID:(NSInteger)item WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    
    
    WS(weakSelf);
    NSMutableDictionary* requestDic  = [NSMutableDictionary dictionaryWithDictionary:@{
        @"to_user_id":@(item),
        @"type":@(s)}];
    if (s== 2) {
        [[YTSharednetManager sharedNetManager]postMoreFiles:[ApiConfig getAppApi:ApiType65] realmNameType:All parameters:@"image" imageDataArray:@[requestParams] success:^(NSDictionary *reponsedic) {
            
            if ([NSString getDataSuccessed:reponsedic]) {
                
                
                NSDictionary* dicc = reponsedic[@"data"];
                
                if ([dicc[@"path"] isKindOfClass:[NSString class]]){
                    [requestDic addEntriesFromDictionary:@{@"content":dicc[@"path"]}];
                }
                [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType71] andType:All andWith:requestDic success:^(NSDictionary *dic) {
                    if ([NSString getDataSuccessed:dic]) {
                        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            //            NSArray* arr = @[];
            //            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                        
                        [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
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
        } error:^(NSError *error) {
            
        }];
    }
    if (s == 1) {
        
    
    [requestDic addEntriesFromDictionary:@{@"content":[NSString stringWithFormat:@"%@",requestParams]}];
        
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType71] andType:All andWith:requestDic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
//            NSArray* arr = @[];
//            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            [YKToastView showToastText:[NSString stringWithFormat:@"%@",weakSelf.model.msg]];
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
}
- (void)network_postHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed {
    
    _listData = [NSMutableArray array];
    if (page ==1) {
        _lastSectionSumArr = [NSMutableArray array];
    }
    
//    [SVProgressHUD showInfoWithStatus:@""];
    
    WS(weakSelf);
    NSDictionary* dic = @{@"cid":@(cid),@"page":@(page)};
    
    
    __block NSArray* arr;
//    weakSelf.model = [HomeModel mj_objectWithKeyValues:[UserInfoManager GetCacheDataWithKey:[ApiConfig getAppApi:ApiType15]]];
//    arr =[HomeList mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
//    if (arr>0) {
//        [self assembleListApiData:arr WithPage:page];
//        success(weakSelf.listData,arr,self.lastSectionSumArr);
//    }
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType15] andType:All andWith:dic success:^(NSDictionary *dic) {
        if ([NSString getDataSuccessed:dic]) {
        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        arr =[HomeList mj_objectArrayWithKeyValuesArray:weakSelf.model.data.list];
        [self assembleListApiData:arr WithPage:page];

//        success(weakSelf.listData);
            success(weakSelf.listData,arr,self.lastSectionSumArr);
        }
    } error:^(NSError *error) {
         NSLog(@".......servicerErr");
               failed(@"servicerErr");
    }];
    
    
    if (page == 1) {
        __block NSArray* bArr;
        NSDictionary* bRqdic = @{@"cid":@(cid)};
        [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType14] andType:All andWith:bRqdic success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                weakSelf.bmodel = [BannerModel mj_objectWithKeyValues:bdic];
                bArr =[HomeItem mj_objectArrayWithKeyValuesArray:weakSelf.bmodel.data];
                [self assembleBanners:bArr WithPage:page];
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
    }else{//读第一次的zeroSectionDic
        [self assembleBanners:@[] WithPage:page];
    }
    
}
- (CGFloat)assembleDataHeight:(NSDictionary*)itemData{
    CGFloat height = 0.1f;
    NSArray* arr = itemData.allValues[0];
    IndexSectionUIStyle style = [itemData.allKeys[0] integerValue];
    if (arr.count>0) {
            if (style == IndexSectionUIStyleFour){
                height = [StyleCell4 cellHeightWithModel];
                
            }
            if (style == IndexSectionUIStyleEight){
                height = [StyleCell8 cellHeightWithModel];
                
            }
            if (style == IndexSectionUIStyleFive) {
                height = [StyleCell5 cellHeightWithModel:itemData];
                
            }

            if (style == IndexSectionUIStyleSix) {
                height = [MoreGridCell cellHeightWithModel:arr];
                
            }

            if (style == IndexSectionUIStyleSeven) {
                if (arr.count > 1) {
                    height = [StyleCell7 cellHeightWithModel:itemData];
                    
                }else if (arr.count ==1){
                    height = [StyleCell5 cellHeightWithModel:itemData];
                    
                }
            }

            if (style < IndexSectionUIStyleFour) {
                if (arr.count > 1) {
                    height = [StyleCell1 cellHeightWithModel:itemData];
                    
                }else if (arr.count ==1){
                    height = [MoreGridCell cellHeightWithModel:arr];
                    
                }

            }
        
    }
    return height;
}
- (void)assembleListApiData:(NSArray*)data WithPage:(NSInteger)page{
//    if (page ==3) {
//        return;
//    }
//    [self removeContentWithType:IndexSectionOne];
    if (data!=nil&&data.count>0) {
        for (int i=0; i<data.count; i++) {
            HomeList* data1 = data[i];
            [self removeContentWithType:data1.sort+1000];
            NSArray* items = @[];
            if (data1.small_video_list !=nil && data1.small_video_list.count>0 ) {
                items =  [HomeItem mj_objectArrayWithKeyValuesArray:data1.small_video_list];
            }
            
            NSString* headStr = @"";
            if (data1.style == IndexSectionUIStyleFour||
                data1.style == IndexSectionUIStyleEight) {
                if (data1.title.length>0) {
                    headStr = data1.title;
                }
            }else{
                headStr = @"";
            }
            
                [_lastSectionSumArr addObject:@{
                    
                    kType:@(data1.style),//hshow
                    
                    kIndexInfo:
                (items.count>0) ? @[data1.name,@(data1.ID),data1.local_bg_img,headStr]
                    :
                        @[]
                    ,//data1.style == IndexSectionUIStyleFour?
                    
                    kIndexSection: @(data1.sort+1000),
                    
                    kIndexRow: @[
                 @{
//                     (items.count>0) ?
//                         (items.count==1) ? @(IndexSectionUIStyleZero):@(data1.style):@(data1.style)
                    @(data1.style)
                   :(items.count>0) ? items:
                       @[]
                     
                 }
                    ],
                    kIndexHeight: @[
                            
                    @([self assembleDataHeight:@{
                        @(data1.style)
                       :(items.count>0) ? items:
                           @[]
                    }])
                    ],
                    
                   kArr: (data1.ad_list!=nil&&data1.ad_list.count>0) ? [HomeItem mj_objectArrayWithKeyValuesArray:data1.ad_list]:
                        @[]
                    
                }
                 ];
            
        }
    }
    [self.listData addObjectsFromArray:_lastSectionSumArr];
    
    [self sortData];
}

- (void)assembleFilmInfos:(HomeItem*)item WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionMinusOne];
    NSMutableDictionary* filmInfos = [NSMutableDictionary dictionary];
    [filmInfos addEntriesFromDictionary: @{
                                                     kIndexInfo:item!=nil?item:
                                                         @{
                                                             }
                                                     }];
    
    if (page==1&&item!=nil) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionMinusOne),
                                   kIndexRow: @[item]}];
    }
    [self sortData];
}

- (void)assembleBanners:(NSArray*)banners WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionZero];
    
    //page==1&&
    if (banners!=nil&&banners.count>0) {
        [self.zeroSectionDic addEntriesFromDictionary: @{
                                                         kArr:banners!=nil?banners:
                                                             @[
                                                                 ]
                                                         }];
    }
        
    //self.zeroSectionDic第一次已经懒加载，page=1后会一直存在
    if (self.zeroSectionDic!=nil&&![self.zeroSectionDic isEqualToDictionary:[@{}mutableCopy]]) {
//        [self.listData insertObject:@{
//                kIndexSection: @(IndexSectionZero),
//                kIndexRow: @[self.zeroSectionDic]} atIndex:IndexSectionZero];//越界
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[self.zeroSectionDic],
                            kIndexHeight:@[@([BannerCell cellHeightWithModel])]
        }];
    }
    
    [self sortData];
}
- (NSMutableDictionary *)zeroSectionDic {
    if (!_zeroSectionDic) {
        NSDictionary* dic = @{
                              
                              };
        _zeroSectionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
    }
    return _zeroSectionDic;
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
