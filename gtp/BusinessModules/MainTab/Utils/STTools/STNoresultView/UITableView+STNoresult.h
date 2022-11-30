//
//  UITableView+ST_Noresult.h
//  TMGold
//
//  Created by stoneobs on 2017/12/25.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>
/************<##>无数据view******************/
@interface UITableView (STNoresult)
- (STNoresultView*)st_noreslutView;
- (void)setSt_noreslutView:(STNoresultView*)st_noreslutView;
@end
