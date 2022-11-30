//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostAdsSubDataItem;
@interface PostAdsRestrictCell : UITableViewCell
@property (copy, nonatomic) void(^clickPButtonBlock)(PostAdsSubDataItem* item);
+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(NSDictionary*)paysDic;
@end
