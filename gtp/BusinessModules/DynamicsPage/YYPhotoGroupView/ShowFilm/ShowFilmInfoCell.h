//
//  SPCell.h
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShowFilmInfoCell : UITableViewCell
+(CGFloat)cellHeightWithModel:(HomeItem*)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)actionBlock:(ActionBlock)block;
- (void)richElementsInCellWithModel:(HomeItem*)model;
@end
