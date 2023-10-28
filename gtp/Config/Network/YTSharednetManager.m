//
//  YTSharednetManager.m
//  yitiangogo
//
//  Created by Tgs on 14-11-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "YTSharednetManager.h"
NSString *const NetworkStatesChangeNotification = @"NetworkStatesChangeNotification";

static YTSharednetManager *sharedManager = nil;
@implementation YTSharednetManager
@synthesize statusBlock;

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(YTSharednetManager *)sharedNetManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YTSharednetManager allocWithZone:NULL]init];
    });
    return sharedManager;
}

-(void)handleExpireDataNetInfoWithUrl:(NSString *)urlPath_Header{
    if (![urlPath_Header isEqualToString:[ApiConfig getAppApi:ApiType11]]&&
        ![urlPath_Header isEqualToString:[ApiConfig getAppApi:ApiType12]]) {
        
        if ([UserInfoManager GetNSUserDefaults].data.expires_at == nil||
            [NSString compareYMDHMSDate:[NSString getCurrentTimeYMDHMS] withDate:[UserInfoManager GetNSUserDefaults].data.expires_at] != 1) {
//            UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
//            userInfoModel.data.account = @"";
//            [UserInfoManager SetNSUserDefaults:userInfoModel];
                
//                [[UserInfoModel new] setDefaultDataIsForceInit:YES];
//            [UserInfoManager DeleteNSUserDefaults];
                
                [[LoginVM new]network_postLoginWithRequestParams:@{} success:^(id data) {
                    
                                
                } failed:^(id data) {
                    
                } error:^(id data) {
                    
                }];
            
        }
    }
    
}
- (NSDictionary *)returnDicHandleParamters:(NSDictionary *)paramters{
    NSString *encodeStr = [NSString stringWithFormat:@"%@",[NEUSecurityUtil neu_MixSHA256encryptAESData:[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]]];
    NSDictionary *postDic = @{@"params":[NSString stringWithFormat:@"%@",encodeStr]};
//    NSDictionary *postDic = @{@"params":[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]};
    return  postDic;
    
}
- (NSData*)returnDataHandleParamters:(NSDictionary *)paramters{
    NSString *titStr = @"";
    NSData *postData ;
//    if (paramters==nil) {
//        titStr = [@{@"params":[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]} mj_JSONString];//avoid  paramters = nil
//
//        postData = [NSJSONSerialization dataWithJSONObject:@{@"params":[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]} options:NSJSONWritingPrettyPrinted error:nil];
////        [titStr  dataUsingEncoding:NSUTF8StringEncoding];
//    }else{
        NSString *encodeStr = [NSString stringWithFormat:@"%@",[NEUSecurityUtil neu_MixSHA256encryptAESData:[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]]];
        titStr = [@{@"params":[NSString stringWithFormat:@"%@",encodeStr]} mj_JSONString];
        postData = [titStr  dataUsingEncoding:NSUTF8StringEncoding];
//    }
    
    
//    NSString *titStr = [@{@"params":[NSString stringWithFormat:@"%@",[paramters mj_JSONString]]} mj_JSONString];//avoid  paramters = nil
//    NSString *encodeStr = [NSString stringWithFormat:@"%@",[NEUSecurityUtil neu_MixSHA256encryptAESData:titStr]];
//    NSData *postData = [titStr  dataUsingEncoding:NSUTF8StringEncoding];
    //allowLossyConversion:YES
    //    NSDictionary *postDic = @{@"params":[NSString stringWithFormat:@"%@",[NEUSecurityUtil neu_MixSHA256encryptAESData:[paramters mj_JSONString]]]};
    return  postData;
}

