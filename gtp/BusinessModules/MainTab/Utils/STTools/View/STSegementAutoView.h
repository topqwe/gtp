//
//  STSegementAutoView.h
//  WorthWhile
//
//  Created by Mac on 2018/5/12.
//  Copyright © 2018年 stoneobs.icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STSegementAutoView;
typedef void (^STSegementAutoViewSlectedAction)(STSegementAutoView *sender,UIButton* currentSelctedButton);
/************自动单选按钮******************/
@interface STSegementAutoView : UIView
@property(nonatomic,strong)UIColor              *lineColor   UI_APPEARANCE_SELECTOR;/**< //未选中线颜色 */
@property(nonatomic,strong)UIColor              *lineSelectedColor UI_APPEARANCE_SELECTOR;/**< 选中颜色 */
@property(nonatomic,strong)UIColor              *butTitleColor UI_APPEARANCE_SELECTOR;/**< 标题颜色 */
@property(nonatomic,strong)UIColor              *butTitleSelectedColor UI_APPEARANCE_SELECTOR;/**< 标题选中颜色 */

@property(nonatomic,strong)UIColor              *buttonBackGroundColor UI_APPEARANCE_SELECTOR;/**< 按钮背景颜色 */
@property(nonatomic,strong)UIColor              *buttonSelctedBackGroundColor UI_APPEARANCE_SELECTOR;/**< 按钮选中背景颜色 */


@property(nonatomic,strong)UIView               *lineSelectedView;/**< 如果和scrollview联动，请在scrollview的代理中修改其位置 */
@property(nonatomic,assign)NSInteger            cureentIndex;/**< 当前被选中的index */
@property(nonatomic,assign)BOOL                 autoMoveWithClic;//是否在点击的时候，下方line跟着滑动,这个属性是为了防止多个scrollview联动导致的动画冲突，默认NO

@property(nonatomic)BOOL                        isShowSpringAnimation;//默认yes，是否展示弹性动画

@property(nonatomic, assign) CGFloat                     butonWith;//当设置这个属性时，button的宽度不在是STSegementAutoView除以数量，当出现过多的button 时候 滑动
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray*)titles handle:(STSegementAutoViewSlectedAction)handle;
@end
