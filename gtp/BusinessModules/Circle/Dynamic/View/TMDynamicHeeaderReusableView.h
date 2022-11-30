//
//  TMDynamicHeeaderReusableView.h
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDynamicModel.h"
#define TMDynamicHeeaderHeight  44
/************通用动态头部******************/
@interface TMDynamicHeeaderReusableView : UICollectionReusableView
@property(nonatomic, strong) STButton                     *iconButton;/**< 头像 */
@property(nonatomic, strong) TMDynamicModel                     *model;/**< 模型 */
@property(nonatomic, strong) STButton                        *detailButton;/**< 详细*/
@end
