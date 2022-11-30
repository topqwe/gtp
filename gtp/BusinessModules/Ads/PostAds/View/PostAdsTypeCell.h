//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WItem;
@interface PostAdsTypeCell : UITableViewCell
@property (copy, nonatomic) void(^clickPButtonBlock)(WItem* item);
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSArray*)model;
@end
