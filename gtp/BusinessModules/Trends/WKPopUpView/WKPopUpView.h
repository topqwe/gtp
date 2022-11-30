//
//  WKPopUpView.h


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface WKPopUpView : UIView
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model;
- (void)changeContentViewFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
