//
//  PageVM.h
//  YBArchitectureDemo
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrdersPageVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrdersPageVM : NSObject

- (void)network_getOrdersPageListWithPage:(NSInteger)page success:(void(^)(NSArray *dataArray))success failed:(void(^)(void))failed;
@end

NS_ASSUME_NONNULL_END
