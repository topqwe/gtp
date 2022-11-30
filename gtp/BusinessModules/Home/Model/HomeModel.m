//
//  HomeModel.m
//  PPOYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "HomeModel.h"

@implementation WItem : NSObject

@end

@implementation WData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"rankinglist" : @"WItem"
             
             };
}
@end

@implementation MinePayMethod

@end
@implementation HomeItem
+(NSDictionary *)objectClassInArray
{
    return @{
        @"types" : [MinePayMethod class],
        @"childs" : [HomeItem class],
        @"ad_list" : [HomeItem class],
//        @"small_video_list" : [HomeItem class],
//
//        @"rights_list" : [HomeItem class]
//
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
return @{
@"ID" : @"id",
};
}

- (UIImage*)getLevImg{
    
    UIImage* img = nil;
    if (self.restricted>0) {
        NSString* title = [NSString stringWithFormat:@"m_s%li",(long)self.restricted];
        img = [UIImage imageNamed:title];
    }
    
    return img;
}
- (NSString*)getLevLimitButTitle{
    
    NSString* str = @"";
    if (self.limit>0) {
        switch (self.limit) {
            case 1:
            {
                str = [NSString stringWithFormat:@"%@",@""];
//
            }
                break;
            case 2:
            {
                str = [NSString stringWithFormat:@"%@",@""];
            }
                break;
            default:
                str = @"";
                break;
        }
    }
    
    return str;
}
- (NSString*)getLevLimitTitle{
    
    NSString* str = @"";
    if (self.limit>0) {
        switch (self.limit) {
            case 1:
            {
                str = [NSString stringWithFormat:@"%@",@""];
                
            }
                break;
            case 2:
            {
                str = [NSString stringWithFormat:@"%@",@""];
            }
                break;
            default:
                str = @"";
                break;
        }
    }
    
    return str;
}
- (NSString*)getNLevLimitTitle{
    
    NSString* str = @"";
    if (self.limit>0) {
        switch (self.limit) {
            case 1:
            {
                str = [NSString stringWithFormat:@"%@",@"优秀"];
                
            }
                break;
            case 2:
            {
                str = [NSString stringWithFormat:@"%@",@"优先"];
            }
                break;
            default:
                str = @"";
                break;
        }
    }
    
    return str;
}
@end

@implementation HomeList
+(NSDictionary *)objectClassInArray
{
    return @{
        
        @"ad_list" : [HomeItem class],
        @"small_video_list" : [HomeItem class],
        
        @"rights_list" : [HomeItem class]
        
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
return @{
@"ID" : @"id",
};
    
}
@end
@implementation MemberItem
- (NSDictionary*)getUserLevel{
    NSDictionary* title = @{};
    title = @{@"" : @"哦"};
    
    return title;
}
@end

@implementation MinePayMsg

@end

@implementation HomeData

+(NSDictionary *)objectClassInArray
{
    return @{
        @"bbs_list" : [DynamicsModel class],
         @"list" : [HomeList class]
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
return @{
@"ID" : @"id",
};
    
}

@end


@implementation ConfigItem : NSObject
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
return @{
@"ID" : @"id",
};
    
}
@end

@implementation ConfigModel : NSObject
- (NSString*)getKFUrl{
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
NSMutableString *url = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.kf_url]];
    
//    if (userInfoModel.data.account.length>0) {
[url appendString:[NSString stringWithFormat:@"?a=%@",userInfoModel.data.account]];
//    }
    [url appendString:[NSString stringWithFormat:@"&b=%@",userInfoModel.data.nickname]];
    return userInfoModel.data.kf_url.length>0?userInfoModel.data.kf_url:[url copy];
}

+(NSDictionary *)objectClassInArray{
    return @{
             @"open_screen_ads" : [ConfigItem class],
             @"activity_ads" : [ConfigItem class],
             };
}
@end

@implementation CategoryModel : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [HomeItem class]
             };
}
@end

@implementation BannerModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [HomeItem class]
             };
}
@end

@implementation HomeModel

@end
