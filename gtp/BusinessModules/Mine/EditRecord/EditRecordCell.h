//
//  TableViewCell.h
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRecordCell : UITableViewCell

+(instancetype)cellWith:(UITableView*)tabelView;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(HomeItem*)model;
@end
