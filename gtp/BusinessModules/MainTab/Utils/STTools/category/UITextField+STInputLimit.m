//
//  UITextField+STInputLimit.m
//  TMGold
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 tangmu. All rights reserved.
//
#import <objc/runtime.h>
#import "UITextField+STInputLimit.h"
static const char textFiledPointLimitLengthKey = '\1000001';
@implementation UITextField (STInputLimit)
- (void)st_textInputLimitWithLength:(NSInteger)length{
    
    NSString *toBeString = self.text;
    CGFloat MAX_STARWORDS_LENGTH = length;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                self.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
- (void)st_textInputLimitPointLength:(NSInteger)length{
    self.keyboardType = UIKeyboardTypeNumberPad;
    objc_setAssociatedObject(self,  &textFiledPointLimitLengthKey, @(length), OBJC_ASSOCIATION_RETAIN);
    [self addNotifacations];
}
#pragma mark --Notifacation
- (void)addNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(st_textFiledDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}
- (void)st_textFiledDidChangeValue:(NSNotification*)notify{
    if (notify.object == self) {
        NSNumber * number =  objc_getAssociatedObject(self, &textFiledPointLimitLengthKey);
        NSString * text = self.text;
        if ([text containsString:@"."]) {
            NSArray * array = [text componentsSeparatedByString:@"."];
            NSString * lastString = array.lastObject;
            if (lastString.length > number.integerValue) {
                NSString * ingoreString = [lastString substringToIndex:number.integerValue];
                self.text = [NSString stringWithFormat:@"%@.%@",array.firstObject,ingoreString];
            }
        }
    }
}
@end

