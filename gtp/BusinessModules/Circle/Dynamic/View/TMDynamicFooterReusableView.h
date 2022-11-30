//
//  TMDynamicFooterReusableView.h
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDynamicModel.h"
#define TMDynamicFooterHeight  44
/************通用动态底部******************/
@interface TMDynamicFooterReusableView : UICollectionReusableView
@property(nonatomic, strong) STButton                     *commentButton;/**< 评论 */
@property(nonatomic, strong) STButton                     *goodButton;/**< 点赞 */
@property(nonatomic, strong) STButton                     *shareButton;/**< 点分享 */
@property(nonatomic, strong) UIImageView                     *adverImageView;/**< <##> */
@property(nonatomic, strong) TMDynamicModel                     *model;/**< 模型 */
@end
