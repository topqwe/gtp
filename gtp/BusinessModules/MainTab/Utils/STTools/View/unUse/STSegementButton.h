//
//  STSegementButton.h
//  lover
//
//  Created by Cymbi on 16/4/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  单选按钮segement样式

#import <UIKit/UIKit.h>
@class STSegementButton;
typedef void (^STSegementButtonSlectedAction)(STSegementButton *sender);
@interface STSegementButton : UIControl
@property(nonatomic,strong)UIColor              *lineColor;//未选中线颜色
@property(nonatomic,strong)UIColor              *lineSelectedColor;//选中颜色
@property(nonatomic,strong)UIColor              *butTitleColor;//标题颜色
@property(nonatomic,strong)UIColor              *butTitleSelectedColor;
@property(nonatomic,strong)UIColor              *buttonBackGroundColor;//按钮颜色
@property(nonatomic,strong)UIView               *lineSelectedView;//如果和scrollview联动，请在scrollview的代理中修改其位置

@property(nonatomic,assign)NSInteger            cureentIndex;//当前被选中
@property(nonatomic,assign)BOOL                 autoMoveWithClic;//是否在点击的时候，下方line跟着滑动,默认yes,这个属性是为了防止多个scrollview联动导致的动画冲突，默认NO

@property(nonatomic)BOOL                        isShowSpringAnimation;//默认yes，是否展示弹性动画

@property(nonatomic, assign) NSInteger                     maxNum;//超过这个值滑动
@property(nonatomic, assign) CGFloat                     butonWith;//一起设置有效
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray*)titles handle:(STSegementButtonSlectedAction)handle;
@end
