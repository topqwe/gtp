//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExchangeDetailSubDataItem;
@interface ExchangeDetailCell : UITableViewCell
@property (copy, nonatomic) void(^clickPButtonBlock)(ExchangeDetailSubDataItem* item);
+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(id)paysDic withExchangeType:(ExchangeType)type;
@end
