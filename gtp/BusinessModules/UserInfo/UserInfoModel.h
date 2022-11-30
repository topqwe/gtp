//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserInfoData : NSObject

@property (nonatomic, copy) NSString * attention;
@property (nonatomic, assign) NSInteger  avatar;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * diamond;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * expires_at;
@property (nonatomic, copy) NSString * fans;
@property (nonatomic, copy) NSString * gold;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * last_ip;
@property (nonatomic, copy) NSString * long_vedio_times;
@property (nonatomic, copy) NSString * kf_url;
@property (nonatomic, copy) NSString * area_number;
@property (nonatomic, copy) NSString * phone_number;
@property (nonatomic, copy) NSString * nickname;

@property (nonatomic, copy) NSString * promotion_code;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString * short_vedio_times;
@property (nonatomic, copy) NSString * token_type;
@property (nonatomic, copy) NSString * upload_times;
@property (nonatomic, copy) NSString * vip;
@property (nonatomic, copy) NSString *vip_expired;

@property (nonatomic, copy) NSString*  token;
@property (nonatomic, copy) NSString*  account;

@end

@interface UserInfoModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  state;
@property (nonatomic,copy) NSArray *searchKeyArrs;
@property (nonatomic, strong) UserInfoData * data;


@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,copy) NSString *paySource;
@property (nonatomic,copy) NSArray *tagArrs;
@property (nonatomic,copy) NSString *currentDay;
@property (nonatomic,copy) NSDate *recordedDate;
@property (nonatomic,copy) NSArray *purseArr;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *cookie;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *deviceid;

- (void)setDefaultDataIsForceInit:(BOOL)isForceInit;
- (UIImage*)getUserAvatorImg;
- (NSString*)getUserGender;
+ (NSArray*)getUserAvatorImgArrs;
@end
/*
 一定要[NSArray arrayWithArray:这个方法否则存不进
 UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
 userInfoModel.searchKeyArrs = [NSArray arrayWithArray:[self.historyArray mutableCopy]];
 [UserInfoManager SetNSUserDefaults:userInfoModel];
 */
