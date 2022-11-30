//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "UserInfoModel.h"
@implementation UserInfoData
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"ID" : @"id",
    };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ID     forKey:@"ID"];
    [aCoder encodeObject:self.token     forKey:@"token"];
    
    [aCoder encodeObject:self.account     forKey:@"account"];
    [aCoder encodeInteger:self.avatar  forKey:@"avatar"];
    [aCoder encodeObject:self.nickname  forKey:@"nickname"];
    
    [aCoder encodeObject:self.email     forKey:@"email"];
    [aCoder encodeInteger:self.sex     forKey:@"sex"];
    [aCoder encodeObject:self.phone_number     forKey:@"phone_number"];
    [aCoder encodeObject:self.gold     forKey:@"gold"];
    [aCoder encodeObject:self.diamond     forKey:@"diamond"];
    [aCoder encodeObject:self.balance     forKey:@"balance"];
    [aCoder encodeObject:self.vip_expired     forKey:@"vip_expired"];
    [aCoder encodeObject:self.long_vedio_times     forKey:@"long_vedio_times"];
    [aCoder encodeObject:self.short_vedio_times     forKey:@"short_vedio_times"];
    [aCoder encodeObject:self.attention     forKey:@"attention"];
    [aCoder encodeObject:self.fans  forKey:@"fans"];
    [aCoder encodeObject:self.area_number     forKey:@"area_number"];
    [aCoder encodeObject:self.kf_url  forKey:@"kf_url"];
    [aCoder encodeObject:self.upload_times     forKey:@"upload_times"];
    [aCoder encodeObject:self.last_ip     forKey:@"last_ip"];
    [aCoder encodeObject:self.expires_at  forKey:@"expires_at"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.avatar = [aDecoder decodeIntegerForKey:@"avatar"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        
        
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.sex = [aDecoder decodeIntegerForKey:@"sex"];
        self.phone_number = [aDecoder decodeObjectForKey:@"phone_number"];
        self.gold = [aDecoder decodeObjectForKey:@"gold"];
        self.area_number = [aDecoder decodeObjectForKey:@"area_number"];
        self.kf_url = [aDecoder decodeObjectForKey:@"kf_url"];
        self.diamond = [aDecoder decodeObjectForKey:@"diamond"];
        self.balance = [aDecoder decodeObjectForKey:@"balance"];
        self.vip_expired = [aDecoder decodeObjectForKey:@"vip_expired"];
        self.vip = [aDecoder decodeObjectForKey:@"vip"];
        self.long_vedio_times = [aDecoder decodeObjectForKey:@"long_vedio_times"];
        self.short_vedio_times = [aDecoder decodeObjectForKey:@"short_vedio_times"];
        self.attention = [aDecoder decodeObjectForKey:@"attention"];
        self.fans = [aDecoder decodeObjectForKey:@"fans"];
        self.upload_times = [aDecoder decodeObjectForKey:@"upload_times"];
        self.last_ip = [aDecoder decodeObjectForKey:@"last_ip"];
        self.expires_at = [aDecoder decodeObjectForKey:@"expires_at"];
    }
    return self;
}

@end

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.msg     forKey:@"msg"];
    [aCoder encodeObject:self.state     forKey:@"state"];
    [aCoder encodeObject:self.searchKeyArrs     forKey:@"searchKeyArrs"];
    [aCoder encodeObject:self.data     forKey:@"data"];
    
    [aCoder encodeBool:self.isLogin forKey:@"isLogin"];
    [aCoder encodeObject:self.paySource     forKey:@"paySource"];
    [aCoder encodeObject:self.tagArrs     forKey:@"tagArrs"];
    [aCoder encodeObject:self.currentDay     forKey:@"currentDay"];
    [aCoder encodeObject:self.recordedDate     forKey:@"recordedDate"];
    [aCoder encodeObject:self.purseArr     forKey:@"purseArr"];
    
    [aCoder encodeObject:self.phoneNumber     forKey:@"phoneNumber"];
    [aCoder encodeObject:self.cookie forKey:@"cookie"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.deviceid forKey:@"deviceid"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super init]) {
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        
        self.searchKeyArrs = [aDecoder     decodeObjectForKey:@"searchKeyArrs"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
        
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
        self.paySource = [aDecoder     decodeObjectForKey:@"paySource"];
        self.tagArrs = [aDecoder     decodeObjectForKey:@"tagArrs"];
        self.currentDay = [aDecoder     decodeObjectForKey:@"currentDay"];
        self.recordedDate = [aDecoder     decodeObjectForKey:@"recordedDate"];
        self.purseArr = [aDecoder     decodeObjectForKey:@"purseArr"];
        
        self.phoneNumber = [aDecoder     decodeObjectForKey:@"phoneNumber"];
        self.cookie = [aDecoder decodeObjectForKey:@"cookie"];
        self.type = [aDecoder     decodeIntegerForKey:@"type"];
        self.deviceid = [aDecoder decodeObjectForKey:@"deviceid"];
    }
    return self;
}

//-(id)copyWithZone:(NSZone*)zone{
//    UserInfoModel* copy = [[[self class]allocWithZone:zone]init];
//    copy.searchKeyArrs = self.searchKeyArrs;
//    return copy;
//}
- (void)setDefaultDataIsForceInit:(BOOL)isForceInit{
    if (isForceInit) {
        
        UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
        userInfoModel.isLogin = NO;
        userInfoModel.searchKeyArrs = @[];
        [UserInfoManager SetNSUserDefaults:userInfoModel];
        
    }else{
        if (![UserInfoManager GetNSUserDefaults].isLogin) {
            UserInfoModel *userInfoModel = [UserInfoSingleton sharedUserInfoContext].userInfo;
            userInfoModel.isLogin = true;
            userInfoModel.searchKeyArrs = @[];
            [UserInfoManager SetNSUserDefaults:userInfoModel];
        }
    }
}


- (UIImage*)getUserAvatorImg{
    NSString* title = [NSString stringWithFormat:@"mine_avator%li",(long)self.data.avatar];
    UIImage* img = [UIImage imageNamed:title];
    return img;
}

+ (NSArray*)getUserAvatorImgArrs{
    
    NSMutableArray* marr = [NSMutableArray array];
    for (int i=1; i< 44; i++) {
        NSString* title = [NSString stringWithFormat:@"mine_avator%li",(long)i];
        UIImage* img = [UIImage imageNamed:title];
        [marr addObject:@{@(i):img}];
    }
    
    return marr;
}

- (NSString*)getUserGender{
    NSString* title = @"不显示";
    
    switch (self.data.sex) {
        case 0:
            title = @"不显示";
            break;
        case 1:
            title = @"男";
            break;
        case 2:
            title = @"女";
            break;
        default:
            title = @"不显示";
            break;
    }
    return title;
}
@end


