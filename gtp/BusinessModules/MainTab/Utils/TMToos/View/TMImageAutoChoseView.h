//
//  TMImageAutoChoseView.h
//  Marriage
//
//  Created by Mac on 2018/4/25.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPhotoModel.h"
/************自动多选imageview,常用与评价图片，意见反馈******************/
@interface TMImageAutoChoseView : UIView
@property(nonatomic, strong) UIImage                     *addImage;/**< 如果设置了头部图片不再使用默认 */
@property(nonatomic, assign) NSInteger                     maxCount;/**< 最高选择数量 */
@property(nonatomic, copy) void(^frameDidChangedHandle)(TMImageAutoChoseView * autochoseView);/**< frame发生变化 */
- (NSArray<STPhotoModel*>*)allImageModels;/**< 所有数组 */
- (NSArray<UIImage*>*)allImages;/**< 所有数组图片 */

- (void)addImageModels:(NSArray<STPhotoModel*>*)imageModels;/**< 批量增加 */
- (void)addImageModel:(STPhotoModel*)imageModel;/**< 单个增加 */

- (void)cancleImageModel:(STPhotoModel*)imageModel;/**< 删除 */
- (void)cancleImageModels:(NSArray<STPhotoModel*>*)imageModels;/**< 批量删除 */
- (void)removeImageModelFormIndex:(NSInteger)index;/**< 根据下标批量删除0~count */


- (void)onSelctedAddButton;
@end
