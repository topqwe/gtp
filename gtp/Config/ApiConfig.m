//rank/list/ug/usr/pbggc
//  ApiConfig.m

#import "ApiConfig.h"

@implementation ApiConfig
+ (NSString *)getAppApi:(ApiType)type{
    NSString *api = nil;
    switch (type)
    {
        case ApiType12: api = @"rank/ug/mifo/pbggc.do"; break;
        
        case ApiType4: api = @"rank/list/ug/usr/pbggc.do"; break;
        
        case ApiType1002: api = @"ug/pbers.do"; break;
        case ApiType1003: api = @"ug/pbebs.do"; break;
        case ApiType1005: api = @"ug/pbels.do"; break;
            
            
        case ApiType3: api = @""; break;
            
    }
    return api;
}
@end
