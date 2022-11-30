//
//  PHPhotoLibrary+STTools.m
//  ZuoBiao
//
//  Created by stoneobs on 17/4/11.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "PHPhotoLibrary+STTools.h"

@implementation PHPhotoLibrary (STTools)
+ (void)saveImageToAssetsLibrary:(UIImage *)image libraryName:(NSString *)libraryName successHandle:(void (^)(void))successHandle errorHandle:(void (^)(STSaveImageError))errorHandle{
    if (!image) {
        if (errorHandle) {
            errorHandle(STSaveImageErrorNoImage);
        }
        return;
    }
    PHAuthorizationStatus  status  =  [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        //无权限- 未被拒绝 请求权限
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [PHPhotoLibrary saveImageToAssetsLibrary:image libraryName:libraryName successHandle:successHandle errorHandle:nil];
            }];
        }else{
            //无权限 被拒绝
            if (errorHandle) {
                errorHandle(STSaveImageErrorDenied);
            }
            
        }
        return;
    }
    
    //NSString * appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString * appName = libraryName;
    //获取自定义相册
    BOOL exist = NO;
    PHAssetCollection *myCollection;//坐标相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHCollection *collection = smartAlbums[i];
        if ([collection.localizedTitle isEqualToString:appName]) {
            exist = YES;
            myCollection = (PHAssetCollection*)collection;
            break;
        }
    }
    if (!exist) {
        //创建相册
        __block NSString *createdCollectionId = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
        
        myCollection =  [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
        
        
        
    }
    // 添加图片到相机胶卷
    __block NSString *createdAssetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    PHFetchResult * myAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
    
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:myCollection];
        [request insertAssets:myAsset atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 保存结果
    if (error) {
        if (errorHandle) {
            errorHandle(STSaveImageErrorUnknown);
        }
    } else {
        if (successHandle) {
            successHandle();
        }
    }
    
    
}

@end
