//
//  ZBActionSheet.h
//  ZuoBiao
//
//  Created by stoneobs on 2017/3/29.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STActionSheet;
@protocol STActionSheetDelegate <NSObject>

@optional

/**
 点击对应的按钮

 @param actionSheet actionSheet对象
 @param buttonIndex 按钮索引
 */
- (void)actionSheet:(STActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

//已经点击了背景图
- (void)actionSheetdidClickedBackGroundAction:(STActionSheet *)actionSheet;
@end
@interface STActionSheet : UIView
@property(nonatomic, strong) UIButton                     *cancleButton;
/**
 创建actionSheet对象的类方法

 @param title 标题
 @param buttonTitles 按钮标题
 @param cancelTitle 取消按钮标题
 @param delegate 代理
 @return actionSheet对象
 */
+ (instancetype)actionSheetWithTitle:(NSString *)title
                        buttonTitles:(NSArray *)buttonTitles
                         cancelTitle:(NSString *)cancelTitle
                            delegate:(id <STActionSheetDelegate>)delegate;

/**
 创建actionSheet对象的实例方法

 @param title 标题
 @param buttonTitles 按钮标题
 @param cancelTitle 取消按钮标题
 @param delegate 代理
 @return actionSheet对象
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                  cancelTitle:(NSString *)cancelTitle
                     delegate:(id <STActionSheetDelegate>)delegate;

/**
 设置标题颜色
 */
- (void)setTitleColor:(UIColor *)titleColor;

/**
 设置指定按钮字体颜色

 @param color 字体颜色
 @param index 按钮所在索引
 */
- (void)setButtonColor:(UIColor *)color index:(NSInteger)index;

/**
 显示Action Sheet
 */
- (void)show;

@end
