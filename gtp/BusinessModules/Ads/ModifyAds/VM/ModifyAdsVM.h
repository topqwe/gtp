//
//  YBHomeDataCenter.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModifyAdsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyAdsVM : NSObject

//这里也可以用代理回调网络请求
- (void)network_getModifyAdsListWithPage:(NSInteger)page success:(void(^)(NSArray *dataArray))success failed:(void(^)(void))failed;
@end

NS_ASSUME_NONNULL_END
