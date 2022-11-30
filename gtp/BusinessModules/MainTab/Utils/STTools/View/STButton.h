//
//  STButton.h
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  

#import <UIKit/UIKit.h>
@class STButton;
typedef void (^STButtonTouchAction)(UIButton* sender);
@interface STButton : UIButton
@property(nonatomic,copy)STButtonTouchAction    clicAction;
@property(nonatomic,copy)STButtonTouchAction    closeAction;//只有在 showCloseButton yes有用
@property(nonatomic,assign)BOOL                 showCloseButton;//是否展示删除按钮，默认为no
@property(nonatomic,strong)NSString             *badgeValue;//右上角图标数字
@property(nonatomic, strong) UIButton                     *closeButton;/**<  */
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString*)title
                   titleColor:(UIColor*)titlecolor
                    titleFont:(CGFloat)fongtsize
                 cornerRadius:(CGFloat)radiu
              backgroundColor:(UIColor*)color
              backgroundImage:(UIImage*)image
                        image:(UIImage*)image;
//点击回调
- (void)setClicAction:(STButtonTouchAction)clicAction;
//点击关闭按钮回调
- (void)setCloseAction:(STButtonTouchAction)closeAction;
//让imageview 变为右边，和title的间隔是insetx
- (void)letImageViewAsright:(CGFloat)insetX;
- (void)makeImageRight;//图片变为右边
- (void)showRoundShadow;//在 button被addsubview 后使用有效
- (void)hideRoundShadowLayer;//隐藏shadow
@end
