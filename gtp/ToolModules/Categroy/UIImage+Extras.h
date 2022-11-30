//
//  UIImage+Extras.h

//
//  Created by WIQ on 2018/12/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GIFimageBlock)(UIImage *GIFImage);
//结合SVProgressHUD_Extension.h里的+ (SVProgressHUD*)sharedView使用
@interface UIImage (Extras)

/** 根据本地GIF图片名 获得GIF image对象 */

+ (UIImage *)imageWithGIFNamed:(NSString *)name;

/** 根据一个GIF图片的data数据 获得GIF image对象 */

+ (UIImage *)imageWithGIFData:(NSData *)data;

/** 根据一个GIF图片的URL 获得GIF image对象 */

+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock;
/**
 根据颜色生成图片

 @param color 颜色
 @return --
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 根据颜色生成图片

 @param color 颜色
 @param rect 大小
 @return --
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;
- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;

@end

NS_ASSUME_NONNULL_END
