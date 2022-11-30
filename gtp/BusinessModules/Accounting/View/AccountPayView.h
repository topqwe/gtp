//
//  AccountTagView.h


#import <UIKit/UIKit.h>

@interface AccountPayView : UIView

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(NSArray*)model;
- (void)showInView:(UIView *)contentView;
- (void)disMissView;
@end
