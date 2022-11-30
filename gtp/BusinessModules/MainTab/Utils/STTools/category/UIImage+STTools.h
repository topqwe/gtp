//
//  UIImage+tools.h
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
@interface UIImage (STTools)
//通过颜色生成图片
+ (UIImage*)st_imageWithColor:(UIColor *)color
                      size:(CGSize)size;
//生成二维码
+ (UIImage*)st_imageWithTwoCode:(NSString*)str
                 andColorred:(CGFloat)red
                       green:(CGFloat)green
                        blue:(CGFloat)blue;
//默认黑白二维码
+ (UIImage*)st_imageWithDefaultTwoCode:(NSString*)str;
//圆角图片
+ (UIImage*)st_createRoundedRectImage:(UIImage*)image
                              size:(CGSize)size
                            radius:(NSInteger)r;
//view ->image
+ (UIImage *)st_snapshot:(UIView *)view;
//毛玻璃图片
- (UIImage *)st_imgWithBlur;
//新size图片
- (UIImage *)st_imageFormNewSize:(CGSize)newSize;
@end
