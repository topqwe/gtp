//
//  NSBundle+STSystemTool.m
//  TheKing
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "NSBundle+STSystemTool.h"

@implementation NSBundle (STSystemTool)
+ (NSString *)st_applictionVersin{
    NSString * version =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
    return version;
}
+  (NSString *)st_applictionBuildNum{
    NSString * build =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return build;
}
+ (NSString *)st_applictionBundleIdentifier{
    NSString * bundleID =  [[NSBundle mainBundle] bundleIdentifier];
    return bundleID;
}
+ (NSString *)st_applictionDisplayName{
    NSString * name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return name;
}
+ (NSDictionary *)st_applictionInfoPlist{
    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
    return dic;
}
#pragma mark --文件
+ (NSString *)st_findMainBundleFilePathWithName:(NSString *)name type:(NSString *)type{
    NSString * existUrl = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return existUrl;
}
+ (NSString *)st_documentDirectoryPath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docDir;
}
+ (BOOL)st_createFolderFormDocumentWithFatherPath:(NSString *)fatherPath folderName:(NSString *)folderName{
    
    NSFileManager* fileManager= [NSFileManager defaultManager];
    NSString * documentPath = [NSBundle st_documentDirectoryPath];
    if(fatherPath.length){
        NSString * realFatherPath = [NSString stringWithFormat:@"%@/%@",documentPath,fatherPath];
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:realFatherPath isDirectory:&isDir];
        if(existed && isDir){
             NSString * finshUrl = [NSString stringWithFormat:@"%@/%@",realFatherPath,folderName];
             [fileManager createDirectoryAtPath:finshUrl withIntermediateDirectories:YES attributes:nil error:nil];
             NSLog(@"创建目录成功:%@",finshUrl);
            return YES;
        }else{
            NSLog(@"fatherPath 不存在或者不是一个目录%@",realFatherPath);
            return NO;
        }
       
    }else{
        NSString * realPath = [NSString stringWithFormat:@"%@/%@",documentPath,folderName];
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:realPath isDirectory:&isDir];
        if(!existed && !isDir){
            NSString * finshUrl = realPath;
            [fileManager createDirectoryAtPath:finshUrl withIntermediateDirectories:YES attributes:nil error:nil];
            NSLog(@"创建目录成功:%@",finshUrl);
            return YES;
        }else{
            NSLog(@"%@已经存在一个目录:%@",realPath,folderName);
            return NO;
        }
    }
    return NO;
}
+ (BOOL)st_copyFile:(NSString *)file toPath:(NSString *)toPath{
    BOOL isDir = NO;
    NSFileManager* fileManager= [NSFileManager defaultManager];
        BOOL existedFile = [fileManager fileExistsAtPath:file isDirectory:&isDir];
    if(!existedFile){
         NSLog(@"该文件不存在:%@",file);
        return NO;
    }
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:toPath isDirectory:&isDir];
    

    if(existed && isDir){
        [[NSFileManager defaultManager] copyItemAtPath:file
                                                toPath:toPath
                                                 error:nil];
        return YES;
    }else{
        NSLog(@"该位置不存在或者不是一个目录:%@",toPath);
        return NO;
    }
}

+ (NSString *)st_UUID{
    NSString * uuid =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuid;
}
+ (void)st_saveUUIDToKeyChain:(NSString *)uuid{
    NSString * bundleID = [NSBundle st_applictionBundleIdentifier];
    NSString * defultPwd = uuid;
    if (uuid.length) {
        NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
        //账号密码 账号和serviece 都是bundleid  密码就是uuid
        [queryDic setObject:bundleID forKey:(__bridge id)kSecAttrService];
        [queryDic setObject:bundleID forKey:(__bridge id)kSecAttrAccount];
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];//表明存储的是一个密码
        OSStatus status = -1;
        CFTypeRef result = NULL;
        status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
        if (status == errSecItemNotFound) {
            //没有找到则添加
            NSData *passwordData = [defultPwd dataUsingEncoding:NSUTF8StringEncoding];
            //把password 转换为 NSData
            [queryDic setObject:passwordData forKey:(__bridge id)kSecValueData];
            //添加密码
            status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);
            //!!!!!关键的添加API
            
        }else if (status == errSecSuccess){
            //成功找到，说明钥匙已经存在则进行更新
            NSData *passwordData = [defultPwd dataUsingEncoding:NSUTF8StringEncoding];
            //把password 转换为NSData
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:queryDic];
            [dict setObject:passwordData forKey:(__bridge id)kSecValueData];
            //添加密码
            status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);
            //!!!!关键的更新API
            
        }
        
    
    }
}
+ (NSString *)st_readUUIDFromKeyChain{
    NSString * bundleID = [NSBundle st_applictionBundleIdentifier];
    if (bundleID.length) {
        NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
        //首先添加获取密码所需的搜索键和类属性：
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        //表明为一般密码可能是证书或者其他东西
        [queryDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        //返回Data
        [queryDic setObject:bundleID forKey:(__bridge id)kSecAttrService];
        //输入service
        [queryDic setObject:bundleID forKey:(__bridge id)kSecAttrAccount];

        OSStatus status = -1;
        CFTypeRef result = NULL;
        status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
        if (status == errSecItemNotFound) {
             return @"";
            
        }else if (status == errSecSuccess){
            //成功找到，说明钥匙已经存在则 取出
            //删除kSecReturnData键; 我们不需要它了：
            [queryDic removeObjectForKey:(__bridge id)kSecReturnData];
            //将密码转换为NSString并将其添加到返回字典：
            NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)result bytes] length:[(__bridge NSData *)result length] encoding:NSUTF8StringEncoding];
            
            [queryDic setObject:password forKey:(__bridge id)kSecValueData];
            NSLog(@"查询 : %@", queryDic);
            return password;
            
        }
        
        
    }
    return @"";
}
@end
