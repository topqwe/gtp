//
//  UIButton+LXExpandBtn.h
//  LXExpandBtn
//
//  Created by 漫漫 on 2018/4/4.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>



#define  Font(f) [UIFont systemFontOfSize:(f)]

typedef void (^ButtonBlock)(UIButton *button);
@interface UIButton (LXExpandBtn)

@property(nonatomic,strong)NSString *buttonId;//标识
@property(nonatomic,copy)ButtonBlock block;//添加点击事件
@property (nonatomic,assign) UIEdgeInsets hitTestEdgeInsets;//点击区域，默认为（0，0，0，0）; 负的为扩大


//frame初始化
+(UIButton *)LXButtonWithTitle:(NSString *)title  titleFont:(UIFont *)titleLabelFont Image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleLabelColor frame:(CGRect)frame;
//约束初始化
+(UIButton *)LXButtonNoFrameWithTitle:(NSString *)title  titleFont:(UIFont *)titleLabelFont Image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleLabelColor;

//添加block
-(void)addClickBlock:(ButtonBlock)block;

@end
