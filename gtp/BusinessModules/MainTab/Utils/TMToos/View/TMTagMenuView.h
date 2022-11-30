//
//  TMTagMenuView.h
//  STToolsMaker
//
//  Created by Mac on 2018/11/13.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

typedef enum : NSUInteger {
    TMTagMenuViewDirectionHorizontal,
    TMTagMenuViewDirectionVertical,

} TMTagMenuViewDirection;
#import <UIKit/UIKit.h>
/************标签集合view 上下左右间距10******************/
@interface TMTagMenuView : UIView
@property(nonatomic, strong) NSArray                     *allArray;/**< 所有数组 */
@property(nonatomic, strong) NSArray                     *chosedArray;/**< 初始选中数组 */
@property(nonatomic, strong) NSArray                    *finshChosedArray;/**< 当前选中数组 */

@property(nonatomic, assign) CGFloat                     forceButtonWitdh;/**< 固定宽度 */
@property(nonatomic, assign) CGFloat                     forceButtonHeight;/**< 高度 默认40*/
@property(nonatomic, assign) BOOL                     allowsMultipleSelection;/**< 是否可以多选 */


@property(nonatomic,strong)UIColor              *butTitleColor UI_APPEARANCE_SELECTOR;/**< 标题颜色 */
@property(nonatomic,strong)UIColor              *butTitleSelectedColor UI_APPEARANCE_SELECTOR;/**< 标题选中颜色 */

@property(nonatomic,strong)UIColor              *buttonBackGroundColor UI_APPEARANCE_SELECTOR;/**< 按钮背景颜色 */
@property(nonatomic,strong)UIColor              *buttonSelctedBackGroundColor UI_APPEARANCE_SELECTOR;/**< 按钮选中背景颜色 */

@property(nonatomic,strong)UIColor              *buttonBoderColor UI_APPEARANCE_SELECTOR;/**< 按钮边框颜色 */
@property(nonatomic,strong)UIColor              *buttonSelectedBoderColor UI_APPEARANCE_SELECTOR;/**< 按按钮边框颜色 */

@property(nonatomic,strong)UIImage              *buttonBackGroundImage UI_APPEARANCE_SELECTOR;/**< 按钮背景 */
@property(nonatomic,strong)UIImage              *buttonSelectedBackGroundImage UI_APPEARANCE_SELECTOR;/**< 按按选中背景 */

@property(nonatomic, assign) CGFloat                     cornerRadius;/**< 圆角  默认10 */
@property(nonatomic, copy) void(^onSlectedTagView)(TMTagMenuView * tagView,NSString * title,NSInteger index)   ;/**< 点击回调 */

@property(nonatomic, assign)TMTagMenuViewDirection                      direction   ;/**< 默认 TMTagMenuViewDirectionVertical */
@property(nonatomic, assign)CGFloat                      inset   ;/**< 默认 TMTagMenuViewDirectionVertical */
- (void)cancleSelctedAllItem;//取消所有点击事件
- (UIButton*)findButtonWithTitle:(NSString*)title;
@end