- (NSDictionary*)handleResultParamters:(id)responseObject{
    NSDictionary *postDic = @{};
    if ([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = (NSDictionary *)responseObject;
        postDic = dic;
    }else{
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* dicc = [NSString dictionaryWithJsonString:string];
        if(dicc && [dicc.allKeys containsObject:@"msg"]){
//            [YKToastView showToastText:dicc[@"msg"]];
        }
        postDic = [NEUSecurityUtil neu_MixSHA256decryptAESData:string];
    }
    return  postDic;
}
#pragma mark--通用网络接口 --Post
-(void)postNetInfoWithUrl:(NSString *)urlPath_Header andType:(RealmNameType)type andWith:(NSDictionary *)paramters success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err{
    
    [self handleExpireDataNetInfoWithUrl:urlPath_Header];
    
    NSString *path;
    if (type==All) {
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;
    }
    else if(type==LNService){
        path = LNURL_IP;
    }
    else if(type==Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    
    //    NSString* aesEnStr = [NEUSecurityUtil neu_encryptAESData:titStr ];
        
    //    NSString* aesDeStr = [NEUSecurityUtil neu_decryptAESData:aesEnStr];
        
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:@{@"params":aesEnStr} options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString* parStr = [@{@"params":aesEnStr} mj_JSONString];
        
    //    NSData *postData = [titStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        //🉑️
    //    NSData *postData =[NSJSONSerialization dataWithJSONObject:@{@"params":titStr} options:NSJSONWritingPrettyPrinted error:nil];
    NSData *postData = [self returnDataHandleParamters:paramters];
        
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",path,urlPath_Header];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    //有body可不用paramters!=nil?postDic:@{}
    //NSDictionary *postDic = [self returnDicHandleParamters:paramters];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:[UserInfoManager GetBearerToken] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPBody:postData];
    NSLog(@"post+ postUrlStr: %@", urlStr);
    AFHTTPResponseSerializer*responseSerializer = [AFHTTPResponseSerializer serializer];

    responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",

    @"text/html",

    @"text/json",

    @"text/javascript",

    @"text/plain",

    nil];

    manager.responseSerializer= responseSerializer;

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        if (!error) {
            NSLog(@"post+ responseObject: %@", responseObject);

            NSDictionary* dic = [self handleResultParamters:responseObject];
            NSLog(@"post+ responseDic: %@", dic);
            [UserInfoManager SetCacheDataWithKey:urlPath_Header withData:dic];
            success(dic);
//
        } else {
            NSLog(@"post++ error: %@, %@, %@", error, response, responseObject);
            err(error);
            
        }
    }];
    [task resume];
}

#pragma mark--通用网络接口 --Get
-(void)getNetInfoWithUrl:(NSString *)urlPath_Header andType:(RealmNameType)type andWith:(NSDictionary *)paramters success:(void(^)(NSDictionary *dic))success error:(void (^)(NSError *error))err{
    [self handleExpireDataNetInfoWithUrl:urlPath_Header];
    NSString *path;
    if (type==All) {
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;
    }else if(type==LNService){
        path = LNURL_IP;
    }
    else if(type==Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [httpManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    [httpManager.requestSerializer setValue:[UserInfoManager GetBearerToken] forHTTPHeaderField:@"Authorization"];
    
    httpManager.requestSerializer.timeoutInterval = 30;
    NSMutableDictionary* headerDic = [@{@"Content-Type":@"application/json",
    @"Accept":@"application/json",
       @"X-Requested-With":@"XMLHttpRequest",
    } mutableCopy];
//    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [headerDic addEntriesFromDictionary:@{@"Authorization":[UserInfoManager GetBearerToken]}];
    WS(weakSelf);
    [httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.selectNetStatus = status;
        managerAFNetworkStatus ownStatus = managerAFNetworkNotReachable;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:     // 无连线
                ownStatus = managerAFNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ownStatus = managerAFNetworkReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                ownStatus = managerAFNetworkReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                ownStatus = managerAFNetworkUnknown;
                break;
        }
        if (weakSelf.statusBlock) {
            weakSelf.statusBlock(ownStatus);
        }
    }];
    // 开始监听
    [httpManager.reachabilityManager startMonitoring];
    //    设置cookie
    if (type!=GetCookie) {
        NSString* cookie = [NSString stringWithFormat:@"%@",GetUserDefaultWithKey(@"mUserDefaultsCookie")];
        [headerDic addEntriesFromDictionary:@{@"Cookie":cookie}];
    }
    
    
    id postData = [self returnDicHandleParamters:paramters];
//    [self returnDataHandleParamters:paramters];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",path,urlPath_Header];
    NSLog(@"get+ getUrlStr: %@", urlStr);
    [httpManager GET:urlStr parameters:postData headers:headerDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"get+ responseObject: %@", responseObject);
        
        NSDictionary* dic = [self handleResultParamters:responseObject];
        NSLog(@"get+ responseDic: %@", dic);
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (weakSelf.selectNetStatus!=AFNetworkReachabilityStatusNotReachable) {
            managerAFNetworkStatus ownStatus = managerAFNetworkServiceError;
            if (weakSelf.statusBlock) {
                weakSelf.statusBlock(ownStatus);
            }
        }
        NSLog(@"get++ error: %@, ", error);

            err(error);
    }];
    
}

