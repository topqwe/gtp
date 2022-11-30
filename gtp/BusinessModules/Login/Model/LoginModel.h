//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoginData : NSObject
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSString * istrpwd;
@property (nonatomic, copy) NSString * valiidnumber;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * safeverifyswitch;
@property (nonatomic, copy) NSString * googlesecret;
@property (nonatomic, copy) NSString * valigooglesecret;

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * userType;
@property (nonatomic, copy) NSString*  token;
@property (nonatomic, copy) NSString*  account;
@end


@interface LoginModel : NSObject
@property (nonatomic, copy) NSString*  servertime;
@property (nonatomic, copy) NSString*  loginname;
@property (nonatomic, copy) NSString*  state;
@property (nonatomic, strong) LoginData * data;
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, copy) NSString*  msg;

@end
