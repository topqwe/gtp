//
//  STMonitorCashViewController.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorCashViewController.h"
#import "STMonitorHeader.h"
#import "STMonitorLookPresentViewController.h"
@interface STMonitorCashViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView                     *tableView;
@property(nonatomic, strong) NSArray                     *dataSouce;
@property(nonatomic, strong) UIButton                     *rightButton;/**<  */
@end

@implementation STMonitorCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"崩溃日志记录";
    [self configSubView];
    [self configFooterView];
    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.dataSouce = @[
                       @{@"title":@"查看崩溃日志"}];
    [self.tableView reloadData];
}
- (void)configFooterView{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton addTarget:self action:@selector(st_rightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"传输" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.rightButton.backgroundColor = STMC_ThemeBackGroundColor;
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.rightButton.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH - 80, 44);
    self.rightButton.layer.cornerRadius = 10;
    self.rightButton.clipsToBounds = YES;
    [self.rightButton addTarget:self action:@selector(st_rightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
    header.backgroundColor = UIColor.whiteColor;
    self.rightButton.stmc_centerX = MAINSCREEN_WIDTH / 2;
    self.rightButton.stmc_centerY = 50;
    [header addSubview:self.rightButton];
    self.tableView.tableFooterView = header;
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
    return @"可以使用隔空投送传输或者分享到汤姆科技微信技术群,会有专业的程序员为您服务";
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    STMonitorLookPresentViewController * vc = [STMonitorLookPresentViewController new];
    vc.logs = @"加载中。。。。。";
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSString *log = [[STMonitorCrashManger defult].crashArray componentsJoinedByString:@"#\n#"];
        vc.logs = log;
    });
    [self presentViewController:vc animated:NO completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --Action Method
- (void)st_rightBarAction:(id)sender{
   //分享
    NSURL *urlToShare = [NSURL fileURLWithPath: [STMonitorCrashManger defult].currentCashPath];
    NSArray *activityItems = @[urlToShare];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [controller setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (activityError) {
            DDLogError(@"%@",activityError.description);
        }
    }];
    //防止ipad crash
    UIPopoverPresentationController *popover = controller.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.rightButton;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:controller animated:YES completion:nil];
}


@end
