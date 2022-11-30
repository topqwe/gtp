//
//  DraggableCVModel.m


#import "DraggableCVModel.h"

@implementation DraggableCVModel
- (BOOL)compareOriginData:(NSMutableArray*)oldArr withNewData:(NSMutableArray*)newArr{
    bool bol = false;
    
    //创建俩新的数组
    
    //对array1排序。
    [oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
  
    //对array2排序。
////    [newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];

    
    if (newArr.count == oldArr.count) {
        
        bol = true;
        for (int i = 0; i < oldArr.count; i++) {
            
            id c1 = [oldArr objectAtIndex:i];
            id newc = [newArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = false;
                break;
            }
        }
    }
    return bol;
}


- (BOOL)isEqualEveryElementInArray:(NSMutableArray*)arr{
    bool bol = false;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSNumber *number in arr) {
        [dic setObject:number forKey:number];
    }
    NSLog(@"[dic allValues] %@",[dic allValues]);
    if (dic.allValues.count == 1) {
        bol = true;
    }
    return bol;
}

- (NSMutableArray*)equalElementsInArray:(NSMutableArray*)arr{
    NSMutableArray* isEqualSplitByLineColors = [NSMutableArray array];
//    for (NSMutableArray* sectionColors in arr) {
//        BOOL isEqual = [self isEqualEveryElementInArray:sectionColors];
//        if (isEqual) {
//            [isEqualSplitByLineColors addObject:@(isEqual)];
//        }
//    }
    for (NSInteger i = 0; i < arr.count; i++) {
        for (NSInteger j = i+1;j < arr.count; j++) {
            NSArray *tempModel = arr[i];
            NSArray *model = arr[j];
            if ([tempModel isEqualToArray:model]) {
                [isEqualSplitByLineColors addObject:@(1)];
//                [arr removeObject:model];
//                j--;
            }
        }
    }
    return isEqualSplitByLineColors;
}

- (NSMutableArray*)assembleEvenOddArray:(NSMutableArray*)originArray withSplitSize : (NSInteger)subSize{
    NSMutableArray *splitByVLOriginColorDatas = [self splitArray:originArray  withSubSize:subSize];
    NSMutableArray *splitByVLAssembleEvenColorDatas = [NSMutableArray array];
    NSMutableArray *splitByVLAssembleOddColorDatas = [NSMutableArray array];
    for (int i=0; i<splitByVLOriginColorDatas.count; i++) {
        NSArray* sectionColors = splitByVLOriginColorDatas[i];//per1
        if (i%2 == 0) {
            [splitByVLAssembleEvenColorDatas addObjectsFromArray:sectionColors];//8 //4
        }else{
            [splitByVLAssembleOddColorDatas addObjectsFromArray:sectionColors];
        }
    }
    [splitByVLAssembleEvenColorDatas addObjectsFromArray:splitByVLAssembleOddColorDatas];
    return splitByVLAssembleEvenColorDatas;
}

- (NSMutableArray*)splitArray:(NSMutableArray*)originArray withSubSize : (NSInteger)subSize{
    NSMutableArray *splitArray = [NSMutableArray array];
    NSUInteger itemsRemaining = originArray.count;
    int j = 0;
    while(itemsRemaining) {
        NSRange range = NSMakeRange(j, MIN(subSize, itemsRemaining));
        NSArray *subLogArr = [originArray subarrayWithRange:range];
        [splitArray addObject:subLogArr];
        itemsRemaining-=range.length;
        j+=range.length;
    }
    NSLog(@"//%@",splitArray);
    return splitArray;
}

- (BOOL)isEqualFinalElementInArray:(NSMutableArray*)data byX:(NSInteger)x{
    BOOL bol = false;
    
    NSMutableArray* colorDatas = [NSMutableArray array];
    for (NSDictionary* dic in data) {
        [colorDatas addObject:dic[kColor]];
    }
    
    
    NSMutableArray *splitByHLOriginColorDatas = [self splitArray:colorDatas  withSubSize:(x*x)/4];
    if ([self equalElementsInArray:splitByHLOriginColorDatas].count == (x*x)/4) {
        bol = true;
    }
    
    
    NSMutableArray *splitByVLAssembleColorDatas  = [NSMutableArray arrayWithArray:[self splitArray:[self assembleEvenOddArray:colorDatas withSplitSize:1]  withSubSize:(x*x)/4]];
    
    if ([self equalElementsInArray:splitByVLAssembleColorDatas].count== (x*x)/4) {
        bol = true;
    }
    
    if ([self equalElementsInArray:splitByVLAssembleColorDatas].count +[self equalElementsInArray:splitByHLOriginColorDatas].count == (x*x)/4) {
        bol = true;
    }
    
    
    NSMutableArray *splitBySquareAssembleColorDatas  = [NSMutableArray arrayWithArray:[self splitArray:[self assembleEvenOddArray:colorDatas withSplitSize:2]  withSubSize:(x*x)/4]];;
    
    if ([self equalElementsInArray:splitBySquareAssembleColorDatas].count== (x*x)/4) {
        bol = true;
    }
    
    if ([self equalElementsInArray:splitBySquareAssembleColorDatas].count +[self equalElementsInArray:splitByHLOriginColorDatas].count == (x*x)/4) {
        bol = true;
    }
    
    if ([self equalElementsInArray:splitBySquareAssembleColorDatas].count +[self equalElementsInArray:splitByVLAssembleColorDatas].count == (x*x)/4) {
        bol = true;
    }

    if ([self equalElementsInArray:splitBySquareAssembleColorDatas].count +[self equalElementsInArray:splitByHLOriginColorDatas].count +[self equalElementsInArray:splitByVLAssembleColorDatas].count== (x*x)/4) {
        bol = true;
    }
    
    return bol;
}

