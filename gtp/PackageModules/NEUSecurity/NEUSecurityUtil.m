//
//  NEUSecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "NEUSecurityUtil.h"
#import "NEUBase64.h"
#import "NSData+NEUAES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <iconv.h>
#import "CusMD5.h"
#import "GTMBase64.h"
#import "AESCrypt.h"
#define Iv          @"P8GmSsx5wlFAKq7ilMqfZQ==" //偏移量,可自行修改
#define KEY         @"ig+5V8EuJAUwUNtFhAyw6UBvj7V+PC//+C8MGRrMWXs=" //key，可自行修改

@implementation NEUSecurityUtil

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [NEUBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
    
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [NEUBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [NEUBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [NEUBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)neu_encryptAESData:(NSString*)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:KEY gIv:Iv];
    //返回进行base64进行转码的加密字符串
    return [self encodeBase64Data:encryptedData];
}

//SHA256将string转成带密码的data
+(NSString*)neu_MixSHA256encryptAESData:(NSString*)string
{
    
    NSString *value = [AES256 encrypt:string WithIv:Iv withKey:KEY];
       
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:KEY options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *mac = [[Iv stringByAppendingString:value] hmacSHA256WithKey:keyData];
    NSDictionary *postDic = @{
        @"iv":Iv,
        @"value":[NSString stringWithFormat:@"%@",value],
        @"mac":[NSString stringWithFormat:@"%@",mac.lowercaseString]
    };
    NSString* inputStr = [NSString dictionaryToJson:postDic];
    
//    NSData *dataSS = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String =  [dataSS base64EncodedStringWithOptions:0];
    NSString* base64String = [GTMBase64 encodeBase64String:inputStr];
    return base64String;
}

#pragma mark - AES解密
//SHA256将带密码的data转成string
+(NSDictionary*)neu_MixSHA256decryptAESData:(NSString *)string
{
    NSString* codeStr =
    [NSString stringWithFormat:@"%@",string];
    
    NSString* decodeContentJson = [GTMBase64 decodeBase64String:codeStr];
    NSDictionary* decodeContentDic = [NSDictionary dictionaryWithJsonString:decodeContentJson];

    NSString*  newIv = [NSString stringWithFormat:@"%@",decodeContentDic[@"iv"]];
    NSString*  value = [NSString stringWithFormat:@"%@",decodeContentDic[@"value"]];
    
    
    NSString *str = [AES256 decrypt:value WithIv:newIv withKey:KEY];
    
//    NSString *convertHexStrToString
//    = [NSString stringFromHexString:str];
    NSDictionary* finalDic = @{};
//    if (convertHexStrToString != nil) {
        finalDic = [NSDictionary dictionaryWithJsonString:[NSString stringWithFormat:@"%@",str]];
//    }
    
    return finalDic;
}


//将带密码的data转成string
+(NSString*)neu_decryptAESData:(NSString *)string
{
    //base64解密
    NSData *decodeBase64Data=[NEUBase64 decodeString:string];
    //使用密码对data进行解密
    NSData *decryData = [decodeBase64Data AES128DecryptWithKey:KEY gIv:Iv];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

@end
