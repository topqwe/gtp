//
//  ABGuidePageManager.h
//  OTC
//
//  Created by David on 2018/12/5.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishBlock)(void);

typedef NS_ENUM(NSInteger, HWGuidePageType) {
    ABGuidePageTypeScan = 1,
    ABGuidePageTypeBuy,
    ABGuidePageTypeSale,
    ABGuidePageTypeOrder,
};

@interface HomeGuidePageManager : NSObject

// 获取单例
+ (instancetype)shareManager;

/**
 显示方法
 @param type 指引页类型
 */
- (void)showGuidePageWithType:(HWGuidePageType)type;

/**
 显示方法
 @param type 指引页类型
 @param completion 完成时回调
 */
- (void)showGuidePageWithType:(HWGuidePageType)type completion:(FinishBlock)completion;

@end

NS_ASSUME_NONNULL_END
