//
//  STLabel.h
//  lover
//
//  Created by stoneobs on 16/5/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  可以居上的lable

#import <UIKit/UIKit.h>
typedef enum
{
    STLabelAlignmentTop = 0, // default
    STLabelAlignmentMiddle,
    STLabelAlignmentBottom,
} STLabelAlignment;
@interface STLabel : UILabel
@property (nonatomic) STLabelAlignment verticalAlignment;

- (instancetype)initWithFrame:(CGRect)frame
                        text:(NSString*)text
                   textColor:(UIColor*)textColor
                        font:(CGFloat)font
                 isSizetoFit:(BOOL)isSizetoFit
               textAlignment:(NSTextAlignment)textAlignment;
- (void)st_loadH5String:(NSString*)h5String;/**< 加载h5字符串 */

- (void)st_autoadjustTextWitdh;/**< 自动适配 宽度 */

- (void)st_autoadjustTextHeight;/**< 自动适配 高度 */

@end
