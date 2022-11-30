//
//  TMUpdateManger.h
//  WorthWhile
//
//  Created by Mac on 2018/10/26.
//  Copyright © 2018年 stoneobs.icloud.com. All rights reserved.
//

/*
ios_release_version: 正式版 版本号    （客户端 版本号 小于 ios_release_version  则需要更新）
ios_debug_version: 测试版本 版本号    （测试版本号 永远比 正式版本 号 大0.1，上架成功 之后版本修改）
updateUrl: 更新地址                          （  客户端版本低于正式版版本 弹出更新）
updateContent:更新内容              （;隔开的数组）
is_appstore_review:是否正在审核，(前端判定版本号 == 正式版本&& is_appstore_review = yes 隐藏无法上架元素)
shouldForceUpdate:是否需要 强制更新
shouldShowDebugMonitor:是否需要展示ios debug日志检测
code:200

当前值
ios_release_version:1.55
ios_debug_version:1.65
updateUrl:
https://itunes.apple.com/us/app/%E7%BB%BF%E8%89%B2%E5%AE%B6%E5%9B%AD-%E7%94%9F%E9%B2%9C%E5%95%86%E5%9F%8E/id1441401041?l=zh&ls=1&mt=8
updateContent:@"新版本AppStore已更新请及时下载;"
shouldForceUpdate:1
is_appstore_review: 1
shouldShowDebugMonitor:1
code:10000
*/
#import <Foundation/Foundation.h>

@interface TMUpdateManger : NSObject
+ (TMUpdateManger*)manger;
- (BOOL)shouldDealWithTheAudit;//是否 需要处理上架版本
- (bool)judgeShouldUpdate;//如果需要更新，展示更新弹窗
@end
