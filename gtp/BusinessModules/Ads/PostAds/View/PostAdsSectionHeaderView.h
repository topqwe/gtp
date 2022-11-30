//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostAdsVM.h"


static NSString *PostAdsSectionHeaderReuseIdentifier = @"PostAdsSectionHeaderView";
@protocol PostAdsSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderSubBtnClickTag:(UIButton*)sender;
@end

@interface PostAdsSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<PostAdsSectionHeaderViewDelegate> delegate;

- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title  withSubTitle:(NSString*)subTitle ;

- (void)setMddifyAdsDataWithType:(IndexSectionType)type withTitle:(NSString*)title  withSubTitle:(NSString*)subTitle ;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
@property (copy, nonatomic) void(^clickSectionBlock)(NSString* sec);
+ (CGFloat)viewHeight;
@end
