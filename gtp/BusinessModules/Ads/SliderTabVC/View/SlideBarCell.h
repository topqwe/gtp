//
//  SlideBarCell.h
//  SlideTabBar
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideBarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tipTitle;
+(instancetype)cellWith:(UITableView*)tabelView;
+(CGFloat)cellHeightWithModelWithType:(NSInteger)accountType WithModel:(NSArray*)model;

- (void)richElementsInCellWithType:(NSInteger)accountType WithModel:(NSArray*)model;
@end
