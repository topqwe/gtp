//
//  InputPWPopUpView.h
//  HHL
//
//  Created by WIQ on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputPWPopUpView : UIView
- (void)richElementsInViewWithModel;//:(id)paysDic
- (void)actionBlock:(ActionBlock)block;
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
