//
//  BVCircleDataController.h
//  BannerVideo
//
//  Created by Mac on 2019/3/29.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/************圈子数据控制******************/
@interface BVCircleDataController : NSObject
//获取banner
+ (void)sendGetCircleBannerRequestWithHandle:(void(^)(NSArray<BVAdverModel*> * array))handle;

//获取区域包括全部
+ (void)sendGetGeginRequestWithHandle:(void(^)(NSArray * reginArray))handle;

//组获取 区域和banner
+ (void)sendGroupGetReginAndBannerRequestWithHandle:(void(^)(NSArray<BVAdverModel*> * banerArray,NSArray * reginArray))handle;

//取消/点赞
+ (void)sendGoodRequestWithD_id:(NSString*)d_id handle:(STDataControllerHandle)handle;

//点赞评论
+ (void)senGoodCommentRequestWithc_id:(NSString*)c_id handle:(STDataControllerHandle)handle;

//评论内容
+ (void)sendAddCommentRequestWithd_id:(NSString*)d_id content:(NSString*)content handle:(STDataControllerHandle)handle;
@end

NS_ASSUME_NONNULL_END