/**
 * 上传单张图片
 */
-(void)postOneImg:(NSString *)apiString
        realmNameType:(RealmNameType)type
         parameters:(id)parameters
          imageData:(NSData *)imageData
          success:(void(^)(NSDictionary *dic))succeed error:(void (^)(NSError *error))err
{
    // 0.设置API地址
    NSString *path;
    if (type==All) {
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;
    }else if(type==LNService){
        path = LNURL_IP;
    }
    else if(type==Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    NSDictionary *postDic = @{@"params":[NSString stringWithFormat:@"%@",[parameters mj_JSONString]]};
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",path,apiString];
    
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    NSMutableDictionary* headerDic = [@{@"Content-Type":@"application/json",
        @"Accept":@"application/json",
           @"X-Requested-With":@"XMLHttpRequest",
        } mutableCopy];
    //    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [headerDic addEntriesFromDictionary:@{@"Authorization":[UserInfoManager GetBearerToken]}];
    // 5. POST数据
    [manager POST:urlStr parameters:postDic headers:headerDic
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";   // 设置时间格式
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary * dic = (NSDictionary *)responseObject;
            succeed(dic);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        //未连接到网络
        if(status == AFNetworkReachabilityStatusNotReachable) {
            [YKToastView showToastText:@"未连接到网络"];
            err(error);
            return ;
        }
        //当服务器无法响应时，使用本地json数据
        NSString *path = task.originalRequest.URL.path;
        if ([path containsString:@"xx"]) {
            succeed([NSString readJson2DicWithFileName:@"awemes"]);
            return;
        }
        err(error);
        
    }];
}

-(void)postMoreFiles:(NSString *)apiString
      realmNameType:(RealmNameType)type
           parameters:(id)parameters
       imageDataArray:(NSArray *)originArrs
              success:(void(^)(NSDictionary *dic))succeed error:(void (^)(NSError *error))err{
    
    
    NSString *path;
    if (type==All) {
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;
    }
    else if(type==LNService){
        path = LNURL_IP;
    }
    else if(type==Default){
        path = @"";
    }else{
        path = URL_IP;
    }
//    NSData *postData ;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:@{@"file_type":[NSString stringWithFormat:@"%@",[parameters mj_JSONString]]}];
//    for (int i = 0; i<originArrs.count; i++){
//
//        NSData *imageData = UIImageJPEGRepresentation(originArrs[i], 1.0);
////        [postDic addEntriesFromDictionary:@{@"file":imageData}];
////        [postDic addEntriesFromDictionary:@{@"file":[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]}];
//    }
//    postData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:nil];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",path,apiString];
        
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:[UserInfoManager GetBearerToken] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary* headerDic = [@{@"Content-Type":@"multipart/form-data",
        @"Accept":@"application/json", @"X-Requested-With":@"XMLHttpRequest",
        } mutableCopy];
    [headerDic addEntriesFromDictionary:@{@"Authorization":[UserInfoManager GetBearerToken]}];//sb
    [manager POST:urlStr parameters:postDic headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<originArrs.count; i++){
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
            
            if ([parameters isEqualToString:@"video"]) {
                
                NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
                [formData appendPartWithFileURL:originArrs[i] name:@"file" fileName:fileName mimeType:@"multipart/form-data" error:nil];
            }
            else if ([parameters isEqualToString:@"image"]) {
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSData *imageData = UIImageJPEGRepresentation(originArrs[i], 0.1);
                
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
            
//            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
            }
            
        }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"....%@",responseObject);
            NSDictionary *postDic = @{};
            if ([responseObject isKindOfClass:[NSDictionary class]]){
                NSDictionary * dic = (NSDictionary *)responseObject;
                postDic = dic;
            }else{
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary* dicc = [NSString dictionaryWithJsonString:string];
                if(dicc && [dicc.allKeys containsObject:@"msg"]){
        //            [YKToastView showToastText:dicc[@"msg"]];
                }
                postDic = [NEUSecurityUtil neu_MixSHA256decryptAESData:string];
                
            }
            succeed(postDic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSDictionary *erroInfo = error.userInfo;
            NSData *data = [erroInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            NSLog(@"errorString%@", errorString);
//            NSLog(@"...errr%@",error);
        }];
    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
