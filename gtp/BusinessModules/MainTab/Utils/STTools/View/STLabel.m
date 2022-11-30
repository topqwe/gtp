//
//  STLabel.m
//  lover
//
//  Created by stoneobs on 16/5/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STLabel.h"

@interface STLabel()
{
@private
    STLabelAlignment _verticalAlignment;
}
@end
@implementation STLabel
@synthesize verticalAlignment = verticalAlignment_;
-(instancetype)initWithFrame:(CGRect)frame
                        text:(NSString *)text
                   textColor:(UIColor *)textColor
                        font:(CGFloat)font
                 isSizetoFit:(BOOL)isSizetoFit
               textAlignment:(NSTextAlignment)textAlignment
{
    if (self == [super initWithFrame:frame]) {
        self.text = text;
        self.textColor = textColor;
        self.font = [UIFont systemFontOfSize:font];
        if (isSizetoFit) {
            [self sizeToFit];
        }
        self.verticalAlignment = STLabelAlignmentMiddle;
        self.numberOfLines = 0;
        self.textAlignment = textAlignment;
    }
    return self;
}
- (void)setText:(NSString *)text{
    text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    [super setText:text];
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = STLabelAlignmentMiddle;
    }
    return self;
}
- (void)setVerticalAlignment:(STLabelAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case STLabelAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case STLabelAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case STLabelAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
#pragma mark --Public Method
- (void)st_loadH5String:(NSString *)h5String{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[h5String dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.attributedText = attrStr;
}
- (void)st_autoadjustTextWitdh{
    NSString * str = self.text ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]} context:nil];
    self.width =  rect.size.width;
}
- (void)st_autoadjustTextHeight{
    NSString * str = self.text ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]} context:nil];
    self.height =  rect.size.height;
}
@end
