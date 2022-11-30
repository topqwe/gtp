//
//  STXingXIngView.h
//  GodHorses
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************评价星星******************/
@interface STXingXIngView : UIView
@property(nonatomic, assign) NSInteger                     chosedNum;
@property(nonatomic, copy)   void(^itemActionHandle)(UIButton * button);/**< 点击回调 */
- (instancetype)initWithFrame:(CGRect)frame maxsNum:(NSInteger)maxsNum;
//传入几颗星星点亮
- (void)st_makeXingXingSelectedWithNum:(NSInteger)num;
@end
