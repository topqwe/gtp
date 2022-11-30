//
//  NSObject+Extras.h
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extras)
//判断类型是否匹配
+(BOOL)isNSStringClass:(id)object;
+(BOOL)isNSDictionaryClass:(id)object;
+(BOOL)isNSNumberClass:(id)object;
+(BOOL)isNSNullClass:(id)object;
+(BOOL)isNSArrayClass:(id)object;

- (NSString *)stringForValue:(id)value;
- (BOOL)boolForValue:(id)value;
- (float)floatForValue:(id)value;
- (int)intForValue:(id)value;
@end
