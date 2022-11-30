//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExchangeSubDataItem;
@interface ExchangeAccountCell : UITableViewCell
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel:(NSString*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(NSString*)model;
@end
