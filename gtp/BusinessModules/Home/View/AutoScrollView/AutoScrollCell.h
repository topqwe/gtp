
#import <UIKit/UIKit.h>

@interface AutoScrollCell : UITableViewCell

+(CGFloat)cellHeightWithModel:(id)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(id)model;
@end
