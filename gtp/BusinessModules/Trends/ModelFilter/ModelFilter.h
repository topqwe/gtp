//
//  ModelFilter.h
//  TagUtilViews
//
//  Created by WIQ on 2017/4/22.
//  Copyright © 2017年 WIQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFilter : NSObject
- (void)filteredSameStringAndAssembleDifferentStringToIndividualArray;
- (void)setFilteredAarryForSameKeyValue;
- (void)setFilteredLastStringForSameKey;
- (void)setFilteredAndDescendingSameStringToArrForSameKey;
- (NSInteger) binarySearchArray:(NSArray*)levelActivities withSelectedAmt:(NSInteger)selectedAmt;
@end
