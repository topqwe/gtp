//
//  HomeModel.h
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicsModel.h"
@interface WItem : NSObject
@property (nonatomic, copy) NSString * argValue;
@property (nonatomic, copy) NSString * rankingType;
@property (nonatomic, copy) NSString * argName;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;
@end

@interface WData : NSObject
@property (nonatomic, copy) NSArray * rankinglist;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
+(NSDictionary *)objectClassInArray;
@end

@interface MinePayMethod : NSObject
@property (nonatomic, copy) NSString*name;
@property (nonatomic, copy) NSString*payMent;
@property (nonatomic, copy) NSString*type;
@end

@interface HomeItem : NSObject
@property (nonatomic, copy) NSString* mark;
@property (nonatomic, copy) NSString* intro;
@property (nonatomic, copy) NSString* start_second;

@property (nonatomic, copy)NSString* start_id;
@property (nonatomic, assign) BOOL  no_read;
@property (nonatomic, copy) NSString*  to_user_id;
@property (nonatomic, copy) NSString* created_at;
@property (nonatomic, copy) NSString* to_user_nickname;

@property (nonatomic, assign) BOOL is_allow_post;
@property (nonatomic, assign) BOOL can_select_city;
@property (nonatomic, assign) BOOL have_new;

@property (nonatomic, copy) NSArray*types;
@property (nonatomic, copy) NSString*preview_hls_url;
@property (nonatomic, copy) NSString*preview_dash_url;
@property (nonatomic, copy) NSArray * childs;
@property (nonatomic, assign) NSInteger  parent_id;
@property (nonatomic, copy) NSArray * ad_list;

@property (nonatomic, assign) NSInteger duration_seconds;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, assign) NSInteger is_love;
@property (nonatomic, assign) NSInteger is_collect;
//@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, assign) NSInteger  cid;
@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, assign) NSInteger  vid;
@property (nonatomic, assign) NSInteger  uid;
@property (nonatomic, assign) NSInteger  reply_cid;
@property (nonatomic, assign) NSInteger  replies;
@property (nonatomic, copy) NSString* reply_at;

@property (nonatomic, assign) NSInteger  icon;
@property (nonatomic, assign) NSInteger  ID;
@property (nonatomic, assign) NSInteger sync;
@property (nonatomic, assign) NSInteger  type;
@property (nonatomic, assign) NSInteger restricted;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, copy) NSString*  gold;
@property (nonatomic, copy) NSString*  cover_img;
@property (nonatomic, copy) NSString*  dash_url;
@property (nonatomic, copy) NSString*  duration;
@property (nonatomic, copy) NSString*  hls_url;
@property (nonatomic, copy) NSString*  name;
@property (nonatomic, copy) NSString*  nickname;
@property (nonatomic, copy) NSString*  content;
@property (nonatomic, copy) NSString*  replied_nickname;
@property (nonatomic, copy) NSString* money;
@property (nonatomic, copy) NSString* amount;

@property (nonatomic, copy) NSString*  title;
@property (nonatomic, copy) NSString*  updated_at;
@property (nonatomic, copy) NSString*  date;
@property (nonatomic, copy) NSString*  url;
@property (nonatomic, copy) NSString*  views;
@property (nonatomic, assign) NSInteger avatar;
@property (nonatomic, copy) NSString*  img;
@property (nonatomic, assign) NSInteger style;
- (UIImage*)getLevImg;
- (NSString*)getLevLimitButTitle;
- (NSString*)getLevLimitTitle;
- (NSString*)getNLevLimitTitle;
@end

@interface HomeList : NSObject
@property (nonatomic, copy) NSArray * rights_list;
@property (nonatomic, copy) NSArray * small_video_list;
@property (nonatomic, copy) NSArray * ad_list;
@property (nonatomic, assign) NSInteger  ID;
@property (nonatomic, copy) NSString*  name;
@property (nonatomic, copy) NSString*  remark;
@property (nonatomic, copy) NSString*  name_day;
@property (nonatomic, copy) NSString*  real_value;
@property (nonatomic, copy) NSString*  value;
@property (nonatomic, copy) NSString*  hours;
@property (nonatomic, assign) NSInteger valid_period;
//@property (nonatomic, copy) NSString*  valid_period;

@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, copy) NSString* bg_img;
@property (nonatomic, copy) NSString* local_bg_img;
@property (nonatomic, copy) NSString*  title;
@property (nonatomic, assign) NSInteger  sort;
@property (nonatomic, assign) IndexSectionUIStyle style;
+(NSDictionary *)objectClassInArray;
@end

@interface MemberItem : NSObject
@property (nonatomic, copy) NSString*name;
@property (nonatomic, copy) NSString*expired_time;
@property (nonatomic, copy) NSString*vip_expired;
@property (nonatomic, copy) NSString*vip_day;
@property (nonatomic, assign) BOOL is_vip;
- (NSDictionary*)getUserLevel;
@end

@interface MinePayMsg : NSObject
@property (nonatomic, copy) NSString*oid;
@property (nonatomic, copy) NSString*payUrl;
@property (nonatomic, copy) NSString*sign;
@property (nonatomic, copy) NSString*rebate;
@property (nonatomic, copy) NSString*mode;
@end

@interface HomeData : NSObject
@property (nonatomic, strong) DynamicsModel*user_info;
@property (nonatomic, strong) MinePayMsg*msg;
@property (nonatomic, copy) NSString*code;
@property (nonatomic, copy) NSString*pay_id;
@property (nonatomic, strong) MemberItem* member_card;

@property (nonatomic, copy) NSString*invite_code;
@property (nonatomic, copy) NSString*reward_rules;
@property (nonatomic, copy) NSString*promotion_url;
@property (nonatomic, strong) NSArray * list;

@property (nonatomic, copy) NSArray * bbs_list;
+(NSDictionary *)objectClassInArray;
@end

@interface ConfigItem : NSObject
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) NSInteger  ID;
@property (nonatomic, assign) NSInteger sync;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, copy) NSString*  url;
@property (nonatomic, copy) NSString*  play_url;
@property (nonatomic, copy) NSString*  weight;
@property (nonatomic, copy) NSString*  name;
@property (nonatomic, copy) NSString*  img;
@property (nonatomic, copy) NSString*  title;
@property (nonatomic, assign) NSInteger position;
@end

@interface ConfigModel : NSObject
- (NSString*)getKFUrl;
@property (nonatomic, copy) NSString*download_url;
@property (nonatomic, assign) NSInteger send_sms_intervals;
@property (nonatomic, copy) NSString*kf_url;
@property (nonatomic, copy) NSArray * open_screen_ads;
@property (nonatomic, copy) NSArray * activity_ads;
@property (nonatomic, copy) NSString*announcement;
@property (nonatomic, assign) NSInteger anActionType;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) NSInteger adTime;
@property (nonatomic, copy) NSString*version;
@property (nonatomic, copy) NSString*obUrl;

+(NSDictionary *)objectClassInArray;
@end

@interface CategoryModel : NSObject
@property (nonatomic, strong) NSArray * data;
+(NSDictionary *)objectClassInArray;
@end

@interface BannerModel : NSObject
@property (nonatomic, strong) NSArray * data;
+(NSDictionary *)objectClassInArray;
@end

@interface HomeModel : NSObject
@property (nonatomic, strong) HomeData * data;
@property (nonatomic, copy) NSString*  state;
@property (nonatomic, copy) NSString*  msg;
@end
