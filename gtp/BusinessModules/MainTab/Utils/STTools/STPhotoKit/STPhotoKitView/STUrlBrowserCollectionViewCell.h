//
//  STCollectionViewCell.h
//  STTools
//
//  Created by stoneobs on 16/10/13.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  网络图片浏览cell

#import <UIKit/UIKit.h>
#import "STUrlPhotoModel.h"
@protocol STUrlBrowserCollectionViewCellDelegate <NSObject>

- (void)gestureRecognizerisRuning:(UIGestureRecognizer *)gestureRecognizer;

- (void)gestureRecognizerdidEnd:(UIGestureRecognizer *)gestureRecognizer;

- (void)pinchRecognizerdisScale:(CGFloat)scale;

- (void)panRecognizerPoint:(CGPoint)center;

- (void)didClicTheImageView;

@end
typedef void(^STCollectionViewCellFinsh)(UIImage* image);

@interface STUrlBrowserCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView                                  *imageView;

@property(nonatomic,strong)STUrlPhotoModel                              *model;

@property(nonatomic,weak)id<STUrlBrowserCollectionViewCellDelegate>     delegate;

@property(nonatomic,copy)STCollectionViewCellFinsh                      finshBlock;//图片加载完的回调，现在基本不用



@property(nonatomic,strong)UIPinchGestureRecognizer                     *pinchRecognizer;//缩放

@property(nonatomic,strong)UIRotationGestureRecognizer                  *rotationGestureRecognizer ;//旋转

@property(nonatomic,strong)UIPanGestureRecognizer                       *panGes;//平移

@property(nonatomic,strong)UITapGestureRecognizer                       *tapGes;//点击

@property(nonatomic,strong)UIScrollView                                 *scrollView;

- (void)backToOrigin;//回到初始缩放和旋转

- (void)setFinshBlock:(STCollectionViewCellFinsh)finshBlock;

@end
