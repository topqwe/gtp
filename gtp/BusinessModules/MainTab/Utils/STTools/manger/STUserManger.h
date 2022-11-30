//
//  STUserManger.h
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVUserModel.h"
#define FIRST_INIT_NOTIFACATION @"FIRST_INIT_NOTIFACATION"
@interface STUserManger : NSObject
@property(nonatomic, strong) NSString                     *token;
@property(nonatomic, strong) NSString                     *userID;

@property(nonatomic, strong) NSString                     *noLoginToken;/**< 未登录的token */
@property(nonatomic, strong) NSString                     *noLoginInviteCode;/**< 未登录的inviteCode */
+ (STUserManger*)defult;
- (BVUserModel*)loginedUser;
- (void)updateUserModel:(BVUserModel*)userModel;
//删除用户信息
- (void)removeUserPreferce;

- (void)updateAccount:(NSString*)account pwd:(NSString*)pwd;
- (NSString*)account;
- (NSString*)pwd;


- (void)fetchNoLoginToken;
@end
