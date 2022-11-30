//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *AccountStatedSectionHVReuseIdentifier = @"AccountStatedSectionHV";


@interface AccountStatedSectionHV : UITableViewHeaderFooterView


+ (void)sectionHeaderViewWith:(UITableView*)tableView;

- (void)richElementsInViewWithModel:(NSDictionary*)model;
+ (CGFloat)viewHeight;

- (void)richElementsInBalanceSourceHVWithModel:(NSDictionary*)model;
+ (CGFloat)balanceSourceHVHeight;
@end
