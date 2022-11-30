//
//  ApiConfig.m

#ifndef ApiConfig_h
#define ApiConfig_h


#define URL_IP @"http://app.u17.com/v3/appV3_3/ios/phone/"
#define LNURL_IP @"http://app.u17.com/v3/appV3_3/ios/phone/"

#define API_GetCookie @""

#endif /* ApiConfig_h */

typedef NS_ENUM(NSInteger, ApiType)
{
    ApiType12,
    
    ApiType4,
    
    ApiType1002,
    ApiType1003,
    ApiType1005,
    
    ApiType3,
};
@interface ApiConfig : NSObject

+ (NSString *)getAppApi:(ApiType)type;

@end
