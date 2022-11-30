//
//  STAreaViewController.h
//  SportHome
//
//  Created by stoneobs on 16/11/11.
//  Copyright © 2016年 zhaowei. All rights reserved.
//  地址选择

#import "STTableViewController.h"
#import "STAreaHeaderView.h"
@interface STAreaViewController : UIViewController
@property(nonatomic, strong) NSString                     *locationCityStr;
@property(nonatomic,copy)STAreaHeaderViewBlock block;
@end
