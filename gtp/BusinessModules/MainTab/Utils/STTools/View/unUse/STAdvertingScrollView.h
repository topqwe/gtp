//
//  STAdvertingScrollView.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  仅仅适用于轮播图片
//废弃
#import <UIKit/UIKit.h>
typedef void(^STAdvertingScrollViewHandle)(NSInteger num);
@class STPageControl;
NS_CLASS_DEPRECATED_IOS(2_0, 11_0, "STAdvertingScrollView is deprecated. Use STPageView with  instead")
@interface STAdvertingScrollView : UIView
@property(nonatomic)BOOL                    canAutoScroll;//是否允许自动轮播 默认是no
@property(nonatomic)NSTimeInterval          time;//滑动时间间隔，默认2秒
@property(nonatomic,strong)UIImage          *placeholderImage;//默认是nil
@property(nonatomic,strong)NSArray          *imageUrlsArray;//网络图片，
@property(nonatomic,strong)NSArray          *dataSouce;//包含url字符串 或者资源图片字符串
@property(nonatomic,strong)STPageControl    *pageControll;//pagecontrol ,可控制颜色等属性
@property(nonatomic)BOOL                    canInfiniteScroll;//是否可以无限滚动

- (instancetype)initWithFrame:(CGRect)frame  andWithArray:(NSArray<NSString*>*)array handle:(STAdvertingScrollViewHandle)handle;
@end



//pageControll
typedef void(^STPageControlHandle)(NSInteger tag);
@interface STPageControl : UIControl
@property(nonatomic) NSInteger              currentPage;// 当前page
@property(nonatomic) BOOL                   isShowAnimation;// 默认显示动画，待完善
@property(nonatomic,strong) UIColor         *pageIndicatorTintColor;//普通状态颜色
@property(nonatomic)  CGSize                 pageSize;//普通状态大小，有默认值（4.4），需要的时候在重写set
@property(nonatomic,strong) UIColor         *currentPageIndicatorTintColor ; //选择后状态颜色
@property(nonatomic)CGSize                  currentPageSize;//选择状态大小，有默认值 （7，7）需要的时候在重写set
@property(nonatomic)NSInteger               numberOfPages;// 数量
-(instancetype)initWithPages:(NSInteger)pages handle:(STPageControlHandle)handle;
@end
