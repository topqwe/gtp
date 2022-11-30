//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataStatisticsSubDataItem;
@interface DataStatisticsSlideCell : UITableViewCell
@property (copy, nonatomic) void(^clickPButtonBlock)(DataStatisticsSubDataItem* item);
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSDictionary*)model;
@end
