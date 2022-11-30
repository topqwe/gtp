//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "AccountingModel.h"

@implementation AccountingModel
- (NSMutableDictionary*)getAccountingTagPieData:(NSDictionary*)dic0{
    NSMutableDictionary* dicMut = [NSMutableDictionary dictionary];
    
    NSInteger type = [dic0[kType]intValue];

    NSString* title = [NSString stringWithFormat:@"%@",dic0[kTit]];
    switch (type) {
        case AccountingTypeIncome:
            {
                NSInteger incomeType = [dic0[kIndexSection]intValue];
                NSString* subTitle = [NSString stringWithFormat:@"%@",dic0[kSubTit]];
                switch (incomeType) {
                    case AccountingIncomeTypeSalary:
                        {
                            
                            [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xff0000),kIndexInfo:subTitle}];
                        }
                        break;
                     case AccountingIncomeTypeInvest:
                        {
                            [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xb5ba30),kIndexInfo:subTitle}];
                        }
                        break;
                    case AccountingIncomeTypePartTime:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x491498),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeLivingCost:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x1588b3),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeRedPacket:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xa87106),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeSecondhand:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xaedc34),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeDebit:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x45c51d),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeReimburse:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xc71fbd),kIndexInfo:subTitle}];
                    }
                    break;
                    case AccountingIncomeTypeOther:
                    {
                        [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x000000),kIndexInfo:subTitle}];
                    }
                    break;
                    
                    default:
                        break;
                }
            }
            break;
       case AccountingTypeDiet:
            {
                [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xffff3f),kIndexInfo:title}];
            }
            break;
        case AccountingTypeShopping:
            {
                [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0xfe0000),kIndexInfo:title}];
            }
            break;
        case AccountingTypeTrip:
            {
                [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x000ff00),kIndexInfo:title}];
            }
            break;
        case AccountingTypeEducation:
        {
            [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x3f3fff),kIndexInfo:title}];
            
        }
        break;
        case AccountingTypeRecreation:
        {
            [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x7f7f7f),kIndexInfo:title}];
        }
        break;
        case AccountingTypeOtherOutcome:
        {
            [dicMut addEntriesFromDictionary:@{kColor:HEXCOLOR(0x000000),kIndexInfo:title}];
        }
        break;
        default:
            break;
    }
    [dicMut addEntriesFromDictionary:dic0];
    return dicMut;
}

