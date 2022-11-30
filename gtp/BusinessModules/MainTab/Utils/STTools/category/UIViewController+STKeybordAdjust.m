//
//  UIViewController+STKeybordAdjust.m
//  HarborCity
//
//  Created by Mac on 2018/5/22.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "UIViewController+STKeybordAdjust.h"
#import <objc/runtime.h>
static const char stKeybordAdjustViewArrayKey = '\9';
@implementation UIViewController (STKeybordAdjust)
- (void)st_autoAdjustAllResponder{

    CGFloat bottom = self.view.frame.origin.y + self.view.frame.size.height;
    if (bottom != [UIScreen mainScreen].bounds.size.height) {
        NSLog(@"UIViewController-STKeybord AdjusttableView 底部不是屏幕底部 取消自动适配");
        return;
    }else{
        [self st_addNotifacations];
    }
}
- (void)st_removeNotifacation{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)st_addAdjustView:(UIView *)view offset:(CGFloat)offset{
    [self st_addNotifacations];
    [self st_removeAdjustView:view];
    STKeybordAdjustViewModel * model = STKeybordAdjustViewModel.new;
    model.responedView = view;
    model.offset = offset;
    [self st_addAdjustViewModel:model];
}
#pragma mark --public
- (void)st_addAdjustViewModel:(STKeybordAdjustViewModel *)model{
    NSMutableArray * stKeybordAdjustViewArray = objc_getAssociatedObject(self, &stKeybordAdjustViewArrayKey);
    if (!stKeybordAdjustViewArray) {
        stKeybordAdjustViewArray = NSMutableArray.new;
    }
    [stKeybordAdjustViewArray addObject:model];
    objc_setAssociatedObject(self, &stKeybordAdjustViewArrayKey, stKeybordAdjustViewArray, OBJC_ASSOCIATION_RETAIN);
}
- (void)st_removeAdjustView:(UIView *)view{
    NSMutableArray * stKeybordAdjustViewArray = objc_getAssociatedObject(self, &stKeybordAdjustViewArrayKey);
    NSMutableArray * bianliArray = stKeybordAdjustViewArray.mutableCopy;
    bool shouldRebetBing = NO;
    for (STKeybordAdjustViewModel * model in bianliArray) {
        if (model.responedView == view) {
            [stKeybordAdjustViewArray removeObject:model];
            shouldRebetBing = YES;
        }
    }
    if (shouldRebetBing) {
        objc_setAssociatedObject(self, &stKeybordAdjustViewArrayKey, stKeybordAdjustViewArray, OBJC_ASSOCIATION_RETAIN);
    }
   
}
- (STKeybordAdjustViewModel*)st_adjustModelFromView:(UIView*)view{
    NSMutableArray * stKeybordAdjustViewArray = objc_getAssociatedObject(self, &stKeybordAdjustViewArrayKey);
    NSMutableArray * bianliArray = stKeybordAdjustViewArray.mutableCopy;
    for (STKeybordAdjustViewModel * model in bianliArray) {
        if (model.responedView == view) {
            return model;
        }
    }
    return nil;
}
#pragma mark --Notifacation
- (void)st_addNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(st_keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(st_keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)st_keyboardWillChangeFrameNotification:(NSNotification*)notify{
    
    // 动画的持续时间
    NSDictionary *userInfo = notify.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIView * responderView = [self st_findResbonderWithView:self.view];
    //获取在window 上的位置
    CGRect windowRect = [responderView convertRect:responderView.bounds toView:responderView.window];
    CGFloat bootomWindowRect = windowRect.origin.y + windowRect.size.height;
    //键盘全部弹出的初始位置
    CGFloat maxKebordOrigin = [UIScreen mainScreen].bounds.size.height - keyboardF.size.height;
    CGFloat insetY = bootomWindowRect - maxKebordOrigin;
    
    STKeybordAdjustViewModel * model = [self st_adjustModelFromView:responderView];

    
    BOOL isTextView = ([responderView isKindOfClass:[UITextField class]] || [responderView isKindOfClass:[UITextView class]] );
    // insetY 大于0 证明键盘弹出会遮挡这个控件，目前仅仅适配 UITextFiled和UITextView
    if (insetY > 0 && isTextView) {
        [UIView animateWithDuration:duration animations:^{
            CGFloat offset = 0;
            if (model) {
                offset = model.offset;
            }
            CGRect frame = self.view.frame;
            frame.origin.y = frame.origin.y - insetY - offset;
            self.view.frame = frame;
            //self.bottom = self.bottom - insetY;
        }];
    }
    
    
    
    
}
//递归寻找当前第一响应者
- (UIView*)st_findResbonderWithView:(UIView*)fatherView{
    if (fatherView.isFirstResponder) {
        return fatherView;
    }
    for (UIView *view  in fatherView.subviews) {
        UIView * findView = [self st_findResbonderWithView:view];
        if (findView) {
            return findView;
        }
    }
    return nil;
}
- (void)st_keyboardWillHideNotification:(NSNotification*)notify{
    // 动画的持续时间
    NSDictionary *userInfo = notify.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘的frame
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = keyboardF.origin.y - frame.size.height;
        self.view.frame = frame;
    }];
    
}

@end

@implementation STKeybordAdjustViewModel

@end

