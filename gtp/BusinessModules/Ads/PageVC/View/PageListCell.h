//
//  SPCell.h
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageItem;
@interface PageListCell : UITableViewCell
- (void)actionBlock:(TwoDataBlock)block;
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(PageItem*)model;
@end
