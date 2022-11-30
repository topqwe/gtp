//
//  UITextField+STInputLimit.h
//  TMGold
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 tangmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (STInputLimit)
//限制输入几位
- (void)st_textInputLimitWithLength:(NSInteger)length;
//限制小数点几位
- (void)st_textInputLimitPointLength:(NSInteger)length;
@end
