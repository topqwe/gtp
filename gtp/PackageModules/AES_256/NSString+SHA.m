//
//  NSString+SHA.m
//  OC-SHA
//
//  Created by 王亮 on 16/12/14.
//  Copyright © 2016年 com.reaal.Dichtbij. All rights reserved.
//

#import "NSString+SHA.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <iconv.h>
#import "GTMDefines.h"
#import "GTMBase64.h"
@implementation NSString (SHA)
#pragma mark - Bytes转字符串
/**
 字符大小写可以通过修改“%02X”中的x修改,下面采用的是大写
 */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02X", bytes[i]];
    }
    
    return [strM copy];
}
- (NSString *)hmacSHA256WithKey:(NSData *)key {
    NSData *hashData = [self dataUsingEncoding:NSUTF8StringEncoding];

    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    //const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(kCCHmacAlgSHA256, [key bytes], [key length], [hashData bytes], [hashData length], digest);

//    NSData* data = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *encode = [self stringFromBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    key = nil;
    return encode;
}

@end

