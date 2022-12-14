//
//  NEUSecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SHA.h"
@interface NEUSecurityUtil : NSObject
//SHA256将string转成带密码的data
+(NSString*)neu_MixSHA256encryptAESData:(NSString*)string;
//SHA256将带密码的data转成string
+(NSDictionary*)neu_MixSHA256decryptAESData:(NSString *)string;
#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
//将string转成带密码的data
+ (NSString*)neu_encryptAESData:(NSString*)string;
//将带密码的data转成string
+ (NSString*)neu_decryptAESData:(NSString*)string;

@end
