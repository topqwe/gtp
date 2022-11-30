//
//  STPasswordTextField.h
//  LangBa
//
//  Created by Mac on 2017/12/23.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************仿微信密码支付******************/
@interface STPasswordTextField : UITextField
@property(nonatomic, assign, readonly) NSInteger                     passwordLength;
@property(nonatomic, copy) void(^textFieldDidInputMaxLength)(NSString * password) ;
- (instancetype)initWithFrame:(CGRect)frame passwordLength:(NSInteger)passwordLength;
@end
