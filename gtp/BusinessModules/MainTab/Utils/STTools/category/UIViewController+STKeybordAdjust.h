//
//  UIViewController+STKeybordAdjust.h
//  HarborCity
//
//  Created by Mac on 2018/5/22.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STKeybordAdjustViewModel;
/************controller键盘的适配 ******************/
@interface UIViewController (STKeybordAdjust)
- (void)st_autoAdjustAllResponder;
- (void)st_removeNotifacation;/**< 移除接受键盘的通知，ios < 9.0 需要在dealloc 中实现这个方法,否则 你不需要做任何操作 */

//增加一个view (在键盘弹出时候)额外设置 偏移量
- (void)st_addAdjustView:(UIView*)view offset:(CGFloat)offset;
- (void)st_addAdjustViewModel:(STKeybordAdjustViewModel *)model;
//移除之前的设置
- (void)st_removeAdjustView:(UIView*)view;
@end

@interface STKeybordAdjustViewModel: NSObject
@property(nonatomic, strong) UIView                     *responedView;/**< 响应的view */
@property(nonatomic, assign) CGFloat                    offset;/**< 上下偏移量 可为负值 */
@end
