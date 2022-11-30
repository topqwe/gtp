//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostAppealVM.h"


static NSString *PostAppealSectionHeaderReuseIdentifier = @"PostAppealSectionHeaderView";

static NSString *PostAppealSectionFooterReuseIdentifier = @"PostAppealSectionFooterView";

@interface PostAppealSectionHeaderView : UITableViewHeaderFooterView
- (void)richElementsInViewWithModel:(id)model;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;

+ (CGFloat)viewHeight;
@end




@interface PostAppealSectionFooterView : UITableViewHeaderFooterView

- (void)richElementsInViewWithModel:(id)model;
+ (void)sectionFooterViewWith:(UITableView*)tableView;
- (void)actionBlock:(TwoDataBlock)block;
+ (CGFloat)viewHeightWithType:(IndexSectionType)type;

@end
