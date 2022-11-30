//
//  STNetWrokManger.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STNetWrokManger.h"
#define st_resp_codeKey @"code"
#define st_resp_tureCode @"1"
#define st_resp_messageKey @"msg"
#define st_down_flodleName @"floderName"
@implementation STNetWrokManger
{
    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_requestTaskPool;
}
static const double kAFTimeoutInterval = 15;
static STNetWrokManger *instance = nil;

- (id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = kAFTimeoutInterval;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    }
    return self;
}
#pragma mark - Public Method
+ (STNetWrokManger *)defaultClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (void)shownNormalRespMsgWithResponse:(id)response{
    NSDictionary * dic = response;
    if ([dic.allKeys containsObject:st_resp_messageKey]) {
        NSString * msg = dic[st_resp_messageKey];
        
        [SVProgressHUD showSuccessWithStatus:msg];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"操作成功"];
}
- (void)requestWithPath:(NSString *)url
                 method:(STHttpRequestType)method
             parameters:(id)parameters
                success:(STSuccessBlock)success
                failure:(STFailureBlock)failure
{
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"app-token"];
    
//    if (![url containsString:@"user/register"]) {
        if (STUserManger.defult.loginedUser.token.length) {
            NSString *value = STUserManger.defult.loginedUser.token;
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
        }else{
            if (STUserManger.defult.noLoginToken.length) {
                NSString *value = STUserManger.defult.noLoginToken;
                [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
                [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
            }
        }
//    }


    NSString * newUrl = url;
    if (method == STHttpRequestTypePost) {
        [_manager POST:newUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if ([retCode isEqualToString:@"-1"]) {
                    //登录过期
                    [STUserManger.defult removeUserPreferce];
                    [TMUtils presentLoginViewController];
                    return ;
                }
                if (failure) {
                    STError * sterror = [STError new];
                    sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_messageKey]];
                    sterror.code = retCode.integerValue;
                    sterror.resp = responseObject;
                    failure(retCode,sterror,nil);
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }else if (method == STHttpRequestTypeGet) {
        [_manager GET:newUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if ([retCode isEqualToString:@"-1"]) {
                    //登录过期
                    [STUserManger.defult removeUserPreferce];
                    [TMUtils presentLoginViewController];
                    return ;
                }
                
                    if (failure) {
                        STError * sterror = [STError new];
                        sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_messageKey]];
                        sterror.code = retCode.integerValue;
                        sterror.resp = responseObject;
                        failure(retCode,sterror,nil);
                    }

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }else if (method == STHttpRequestTypePut) {
        [_manager PUT:newUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if (failure) {
                    STError * sterror = [STError new];
                    sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_messageKey]];
                    sterror.code = retCode.integerValue;
                    failure(retCode,sterror,nil);
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
        
    }else if (method == STHttpRequestTypeDelete) {
        [_manager DELETE:newUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if (failure) {
                    STError * sterror = [STError new];
                    sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_messageKey]];
                    sterror.code = retCode.integerValue;
                    failure(retCode,sterror,nil);
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
        
    }
}
- (void)requestIgnoreSuccessWithPath:(NSString *)url method:(STHttpRequestType)method parameters:(id)parameters success:(STSuccessBlock)success failure:(STFailureBlock)failure{
    NSString * newUrl = url;
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"app-token"];
    if (STUserManger.defult.loginedUser.token.length) {
        NSString *value = STUserManger.defult.loginedUser.token;
        [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
        [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
    }else{
        if (STUserManger.defult.noLoginToken.length) {
            NSString *value = STUserManger.defult.noLoginToken;
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
        }
    }
    if (method == STHttpRequestTypePost) {
        [_manager POST:newUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task,responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }else if (method == STHttpRequestTypeGet) {
        [_manager GET:newUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(task,responseObject);
                }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }
    
}
//有返回值的请求
- (NSURLSessionDataTask *)taskRequestWithPath:(NSString *)url
                                       method:(STHttpRequestType)method
                                   parameters:(id)parameters
                                      success:(STSuccessBlock)success
                                      failure:(STFailureBlock)failure
{
    if (method == STHttpRequestTypePost) {
        return  [_manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                success(task,responseObject);
            }else {
                if (failure) {
                    STError * sterror =  [STError new];
                    sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                    sterror.code = retCode.integerValue;
                    failure(retCode,sterror,nil);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }else if (method == STHttpRequestTypeGet) {
        return    [_manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
            if ([retCode isEqualToString:st_resp_tureCode]) {
                success(task,responseObject);
            }else {
                if (failure) {
                    STError * sterror =  [STError new];
                    sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                    sterror.code = retCode.integerValue;
                    failure(retCode,sterror,nil);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.userInfo[@"NSDebugDescription"];
                sterror.code =  error.code;
                failure(@(error.code).description,sterror,error);
            }
        }];
    }
    return nil;
}
//下载文件
- (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url
                                     progress:(STProgressBlock)progress
                                      success:(STCompletionHandlerBlock)CompletionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSURLSessionDownloadTask *download =  [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createDir = [NSString stringWithFormat:@"%@/%@/Files", st_down_flodleName,pathDocuments];
        
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:createDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
        NSString *path = [createDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (CompletionHandler) {
            CompletionHandler(response, filePath, error);
        }
        
    }];
    return download;
}
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure
{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"head_img" fileName:[NSString stringWithFormat:@"%lld.png",time] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.userInfo[@"NSDebugDescription"];
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
    
}
//附带imageName 参数
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                   imageName:(NSString*)imageName
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure{
    
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"app-token"];
    if (STUserManger.defult.noLoginToken.length) {
        NSString *value = STUserManger.defult.noLoginToken;
        [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
        [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
    }else{
        if (STUserManger.defult.loginedUser.token.length) {
            NSString *value = STUserManger.defult.loginedUser.token;
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"app-token"];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:@"token"];
        }
    }
    
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:imageName fileName:[NSString stringWithFormat:@"%lld.png",time] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }//
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.userInfo[@"NSDebugDescription"];
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
    
}
- (void)imagesRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure
{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        for (NSInteger i=1; i<=imageArray.count;i++ ) {
            UIImage * ima =imageArray[i-1];
            
            NSData * data =UIImageJPEGRepresentation(ima, 0.5);
            [formData appendPartWithFileData:data name:@"images" fileName:[NSString stringWithFormat:@"%lld-%ld.png",time,i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.userInfo[@"NSDebugDescription"];
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
}
//iamge参数
- (void)imagesRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                   imageNames:(NSArray*)imageNames
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        for (NSInteger i=1; i<=imageArray.count;i++ ) {
            UIImage * ima =imageArray[i-1];
            NSData * data =UIImageJPEGRepresentation(ima, 0.5);
            [formData appendPartWithFileData:data name:imageNames[i -  1] fileName:[NSString stringWithFormat:@"%lld-%ld.png",time,i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.userInfo[@"NSDebugDescription"];
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
}
- (void)uploadFileWithUrl:(NSString *)url
                 filePath:(NSString *)filePath
               parameters:(id)parameters
                 progress:(STProgressBlock)progress
                  success:(STSuccessBlock)success
                  failure:(STFailureBlock)failure
{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.userInfo[@"NSDebugDescription"];
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
}
- (NSURLSessionDataTask *)sessionUploadFileWithUrl:(NSString *)url
                                          filePath:(NSString *)filePath
                                        parameters:(id)parameters
                                          progress:(STProgressBlock)progress
                                           success:(STSuccessBlock)success
                                           failure:(STFailureBlock)failure{
    
    return     [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:st_resp_codeKey]];
        if ([retCode isEqualToString:st_resp_tureCode]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:st_resp_messageKey];
                sterror.code = retCode.integerValue;
                failure(retCode,sterror,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            sterror.code =  error.code;
            failure(@(error.code).description,sterror,error);
        }
    }];
}

@end
