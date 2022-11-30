//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExchangeSubData;
@interface ExchangeStatusCell : UITableViewCell

+(CGFloat)cellHeightWithModel:(ExchangeSubData*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(ExchangeSubData*)model;
@end
