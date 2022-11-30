//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostAdsVM.h"


static NSString *ExchangeSectionHeaderReuseIdentifier = @"ExchangeSectionHeaderView";
@protocol ExchangeSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderSubBtnClickTag:(UIButton*)sender;
@end

@interface ExchangeSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<ExchangeSectionHeaderViewDelegate> delegate;

- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title  withSubTitle:(NSString*)subTitle ;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
@property (copy, nonatomic) void(^clickSectionBlock)(NSString* sec);
+ (CGFloat)viewHeight;
@end
