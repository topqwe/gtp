//
//  NSArray+STArrayTool.h
//  togetherPlay
//
//  Created by Mac on 2018/12/27.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/************数组工具类******************/
@interface NSArray (STArrayTool)
//内部模型的某个数组,可嵌套使用 obj 作为开头，eg:array是一个用户数组，st_arrayFromObjName:@"obj.uid"  将返回一个 只包含uid 的数组
- (NSArray*)st_arrayFromObjKeyName:(NSString*)KeyName;
//返回内部模型值==objValue 的新模型数组，eg:array是一个用户数组，st_arrayFromObjName:@"obj.sex"  objValue = @"1" 将返回一个 只包含uid  =  objValue 的 obj数组
- (NSArray*)st_arrayFromObjKeyName:(NSString*)KeyName objValue:(id)objValue;
//解散数组 如果数组嵌套数组，全部解散 将模型 放到一个数组里面
- (NSArray*)st_dissolveArray;
//升序
- (NSArray*)st_ascendingArrayFromObjKeyName:(NSString*)KeyName;
//降序
- (NSArray*)st_descendingArrayFromObjKeyName:(NSString*)KeyName;

+ (NSArray *)st_safeArrayWithValue:(id)value;
@end
