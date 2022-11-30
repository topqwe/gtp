
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeFV : UIView
- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin;
- (void)actionBlock:(ActionBlock)block;
- (void)richElementsInCellWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
