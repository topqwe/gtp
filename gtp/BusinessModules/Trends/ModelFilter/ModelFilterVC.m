//
//  ModelFilterVCViewController.m
//  HHL
//
//  Created by GT on 2019/1/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import "ModelFilterVC.h"
#import "ModelFilter.h"
@interface ModelFilterVC ()

@end

@implementation ModelFilterVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    ModelFilterVC *vc = [[ModelFilterVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    ModelFilter* m = [[ModelFilter alloc]init];
    [m filteredSameStringAndAssembleDifferentStringToIndividualArray];
    [m setFilteredAarryForSameKeyValue];
    [m setFilteredLastStringForSameKey];
    [m setFilteredAndDescendingSameStringToArrForSameKey];
    
    NSInteger bValue = [m binarySearchArray:@[@(3500),@(3300),@(30000),@(3100),@(35000),@(80000),@(45000),@(46000),@(50000),@(85000),@(86000)] withSelectedAmt:187000];
    [YKToastView showToastText:[NSString stringWithFormat:@"二分查找出数组中比给出数最近低的数%li",(long)bValue]];
    NSLog(@"二分查找出数组中比给出数最近低的数%li",(long)bValue);//86000
}


@end
