//
//  STRadioButton.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  说明：单选框

#import <UIKit/UIKit.h>

@interface STRadioButton : UIView
@property(nonatomic, strong,getter=currentChosedTitle) NSString         *chosedTitle;/**<  当前选中title*/
@property(nonatomic, assign,getter=currentChosedIndex) NSInteger         chosedIndex;/**<  当前选中index，设置之后可以跳转*/
@property(nonatomic, strong) UIColor            *titleColor;//标题颜色
@property(nonatomic, strong) UIColor            *selectedTitleColor;
@property(nonatomic, copy)   void(^onSelctedRadioButton)(STRadioButton *radioButton,NSInteger selectedIndex);
@property(nonatomic, readonly) NSArray                     *buttonArray;/**< 所有按钮 */
//固定itme 宽高，自适应frame
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray*)titles
                     itemSize:(CGSize)itemSize
                    itemInset:(UIEdgeInsets)itemInset;
@end
