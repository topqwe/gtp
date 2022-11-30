//
//  TMImageAdjustView.h
//  WeddingTime
//
//  Created by Mac on 2018/11/13.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMImageDownloadModel;
/************图片不拉伸集合展示(默认隐藏,加载完毕之后显示)******************/
@interface TMImageAdjustView : UIView
@property(nonatomic, assign) NSInteger                     maxDuring;/**< 最大响应时间 默认15秒*/
@property(nonatomic, assign) UIEdgeInsets                   itemInset;/**< 每个imageView 的 itemInset*/
@property(nonatomic, copy)   void(^allImageViewDisplayHandle)(TMImageAdjustView * adjustView,NSArray<TMImageDownloadModel*>* displayArray,NSArray<TMImageDownloadModel*>* allArray);/**< 图片加载完毕的handle,或者超过最大响应时间 */
- (void)beginLoadUrls:(NSArray<NSString*>*)urls;/**< 开始加载Url  所有删除参数必须在此方法之前设置否则无效*/
@end

@interface TMImageDownloadModel : NSObject
@property(nonatomic, strong) NSString                     *url;/**<  */
@property(nonatomic, assign) CGFloat                     height;/**<  */
@property(nonatomic, assign) BOOL                        didDownload;/**<  */
@end
