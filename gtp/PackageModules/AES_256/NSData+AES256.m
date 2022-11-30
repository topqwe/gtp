//
//  NSData+AES256.m
//  iOS_AES
//
//  Created by Ying on 2018/9/6.
//  Copyright © 2018 cong. All rights reserved.
//

#import "NSData+AES256.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES256)

- (NSData *)AES256EncryptWithIv:(NSString*)iv withKey:(NSString*)key
{
    return [self cryptOperation:kCCEncrypt WithIv:iv withKey:key];
}

- (NSData *)AES256DecryptWithIv:(NSString*)iv withKey:(NSString*)key
{
    return [self cryptOperation:kCCDecrypt WithIv:iv withKey:key];
}

- (NSData *) cryptOperation:(CCOperation)operation WithIv:(NSString*)iv withKey:(NSString*)key
{
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *ivData = [[NSData alloc] initWithBase64EncodedString:iv options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus status = CCCrypt(operation,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     [keyData bytes],
                                     kCCKeySizeAES256,
                                     //[iv UTF8String],
                                     [ivData bytes],
                                     [self bytes],
                                     dataLength,
                                     buffer,
                                     bufferSize,
                                     &numBytesDecrypted);
    if (status == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}


@end
