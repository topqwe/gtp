//
//  SlideBarCell.h
//  SlideTabBar
//
//  Created by Mr.LuDashi on 15/6/30.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSSlideCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tipTitle;
+(instancetype)cellWith:(UITableView*)tabelView;
+(CGFloat)cellHeightWithModelWithType:(NSInteger)accountType WithModel:(id)model;

- (void)richElementsInCellWithType:(NSInteger)accountType WithModel:(id)model;
@end
