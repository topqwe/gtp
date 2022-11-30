//
//  STNetWrokManger.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STError.h"
typedef NS_ENUM(NSInteger, STHttpRequestType) {
    STHttpRequestTypeGet,
    STHttpRequestTypePost,
    STHttpRequestTypeDelete,
    STHttpRequestTypePut,
};
typedef void (^STSuccessBlock)(NSURLSessionDataTask *operation, id responseObject);
typedef void (^STFailureBlock)(NSString *stateCode, STError *error,NSError * originError);
typedef void (^STProgressBlock)(NSProgress* progress);
typedef void (^STCompletionHandlerBlock)(NSURLResponse *  response, NSURL *  filePath, NSError *  error);
@interface STNetWrokManger : NSObject
+ (STNetWrokManger *)defaultClient;
+ (void)shownNormalRespMsgWithResponse:(id)response;
/**
 * @brief HTTP请求处理接口
 * @param url 接口地址
 * @param method 请求方式
 * @param parameters 参数
 * @param success 成功回调
 * @param failure 失败回调
 */
- (void)requestWithPath:(NSString *)url
                 method:(STHttpRequestType)method
             parameters:(id)parameters
                success:(STSuccessBlock)success
                failure:(STFailureBlock)failure;

//将会忽略固定成功之值
- (void)requestIgnoreSuccessWithPath:(NSString *)url
                              method:(STHttpRequestType)method
                          parameters:(id)parameters
                             success:(STSuccessBlock)success
                             failure:(STFailureBlock)failure;

/**
 * @brief HTTP请求处理接口,有返回值
 * @param url 接口地址
 * @param method 请求方式
 * @param parameters 参数
 * @param success 成功回调
 * @param failure 失败回调
 */
- (NSURLSessionDataTask *)taskRequestWithPath:(NSString *)url
                                       method:(STHttpRequestType)method
                                   parameters:(id)parameters
                                      success:(STSuccessBlock)success
                                      failure:(STFailureBlock)failure;


/**
 默认 post 请求
 @param url HTTP请求处理接口
 @param parameters 参数
 @param image 一张图片
 @param progress 进度
 @param success 成功回调
 @param failure 失败回到
 */
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure;
//附带imageName 参数
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                   imageName:(NSString*)imageName
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure;

- (void)imagesRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure;
//附带image参数
- (void)imagesRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                  imageNames:(NSArray*)imageNames
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure;

- (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url
                                     progress:(STProgressBlock)progress
                                      success:(STCompletionHandlerBlock)CompletionHandler;


/**
 默认 post 请求 上传文件
 @param url HTTP请求处理接口
 @param filePath 文件本地路径
 @param parameters 参数
 @param progress 进度
 @param success 成功回调
 @param failure 失败回到
 */
- (void)uploadFileWithUrl:(NSString *)url
                 filePath:(NSString *)filePath
               parameters:(id)parameters
                 progress:(STProgressBlock)progress
                  success:(STSuccessBlock)success
                  failure:(STFailureBlock)failure;

- (NSURLSessionDataTask *)sessionUploadFileWithUrl:(NSString *)url
                                          filePath:(NSString *)filePath
                                        parameters:(id)parameters
                                          progress:(STProgressBlock)progress
                                           success:(STSuccessBlock)success
                                           failure:(STFailureBlock)failure;
@end
