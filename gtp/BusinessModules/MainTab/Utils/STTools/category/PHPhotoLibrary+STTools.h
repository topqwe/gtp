//
//  PHPhotoLibrary+STTools.h
//  ZuoBiao
//
//  Created by stoneobs on 17/4/11.
//  Copyright © 2017年 shixinyun. All rights reserved.
//
typedef NS_ENUM(NSUInteger, STSaveImageError) {
    STSaveImageErrorNoImage = 0,
    STSaveImageErrorNotDetermined = 1,//没有询问权限
    STSaveImageErrorDenied = 2,//被拒绝
    STSaveImageErrorUnknown = 3,
};
#import <Photos/Photos.h>

@interface PHPhotoLibrary (STTools)

/**
 保存图片到相册

 @param image image
 @param libraryName 相册名字
 @param successHandle 成功回调
 @param errorHandle 失败回调
 */
+ (void)saveImageToAssetsLibrary:(UIImage*) image libraryName:(NSString*)libraryName successHandle:(void(^)(void))successHandle errorHandle:(void(^)(STSaveImageError error)) errorHandle;
@end
