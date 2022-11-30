//
//  YTSharednetManager.h
//  yitiangogo
//
//  Created by Tgs on 14-11-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
//network state notification
extern NSString *const NetworkStatesChangeNotification;

#define kNeedNetLog   @"1"
typedef NS_ENUM (NSUInteger, RealmNameType) {
    All = 0 ,
    PayService,
    UpayService,
    ShareType,
    GetCookie,
    Default,
    LNService
};
typedef NS_ENUM (NSUInteger, managerAFNetworkStatus) {
    managerAFNetworkNotReachable = 0 ,//无网络连接
    managerAFNetworkReachableViaWWAN,//手机自带网络
    managerAFNetworkReachableViaWiFi,//手机wifi
    managerAFNetworkUnknown,//未知网络
    managerAFNetworkOutTime,//接口超时
    managerAFNetworkServiceError,//接口报错
};
typedef void(^AFNetStatusBlock)(managerAFNetworkStatus status);
@interface YTSharednetManager : NSObject
//Reachability
+ (AFNetworkReachabilityManager *)shareReachabilityManager;

+ (void)startListening;

+ (AFNetworkReachabilityStatus)networkStatus;

+ (BOOL)isWifiStatus;

+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status;
@property(nonatomic,assign)AFNetworkReachabilityStatus selectNetStatus;
@property(nonatomic,copy)NSString *netCookie;
@property(nonatomic,strong)AFNetStatusBlock statusBlock;

+(YTSharednetManager *)sharedNetManager;

-(void)postNetInfoWithUrl:(NSString *)urlPath_Header andType:(RealmNameType)type andWith:(NSDictionary *)paramters success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err;

-(void)getNetInfoWithUrl:(NSString *)urlPath andType:(RealmNameType)type andWith:(NSDictionary *)paramters success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err;

-(void)postOneImg:(NSString *)apiString
realmNameType:(RealmNameType)type
 parameters:(id)parameters
  imageData:(NSData *)imageData
          success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err;
-(void)postMoreFiles:(NSString *)apiString
      realmNameType:(RealmNameType)type
           parameters:(id)parameters
       imageDataArray:(NSArray *)imageDataArray
             success:(void(^)(NSDictionary *dic))succeed error:(void (^)(NSError *error))err;

-(void)postFileData:(NSString *)apiString
realmNameType:(RealmNameType)type
    parameters:(id)parameters
      fileData:(NSData *)fileData
            success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err;

-(void)getNetInfoWithUrl:(NSString *)urlPath andType:(RealmNameType)type andWith:(NSDictionary *)paramters andReturn:(void (^)(NSDictionary *dic))block;


//设置网络监听
-(void)setAFNetStatusChangeBlock:(void(^)(managerAFNetworkStatus status))block;

////文件上传
//-(void)requestAFNetWorkingByUrl:(NSString *)url
//                     parameters:(id)parameters
//                          files:(NSDictionary *) files
//                        success:(void (^)(AFHTTPRequestOperation *operation, id data))success
//                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
