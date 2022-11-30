//
//  STPopMenuViewController.h
//  GrapeGold
//
//  Created by Mac on 2018/5/7.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************菜单弹出框******************/
@interface STPopMenuViewController : UIViewController
@property(nonatomic, strong) NSArray<NSString*>                     *titlesArray;/**< 数组 */
@property(nonatomic, strong) UIColor                     *titleColor UI_APPEARANCE_SELECTOR;/**< 颜色 */
@property(nonatomic, strong) UIColor                     *itemBackgourndColor UI_APPEARANCE_SELECTOR;/**< 背景颜色 */
@property(nonatomic, strong) UIColor                     *arrowsBackgourndColor UI_APPEARANCE_SELECTOR;/**< 箭头和整个背景颜色 默认clear */

@property(nonatomic, strong) UIColor                     *lineColor UI_APPEARANCE_SELECTOR;/**< 分割线颜色 */
@property(nonatomic, copy) void(^onSelctedItemHandle)(STPopMenuViewController * menuVc,NSInteger index,NSString * chosedTitle)           ;/**< 回调 */
- (instancetype)initWithSize:(CGSize)size targetView:(UIView*)targetView;

//设置单个颜色
- (void)setItemColor:(UIColor*)color atIndex:(NSInteger)index;
@end
