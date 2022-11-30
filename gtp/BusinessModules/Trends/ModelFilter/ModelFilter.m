

//
//  ModelFilter.m
//  TagUtilViews
//
//  Created by WIQ on 2017/4/22.
//  Copyright © 2017年 WIQ. All rights reserved.
//

#import "ModelFilter.h"

@implementation ModelFilter
- (void)filteredSameStringAndAssembleDifferentStringToIndividualArray{
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    
    NSArray *array1 = @[@"2014-04-01",@"2014-04-02",@"2014-04-03",
                        
                        @"2014-04-02",@"2014-04-03"
                        
                        ];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *number in array1) {
        [dict setObject:number forKey:number];
    }
    NSLog(@"等同与下面无序筛选后的array%@",[dict allValues]);
    /*
     (
     "2014-04-03",
     "2014-04-02",
     "2014-04-01"
     )
     */

    NSSet *set = [NSSet setWithArray:array1];
    NSLog(@"无序筛选后%@",[set allObjects]);
    /*
     (
     "2014-04-03",
     "2014-04-01",
     "2014-04-02"
     )
     */
    NSMutableArray *array = [NSMutableArray arrayWithArray:array1];
    
    for (int i = 0; i < array.count; i ++) {
        
        NSString *string = array[i];
        
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        [tempArray addObject:string];
        
        for (int j = i+1; j < array.count; j ++) {
            
            NSString *jstring = array[j];
            
//            NSLog(@"jstring:%@",jstring);
            
            if([string isEqualToString:jstring]){
                
//                NSLog(@"jvalue = kvalue");
                
                [tempArray addObject:jstring];
                
                [array removeObjectAtIndex:j];
                
            }
        }
        
        [dateMutablearray addObject:tempArray];
        
    }
    
    NSLog(@"FilteredDescendingSortArray:%@",array);
    /*
     (
     "2014-04-01",
     "2014-04-02",
     "2014-04-03"
     )
     */
    NSLog(@"AssembleDifferentStringToIndividualArray:%@",dateMutablearray);
    /*
     (
     (
     "2014-04-01"
     ),
     (
     "2014-04-02",
     "2014-04-02"
     ),
     (
     "2014-04-03",
     "2014-04-03"
     )
     )
     */
}

- (void)setFilteredAarryForSameKeyValue{
    NSMutableArray* filteredAarry = [NSMutableArray array];
    NSMutableArray* attriArrs = [NSMutableArray array];
//    NSMutableArray* matchArr = [NSMutableArray array];
    attriArrs =[@[
    @{
      @"111" : @"Aonsectetur adipisicing elit",
      @"kAmount" : @"12"
     },
    @{
       @"222" : @"DLorem ipsum"
     },
    @{
        @"111" : @"Aonsectetur adipisicing elit",
        @"kAmount" : @"13"
    },
    @{
        @"222" : @"DLorem ipsum"
    },
    
    @{
        @"222" : @"D"
    }
     ]mutableCopy];
    
    for (int i=0; i<attriArrs.count; i++) {
        NSDictionary* temA = attriArrs[i];
        NSString* AheadKey = temA.allKeys[0];
        NSString *tempAValue = temA[AheadKey];
//        if ([temA[kAmount] intValue] != 12) {
//            continue;
//        }
        
        
        NSMutableArray* Is = [NSMutableArray array];
        
        NSMutableArray* matchArr = [NSMutableArray array];
        [matchArr addObject:temA];
        for (int j=i+1; j<attriArrs.count; j++) {
            NSDictionary* temB = attriArrs[j];
            NSString* BheadKey = temB.allKeys[0];
            NSString *tempBValue = temB[BheadKey];
            //不同key过滤 2个
            //同key异Value过滤 4个
            if (tempBValue.hash ==  tempAValue.hash) {
                //BheadKey.hash ==  AheadKey.hash
                
               [matchArr addObject:temB];
                
                
//                NSNumber* num = [NSString getPropertAmountNumberByArray:matchArr];
//                if (num&& [num floatValue]>0) {
//
//                }
//                tempAValue= tempBValue;
//                NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
////                [dicHR setObject:tempAValue forKey:AheadKey];
//                [dicHR addEntriesFromDictionary:temB];
//                [attriArrs replaceObjectAtIndex:i  withObject:dicHR];
//
                [attriArrs replaceObjectAtIndex:i  withObject:temB];

                
                [Is  addObject:@(j)];
                
                
            }
           
        }
        [filteredAarry addObject:matchArr];
        for (NSInteger h =Is.count - 1; h>=0; h--) {
            NSInteger remove = [Is[h] integerValue];
            [attriArrs removeObjectAtIndex:remove];
        }
        
    }
    
    
    
     
    
    NSLog(@"setFilteredAarryForSameKeyValue%@",filteredAarry);
    /*
     <__NSArrayM 0x600001be4e40>(
     <__NSArrayM 0x600001be5530>(
     {
         111 = "Aonsectetur adipisicing elit";
         QQ = tt;
     },
     {
         111 = "Aonsectetur adipisicing elit";
         QQ = pp;
     }
     )
     ,
     <__NSArrayM 0x600001be5560>(
     {
         222 = "DLorem ipsum";
     },
     {
         222 = "DLorem ipsum";
     }
     )

     )
     */

    
    /* Total DicArr
    <__NSArrayM 0x600002cb2400>(
    {
        kTotal = 24;
    },
    {
        kTotal = 0;
    }
    )
    */

}

