//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DataStatisticsVM.h"

static NSString *PostAdsDetailSectionHeaderReuseIdentifier = @"PostAdsDetailSectionHeaderView";
static NSString *PostAdsDetailSectionFooterReuseIdentifier = @"PostAdsDetailSectionFooterView";

@interface PostAdsDetailSectionHeaderView : UITableViewHeaderFooterView

+ (CGFloat)viewHeight;
- (void)setDataWithType:(PostAdsDetailType)type withTitle:(NSString*)title  withSubTitle:(NSString*)subTitle withImg:(NSString*)img;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
@property (copy, nonatomic) void(^clickSectionBlock)(NSString* sec);

@end

@interface PostAdsDetailSectionFooterView : UITableViewHeaderFooterView

- (void)setDataWithType:(PostAdsDetailType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle;
+ (void)sectionFooterViewWith:(UITableView*)tableView;

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)viewHeightWithType:(PostAdsDetailType)type;

@end
