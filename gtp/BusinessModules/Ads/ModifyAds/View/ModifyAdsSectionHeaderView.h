//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyAdsVM.h"

static NSString *ModifyAdsSectionHeaderReuseIdentifier = @"ModifyAdsSectionHeaderView";
static NSString *ModifyAdsSectionFooterReuseIdentifier = @"ModifyAdsSectionFooterView";


@interface ModifyAdsSectionHeaderView : UITableViewHeaderFooterView
+ (CGFloat)viewHeight;
- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title  withSubTitle:(NSString*)subTitle withImg:(NSString*)img;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;

@end

@interface ModifyAdsSectionFooterView : UITableViewHeaderFooterView

- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle;
+ (void)sectionFooterViewWith:(UITableView*)tableView;

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)viewHeightWithType:(IndexSectionType)type;

@end
