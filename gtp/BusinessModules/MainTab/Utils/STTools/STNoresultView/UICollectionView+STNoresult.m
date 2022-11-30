//
//  UICollectionView+STNoresult.m
//  TMGold
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 tangmu. All rights reserved.
//

#import "UICollectionView+STNoresult.h"
#import <objc/runtime.h>
#import "STNoresultView.h"
static const char collectionViewnoReslutView = '\2';
#define copyReloadDataMethodName @"copyReloadDataMethodName"
@implementation UICollectionView (STNoresult)
+ (void)load{
    Method reloadDataMethod = class_getInstanceMethod([self class], @selector(reloadData));
    //获取reloadata 的实现
    IMP reloadDataIMP = method_getImplementation(reloadDataMethod);
    //增加方法copyReloadDataMethodName  实现reloadDatade
    class_addMethod([self class], NSSelectorFromString(copyReloadDataMethodName), reloadDataIMP, nil);
    //修改方法
    Method swizzingMethod = class_getInstanceMethod([self class], @selector(st_reloadData));
    //交换
    method_exchangeImplementations(reloadDataMethod, swizzingMethod);
    //增加一个noresultView 变量
    
}
- (STNoresultView*)st_noreslutView{
    return objc_getAssociatedObject(self,  &collectionViewnoReslutView);
}
- (void)setSt_noreslutView:(STNoresultView*)st_noreslutView{
    objc_setAssociatedObject(self,  &collectionViewnoReslutView, st_noreslutView, OBJC_ASSOCIATION_ASSIGN);
    st_noreslutView.hidden = YES;
    [self addSubview:st_noreslutView];
}
- (void)st_reloadData{
    [self performSelector:NSSelectorFromString(copyReloadDataMethodName)];
    NSInteger allrows = 0;
    NSInteger section = [self numberOfSections];
    for (NSInteger i = 0; i < section; i ++) {
        allrows =   allrows +  [self numberOfItemsInSection:i];
    }
    [self st_noreslutView].hidden = @(allrows).boolValue;
}
@end
