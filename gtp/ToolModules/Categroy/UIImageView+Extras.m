//
//  UIImageView+Extr.m
//  TagUtilViews
//
//  Created by WIQ on 16/10/14.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "UIImageView+Extras.h"

@implementation UIImageView (Extras)
- (void)drawCircle{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.width]addClip];
    [self drawRect:self.bounds];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
- (void)bezierCircle{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