- (NSMutableDictionary*)getCollectionDatasByX:(NSInteger)x byY:(NSInteger)y{
     NSMutableArray* sections = [NSMutableArray array];
 //        for(int s = 0; s < 3; s++) {
 //            NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:6];
 //            for(int i = 0; i < 6; i++) {
 //                [data addObject:[NSString stringWithFormat:@"%c %@", 65+s, @(i)]];
 //            }
 //            [sections addObject:data];
 //        }
     //
     NSMutableArray* originArr = [NSMutableArray array];
     for (int i=1; i<x*y+1; i++) {
         [originArr addObject:@{kTit:[NSString stringWithFormat:@"%li",(long)i]}];
     }
     
     NSMutableArray* originColorArr = [NSMutableArray array];
     for(int s = 0; s < x; s++) {
         NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:x];
         if (s%x == 0||s%x == 4) {
             for(int i = 0; i < y; i++) {
                 [data addObject:UIColor.redColor];
             }
             [originColorArr addObjectsFromArray:data];
         }
         if (s%x == 1||s%x == 5) {
             for(int i = 0; i < y; i++) {
                 [data addObject:UIColor.greenColor];
             }
             [originColorArr addObjectsFromArray:data];
         }
         if (s%x == 2||s%x == 6) {
             for(int i = 0; i < y; i++) {
                 [data addObject:UIColor.yellowColor];
             }
             [originColorArr addObjectsFromArray:data];
         }
         if (s%x == 3||s%x == 7) {
             for(int i = 0; i < y; i++) {
                 [data addObject:UIColor.blueColor];
             }
             [originColorArr addObjectsFromArray:data];
         }
     }
 //    NSMutableArray *splitoriginColorArr = [self assembleEvenOddArray:originColorArr withSplitSize:1];
     
     
     NSMutableArray *assembleArray = [[NSMutableArray alloc] init];
     for (int i=0; i<originArr.count; i++) {
         NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:originArr[i]];
         [dic addEntriesFromDictionary:@{kColor:originColorArr[i]}];
         [assembleArray addObject:dic];
     }
     
     
     NSMutableArray *resultArray = [[NSMutableArray alloc] init];
     NSInteger i;
     NSInteger count = assembleArray.count;
     for (i = 0; i < count; i ++) {
         int index = arc4random() % (count - i);
         NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[assembleArray objectAtIndex:index]];
         [resultArray addObject:dic];
         [assembleArray removeObjectAtIndex:index];
         
     }
     [sections  addObjectsFromArray:resultArray];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:@{kArr:sections}];
    [dic addEntriesFromDictionary:@{kIndexRow:@(x)}];
    [dic addEntriesFromDictionary:@{kIndexSection:@(y)}];
    return dic;
}

- (NSMutableDictionary*)getRotateDatasByX:(NSInteger)x byY:(NSInteger)y{
    NSMutableArray* sections = [NSMutableArray array];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < x*y; i ++) {
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:@{kTit:[NSString stringWithFormat:@"%li",(long)i]}];
        [dic addEntriesFromDictionary:@{kSubTit:[NSString stringWithFormat:@"%li",(i/x)*(x+1)+i%x]}];
        [resultArray addObject:dic];
    }
    [sections  addObjectsFromArray:resultArray];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:@{kArr:sections}];
    [dic addEntriesFromDictionary:@{kIndexRow:@(x)}];
    [dic addEntriesFromDictionary:@{kIndexSection:@(y)}];
    return dic;
}
- (void)setDataIsForceInit:(BOOL)isForceInit{
    if (isForceInit) {
        
        UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
        userInfoModel.recordedDate = nil;
        [UserInfoManager SetNSUserDefaults:userInfoModel];
        
    }else{
        if (![UserInfoManager GetNSUserDefaults].recordedDate) {
            UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
            userInfoModel.recordedDate = [NSDate date];
            
            [UserInfoManager SetNSUserDefaults:userInfoModel];
        }
    }
}

@end
