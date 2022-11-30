//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "UserInfoSingleton.h"

@implementation UserInfoSingleton
static UserInfoSingleton *sharedUserInfoContext = nil;
+(UserInfoSingleton*)sharedUserInfoContext{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedUserInfoContext == nil){
            sharedUserInfoContext = [[self alloc] init];
        }
    });
    return sharedUserInfoContext;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t token;
     dispatch_once(&token, ^{
         if(sharedUserInfoContext == nil){
             sharedUserInfoContext = [super allocWithZone:zone];
         }
     });
         return sharedUserInfoContext;
}
- (instancetype)init{
     self = [super init];
     if(self){
        //实例化这个Models
         sharedUserInfoContext.userInfo = [[UserInfoModel alloc] init];
     }
     return self;
}
- (id)copy{
     return self;
}
- (id)mutableCopy{
     return self;
}
@end
