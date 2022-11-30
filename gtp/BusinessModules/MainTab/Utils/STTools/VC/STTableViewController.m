//
//  STTableViewController.m
//  SportClub
//
//  Created by stoneobs on 16/7/28.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define STBACKROUND_COLOR  STRGB(0xf1f2f7)

#import "STTableViewController.h"
@interface STTableViewController()

@end
@implementation STTableViewController
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (instancetype)initWithStyle:(UITableViewStyle )style
{
    if (self == [super init]) {
        [self loadTableViewWithStyle:style];
    }
    return self;
}
- (CGFloat)insetX
{
    //箭头大小（15，15）,detalilable 距离箭头固定5；
    if ([UIScreen mainScreen].bounds.size.width > 539) {
        return 20.0;//基本大于=6p的大小就20 ，其余15
    }
    return 15;
}
-(void)loadView
{
    [super loadView];
    [self.view addSubview:self.tableView];
}
- (void)loadTableViewWithStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:style];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = STBACKROUND_COLOR;
    self.tableView.separatorColor = STRGB(0xe0e4e5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self loadTableViewWithStyle:UITableViewStyleGrouped];
    }
    return self;
}
//如果设置了估计高度，则设置高度无效
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(tableView:heightForRowAtIndexPath:)) {
        if (self.tableView.estimatedRowHeight) {
            return NO;
        }else{
            return YES;
        }
        
    }
    return [super canPerformAction:action withSender:sender];
}
#pragma mark --vc 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    //适配
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (ios11 && [self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        [self.tableView setContentInsetAdjustmentBehavior:@(2)];
    }
    if (ios11) {
        UIWindow * window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.top) {
           
        }
    }
    
    BOOL isIphoneX = NO;
    if (ios11) {
        UIWindow * window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.bottom) {
            isIphoneX = YES;
        }
    }
    CGFloat navBarBootom;
    CGFloat tabbarTop;
    if (isIphoneX) {
        navBarBootom = 88;
        tabbarTop = UIScreenHeight - 83;
    }else{
        navBarBootom = 64;
        tabbarTop = UIScreenHeight - 49;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(navBarBootom, 0, (UIScreenHeight - tabbarTop)-49, 0);
    self.tableView.contentInset = inset;
    if (self == self.navigationController.childViewControllers.firstObject) {
        //首页
        self.tableView.contentInset = UIEdgeInsetsMake(navBarBootom, 0, (UIScreenHeight -tabbarTop),0);
    }
    self.view.backgroundColor = UIColor.whiteColor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)automaticallyAdjustsScrollViewInsets{
    if (automaticallyAdjustsScrollViewInsets == NO) {
        self.tableView.contentInset  = UIEdgeInsetsZero;
    }
    [super setAutomaticallyAdjustsScrollViewInsets:automaticallyAdjustsScrollViewInsets];
    
}
#pragma --mark UITableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    cell.textLabel.textColor = STRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = STRGB(0x999999);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

