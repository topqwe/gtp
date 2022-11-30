//
//  DraggableCView.h
//  PLLL
//

#import <UIKit/UIKit.h>

@interface DraggableCView : UIView

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(NSDictionary*)model;
- (void)rotateModel:(NSDictionary*)model;
- (void)showInView:(UIView *)contentView;
- (void)disMissView;
@end
