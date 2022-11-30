#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TurntableView : UIView
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin;
- (void)actionBlock:(ActionBlock)block;
- (void)richElementsInViewWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
