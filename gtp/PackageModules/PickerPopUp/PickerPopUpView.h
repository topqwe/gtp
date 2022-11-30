//
//  PickerPopUpView.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerPopUpView : UIView
- (void)richElementsInViewWithModel:(NSArray*)model;//:(id)paysDic
- (void)actionBlock:(ActionBlock)block;
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
