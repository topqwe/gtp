//
//  TableViewCell.h
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
- (void)actionBlock:(ActionBlock)block;
+(instancetype)cellWith:(UITableView*)tabelView;
+ (CGFloat)cellHeightWithModel:(NSArray*)model;
- (void)richElementsInCellWithModel:(NSArray*)model;
@end