- (void)setFilteredLastStringForSameKey{
    NSMutableArray* attriArrs = [NSMutableArray array];
    attriArrs =[@[
    @{
      @"111" : @"Aonsectetur adipisicing elit"
     },
    @{
       @"222" : @"DLorem ipsum"
     },
    @{
        @"111" : @""
    },
    @{
        @"222" : @"Bsed do"
    }
     ]mutableCopy];
    
    for (int i=0; i<attriArrs.count; i++) {
        NSDictionary* temA = attriArrs[i];
        NSString* AheadKey = temA.allKeys[0];
        NSString *tempAValue = temA[AheadKey];
        //        NSString* ArowValue = temA.allValues[0] ;
        
        
        NSMutableArray* Is = [NSMutableArray array];
        
        
        for (int j=i+1; j<attriArrs.count; j++) {
            NSDictionary* temB = attriArrs[j];
            NSString* BheadKey = temB.allKeys[0];
            NSString *tempBValue = temB[BheadKey];
            //不同key过滤 2个
            //同key异Value过滤 4个
            if (BheadKey.hash ==  AheadKey.hash) {
//                &&tempBValue.hash ==  tempAValue.hash
                
                tempAValue= tempBValue;
                
                
                
                NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
//                [dicHR setObject:tempAValue forKey:AheadKey];
                [dicHR addEntriesFromDictionary:temB];
                [attriArrs replaceObjectAtIndex:i  withObject:dicHR];
                
                [Is  addObject:@(j)];
                
            }
        }
        
        for (NSInteger h =Is.count - 1; h>=0; h--) {
            NSInteger remove = [Is[h] integerValue];
            [attriArrs removeObjectAtIndex:remove];
        }
    }
    
    NSLog(@"setFilteredLastStringForSameKey%@",attriArrs);
    /*
     (
     {
     111 = "";
     },
     {
     222 = "Bsed do";
     }
     )
     */


}

