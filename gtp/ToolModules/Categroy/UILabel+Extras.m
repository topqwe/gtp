//
//  UILabel+Extras.m
//  PhoneZhuan
//
//  Created by WIQ on 14-2-17.
//  Copyright (c) 2014年 shen. All rights reserved.
//

#import "UILabel+Extras.h"

@implementation UILabel (Extras)
- (void)autoHeightWithin:(float)maxHeight{//固定高度
    self.numberOfLines = 0;
    CGSize fitsize;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGRect rectSize =[self.text boundingRectWithSize:CGSizeMake(MAXFLOAT,maxHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    fitsize = CGSizeMake(rectSize.size.width, maxHeight);
    
    NSLog(@"%@",NSStringFromCGSize(fitsize));
    CGRect frame = self.frame;
    //fitsize.width = fitsize.width < self.frame.size.width?self.frame.size.width:fitsize.width;
    frame.size = fitsize;
    self.frame = frame;
    
}

- (void)autoWidthWithin:(float)maxWidth{//固定宽度
    self.numberOfLines = 0;
    CGSize fitsize;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGRect rectSize =[self.text boundingRectWithSize:CGSizeMake(maxWidth,MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    fitsize = CGSizeMake(maxWidth,rectSize.size.height);
    
    CGRect frame = self.frame;
    frame.size = fitsize;
    self.frame = frame;
}

- (void)setParagraphLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize isCharWrappingOrTruncatingTail:(BOOL)isCharWrapping{
    if (fontWithString.length>0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = lineSpacing;
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:fontOfSize],
                                      NSParagraphStyleAttributeName:paragraphStyle};
        if (!fontWithString) {
            fontWithString = @"";
        }
        self.attributedText = [[NSAttributedString alloc]initWithString:fontWithString attributes:attributes];
        self.lineBreakMode = isCharWrapping?NSLineBreakByCharWrapping:NSLineBreakByTruncatingTail;
        [self sizeToFit];
    }
    
}
@end
