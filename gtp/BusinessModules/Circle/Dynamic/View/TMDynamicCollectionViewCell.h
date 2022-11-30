//
//  TMDynamicCollectionViewCell.h
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDynamicModel.h"
/************通用动态cell******************/
@interface TMDynamicCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView                     *itemImageView;/**< 图片 */
@property(nonatomic, strong) UIImageView                     *playView;/**< <##> */
@property(nonatomic, strong) TMDynamicModel                     *model;/**< 模型 */

@property(nonatomic, strong) TMDynamicVideoModel                 *videoModel;/**<  */
@property(nonatomic, strong) TMDynamicImageModel                 *imageModel;/**<  */
@end
