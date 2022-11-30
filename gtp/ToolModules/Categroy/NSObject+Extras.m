

//
//  NSObject+Extras.m
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//

#import "NSObject+Extras.h"

@implementation NSObject (Extras)
+(BOOL)isNSStringClass:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return YES;
    }
    else
        return NO;
}

+(BOOL)isNSDictionaryClass:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    else
        return NO;
}

+(BOOL)isNSNumberClass:(id)object
{
    if ([object isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    else
        return NO;
}

+(BOOL)isNSNullClass:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else
        return NO;
}

+(BOOL)isNSArrayClass:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        return YES;
    }
    else
        return NO;
}

- (BOOL)boolForValue:(id)value{
    if (value == nil || [NSObject isNSNullClass:value]) {
        return NO;
    } else if([NSObject isNSStringClass:value]) {
        if ([(NSString *)value match:@"\\d+"]) {
            return [value boolValue];
        } else {
            return NO;
        }
    } else if ([NSObject isNSNumberClass:value]) {
        return [value boolValue];
    }
    return NO;
}

- (float)floatForValue:(id)value {
    if (value == nil || [NSObject isNSNullClass:value]) {
        return 0;
    } else if([NSObject isNSStringClass:value]) {
        if ([(NSString *)value match:@"\\d+"]) {
            return [value floatValue];
        } else {
            return 0;
        }
    } else if ([NSObject isNSNumberClass:value]) {
        return [value floatValue];
    }
    return 0;
}

- (NSString *)stringForValue:(id)value {
    if (value == nil || [NSObject isNSNullClass:value]) {
        return @"";
    } else if ([NSObject isNSStringClass:value]) {
        return value;
    } else if ([NSObject isNSNumberClass:value]) {
        return [value stringValue];
    }
    return @"";
}

- (int)intForValue:(id)value {
    if (value == nil || [NSObject isNSNullClass:value]) {
        return 0;
    } else if ([NSObject isNSStringClass:value]) {
        return [value intValue];
    } else if ([NSObject isNSNumberClass:value]) {
        return [value intValue];
    }
    return 0;
}


@end
