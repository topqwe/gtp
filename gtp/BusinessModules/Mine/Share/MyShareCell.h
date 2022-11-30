//

#import <UIKit/UIKit.h>

@interface MyShareCell : UITableViewCell

+(instancetype)cellWith:(UITableView*)tabelView;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(HomeItem*)model;
- (void)richElementsInLevelListCellWithModel:(HomeItem*)model;
- (void)richElementsInMsgHomeListCellWithModel:(HomeItem*)model;
@end
