//
//  AES256.m
//  iOS_AES
//
//  Created by Ying on 2018/9/6.
//  Copyright © 2018 cong. All rights reserved.
//

#import "AES256.h"
#import "NSData+AES256.h"
#import "GTMBase64.h"

@implementation AES256
/**加密*/
+ (NSString *)encrypt:(NSString *)string WithIv:(NSString*)iv withKey:(NSString*)key{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataEncrypted = [data AES256EncryptWithIv:iv withKey:key];
    NSString *strRecordEncrypted = [dataEncrypted base64EncodedStringWithOptions:NSUTF8StringEncoding];
    return strRecordEncrypted;
}

/**解密*/
+ (NSString *)decrypt:(NSString *)string WithIv:(NSString*)iv withKey:(NSString*)key{
    if([string containsString:@"\n"] || [string containsString:@"\t"])
    {
        string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    }
    NSData *valueData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *dataDecrypted = [valueData AES256DecryptWithIv:iv withKey:key];
    NSString *receivedDataDecryptString =
    [[NSString alloc]initWithData:dataDecrypted encoding:NSUTF8StringEncoding];
    return receivedDataDecryptString;
}


@end
