//
//  NSBundle+STSystemTool.h
//  TheKing
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/************提供bundle系统级别的功能******************/
@interface NSBundle (STSystemTool)
//版本号 有小数点
+ (NSString*)st_applictionVersin;
//build次数
+ (NSString*)st_applictionBuildNum;
//bundleID
+ (NSString*)st_applictionBundleIdentifier;
//appname
+ (NSString*)st_applictionDisplayName;
//获取主目录 plist
+ (NSDictionary*)st_applictionInfoPlist;
#pragma mark --文件
//获取工程主目录下的文件
+ (NSString*)st_findMainBundleFilePathWithName:(NSString*)name type:(NSString*)type;
//获取沙河document主目录
+ (NSString*)st_documentDirectoryPath;
//在document 下面创建一个目录，如果fatherPath 为空，直接在document下创建folderName.//eg fatherPath=@"music" folderName = @"周杰伦";
+ (BOOL)st_createFolderFormDocumentWithFatherPath:(NSString*)fatherPath folderName:(NSString*)folderName;
//拷贝到目标 目录， toPath必须是目录
+ (BOOL)st_copyFile:(NSString*)file toPath:(NSString*)toPath;

+ (NSString*)st_UUID;/**< 软件唯一码，会随着app 的卸载和重新安装改变 */
+ (void)st_saveUUIDToKeyChain:(NSString*)uuid;/**< 储存UUID 到keychain  keychain是钥匙串，除非ios系统 回退（正常升级不会），否则不会消失，机制同沙盒*/
+ (NSString*)st_readUUIDFromKeyChain;/**< 从keyChain 读取UUID 无论卸卸载还是初次安装 */


@end
