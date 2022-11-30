//
//  GHUtils.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVUserModel.h"
#import "BVAdverModel.h"
#import "TMDynamicModel.h"
@interface TMUtils: NSObject
//网络可用时候的回调
+ (BOOL)isIphoneX;
+ (UIView*)headerViewWithTitle:(NSString*)title;
+ (UINavigationBar *)navigationBar;
+ (UITabBar *)tabbar;
+ (CGFloat)navgationBarBootom;
+ (CGFloat)tabBarTop;
+ (void)debugSimulationNetWorkWithHadle:(void (^)(NSInteger, NSMutableArray *))handle;
+ (void)sendNoJsonRequestWithUrl:(NSString*)url params:(NSDictionary*)params isPost:(BOOL)isPost handle:(void(^)(BOOL success,NSString * response))handle;

+ (STButton*)titleButtonViewWithTile:(NSString*)title showRightGo:(BOOL)showRightGo handle:(void(^)(void))handle;
//按钮 和 更多
+ (STButton*)titleThemeButtonViewWithTile:(NSString*)title showRightGo:(BOOL)showRightGo handle:(void(^)(void))handle;

+ (UITextField*)textFiledWithLeftImage:(NSString*)leftImage placeHolader:(NSString*)placeHolader  rightView:(UIView*)rightView;
+ (UITextField*)textFiledWithLeftTitle:(NSString*)leftTitle placeHolader:(NSString*)placeHolader  rightView:(UIView*)rightView;

+ (void)makeViewToThemeGrdualColor:(UIView*)view;
//随即一个数字，出现偶数和奇数
+ (void)randNumberWithOuHandle:(void(^)(void))oushuHandle jiHandle:(void(^)(void))jiHandle;
//上传图片
+ (void)uploadImage:(UIImage*)image handle:(void(^)(BOOL success, NSString * imageUrl,NSString * thumbnail))handle;
//上传多张图片
+ (void)uploadMoreImage:(NSArray<UIImage*>*)imageArray handle:(void(^)(BOOL success, NSArray <NSDictionary*>* imageModels))handle;


//逻辑
//去视频详情
+ (void)gotoVideoDetailWithVideoId:(NSString*)video_id;
//去演员详情
+ (void)gotoActorDetailWithActorID:(NSString*)actor_id;
//去广告
+ (void)gotoAdverController:(BVAdverModel*)model;
//区分类列表
+ (void)gotoAllcateWithSting:(NSString *)cate;
//分享
+ (void)onSelctedShareButton;
//弹出登录
+ (void)presentLoginViewController;
@end
