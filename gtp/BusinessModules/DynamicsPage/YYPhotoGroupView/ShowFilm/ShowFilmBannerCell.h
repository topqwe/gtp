//
//  SPCell.h
//  PPOYang
//
//  Created by ok on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShowFilmBannerCell : UITableViewCell
- (void)actionBlock:(TwoDataBlock)block;
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSDictionary*)model;
@end
