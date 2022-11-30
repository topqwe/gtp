//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserInfoSingleton.h"
@interface UserInfoManager : NSObject
+(void)SetCacheDataWithKey:(NSString*)key withData:(id)data;
+(id)GetCacheDataWithKey:(NSString*)key;
+(void)SetNSUserDefaults:(UserInfoModel *)userInfo;
+(UserInfoModel *)GetNSUserDefaults;
+(void)DeleteNSUserDefaults;
+(NSString *)GetBearerToken;
@end
