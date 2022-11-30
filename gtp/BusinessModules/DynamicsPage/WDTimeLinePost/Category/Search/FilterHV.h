 
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterHV : UIView
- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin;
- (void)actionBlock:(ActionBlock)block;
- (void)richElementsInCellWithModel:(id)model WithDummy0Datas:(NSArray*)dummy0Datas;
-(void)richOnlyElementsInCellWithModel:(id)model didDefaultSelectFirst:(BOOL)didDefaultSelectFirst didAllowsInvertSelection:(BOOL)didAllowsInvertSelection;
@end

NS_ASSUME_NONNULL_END
