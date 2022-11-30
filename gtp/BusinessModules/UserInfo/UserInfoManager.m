//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager
+(void)SetCacheDataWithKey:(NSString*)key withData:(id)data{
    if (data) {
        NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    }
}
+(id)GetCacheDataWithKey:(NSString*)key{
    NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return data;
}

+(void)SetNSUserDefaults:(UserInfoModel *)userInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kUserInfo];
    [defaults synchronize];
}

+(UserInfoModel *)GetNSUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:kUserInfo];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)DeleteNSUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserInfo];
}

+(NSString *)GetBearerToken{
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    NSString* loginToken = @"";
    if (userInfoModel.data.token.length>0) {
        loginToken =  [NSString stringWithFormat:@"Bearer %@",userInfoModel.data.token];
    }
    return loginToken;
}
@end
