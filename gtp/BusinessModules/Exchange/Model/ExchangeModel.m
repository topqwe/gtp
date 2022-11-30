//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "ExchangeModel.h"
@implementation ExchangeApplyItem : NSObject

@end

@implementation ExchangeRateItem : NSObject

@end

@implementation ExchangeSubPageData : NSObject

@end

@implementation ExchangeSubData : NSObject
- (NSString*)getExchangeTitle{
    NSString* title = @"哥哥 BTC";
    return title;
}

- (NSString*)getExchangeSubtitle{
    NSString* title = @"";
    if (![NSString isEmpty:self.number]&&![NSString isEmpty:self.btcNumber]) {
        title = [NSString stringWithFormat:@"%@ AB = %@ BTC",self.number,self.btcNumber];
    }
    return title;
}

- (NSString*)getExchangeStatusName{
    NSString* title = @"";
    ExchangeType type = [self getExchangeStatus];
    switch (type) {
        case ExchangeTypeHandling:
            title = @"处理中";
            break;
        case ExchangeTypePayed:
            title = @"已汇出";
            break;
        case ExchangeTypeBack:
            title = @"已驳回";
            break;
        default:
            break;
    }
    return title;
}
- (ExchangeType)getExchangeStatus{
    ExchangeType type = ExchangeTypeAll;
    NSInteger tag = [self.status integerValue];
    if (tag  == 0)
    {
        type = ExchangeTypeAll;
    }
    else if (tag  == 1)
    {
        type = ExchangeTypeHandling;
    }
    else if (tag == 2)
    {
        type = ExchangeTypePayed;
    }
    else if (tag == 3)
    {
        type = ExchangeTypeBack;
    }
    
    return type;
}
@end


@implementation ExchangeModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"exchangeBTC" : [ExchangeSubData class]
             };
}
@end
