//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountingModel : NSObject
- (NSMutableArray*)getAccountingAssembledData:(NSArray*)originArr selectedType:(AccountingSelectedType)selectedType withDistinction:(AccountingDistinctionType)distinctionType
withDistinctionTime:(NSString*)distinctionTime withDistinctionBalanceSource:(NSString*)distinctionBalanceSource;

- (NSMutableArray*)getAccountingTagDataWithSelectedType:(AccountingSelectedType)selectedType;


- (NSMutableArray*)getAccountingPayData;

- (void)setDefaultDataIsForceInit:(BOOL)isForceInit;

@end
