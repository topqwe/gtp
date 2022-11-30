//
//  YBFrameTool.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBFrameTool : NSObject

/** 适配的底部额外的高度 */
+ (CGFloat)iphoneBottomHeight;

/** 原TabBar高度 */
+ (CGFloat)tabBarHeight;

/** 原TabBar高度+ 适配的底部额外的高度*/
+ (CGFloat)safeAdjustTabBarHeight;

/** 适配的状态栏高度 */
+ (CGFloat)statusBarHeight;

/** 原导航栏高度 */
+ (CGFloat)navigationBarHeight;

/** 适配的状态栏高度+ 原导航栏高度 */
+ (CGFloat)safeAdjustNavigationBarHeight;
@end

NS_ASSUME_NONNULL_END
