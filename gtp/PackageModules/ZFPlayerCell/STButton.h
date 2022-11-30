//
//  STButton.h
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  

#import <UIKit/UIKit.h>
@class STButton;
@interface STButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString*)title
                   titleColor:(UIColor*)titlecolor
                    titleFont:(CGFloat)fongtsize
                 cornerRadius:(CGFloat)radiu
              backgroundColor:(UIColor*)color
              backgroundImage:(UIImage*)image
                        image:(UIImage*)image;

- (void)showRoundShadow;//在 button被addsubview 后使用有效
- (void)hideRoundShadowLayer;//隐藏shadow
@end
