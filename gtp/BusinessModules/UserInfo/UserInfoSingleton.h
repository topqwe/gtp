//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface UserInfoSingleton : NSObject
@property(nonatomic,strong) UserInfoModel *userInfo;
+(UserInfoSingleton*)sharedUserInfoContext;
@end
