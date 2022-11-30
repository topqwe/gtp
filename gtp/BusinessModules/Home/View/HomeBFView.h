//
//  PHPapaSectionHeaderView.h
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVM.h"

static NSString *HomeBFViewReuseIdentifier = @"HomeBFView";


@interface HomeBFView : UITableViewHeaderFooterView
- (void)richElementsInViewWithModel:(id)model;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
+ (CGFloat)viewHeight:(id)model;
- (void)actionBlock:(TwoDataBlock)block;
@end
