//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeDetailVM.h"
static NSString *ExchangeDetailSectionHeaderReuseIdentifier = @"ExchangeDetailSectionHeaderView";
static NSString *ExchangeDetailSectionFooterReuseIdentifier = @"ExchangeDetailSectionFooterView";

@interface ExchangeDetailSectionHeaderView : UITableViewHeaderFooterView
+ (CGFloat)viewHeight;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
@end

@interface ExchangeDetailSectionFooterView : UITableViewHeaderFooterView

- (void)setDataWithType:(ExchangeType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle;
+ (void)sectionFooterViewWith:(UITableView*)tableView;

- (void)moreActionBlock:(DataBlock)block;
+ (CGFloat)viewHeightWithType:(ExchangeType)type;

@end
