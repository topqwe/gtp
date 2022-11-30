//
//  STPhotoCollectionViewController.h
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//**********************相册详情collectionviewController***************************
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "STPhotoModel.h"

@interface STPhotoCollectionViewController : UIViewController
NS_ASSUME_NONNULL_BEGIN
@property(nonatomic,strong)UICollectionView               *collectionView;
@property(nonatomic,strong)PHFetchResult                  *curentAlbum;//当前被选中相册
@property(nonatomic,strong)NSMutableArray<STPhotoModel*>  *chosedArray;//被选中的数组
- (void)showAnimation:(NSIndexPath*)indexpath;//展示动画
NS_ASSUME_NONNULL_END
@end
