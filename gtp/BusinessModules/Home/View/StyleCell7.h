//
//  GridCell.h
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCell7 : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UIButton* vBgV;
@property (nonatomic, strong) SelVideoPlayer *player;
@property(nonatomic, strong)UICollectionView *collectionView;
//@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel:(id)dic;
+(instancetype)cellWith:(UITableView*)tabelView;
-(void)richElementsInCellWithModel:(NSDictionary*)dic;
    
@end
