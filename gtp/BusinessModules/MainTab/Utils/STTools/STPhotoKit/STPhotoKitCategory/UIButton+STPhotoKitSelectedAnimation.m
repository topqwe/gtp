//
//  UIButton+SelectedAnimation.m
//  STNewTools
//
//  Created by stoneobs on 17/3/1.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "UIButton+STPhotoKitSelectedAnimation.h"

@implementation UIButton (STPhotoKitSelectedAnimation)
- (void)showSlectedAnimation
{
    if (self.selected) {
        [UIView animateWithDuration:0.1 animations:^{
            //self.frame = CGRectMake(frame.origin.x-frame.size.width*0.1, frame.origin.y-frame.size.height*0.1, frame.size.width*1.2, frame.size.height*1.2);
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}
@end
