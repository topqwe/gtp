//
//  YBHomeDataCenter.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExchangeVM : NSObject
- (void)network_getExchangeApplyWithResquestParams:(NSArray*)resquestParams Success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_getExchangeListWithPage:(NSInteger)page WithExchangeType:(ExchangeType)type success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
