//
//  STUrlPhotoModel.h
//  STTools
//
//  Created by stoneobs on 16/10/13.
//  Copyright © 2016年 stoneobs. All rights reserved.
// 普通照片model

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface STUrlPhotoModel : NSObject
@property(nonatomic,strong)NSString             *thumbImageUrl;//缩略图url

@property(nonatomic,strong)NSString             *originImageUrl;//高清图url

@property(nonatomic,strong)NSString             *filePath;//视频／图片 本地地址

@property(nonatomic,strong)UIImage              *thumbImage;//缩略图

@property(nonatomic,strong)UIImage              *originImage;//高清图

@property (nonatomic, copy) NSString *messageSN; //消息SN

@property (nonatomic, assign) int type; //type 0 图片  1 gif
@end