- (void)setFilteredAndDescendingSameStringToArrForSameKey{
    NSMutableDictionary* dic6 = [@{@"head":@333,@"res":@[@"333",@"332"]}mutableCopy];
    
    NSMutableDictionary* dic = [@{@"head":@111,@"res" :@[@"111",@"111"]}mutableCopy];
    
    NSMutableDictionary* dic2 = [@{@"head":@222,@"res":@[@"225",@"223"]}mutableCopy];
    
    NSMutableDictionary* dic3 = [@{@"head":@111,@"res":@[@"113",@"114"]}mutableCopy];
    NSMutableDictionary* dic4 = [@{@"head":@111,@"res":@[@"115",@"111"]}mutableCopy];
    
    NSMutableDictionary* dic5 = [@{@"head":@222,@"res":@[@"224",@"222"]}mutableCopy];
    
    
    NSMutableArray* arr = [@[dic6,dic,dic2,dic3,dic4,dic5
                             ] mutableCopy];
    
    NSMutableArray* hRs = [NSMutableArray array];
    
    for (int i=0; i<arr.count; i++) {
        NSDictionary* dic = arr[i];
        NSNumber* headNum = dic[@"head"];
        NSMutableArray* res = [dic[@"res"] mutableCopy] ;
        [self descendingSortData:res];
        
        NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
        [dicHR setObject:[self arrayWithMemberIsOnly:res]  forKey:headNum];
        
        [hRs addObject:dicHR];
        
    }
    
    
    for (int i=0; i<hRs.count; i++) {
        NSDictionary* temA = hRs[i];
        NSNumber* temAKey = temA.allKeys[0];
        NSMutableArray* Is = [NSMutableArray array];
        NSMutableArray *tempAValue = [NSMutableArray arrayWithArray:temA[temAKey]];
        
        for (int j=i+1; j<hRs.count; j++) {
            NSDictionary* temB = hRs[j];
            NSNumber* temBKey = temB.allKeys[0];
            
            if (temBKey == temAKey) {
                
                NSArray *tempBValue = temB[temBKey];
                [tempAValue addObjectsFromArray:tempBValue];
                
//                NSLog(@"beforeV....%@",tempAValue);
                [self descendingSortData:tempAValue];
//                NSLog(@"AfterV....%@",tempAValue);
                
                NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
                [dicHR setObject:[self arrayWithMemberIsOnly: tempAValue] forKey:temAKey];
                [hRs replaceObjectAtIndex:i  withObject:dicHR];
                
                [Is  addObject:@(j)];
                
            }
        }
        
        for (NSInteger h =Is.count - 1; h>=0; h--) {
            NSInteger remove = [Is[h] integerValue];
            [hRs removeObjectAtIndex:remove];
        }
    }
    
    
    [hRs sortUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[self filterIntegerInString:[obj1.allKeys[0] stringValue] ]];
        NSNumber *number2 = [NSNumber numberWithInteger:[self filterIntegerInString:[obj2.allKeys[0] stringValue]]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
    
    NSLog(@"setFilteredAndDescendingSameStringToArrForSameKey%@",hRs);
    /*
     (
     {
     111 =         (
     111,
     113,
     114,
     115
     );
     },
     {
     222 =         (
     222,
     223,
     224,
     225
     );
     },
     {
     333 =         (
     332,
     333
     );
     }
     )
     */
    
}
//- (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
//{
//    NSMutableArray *categoryArray = [NSMutableArray array];
//    BOOL hadItemFlag = NO;
//    for (unsigned i = 0; i < [array count]; i++) {
//        PHTodayEatReceipesInfo* item = array[i];
//        hadItemFlag = NO;
//        if ([categoryArray count]) {
//            for (int j = 0; j < [categoryArray count]; j++) {
//                PHTodayEatReceipesInfo* categoryItem = [categoryArray objectAtIndex:j];
//                if (categoryItem.days == item.days) {
//                    hadItemFlag = YES;
//                }
//
//            }
//            if (!hadItemFlag) {
//                [categoryArray addObject:[array objectAtIndex:i]];
//            }
//        }else{
//            [categoryArray addObject:[array objectAtIndex:i]];
//        }
//    }
//    //    NSLog(@"categoryArray=======%@",categoryArray);
//
//
//    return categoryArray;
//}
- (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
        }
        
    }
    return categoryArray;
}
//https://www.jianshu.com/p/039ba9ad2a87
- (NSInteger) binarySearchArray:(NSArray*)levelActivities withSelectedAmt:(NSInteger)selectedAmt
{
    NSMutableArray* testarrs  = [levelActivities mutableCopy];
    //    NSMutableArray* testarrs  = [@[@(80000),@(3500)]mutableCopy];
    //    NSMutableArray* testarrs  = [@[@(80000)]mutableCopy];
    
    
    [self descendingSortData:testarrs];
    
//    NSArray *list = [testarrs copy];
    
    NSInteger low = 0,mid,high = testarrs.count - 1;
    while(low <= high) {
        mid = (low + high)/2;
        NSInteger midT = [testarrs[mid] integerValue];
        //        if(midT == selectedAmt) low = mid;
        if(midT > selectedAmt) high = mid - 1;
        else if(midT <= selectedAmt) low = mid + 1;
    }
    NSInteger lowT = 0;
    NSInteger lowi = 0;
    if(low>=1){
        lowi = low-1;
        if(lowi>=testarrs.count - 1){
            lowi = testarrs.count - 1;
        }
        lowT = [testarrs[lowi] integerValue];
    }
    
    return lowT;
    
}

- (void)descendingSortData:(NSMutableArray*)array {
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[obj1  integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[obj2  integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}
-(NSInteger)filterIntegerInString:(NSString*)str{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[str stringByTrimmingCharactersInSet:nonDigits] integerValue];
}

@end
