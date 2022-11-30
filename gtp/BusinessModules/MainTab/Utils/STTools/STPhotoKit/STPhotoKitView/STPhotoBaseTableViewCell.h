//
//  STPhotoBaseTableViewCell.h
//  STNewTools
//
//  Created by stoneobs on 17/3/1.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
//**********************仿系统图片选择图片集合***************************
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>

@interface STPhotoBaseTableViewCell : UITableViewCell
@property(nonatomic,strong)PHAssetCollection            *model;
+ (CGFloat)height;
@end
