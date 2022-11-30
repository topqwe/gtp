//
//  NSDictionary+Extras.h
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extras)
/** 将二进制数据转换成字典*/

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData;
/*!

* @brief 把格式化的JSON格式的字符串转换成字典

* @param jsonString JSON格式的字符串

* @return 返回字典

*/

//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//字典转json格式字符串：

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

//NSJSONWritingPrettyPrinted  是有换位符的。
//
//如果NSJSONWritingPrettyPrinted 是nil 的话 返回的数据是没有 换位符的
//
//
//链接：https://www.jianshu.com/p/6cca93f195b0

/**
 
 下列方法可以安全取得相应的值,避免类型不匹配或空对象导致的各种Crash现象
 
 */

- (BOOL)hasObjectForKey:(id)key;

// 取得字符串值
- (NSString *)stringForKey:(id)key;

// 取得Number值
- (NSNumber *)numberForKey:(id)key;

// 取得int值
- (int)intForKey:(id)key;

// 取得float值
- (float)floatForKey:(id)key;

// 取得long值
- (long)longForKey:(id)key;

// 取得bool值
- (BOOL)boolForKey:(id)key;

// 取得array数组
- (NSArray *)arrayForKey:(id)key;

- (BOOL)avaliableForKey:(id)key;
/**
 *  替换字典的key名称
 *
 *  @param orginName  原来的名称
 *
 *  @param replaceKey 替换的名称
 *
 *  @return 替换后的结果
 */
-(NSDictionary *)replacedKeyName:(NSString *)orginName replaceKey:(NSString*)replaceKey;
@end
