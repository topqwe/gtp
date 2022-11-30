

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface IntroPopUpView : UIView
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model WithConfig:(id)configModel;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
