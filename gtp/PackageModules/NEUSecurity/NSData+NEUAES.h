//
//  NSData+AES.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (NEUAES)

- (NSData *)AES128EncryptWithKey:(NSString *)key withStr:(NSString*)str gIv:(NSString *)Iv;   //加密
- (NSData *)AES128EncryptWithKey:(NSString *)key  gIv:(NSString *)Iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;   //解密

@end
