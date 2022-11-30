//
//  NSString+YBFontSize.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/20.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YBFontSize)

- (CGSize)yb_sizeForFont:(UIFont *)font size:(CGSize)size;
- (CGSize)yb_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)yb_heightForFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGFloat)yb_widthForFont:(UIFont *)font maxHeight:(CGFloat)maxHeight;

@end

NS_ASSUME_NONNULL_END
