//
//  STTableViewController.h
//  SportClub
//
//  Created by stoneobs on 16/7/28.
//  Copyright © 2016年 stoneobs. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface STTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,assign)CGFloat           insetX;//各种屏幕距离屏幕的x值
@property(nonatomic, assign) NSInteger                     page;/**< <##> */
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (instancetype)init;
@end
