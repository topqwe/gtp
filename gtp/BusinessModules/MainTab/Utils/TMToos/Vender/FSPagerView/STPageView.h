//
//  FSPageView.h
//  DJMusic
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 配置 Swift Language Version  4.0
 开启 defines module  yes
 导入 工程名字-Swift.h  (先bulid 成功之后再倒入)
 */
typedef NS_ENUM(NSUInteger, FSPageViewPageControlType) {
    FSPageViewPageControlTypeDefult = 0,
    FSPageViewPageControlTypeRing,
    FSPageViewPageControlTypeImage,
    FSPageViewPageControlTypeBezierPath_star,
    FSPageViewPageControlTypeBezierPath_heart,
};
#import "BannerVideo-Swift.h"
/************pageView 整合******************/
@interface STPageView : UIView
@property(nonatomic, assign) FSPagerViewTransformerType                     animationType;/**< 动画 默认FSPagerViewTransformerTypeLinear */
@property(nonatomic, assign) FSPageViewPageControlType                                      styleIndex;/**< 0Defult 1 FSPageViewPageControlTypeRing */

@property(nonatomic, assign) CGFloat                                       autoMoveDuring;/**< 0不滑动 大于0 自定滑动 */

@property(nonatomic, strong) NSMutableArray                     *imageArray;/**< 本地image图片 */
@property(nonatomic, strong) NSMutableArray                     *imageUrlArray;/**< 网络image图片 */
@property(nonatomic, strong) UIImage                            *urlPlaceHolderImage;/**< 网络占位图 */

@property(nonatomic, strong,readonly) FSPageControl                      *pageControl;/**< pageControl */
@property(nonatomic, strong,readonly) FSPagerView                        *pagerView;/**< pagerView */

@property(nonatomic, assign) CGSize                             itemSize;/**< itemSize */
@property(nonatomic, copy) void(^onSelectedBannerHandle)(NSInteger index)        ;/**< 点击事件 */
@property(nonatomic, copy) void(^scrollDidScroll)(NSInteger   currentIndex)        ;/**< 滑动 */

- (void)forceReloadData;/**< 强制刷新 */
@end