- (NSMutableArray*)getAccountingAssembledData:(NSArray*)originArr selectedType:(AccountingSelectedType)selectedType withDistinction:(AccountingDistinctionType)distinctionType
withDistinctionTime:(NSString*)distinctionTime withDistinctionBalanceSource:(NSString*)distinctionBalanceSource{
    
    NSMutableArray* allStatedMutArr = [NSMutableArray array];
    NSMutableArray* dayStatedMutArr = [NSMutableArray array];
    NSMutableArray* monthPieMutArr = [NSMutableArray array];
    
    NSMutableArray* allBalanceFromSameSourceMutArr = [NSMutableArray array];
    NSMutableArray* monthBalanceFromSameSourceMutArr = [NSMutableArray array];
    
    for (NSDictionary* dic0 in originArr) {
        
        BOOL isContainKAmount = [[dic0 allKeys] containsObject:kAmount];
        if (!isContainKAmount) {
            continue;
        }
        [allStatedMutArr addObject:dic0];
        
        switch (distinctionType) {
            case AccountingDistinctionTypeDayAllStated:
            {
                NSString* ymd = dic0[kDate];
                if (ymd.hash != distinctionTime.hash) {
                    continue;
                }
                [dayStatedMutArr addObject:dic0];
            }
                break;
            case AccountingDistinctionTypeMonthPie:
            {
                NSString* ymd = dic0[kDate];
                NSString* newYm = [NSString dateStrWithString:[ymd substringToIndex:7] formatString:[NSString ymSeparatedBySlashFormatString]];
                if (newYm.hash != distinctionTime.hash) {
                    continue;
                }
                [monthPieMutArr addObject:dic0];
            }
                break;
                
            case AccountingDistinctionTypeAllBalanceFromSameSource:
            {
                NSString* balanceSource = dic0[kIsOn];
                
                if (balanceSource.hash != distinctionBalanceSource.hash
                    ) {
                    continue;
                }
                [allBalanceFromSameSourceMutArr addObject:dic0];
            }
                break;
            case AccountingDistinctionTypeMonthBalanceFromSameSource:
            {
                if (![dic0.allKeys containsObject:kIsOn]) {
                    continue;
                }
                
                NSString* balanceSource = dic0[kIsOn];
                if (balanceSource.hash != distinctionBalanceSource.hash) {
                    continue;
                }
                
                NSString* ymd = dic0[kDate];
                NSString* newYm = [NSString dateStrWithString:[ymd substringToIndex:7] formatString:[NSString ymSeparatedBySlashFormatString]];
                if (newYm.hash != distinctionTime.hash) {
                    continue;
                }
                
                [monthBalanceFromSameSourceMutArr addObject:dic0];
            }
                break;
            default:
                break;
        }
    }
    switch (selectedType) {
            case AccountingSelectedTypeIncome:
                return [self setFilteredAarryForSameKeyValue:monthPieMutArr withSameKey:kIndexSection];
                break;
            case AccountingSelectedTypeOutcome:
                return [self setFilteredAarryForSameKeyValue:monthPieMutArr withSameKey:kType];
                break;
            
            case AccountingSelectedTypeDayAllStated:
                return dayStatedMutArr;
                break;
            case AccountingSelectedTypeDayBalanceTotalStated:{
                return [self sumBalanceForSameWay:dayStatedMutArr withDistinctionTime:distinctionTime];
            }
                break;
            
            case AccountingSelectedTypeAllStated:
                return allStatedMutArr;
                break;
            case AccountingSelectedTypeAllBalanceTotalStated:
            {
                return [self sumBalanceForSameWay:allStatedMutArr withDistinctionTime:distinctionTime];
            }
                break;
            
            case AccountingSelectedTypeAllSameSourceBalanceStated:
            {
                return [self sumBalanceForSameWay:allBalanceFromSameSourceMutArr withDistinctionTime:distinctionTime];
            }
                break;
            case AccountingSelectedTypeMonthSameSourceBalanceStated:
            {
                return [self sumBalanceForSameWay:monthBalanceFromSameSourceMutArr withDistinctionTime:distinctionTime];
            }
                break;
        case AccountingSelectedTypeMonthSameDaySameSourceBalanceStated:
        {
            return [self setFilteredAarryForSameKeyValue:monthBalanceFromSameSourceMutArr withSameKey:kDate];
        }
            break;
            default:
                break;
        }
    
        return [@[]mutableCopy];
}

- (NSMutableArray*)sumBalanceForSameWay:(NSMutableArray*)originArr withDistinctionTime:(NSString*)distinctionTime{
    NSNumber* incomeTotal = [NSString getPropertTotalNumberByArray:[self setFilteredAarryForSameKeyValue:originArr withSameKey:kIndexSection]];
    NSNumber* outcomeTotal = [NSString getPropertTotalNumberByArray:[self setFilteredAarryForSameKeyValue:originArr withSameKey:kType]];
    
    NSDecimalNumber* allOutcomeBalance = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",outcomeTotal]];
     NSDecimalNumber* allIncomeBalance = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",incomeTotal]];
    
     NSDecimalNumber*finalNum = [allIncomeBalance decimalNumberBySubtracting:allOutcomeBalance];
    return [@[
            @{
    kDate:distinctionTime,
    kTit:outcomeTotal,
    kSubTit:incomeTotal,
    kTotal:finalNum
            }
        ] mutableCopy];
}

