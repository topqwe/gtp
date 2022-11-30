//
//  InputPWPopUpView.h
//  HHL
//
//  Created by GT on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AccountingView : UIView
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
