//
//  UILabel+Extras.h
//  PhoneZhuan
//
//  Created by WIQ on 14-2-17.
//  Copyright (c) 2014年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extras)
- (void)autoHeightWithin:(float)maxHeight;
- (void)autoWidthWithin:(float)maxWidth;
- (void)setParagraphLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize isCharWrappingOrTruncatingTail:(BOOL)isCharWrapping;
@end
