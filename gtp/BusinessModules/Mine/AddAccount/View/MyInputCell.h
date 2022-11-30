//
//  MyInputCell.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyInputCell : UITableViewCell
@property (nonatomic, strong) UILabel * titleLb;
@property (nonatomic, strong) UITextField * inputTF;
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row;
- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row WithAllSourceSum:(NSInteger)sum;
- (void)richElementsInNotYetVertifyCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row;
- (void)actionBlock:(TwoDataBlock)block;
@end

NS_ASSUME_NONNULL_END
