//
//  BVCateDataController.h
//  BannerVideo
//
//  Created by apple on 2019/3/31.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "STDataController.h"
#import "BVActorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BVCateDataController : STDataController
//获取演员信息
+ (void)sendFetchActorRequestWith:(NSString*)actor_id handle:(void(^)(bool success, BVActorModel*model))handle;
//收藏或者取消收藏演员
+ (void)sendCollectActorRequestWithActor_id:(NSString*)actor_id handle:(STDataControllerHandle)handle;
@end

NS_ASSUME_NONNULL_END
