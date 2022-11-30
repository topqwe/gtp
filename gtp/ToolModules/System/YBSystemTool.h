//
//  YBSystemTool.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBSystemTool : NSObject
+ (int)compareWithVersion1:(NSString *)version1;
/** 判断是否是 iphoneX 系列 */
+ (BOOL)isIphoneX;

/** app 版本号 */
+ (NSString *)appVersion;

/** app 来源 ：iOS或安卓 */
+ (NSString *)appSource;

/** app 名称 */
+ (NSString *)appName;
//获取设备唯一标识符
+ (NSString *)getUUIDString;
//获取设备的型号 iPhone
+ (NSString *)deviceModel;
//获取系统版本号
+ (NSString *)systemVersion;
//地方型号  （国际化区域名称）
+ (NSString *)localPhoneModel;
//获取设备名称
+ (NSString *)deviceName;
//获取iOS设备型号：iPhone8.2
+ (NSString*)deviceModelName;
@end

@interface YBSystemTool (UI)

/** 获取顶层的 UIViewController 实例 */
+ (UIViewController *)topViewController;

/** 获取 windowLevel 为 UIWindowLevelNormal 的 UIWindow 实例 */
+ (UIWindow *)normalWindow;

@end

NS_ASSUME_NONNULL_END
