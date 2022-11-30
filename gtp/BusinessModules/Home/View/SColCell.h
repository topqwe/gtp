//
//  CollectionCell.h
//  SegmentController
//
//  Created by mamawang on 14-6-10.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SColCell : UICollectionViewCell

@property(nonatomic, strong) UIView* vBgV;

@property(nonatomic,strong)UIButton * menuBtn;
-(void)hideHorLabShowTitBut:(BOOL)isHidden;
@property(nonatomic, assign)IndexSectionUIStyle style;
+ (instancetype)cellAtIndexPath:(NSIndexPath*)indexPath inView:(UICollectionView *)collectionView;
-(void)richElementsInCellWithModel:(id)cellModel;
+(CGFloat)cellHeight;
@property(nonatomic, strong) UIButton* contentBgV;
-(void)handleEVCell;
-(void)handleSRCell;
-(void)handleSSCell;
@end
