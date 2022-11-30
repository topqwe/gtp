//
//  AccountTagView.h


#import <UIKit/UIKit.h>

@interface AccountTagView : UIView

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(NSArray*)model;
- (void)showInView:(UIView *)contentView;
- (void)disMissView;
@end
