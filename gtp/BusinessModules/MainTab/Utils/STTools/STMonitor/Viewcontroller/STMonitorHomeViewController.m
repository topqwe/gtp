//
//  STMonitorHomeViewController.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorHomeViewController.h"
#import "STMonitorCashViewController.h"
#import "STMonitorDDLogViewController.h"
#import "STMonitorHeader.h"
@interface STMonitorHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView                     *tableView;
@property(nonatomic, strong) UISwitch                       *logSwitch;
@property(nonatomic, strong) UISwitch                       *crashProtectSwitch;/**< 闪退保护开关 */
@property(nonatomic, strong) NSArray                     *dataSouce;
@end

@implementation STMonitorHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug模式";
    [self configSubView];
    [self configNavItem];
    

    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{
    self.logSwitch = [self deflutSwitch];
    bool open = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenDeBugWindowKey];
    [self.logSwitch setOn:open];
    
    self.crashProtectSwitch = [self deflutSwitch];
    bool carshOpen = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenCrashProtectKey];
    [self.crashProtectSwitch setOn:carshOpen];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.dataSouce = @[
                       @{@"title":@"开启实时日志监听(开启之后略微阻塞线程)"},
                       @{@"title":@"开启闪退保护(Beta)"},
                       @{@"title":@"崩溃日志记录"},
                       @{@"title":@"所有日志记录"}];
    [self.tableView reloadData];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, STMC_UIScrenWitdh, 40)];
    label.text = @"共建和谐网络环境";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.stmc_bottom = STMC_UIScrenHeight;
    [self.view addSubview:label];
}
- (void)configNavItem{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(st_rightBarAction:)];
    right.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = right;
}
- (UISwitch*)deflutSwitch{
    UISwitch * switchView = [UISwitch new];
    switchView.onTintColor = STMC_ThemeBackGroundColor;
    [switchView addTarget:self action:@selector(switchViewChangedValue:) forControlEvents:UIControlEventValueChanged];
    return switchView;
}
#pragma --mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * title = @"欢迎来到开发者调试模式,当前环境release";
#if DEBUG
    title = @"欢迎来到开发者调试模式,当前环境debug";
#endif
    return title;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        
    }
    cell.textLabel.textColor = STMC_UIColorFromRGBA(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = STMC_UIColorFromRGBA(0x999999);
    NSDictionary * dic = self.dataSouce[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    if (indexPath.row == 0) {
        cell.accessoryView = self.logSwitch;
    }else  if (indexPath.row == 1) {
        cell.accessoryView = self.crashProtectSwitch;
    }else{
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[STMonitorCashViewController new] animated:YES];
    }
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[STMonitorDDLogViewController new] animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --Action Method
- (void)st_rightBarAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)switchViewChangedValue:(UISwitch*)sender{
    if (sender == self.logSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:isOpenDeBugWindowKey];
    }
    if (sender == self.crashProtectSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:isOpenCrashProtectKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[STMonitorLogManger manger] beginMonitorIndicatiorViewJudge];
}
@end
