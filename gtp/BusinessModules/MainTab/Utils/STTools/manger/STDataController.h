//
//  STDataController.h
//  BannerVideo
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^STDataControllerHandle)(NSError * error,BOOL success,NSDictionary * resp);
NS_ASSUME_NONNULL_BEGIN

@interface STDataController : NSObject

@end

NS_ASSUME_NONNULL_END
