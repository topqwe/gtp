//
//  STPasswordTextField.m
//  LangBa
//
//  Created by Mac on 2017/12/23.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STPasswordTextField.h"
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
@interface  STPasswordTextField()
@property(nonatomic, strong) NSMutableArray                     *lablesArray;
@end
@implementation STPasswordTextField

- (instancetype)initWithFrame:(CGRect)frame passwordLength:(NSInteger)passwordLength{
    if (self == [super initWithFrame:frame]) {
        _passwordLength = passwordLength;
        [self configLine];
        [self configSubView];
        [self addNotifacations];
    }
    return self;
}
#pragma mark --Notifacation
- (void)addNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeNotifycation:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}
- (void)textFieldDidChangeNotifycation:(NSNotification*)notifycation{
    if (notifycation.object == self) {
        //设置最多字数
        NSString *toBeString = self.text;
        CGFloat MAX_STARWORDS_LENGTH = self.passwordLength;
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
        //配置label
        [self configLable];
        //是否已经输入最大字数
        if (self.text.length == self.passwordLength) {
            if (self.textFieldDidInputMaxLength) {
                self.textFieldDidInputMaxLength(self.text);
            }
        }
       
    }
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --subView
- (void)configSubView{
    self.textColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    self.keyboardType = UIKeyboardTypeNumberPad;
}
- (void)configLine{
    
    UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,0.5 )];
    topline.backgroundColor = STRGB(0xFFB4B4B4);
    [self addSubview:topline];
    
    UIView *bootomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width,0.5 )];
    bootomline.backgroundColor = STRGB(0xFFB4B4B4);
    [self addSubview:bootomline];
    
    for (int i = 0; i <= self.passwordLength; i ++ ) {
        CGFloat witdh = self.frame.size.width / self.passwordLength;
        CGFloat left = i * witdh;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(left, 0, 0.5,self.frame.size.height)];
        line.backgroundColor = STRGB(0xFFB4B4B4);
        [self addSubview:line];
    }
}
- (void)configLable{
    NSInteger currendLenth = self.text.length;
    self.lablesArray = [NSMutableArray new];
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]] && view.tag > 9999) {
            [view removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < currendLenth; i ++) {
        CGFloat witdh = self.frame.size.width / self.passwordLength;
        CGFloat left = i * witdh;

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, witdh, self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18];
        label.tag = i + 10000;
        if (self.secureTextEntry) {
            label.text = @"●";
        }else{
            label.text = [self.text substringWithRange:NSMakeRange(i, 1)];
        }
        [self.lablesArray addObject:label];
        [self addSubview:label];
    }
}
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    [super setSecureTextEntry:secureTextEntry];
    for (NSInteger i = 0; i < self.lablesArray.count; i ++) {
        UILabel * label = self.lablesArray[i];
        if (secureTextEntry) {
            label.text = @"●";
        }else{
            label.text = [self.text substringWithRange:NSMakeRange(i, 1)];
        }
    }

}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // 禁用粘贴功能
    if (action == @selector(paste:))
        return NO;
    // 禁用选择功能
    if (action == @selector(select:))
        return NO;
    // 禁用全选功能
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
