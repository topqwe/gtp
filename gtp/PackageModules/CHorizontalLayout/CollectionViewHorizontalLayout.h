//
//  CollectionViewHorizontalLayout.h
//  Sanjieyou
//
//  Created by LL on 2018/4/11.
//  Copyright © 2018年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewHorizontalLayout : UICollectionViewFlowLayout
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@property (strong, nonatomic) NSMutableArray *allAttributes;
@end
