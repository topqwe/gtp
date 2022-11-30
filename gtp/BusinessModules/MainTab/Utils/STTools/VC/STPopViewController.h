//
//  STPopViewController.h
//  STTools
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//` 说明： 这是一个点击加号，弹出的下拉列表控制器，可以在任何view下方出现
//  未解决bug ，背后有蒙层，错误消息：<_UIPopoverBackgroundVisualEffectView 0x7f988af0f470> is being asked to animate its opacity. This will cause the effect to appear broken until opacity returns to 1.

#import <UIKit/UIKit.h>
@class STPopViewController;
@protocol STPopViewControllerdelegate <NSObject>
@optional
-(void)popViewController:(UIViewController *)vc didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
@protocol STPopViewControllerdatasouce <NSObject>
@optional
-(UITableViewCell *)popViewController:(UIViewController *)vc cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)popViewController:(UIViewController *)vc heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface STPopViewController : UIViewController <STPopViewControllerdelegate,STPopViewControllerdatasouce>
@property(nonatomic,weak)id  <STPopViewControllerdelegate>        PopTableViewdelegate;
@property(nonatomic,weak)id  <STPopViewControllerdatasouce>       PopTableViewdatasouce;
// 如果用默认左边图片 右边 title，下面必须实现来传入imag；
@property(nonatomic,strong)NSArray<NSString*>           *imageAry;
//箭头方向
@property(nonatomic)UIPopoverArrowDirection             direction;

@property(nonatomic,strong)UIColor                      *cellColor;
@property(nonatomic,strong)UIColor                      *textlabelColor;
@property(nonatomic)BOOL  canScroll;//是否滑动

/**
 初始化默认弹出框

 @param titleAry 标题
 @param size 这个控制器view 的大小
 @param view 从哪一个view弹出这个控制器
 @return   ————
 */
-(instancetype)initWithArray:(NSArray<NSString*>*)titleAry size:(CGSize)size view:(UIView*)view;
@end
