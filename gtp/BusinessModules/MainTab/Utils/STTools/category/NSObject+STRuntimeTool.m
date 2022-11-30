//
//  NSObject+STRuntimeTool.m
//  STNewTools
//
//  Created by stoneobs on 17/1/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "NSObject+STRuntimeTool.h"
#import <objc/runtime.h>
@implementation NSObject (STRuntimeTool)
- (void)st_showAllProperties
{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    NSString *key = nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        NSString *   key2 = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        NSLog(@"\n变量名字 :%@     变量类型： %@", key,key2);
    }
    free(vars);
}
- (void)st_showAllFunctions
{
    unsigned int numIvars; //方法个数
    Method *meth = class_copyMethodList([self class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Method thisIvar = meth[i];
        SEL sel = method_getName(thisIvar);
        const char *name = sel_getName(sel);
        NSLog(@"\n函数名字 :%s", name);
    }
    free(meth);
}
@end
