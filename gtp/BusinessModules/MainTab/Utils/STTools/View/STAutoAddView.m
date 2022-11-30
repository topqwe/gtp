//
//  STAutoAddView.m
//  GodHorses
//
//  Created by Mac on 2017/11/18.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STAutoAddView.h"
@interface STAutoAddView()<UITextFieldDelegate>

@end
@implementation STAutoAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    
    CGFloat witdh = self.frame.size.width / 3;
    CGFloat height = self.frame.size.height;
    
    self.reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, witdh, height)];
    self.reduceButton.backgroundColor = TM_backgroundColor;
    [self.reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [self.reduceButton setTitleColor:TM_secendTextColor forState:UIControlStateNormal];
    self.reduceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.reduceButton addTarget:self action:@selector(onSelectedReduceButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceButton];
    
    self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(witdh, 0, witdh, height)];
    self.textFiled.text = @"1";
    self.textFiled.textAlignment = NSTextAlignmentCenter;
    self.textFiled.textColor = TM_secendTextColor;
    self.textFiled.font = [UIFont systemFontOfSize:13];
    self.textFiled.backgroundColor = [UIColor whiteColor];
    self.textFiled.textAlignment = NSTextAlignmentCenter;
    self.textFiled.userInteractionEnabled = NO;
    self.textFiled.delegate = self;
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.textFiled];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(witdh * 2, 0, witdh, height)];
    self.addButton.backgroundColor = TM_backgroundColor;
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.addButton setTitleColor:TM_secendTextColor forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(onSelectedAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
}
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL willChange = YES;
    if (self.autoaddViewWillChangeHandle) {
        willChange = self.autoaddViewWillChangeHandle(self,self.textFiled.text);
    }
    return willChange;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!string.length) {
        return YES;
    }
    BOOL willChange = YES;
    if (self.autoaddViewWillChangeHandle) {
        NSMutableString * beforSting = self.textFiled.text.mutableCopy;
        [beforSting insertString:string atIndex:range.location];
        willChange = self.autoaddViewWillChangeHandle(self,beforSting);
    }
    return willChange;
}
#pragma mark --Action Method
- (void)onSelectedReduceButton{
    if ([self.textFiled.text isEqualToString:@"1"]) {
        return;
    }else{
 
        NSString * text;
        NSInteger num = [self.textFiled.text integerValue];
        num = num - 1;
        text =  @(num).description;
        BOOL willChange = YES;
        if (self.autoaddViewWillChangeHandle) {
          willChange = self.autoaddViewWillChangeHandle(self,text);
        }
        if (willChange) {
            self.textFiled.text = text;
            if (self.autoaddViewDidChangeHandle) {
               self.autoaddViewDidChangeHandle(self,self.textFiled.text);
            }
        }
    }

}
- (void)onSelectedAddButton{
    
    if ([self.textFiled.text isEqualToString:@"1"]) {
        return;
    }else{
        
        NSString * text;
        NSInteger num = [self.textFiled.text integerValue];
        num = num + 1;
        text =  @(num).description;
        self.textFiled.text = text;
        if (self.autoaddViewDidChangeHandle) {
            if (self.autoaddViewDidChangeHandle) {
                self.autoaddViewDidChangeHandle(self,self.textFiled.text);
            }
        }
    }
}
@end

