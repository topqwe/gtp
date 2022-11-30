//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ExchangeApplyItem : NSObject
@property (nonatomic, copy) NSString*  err_code;
@property (nonatomic, copy) NSString*  msg;
@end


@interface ExchangeRateItem : NSObject
@property (nonatomic, copy) NSString*  err_code;
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  exchangeRate;
@end

@interface ExchangeSubPageData : NSObject
@property (nonatomic, strong) NSString * pageno;
@property (nonatomic, strong) NSString * pagesize;
@property (nonatomic, strong) NSString * sum;
@end

@interface ExchangeSubData : NSObject
@property (nonatomic, strong) NSString * btcApplyId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * btcNumber;
@property (nonatomic, strong) NSString * btcAddress;
@property (nonatomic, strong) NSString * createdTime;
@property (nonatomic, strong) NSString * status;
- (NSString*)getExchangeTitle;

- (NSString*)getExchangeSubtitle;

- (NSString*)getExchangeStatusName;
- (ExchangeType)getExchangeStatus;
@end

@interface ExchangeModel : NSObject
@property (nonatomic, strong) ExchangeSubPageData* page;
@property (nonatomic, strong) NSArray * exchangeBTC;
@property (nonatomic, copy) NSString*  err_code;
@property (nonatomic, copy) NSString*  msg;
+(NSDictionary *)objectClassInArray;
@end
