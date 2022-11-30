//
//  InputPWPopUpView.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomListPopUpView : UIView
- (void)richElementsInViewWithModel:(NSArray*)model withTitle:(NSString*)tit withSectionHeaderTitle:(NSString*)sTit;//:(id)paysDic
- (void)actionBlock:(ActionBlock)block;
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
