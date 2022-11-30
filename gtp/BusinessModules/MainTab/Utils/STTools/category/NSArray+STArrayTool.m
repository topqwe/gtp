//
//  NSArray+STArrayTool.m
//  togetherPlay
//
//  Created by Mac on 2018/12/27.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import "NSArray+STArrayTool.h"

@implementation NSArray (STArrayTool)
- (NSArray*)st_arrayFromObjKeyName:(NSString*)KeyName{
    if (![KeyName containsString:@"obj."]) {
        NSLog(@"检索格式不正确 需要obj.开头");
        return nil;
    }else{
        NSMutableArray * dealArray = NSMutableArray.new;
        NSArray * allArray = [KeyName componentsSeparatedByString:@"."];
        NSArray * menuArray = [allArray subarrayWithRange:NSMakeRange(1, allArray.count-1)];
        
        for (NSObject * object in self) {
            id value;
            for (NSString * objKey in menuArray) {
                value = [object valueForKey:objKey];
            }
            //如果存在 且 不是基本数据类型
            if (![value isKindOfClass:NSNumber.class]) {
                [dealArray addObject:value];
            }else{
                //如果存在 且 是基本数据类型
                NSString * dValue = [NSString stringWithFormat:@"%@",value];
                [dealArray addObject:dValue];
            }
            
            
        }
        return dealArray;
        
    }
    return nil;
}
- (NSArray*)st_arrayFromObjKeyName:(NSString*)KeyName objValue:(id)objValue{
    if (![KeyName containsString:@"obj."]) {
        NSLog(@"检索格式不正确 需要obj.开头");
        return nil;
    }else{
        NSMutableArray * dealArray = NSMutableArray.new;
        NSArray * allArray = [KeyName componentsSeparatedByString:@"."];
        NSArray * menuArray = [allArray subarrayWithRange:NSMakeRange(1, allArray.count-1)];
        
        for (NSObject * object in self) {
            id value;
            for (NSString * objKey in menuArray) {
                value = [object valueForKey:objKey];
      
                
            }
            //如果存在 且 不是基本数据类型
            if (![value isKindOfClass:NSNumber.class]) {
                if (value == objValue) {
                    [dealArray addObject:object];
                }else{
                    if ([value isEqualToString:objValue]) {
                        [dealArray addObject:object];                              
                    }
                }
            }else{
                //如果存在 且 是基本数据类型
                NSString * dValue = [NSString stringWithFormat:@"%@",value];
                NSString * equalValue = [NSString stringWithFormat:@"%@",objValue];
                if ([dValue isEqualToString:equalValue]) {
                    [dealArray addObject:object];
                }
            }



            
        }
        return dealArray;
        
    }
    return nil;
}
//解散数组 如果数组嵌套数组，全部解散 将模型 放到一个数组里面
- (NSArray*)st_dissolveArray{
    NSMutableArray *  dealArray = NSMutableArray.new;
    for (NSArray * array in self) {
        if ([array isKindOfClass:NSArray.class]) {
            //解散这个数组
            NSArray * digui = [self st_dissolveArrayWithArray:array];
            [dealArray addObjectsFromArray:digui];
        }else{
            [dealArray addObject:array];
        }
    }
    return dealArray;
}
- (NSArray*)st_dissolveArrayWithArray:(NSArray*)inputArray{
    NSMutableArray *  dealArray = NSMutableArray.new;
    for (NSArray * array in inputArray) {
        if ([array isKindOfClass:NSArray.class]) {
            //解散这个数组
            NSArray * digui = [self st_dissolveArrayWithArray:array];
            [dealArray addObject:digui];
        }else{
            [dealArray addObject:array];
        }
    }
    return dealArray;
}
+ (NSArray *)st_safeArrayWithValue:(id)value{
    NSArray * array = value;
    if ([array isKindOfClass:NSDictionary.class]) {
        NSDictionary * dic = (id)value;
        array = dic.allValues;
    }
    return array;
}
@end