- (NSMutableArray*)setFilteredAarryForSameKeyValue:(NSMutableArray*)originArr withSameKey:(NSString*)sameKey{
    NSMutableArray* finalArrIncome = [NSMutableArray array];
    NSMutableArray* finalArrOutcome = [NSMutableArray array];
    NSMutableArray* filteredAarry = [NSMutableArray array];
    
    NSMutableArray* attriArrs = [NSMutableArray array];
    
    [attriArrs addObjectsFromArray:[originArr mutableCopy]];
    
    
    for (int i=0; i<attriArrs.count; i++) {
        NSDictionary* temA = attriArrs[i];
        NSString* AheadKey = sameKey;
        
        BOOL isContainKAmount = [[temA allKeys] containsObject:sameKey];
        if (!isContainKAmount) {
            continue;
        }
        
//        NSNumber* tempAValue = @([temA[AheadKey]intValue]);
        NSString* tempAValue = [NSString stringWithFormat:@"%@",temA[AheadKey]];
        NSMutableArray* Is = [NSMutableArray array];
        
        NSMutableArray* matchArr = [NSMutableArray array];
        [matchArr addObject:temA];
        
        for (int j=i+1; j<attriArrs.count; j++) {
            NSDictionary* temB = attriArrs[j];
            NSString* BheadKey = sameKey;
            BOOL isContainKAmount = [[temB allKeys] containsObject:sameKey];
            if (!isContainKAmount) {
                continue;
            }
//            NSNumber* tempBValue = @([temB[BheadKey]intValue]);
            NSString* tempBValue = [NSString stringWithFormat:@"%@",temB[BheadKey]];
            if ( BheadKey.hash ==  AheadKey.hash &&tempBValue.hash ==  tempAValue.hash) {
                
                [matchArr addObject:temB];
                
//                tempAValue= tempBValue;
//
//                NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
//                [dicHR addEntriesFromDictionary:[self getAccountingTagPieData:temB]];
//                [dicHR addEntriesFromDictionary:@{kTotal:num}];
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
    for (int i=0; i<filteredAarry.count; i++) {
        NSArray* matchArr = filteredAarry[i];
        
        NSNumber* num = [NSString getPropertAmountNumberByArray:matchArr];
        NSDictionary* dic0 = matchArr.lastObject;
        NSMutableDictionary* dicHR = [NSMutableDictionary dictionary];
        [dicHR addEntriesFromDictionary:[self getAccountingTagPieData:dic0]];
        [dicHR addEntriesFromDictionary:@{kTotal:num}];
        if ([dic0[kType]intValue] == AccountingTypeIncome) {

            [finalArrIncome addObject:dicHR];
        }else{
            [finalArrOutcome addObject:dicHR];
        }
        
    }
    return [sameKey isEqualToString: kDate]?filteredAarry:[sameKey isEqualToString: kIndexSection]? finalArrIncome: finalArrOutcome;
//    return attriArrs;

/*
 {
     kAmount = 25;
     kDate = "2020.05.22";
     kImg = fushi;
     kIndexRow = 25;
     kSubTit = "\U670d\U9970";
     kTit = "\U8d2d\U7269";
     kType = 2;
 },
 {
     kAmount = 2356;
     kColor = "UIExtendedSRGBColorSpace 0.709804 0.729412 0.188235 1";
     kDate = "2020.05.22";
     kImg = touzi;
     kIndexInfo = "\U6295\U8d44";
     kIndexRow = 1;
     kIndexSection = 1;
     kSubTit = "\U6295\U8d44";
     kTit = "\U6536\U5165";
     kTotal = 87071;
     kType = 0;
 },
 */
}

- (NSMutableArray*)setFilteredData:(NSMutableArray*)outcomeMutArr withSameKey:(NSString*)sameKey{
    NSMutableArray* attriArrs = [NSMutableArray array];
    [attriArrs addObjectsFromArray:[outcomeMutArr mutableCopy]];
    
    for (int i=0; i<attriArrs.count; i++) {
        NSDictionary* temA = attriArrs[i];
        NSString* AheadKey = sameKey;
        BOOL isContainKAmount = [[temA allKeys] containsObject:sameKey];
        if (!isContainKAmount) {
            continue;
        }
        
//        NSNumber* tempAValue = @([temA[AheadKey]intValue]);
        NSString* tempAValue = [NSString stringWithFormat:@"%@",temA[AheadKey]];


        
        NSMutableArray* Is = [NSMutableArray array];
        
        
        for (int j=i+1; j<attriArrs.count; j++) {
            NSDictionary* temB = attriArrs[j];
            NSString* BheadKey = sameKey;
            BOOL isContainKAmount = [[temB allKeys] containsObject:sameKey];
            if (!isContainKAmount) {
                continue;
            }
//            NSNumber* tempBValue = @([temB[BheadKey]intValue]);
            NSString* tempBValue = [NSString stringWithFormat:@"%@",temB[BheadKey]];
            
            if ( tempBValue.hash ==  tempAValue.hash) {
//                BheadKey.hash ==  AheadKey.hash &&
                
                tempAValue = tempBValue;
                
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
    
//    NSLog(@"setFilteredLastStringForSameKey%@",attriArrs);
    return attriArrs;


}
- (NSMutableArray*)getAccountingTagDataWithSelectedType:(AccountingSelectedType)selectedType{
    NSArray* incomeArr = @[
        @{@"工资":@"gongzi"},
        @{@"投资":@"touzi"},
        @{@"兼职外快":@"jianzhiwaikuai"},
        @{@"生活费":@"shenghuofei"},
        @{@"收红包":@"shouhongbao"},
        @{@"二手闲置":@"ershouxianzhi"},
        @{@"借入":@"jieru"},
        @{@"报销":@"baoxiao"},
        @{@"其他":@"qita"},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* incomeMutArr = [NSMutableArray array];
    for (int i=0 ; i< incomeArr.count; i++){
        NSDictionary* dic0 = incomeArr[i];
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeIncome),
            kIndexSection:@(i),
            kTit:[NSString stringWithFormat:@"%@",@"🎂"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [incomeMutArr addObject:dic1];
    }
    
    NSArray* dietArr = @[
        @{@"早餐":@"zaocan"},
        @{@"午餐":@"wucan"},
        @{@"晚餐":@"wancan"},
        @{@"宵夜":@"yexiao"},
        @{@"零食":@"lingshi"},
        @{@"饮料":@"yinliao"},
        @{@"可可菜":@"maicai"},
        @{@"酒水":@"jiushui"},
        @{@"水果":@"shuiguo"},
        @{@"香烟":@"xiangyan"},
        @{@"其他":@"qita"},
        @{@"":@""}
    ];
    NSMutableArray* dietMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in dietArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeDiet),
            kTit:[NSString stringWithFormat:@"%@",@"饮食"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [dietMutArr addObject:dic1];
    }
    
    NSArray* shoppingArr = @[
        @{@"生活用品":@"shenghuoyongpin"},
        @{@"服饰":@"fushi"},
        @{@"包包":@"baobao"},
        @{@"鞋子":@"xiezi"},
        @{@"淘宝":@"taobao"},
        @{@"护肤彩妆":@"hufucaizhuang"},
        @{@"饰品":@"shipin"},
        @{@"美容美甲":@"meijia"},
        @{@"其他":@"qita"},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* shoppingMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in shoppingArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeShopping),
            kTit:[NSString stringWithFormat:@"%@",@"购物"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [shoppingMutArr addObject:dic1];
    }
    
    NSArray* tripArr = @[
        @{@"交通":@"chuxing"},
        @{@"加油":@"jiayou"},
        @{@"停车费":@"tingchefei"},
        @{@"打车":@"dache"},
        @{@"地铁":@"ditie"},
        @{@"火车":@"huoche"},
        @{@"公交":@"gongjiao"},
        @{@"机票":@"jipiao"},
        @{@"修车养护":@"xiucheyanghu"},
        @{@"其他":@"qita"},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* tripMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in tripArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeTrip),
            kTit:[NSString stringWithFormat:@"%@",@"出行"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [tripMutArr addObject:dic1];
    }
    
    NSArray* educationArr = @[
        @{@"学习":@"xuexi"},
        @{@"书籍":@"shu"},
        @{@"文具":@"wenju"},
        @{@"学费":@"xuefei"},
        @{@"考试":@"kaoshi"},
        @{@"培训":@"peixun"},
        @{@"辅导班":@"fudaoban"},
        @{@"育儿":@"yuer"},
        @{@"其他":@"qita"},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* educationMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in educationArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeEducation),
            kTit:[NSString stringWithFormat:@"%@",@"教育"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [educationMutArr addObject:dic1];
    }
    
    NSArray* recreationArr = @[
        @{@"电影":@"dianying"},
        @{@"游戏":@"youxi"},
        @{@"追星":@"zhuixing"},
        @{@"ktv":@"KTV"},
        @{@"酒吧":@"jiuba"},
        @{@"健身":@"jianshen"},
        @{@"旅游":@"lvyou"},
        @{@"洗浴":@"xiyu"},
        @{@"其他":@"qita"},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* recreationMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in recreationArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeRecreation),
            kTit:[NSString stringWithFormat:@"%@",@"娱乐"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [recreationMutArr addObject:dic1];
    }
    NSArray* otherOutcomeArr = @[
        @{@"其他支出":@"qitazhichu"},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""},
        @{@"":@""}
    ];
    NSMutableArray* otherOutcomeMutArr = [NSMutableArray array];
    for (NSDictionary* dic0 in otherOutcomeArr) {
        
        NSDictionary* dic1 = @{
            kType:@(AccountingTypeOtherOutcome),
            kTit:[NSString stringWithFormat:@"%@",@"其他支出"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [otherOutcomeMutArr addObject:dic1];
    }
    
    NSMutableArray*listData = [NSMutableArray array];
    [listData addObjectsFromArray:incomeMutArr];
    [listData addObjectsFromArray:dietMutArr];
    [listData addObjectsFromArray:shoppingMutArr];
    [listData addObjectsFromArray:tripMutArr];
    [listData addObjectsFromArray:educationMutArr];
    [listData addObjectsFromArray:recreationMutArr];
    [listData addObjectsFromArray:otherOutcomeMutArr];
    
    for (int i=0; i< listData.count; i++) {
        NSDictionary* dic = listData[i];
        NSMutableDictionary* dic0= [NSMutableDictionary dictionaryWithDictionary:dic];
        [dic0 addEntriesFromDictionary:@{kIndexRow:@(i)}];
        [listData replaceObjectAtIndex:i withObject:[dic0 mutableCopy]];
    }
    
    
        
        switch (selectedType) {
            case AccountingSelectedTypeIncome:{
                
                return [NSMutableArray arrayWithArray:[[listData mutableCopy] subarrayWithRange:NSMakeRange(0, incomeMutArr.count)]];
            }
                break;
            case AccountingSelectedTypeOutcome:{
                
                return [NSMutableArray arrayWithArray:[[listData mutableCopy] subarrayWithRange:NSMakeRange(incomeMutArr.count, listData.count - incomeMutArr.count)]];
            }
                break;
            case AccountingSelectedTypeAllStated:{
                
                return listData;
            }
                break;
            default:
                break;
        }
        return [@[]mutableCopy];
    //    return [NSMutableArray arrayWithArray:tags];;
}

- (NSMutableArray*)getAccountingPayData{
    NSArray* incomeArr = @[
        @{@"":@"paycash"},
        @{@"":@"paycredit"},
        @{@"😊":@"payzhifubao"},
        @{@"😄包":@"payweixin"},
        @{@"":@"paydeposit"},
    //    @{@"":@""}
    ];
    NSMutableArray* incomeMutArr = [NSMutableArray array];
    for (int i=0; i< incomeArr.count; i++){
        NSDictionary* dic0  = incomeArr[i];
        NSDictionary* dic1 = @{
            kType:@(i),
    //        kTit:[NSString stringWithFormat:@"%@",@"🎂"],
            kSubTit:[NSString stringWithFormat:@"%@",dic0.allKeys[0]],
            kImg:[NSString stringWithFormat:@"%@",dic0.allValues[0]]
                               
                               };
        [incomeMutArr addObject:dic1];
    }
    return incomeMutArr;
}

- (void)setDefaultDataIsForceInit:(BOOL)isForceInit{
    if (isForceInit) {
        [UserInfoManager DeleteNSUserDefaults];
        
        UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
//        userInfoModel.tagArrs = [[self getAccountingTagDataWithSelectedType:AccountingSelectedTypeAllStated] mutableCopy];
        userInfoModel.tagArrs = @[];
        userInfoModel.currentDay = [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]];
        userInfoModel.paySource = [[AccountingModel new]getAccountingPayData][3][kSubTit];
        
        userInfoModel.purseArr = [[self getAccountingPayData]mutableCopy];
        [UserInfoManager SetNSUserDefaults:userInfoModel];
        
    }else{
        if (![UserInfoManager GetNSUserDefaults].tagArrs) {
            UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
            userInfoModel.tagArrs = @[];
            userInfoModel.currentDay = [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]];
            userInfoModel.paySource = [[AccountingModel new]getAccountingPayData][3][kSubTit];
            
            userInfoModel.purseArr = [[self getAccountingPayData]mutableCopy];
            [UserInfoManager SetNSUserDefaults:userInfoModel];
        }
    }
}
@end