////    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        for (int i = 0; i<imageDataArray.count; i++){
//
//            NSData *imageData = UIImageJPEGRepresentation(imageDataArray[i], 1.0);
//
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
//
//            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
//            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"multipart/form-data"];
////            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
//        }
//        } error:nil];
//    //有body可不用paramters!=nil?postDic:@{}
//    //NSDictionary *postDic = [self returnDicHandleParamters:paramters];
//    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    [request setValue:[UserInfoManager GetBearerToken] forHTTPHeaderField:@"Authorization"];
//
//    [request setHTTPBody:postData];
//
//    NSLog(@"post+ postUrlStr: %@", urlStr);
//    AFHTTPResponseSerializer*responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",
//
//    @"text/html",
//
//    @"text/json",
//
//    @"text/javascript",
//
//    @"text/plain",
//
//    nil];
//
//    manager.responseSerializer= responseSerializer;
//
//    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        [SVProgressHUD dismiss];
//        if (!error) {
//            NSLog(@"post+ responseObject: %@", responseObject);
//
//
//            NSDictionary *postDic = @{};
//            if ([responseObject isKindOfClass:[NSDictionary class]]){
//                NSDictionary * dic = (NSDictionary *)responseObject;
//                postDic = dic;
//            }else{
//                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSDictionary* dicc = [NSString dictionaryWithJsonString:string];
//                if(dicc && [dicc.allKeys containsObject:@"msg"]){
//        //            [YKToastView showToastText:dicc[@"msg"]];
//                }
//                postDic = [NEUSecurityUtil neu_MixSHA256decryptAESData:string];
//                postDic = dicc;
//            }
//            succeed(postDic);
//
////
//        } else {
//            NSLog(@"post++ error: %@, %@, %@", error, response, responseObject);
//            err(error);
//
//        }
//    }];
//    [task resume];
}

/**
 * 上传文件
 */
-(void)postFileData:(NSString *)apiString
     realmNameType:(RealmNameType)type
         parameters:(id)parameters
           fileData:(NSData *)fileData
            success:(void(^)(NSDictionary *dic))succeed error:(void (^)(NSError *error))err
{
    // 0.设置API地址
    NSString *path;
    if (type==All) {
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;
    }else if(type==LNService){
        path = LNURL_IP;
    }
    else if(type==Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    NSDictionary *postDic = @{@"params":[NSString stringWithFormat:@"%@",[parameters mj_JSONString]]};
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",path,apiString];
    
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    NSMutableDictionary* headerDic = [@{@"Content-Type":@"application/json",
        @"Accept":@"application/json",
           @"X-Requested-With":@"XMLHttpRequest",
        } mutableCopy];
    //    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [headerDic addEntriesFromDictionary:@{@"Authorization":[UserInfoManager GetBearerToken]}];
    // 5. POST数据
    [manager POST:urlStr parameters:postDic headers:headerDic
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //将得到的二进制数据拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData :fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary * dic = (NSDictionary *)responseObject;
            succeed(dic);
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        err(error);
    }];
}
//设置网络监听
-(void)setAFNetStatusChangeBlock:(void(^)(managerAFNetworkStatus status))block{
    self.statusBlock = [block copy];
}

//Reachability
+(AFNetworkReachabilityManager *)shareReachabilityManager {
    static dispatch_once_t once;
    static AFNetworkReachabilityManager *manager;
    dispatch_once(&once, ^{
        manager = [AFNetworkReachabilityManager manager];
    });
    return manager;
}

+ (void)startListening {
    [[YTSharednetManager shareReachabilityManager] startMonitoring];
    [[YTSharednetManager shareReachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatesChangeNotification object:nil];
        if(![YTSharednetManager isNotReachableStatus:status]) {
            [YTSharednetManager registerUserInfo];
        }
    }];
}

+ (AFNetworkReachabilityStatus)networkStatus {
    return [YTSharednetManager shareReachabilityManager].networkReachabilityStatus;
}

+ (BOOL)isWifiStatus {
    return [YTSharednetManager shareReachabilityManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}
+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status {
    return status == AFNetworkReachabilityStatusNotReachable;
}

//visitor
+ (void)registerUserInfo {
//    VisitorRequest *request = [VisitorRequest new];
//    request.udid = UDID;
//    [NetworkHelper postWithUrlPath:CreateVisitorPath request:request success:^(id data) {
//        VisitorResponse *response = [[VisitorResponse alloc] initWithDictionary:data error:nil];
//        writeVisitor(response.data);
//    } failure:^(NSError *error) {
//        NSLog(@"Register visitor failed.");
//    }];
}
@end
