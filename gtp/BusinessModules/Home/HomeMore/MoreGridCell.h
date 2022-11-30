//
//  GridCell.h
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreGridCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SelVideoPlayer *player;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign)IndexSectionUIStyle style;
//@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel:(NSArray*)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSArray*)model;
@end
