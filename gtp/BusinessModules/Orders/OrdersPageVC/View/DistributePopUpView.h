//
//  DistributePopUpView.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface DistributePopUpView : UIView
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
