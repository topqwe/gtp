//
//  UIResponder+STFeedbackGenerator.h
//  togetherPlay
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 stoneobs.qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************触感反馈 拥有3dTouch功能者ios10 以上可使用******************/
NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (STFeedbackGenerator)

/**
 展示通知 成功 警告 错误 反馈

 @param type type description
 */
- (void)st_showNotificationFeedback:(UINotificationFeedbackType)type;

/**
 展示触感反馈 低 中 高

 @param style style description
 */
- (void)st_showImpactFeedbackGenerator:(UIImpactFeedbackStyle)style;


/**
 展示picker滚轮效果
 */
- (void)st_showSelectionFeedbackGenerator;
@end

NS_ASSUME_NONNULL_END
