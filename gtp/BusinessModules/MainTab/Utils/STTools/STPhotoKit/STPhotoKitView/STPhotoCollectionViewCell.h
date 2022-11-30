//
//  STPhotoCollectionViewCell.h
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  说明：图片集合cell
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "STPhotoModel.h"


@interface STPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView                              *imageView;

/**
 右上角选择按钮
 */
@property(nonatomic,strong)UIButton                                 *chosedButton;

@property(nonatomic,strong)STPhotoModel                             *model;
//图片点击回调
- (void)imageViewClicHandle:(void(^)(UIImageView * imageView))      imageHandle;
//按钮点击回调
- (void)chosedButtonClicHandle:(void(^)(UIButton * button))         buttonHandle;
@end
