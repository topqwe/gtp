//
//  NSDictionary+STProperty.m
//  WorthWhile
//
//  Created by Mac on 2018/9/15.
//  Copyright © 2018年 stoneobs.icloud.com. All rights reserved.
//

#import "NSDictionary+STProperty.h"
//只到 二级 模型中的模型 中的数组模型 不会解析
@implementation NSDictionary (STProperty)
- (void)st_showProperty{
    
    NSMutableArray * logsArray = NSMutableArray.new;
    NSArray * keys = self.allKeys;
    
    NSString * mainClassName = @"mainExample";//子模型类名
    NSString * faterClassName = @"objExample";//子模型类名
    //字典中 包含 字典
    NSMutableArray * secendObjArray = NSMutableArray.new;
    //字典中 包含 数组
    NSMutableArray * arryObjArray = NSMutableArray.new;
    NSString * beigin =  @" ------字典转换成oc模型.h属性开始--------------";
    [logsArray addObject:beigin];
    NSString * interfaceName = [NSString stringWithFormat:@"@interface %@ : NSObject",mainClassName];
    
    NSString * miaoshu =  @"/******************************/";
    [logsArray addObject:miaoshu];
    
    [logsArray addObject:interfaceName];
    for (NSString * key in keys) {
        id object = self[key];
        if ([object isKindOfClass:self.class]) {
            [secendObjArray addObject:key];
        }else if ([object isKindOfClass:NSArray.class]) {
            [arryObjArray addObject:key];
        }else{
            //打印  全部解析成字符串
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSString                     *%@;/**<  */",key];
           [logsArray addObject:alert];
            
        }
    }
    //打印 字典字段
    for (NSString * key in secendObjArray) {
        //打印  全部解析成字符串
        NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) %@                     *%@;/**<  */",key,key];
        [logsArray addObject:alert];
    }
    //打印 数组
    for (NSString * key in arryObjArray) {
        //打印  全部解析成字符串
        NSArray * array = self[key];
        if ([array.firstObject isKindOfClass:NSDictionary.class]) {
            //子模型
            
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSArray<%@*>                     *%@;/**<  */",faterClassName,key];
            [logsArray addObject:alert];
        }
        if ([array.firstObject isKindOfClass:NSString.class]) {
            //里面存放字符串
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSArray<NSString*>                     *%@;/**<  */",key];
            [logsArray addObject:alert];
        }
        if ([array.firstObject isKindOfClass:NSNumber.class]) {
            //里面存放 number
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSArray<NSNumber*>                     *%@;/**<  */",key];
            [logsArray addObject:alert];
        }

    }
    NSString * end = @"@end";
    [logsArray addObject:end];
    
    //前缀 @class
    NSMutableArray *aiteClass = NSMutableArray.new;
    
    //打印二级模型
    for (NSString * key in secendObjArray) {
        NSDictionary * dic = self[key];
        [self st_log_level_modelWithKey:key dic:dic logsArray:logsArray];
        [aiteClass addObject:key];
    }
    //打印数组模型
    for (NSString * key in arryObjArray) {
        NSArray * array = self[key];
        NSDictionary  * dic = array.firstObject;
        if (![aiteClass containsObject:faterClassName]) {
            [aiteClass addObject:faterClassName];
        }
        
        [self st_log_level_modelWithKey:faterClassName dic:dic logsArray:logsArray];
    }
    
    NSString * lastAtClass = [aiteClass componentsJoinedByString:@","];
    NSString * realAtClass = [NSString stringWithFormat:@"@class %@;",lastAtClass];
    [logsArray insertObject:realAtClass atIndex:2];
    
    //打印  @implementation
    
    NSString * realEnd =  @" ------字典转换成oc模型.h属性结束--------------";
    [logsArray addObject:realEnd];
    
    NSString * finsh = [logsArray componentsJoinedByString:@"\n"];
    NSLog(@"\n%@",finsh);
    
    
}
- (void)st_log_level_modelWithKey:(NSString*)faterkey dic:(NSDictionary*)dic logsArray:(NSMutableArray*)logsArray{
    //打印 一个 新 的模型
    NSString * interfaceName = [NSString stringWithFormat:@"@interface %@ : NSObject",faterkey];
    NSString * miaoshu =  @"/******************************/";
    [logsArray addObject:miaoshu];
    [logsArray addObject:interfaceName];
    for (NSString * key in dic.allKeys) {
        id object = self[key];
        if ([object isKindOfClass:NSDictionary.class]) {
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSDictionary                     *%@;/**<  */",key];
           [logsArray addObject:alert];
        }else if ([object isKindOfClass:NSArray.class]) {
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSArray                     *%@;/**<  */",key];
           [logsArray addObject:alert];
        }else{
            //打印  全部解析成字符串
            NSString * alert = [NSString stringWithFormat:@"@property(nonatomic, strong) NSString                     *%@;/**<  */",key];
            [logsArray addObject:alert];
            
        }
    }
    NSString * end = @"@end";
    [logsArray addObject:end];
}
@end
