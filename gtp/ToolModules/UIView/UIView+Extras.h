//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by WIQ on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^ActionBlock)(id data);
static CGFloat rRadii = 10.0f;//默认圆角大小
@interface UIView (Extras)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
- (void)gradientLayerAboveView:(UIView*)view withShallowColor:(UIColor*)shallowC withDeepColor:(UIColor*)deepC isVerticalOrHorizontal:(BOOL)isVertical;
-(void)removeAllSubViews;

@property (nonatomic, copy) ActionBlock leftLittleButtonEventBlock;
@property (nonatomic, copy) ActionBlock leftButtonEventBlock;
@property (nonatomic, copy) ActionBlock rightButtonEventBlock;

@property (nonatomic, strong) NSMutableArray* funcBtns;

- (void)loginRightButtonInSuperView:(UIView*)superView withTitle:(NSString*)title rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)goBackButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)goBackBlackButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)goBackEmptyContentButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (UIView*)setDataEmptyViewInSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin withCustomTitle:(NSString*)customTitle withCustomImageName:(NSString*)imgName;
- (void)addCornersAndShadow;

- (void)addCorners:(UIRectCorner)corners
       shadowLayer:(void (^)(CALayer * shadowLayer))shadowLayer;

- (void)addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii;

/*
@param corners 圆角设置
@param rRadii 圆角设置
@return shadowLayer 阴影设置
*/
- (void)addCorners:(UIRectCorner)corners
            rRadii:(CGFloat)rRadii
       shadowLayer:(nullable void (^)(CALayer * shadowLayer))shadowLayer;
+ (void)addShadowToView:(UIView *)view withOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius andCornerRadius:(CGFloat)cornerRadius;
- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withShadowWithColor:(UIColor*)shadowColor andRadius:(CGFloat)shadowRadius andOffset:(CGSize)shadowOffset andOpacity:(CGFloat)shadowOpacity;
+ (void)putView:(UIView*)view andCornerRadius:(CGFloat)cornerRadius insideShadowWithColor:(UIColor*)color andRadius:(CGFloat)shadowRadius andOffset:(CGSize)shadowOffset andOpacity:(CGFloat)shadowOpacity;
- (UIView*)setDataEmptyViewInSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin;
- (UIView*)setServiceErrorViewInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;
- (UIView*)setNetworkErrorViewInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;
- (void)bottomSingleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSString*)btnTitle withBottomMargin:(NSInteger)bottomMargin  isHidenLine:(BOOL)isHidenLine leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)bottomSingleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSString*)btnTitle leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)customDoubleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSArray*)btnTitles leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)bottomDoubleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSArray*)btnTitles leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)bottomDoubleButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)bottomTripleButtonInSuperView:(UIView*)superView leftLittleButtonEvent:(ActionBlock)leftLittleButtonEventBlock leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)showError:(NSError *)error;
- (void)showAlertView:(NSString *)message ok:(void(^)(UIAlertAction * action))ok cancel:(void(^)(UIAlertAction * action))cancel;
@end
NS_ASSUME_NONNULL_END
