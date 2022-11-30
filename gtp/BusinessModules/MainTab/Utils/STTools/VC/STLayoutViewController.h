//
//  ETSideViewController.h
//  EasyTool
//  左右滑动抽屉效果的controller,修改于2016-3-25，增加单例模式,存在问题，和tableview的左滑手势冲突
//
//  Copyright (c) 2016年 stoneobs. All rights reserved.

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STLayoutViewStatus)
{
    STLayoutViewStatusNormal,
    STLayoutViewStatusLeftshowing,
    STLayoutViewStatusLeftshowed,
    STLayoutViewStatusLefthiding,
    STLayoutViewStatusRightshowing,
    STLayoutViewStatusRightshowed,
    STLayoutViewStatusRighthiding,
};
typedef NS_ENUM(NSInteger, STLayoutViewDisplayMode) {
    STLayoutViewDisplayModeBackground,//悬浮框
    STLayoutViewDisplayModeCover,//左右滑动拉伸
    STLayoutViewDisplayModeDefault = STLayoutViewDisplayModeBackground,
};

NS_CLASS_AVAILABLE_IOS(7_0)

@interface STLayoutViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,strong,readonly)   UIViewController            *rootViewController;
@property (nonatomic,strong,readonly)   UIPanGestureRecognizer      *panGestureRecognizer;
@property (nonatomic,strong,nullable)   UIViewController            *leftViewController;
@property (nonatomic,strong,nullable)   UIViewController            *rightViewController;
@property (nonatomic,readonly)          STLayoutViewStatus          status;
@property (nonatomic)                   STLayoutViewDisplayMode     leftDisplayMode;
@property (nonatomic)                   STLayoutViewDisplayMode     rightDisplayMode;
@property (nonatomic)                   NSTimeInterval              animationDuration;
@property (nonatomic,getter=canDisplayShadow) BOOL                  displayShadow;
/**
 左右向量
 */
@property (nonatomic) CGVector                                  leftDisplayVector;
@property (nonatomic) CGVector                                  rightDisplayVector;

+ (STLayoutViewController*)defaultLayout;
- (void)setPanGestureEnable:(BOOL)enable;//默认手势开启，
- (void)showLeftViewController:(BOOL)animated;//显示左边vc
- (void)showRightViewController:(BOOL)animated;
- (void)dismissCurrentController:(BOOL)animated;//退出侧滑


@end
@interface STLayoutViewController (customAnimationSuport)
- (void)layoutSubviewWithOffset:(CGFloat)offset maxOfsset:(CGFloat)maxofsset atView:(UIView *)animationView status:(STLayoutViewStatus)status;
@end

NS_ASSUME_NONNULL_END
