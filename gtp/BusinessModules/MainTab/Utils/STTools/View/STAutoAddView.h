//
//  STAutoAddView.h
//  GodHorses
//
//  Created by Mac on 2017/11/18.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/************上平加减按钮，自动计算数字 0 耦合度******************/
@interface STAutoAddView : UIView
@property(nonatomic, strong) UIButton                     *addButton;//+
@property(nonatomic, strong) UITextField                  *textFiled;/**< 默认无法编辑，需要开启交互 */
@property(nonatomic, strong) UIButton                     *reduceButton;//-
@property(nonatomic, copy) BOOL (^autoaddViewWillChangeHandle)(STAutoAddView * autoAddView,NSString *willChangeText);
@property(nonatomic, copy) void (^autoaddViewDidChangeHandle)(STAutoAddView * autoAddView,NSString *didChangeText);
@end
