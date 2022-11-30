//
//  CollectionCell.h
//  SegmentController
//
//  Created by mamawang on 14-6-10.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionAndQuiltModel.h"
@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
+ (instancetype)cellAtIndexPath:(NSIndexPath*)indexPath inView:(UICollectionView *)collectionView;
-(void)richElementsInCellWithModel:(NSDictionary*)cellModel;
+(CGFloat)cellHeight;
@end
