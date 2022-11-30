

//
//  NSDictionary+Extras.m
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//

#import "NSDictionary+Extras.h"

@implementation NSDictionary (Extras)
/** 将二进制数据转换成字典*/

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData

{

    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {

        return nil;

    }

    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObj isKindOfClass:[NSDictionary class]]) {

        return nil;

    }

    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];

}
/*!

* @brief 把格式化的JSON格式的字符串转换成字典

* @param jsonString JSON格式的字符串

* @return 返回字典

*/

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
   if (jsonString == nil) {
       return nil;
   }

   NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
   NSError *err;
   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
   if(err)
   {
       NSLog(@"json解析失败：%@",err);
       return nil;
   }
   return dic;
}


//字典转json格式字符串：

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

//NSJSONWritingPrettyPrinted  是有换位符的。
//
//如果NSJSONWritingPrettyPrinted 是nil 的话 返回的数据是没有 换位符的
//
//
//链接：https://www.jianshu.com/p/6cca93f195b0

- (BOOL)hasObjectForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return NO;
    }
    return YES;
}

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return @"";
    } else if ([NSObject isNSStringClass:object]) {
        return object;
    } else if ([NSObject isNSNumberClass:object]) {
        return [object stringValue];
    }
    return @"";
}
- (NSNumber *)numberForKey:(id)key{
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return [NSNumber numberWithInt:0];
    } else if ([NSObject isNSStringClass:object]) {
        return [NSNumber numberWithLongLong:[object longLongValue]];
    } else if ([NSObject isNSNumberClass:object]) {
        return object;
    }
    return [NSNumber numberWithInt:0];
}

- (int)intForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if ([NSObject isNSStringClass:object]) {
        return [object intValue];
    } else if ([NSObject isNSNumberClass:object]) {
        return [object intValue];
    }
    return 0;
}

- (float)floatForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object floatValue];
        } else {
            return 0;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object floatValue];
    }
    return 0;
}

- (long)longForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object longValue];
        } else {
            return 0;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object longValue];
    }
    return 0;
}

- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return NO;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object boolValue];
        } else {
            return NO;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object boolValue];
    }
    return NO;
}

- (NSArray *)arrayForKey:(id)key {
    id object = [self objectForKey:key];
    if ([NSObject isNSArrayClass:object]) {
        return object;
    }
    return [NSArray array];
}

- (BOOL)avaliableForKey:(id)key {
    if ([[self allKeys] containsObject:key]) {
        if ([self hasObjectForKey:key]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSDictionary *)replacedKeyName:(NSString *)orginName replaceKey:(NSString*)replaceKey
{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if ([self allKeys].count > 0) {
        for (int i = 0; i < [self allKeys].count; i++) {
            if ([orginName isEqualToString:[[self allKeys] objectAtIndex:i]]) {
                NSString *tempValue = [self objectForKey:orginName];
                [data setObject:tempValue forKey:replaceKey];
            }else{
                
                NSString *tempKey =[[self allKeys] objectAtIndex:i];
                NSString *tempValue = [self objectForKey:tempKey];
                [data setObject:tempValue forKey:tempKey];
            }
        }
    }
    return data;
}
@end
