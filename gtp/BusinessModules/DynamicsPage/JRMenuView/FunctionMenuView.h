//
//  JRMenuView.h
//  JRMenu
//
//  Created by Andy on 15/12/31.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionMenuView : UIView

- (void)resetButton:(HomeItem*)model;
- (void)resetSelfFrame;
-(void)actionBlock:(ActionBlock)block;
- (instancetype)init;
- (void)setTargetView:(UIView *)target InView:(UIView *)superview;
- (void)setData:(HomeItem *)item;
- (void)show;
- (void)dismiss;
+ (void)dismissAllJRMenu;
@end
