//
//  NSString+YBFontSize.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/20.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "NSString+YBFontSize.h"

@implementation NSString (YBFontSize)

- (CGSize)yb_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGSize)yb_sizeForFont:(UIFont *)font size:(CGSize)size {
    return [self yb_sizeForFont:font size:size mode:NSLineBreakByWordWrapping];
}

- (CGFloat)yb_heightForFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [self yb_sizeForFont:font size:CGSizeMake(maxWidth, CGFLOAT_MAX)].height;
}

- (CGFloat)yb_widthForFont:(UIFont *)font maxHeight:(CGFloat)maxHeight {
    return [self yb_sizeForFont:font size:CGSizeMake(CGFLOAT_MAX, maxHeight)].width;
}

@end
