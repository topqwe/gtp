//
//  CollectionCell.m
//  SegmentController
//
//  Created by mamawang on 14-6-10.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        // 初始化时加载collectionCell.xib文件
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:self options:nil];
//        
//        // 如果路径不存在，return nil
//        if (arrayOfViews.count < 1)
//        {
//            return nil;
//        }
//        // 如果xib中view不属于UICollectionViewCell类，return nil
//        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
//        {
//            return nil;
//        }
//        // 加载nib
//        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
+ (instancetype)cellAtIndexPath:(NSIndexPath*)indexPath inView:(UICollectionView *)collectionView{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    return cell;
}
-(void)richElementsInCellWithModel:(NSDictionary*)cellModel{
//    [self.imageView setImageWithURL:URLFromString(cellModel.icon) placeholderImage:SQUARE_PLACEDHOLDER_IMG];
    [self.imageView setImage:[UIImage imageNamed:cellModel[kImg]]];
    [self.label setText:cellModel[kArr]];
}
+(CGFloat)cellHeight{
    return 90000000;
}
//+(instancetype)cellWith:(UITableView*)tabelView{
//    GridCell *cell = (GridCell *)[tabelView dequeueReusableCellWithIdentifier:@"GridCell"];
//    if (!cell) {
//        cell = [[GridCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GridCell"];
//    }
//    return cell;
//}

@end
