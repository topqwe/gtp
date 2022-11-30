//
//  STPhotoModel.h
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  系统照片model

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface STPhotoModel : NSObject
//如果model 中存在 缩略图 或者原图，则不用请求
@property(nonatomic,strong)PHAsset                  *asset;

@property(nonatomic)        BOOL                    isChosed;//是否被选中

@property(nonatomic,strong)UIImage                  *thumbImage;//缩略图

@property(nonatomic,strong)UIImage                  *originImage;//原图

@property(nonatomic)PHImageRequestID                requsetID;//请求id form iCloud

@property(nonatomic)PHImageRequestID                originRequsetID;//大图请求id
@end
