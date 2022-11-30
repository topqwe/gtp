//
//  UITableView+ST_Noresult.m
//  TMGold
//
//  Created by stoneobs on 2017/12/25.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "UITableView+STNoresult.h"
#import <objc/runtime.h>
#import "STNoresultView.h"
static const char tableViewNoreslutViewkey = '\9';
#define copyReloadDataMethodName @"copyReloadDataMethodName"
@implementation UITableView (STNoresult)
+ (void)load{
    Method reloadDataMethod = class_getInstanceMethod([self class], @selector(reloadData));
    //获取reloadata 的实现
    IMP reloadDataIMP = method_getImplementation(reloadDataMethod);
    //增加方法copyReloadDataMethodName  实现reloadData
    class_addMethod([self class], NSSelectorFromString(copyReloadDataMethodName), reloadDataIMP, nil);
    //修改方法
    Method swizzingMethod = class_getInstanceMethod([self class], @selector(st_reloadData));
    //交换
    method_exchangeImplementations(reloadDataMethod, swizzingMethod);
    //增加一个noresultView 变量
    
}
- (STNoresultView*)st_noreslutView{
    return objc_getAssociatedObject(self,  &tableViewNoreslutViewkey);
}
- (void)setSt_noreslutView:(STNoresultView*)st_noreslutView{
    if ([self st_noreslutView] != st_noreslutView) {
        objc_setAssociatedObject(self,  &tableViewNoreslutViewkey, st_noreslutView, OBJC_ASSOCIATION_ASSIGN);
        st_noreslutView.hidden = YES;
        [self addSubview:st_noreslutView];
    }

}
- (void)st_reloadData{

    [self performSelector:NSSelectorFromString(copyReloadDataMethodName)];
    NSInteger allrows = 0;
    NSInteger section = [self numberOfSections];
    for (NSInteger i = 0; i < section; i ++) {
        allrows =   allrows +  [self numberOfRowsInSection:i];
    }
    [self st_noreslutView].hidden = @(allrows).boolValue;
    
}
@end
