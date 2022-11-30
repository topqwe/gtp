//
//  STBrowserCollectionViewCell.h
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  系统级别图片浏览


#import <UIKit/UIKit.h>
#import "STPhotoModel.h"
@protocol STBrowserCollectionViewCellDelegate <NSObject>

- (void)gestureRecognizerisRuning:(UIGestureRecognizer *)gestureRecognizer;

- (void)gestureRecognizerdidEnd:(UIGestureRecognizer *)gestureRecognizer;

- (void)pinchRecognizerdisScale:(CGFloat)scale;

- (void)panRecognizerPoint:(CGPoint)center;

- (void)didClicTheImageView;

@end
@interface STBrowserCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView                              *imageView;

@property(nonatomic,strong)STPhotoModel                             *model;

@property(nonatomic,strong)UIPinchGestureRecognizer                 *pinchRecognizer;//缩放

@property(nonatomic,strong)UIRotationGestureRecognizer              *rotationGestureRecognizer ;//旋转

@property(nonatomic,strong)UIPanGestureRecognizer                   *panGes;//平移

@property(nonatomic,strong)UITapGestureRecognizer                   *tapGes;//点击

@property(nonatomic,weak)id <STBrowserCollectionViewCellDelegate>   delegate;

@property(nonatomic,strong)UIScrollView                             *scrollView;

- (void)backToOrigin;//回到初始状态

- (void)backToVertical;//放手回到竖直状态
@end
