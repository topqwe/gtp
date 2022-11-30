//
//  STMonitorCashViewController.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorDDLogViewController.h"
#import "STMonitorHeader.h"
#import "STMCTableEasyModel.h"
#import "STMonitorLookPresentViewController.h"
@interface STMonitorDDLogViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView                     *tableView;
@property(nonatomic, strong) NSArray                     *dataSouce;
@property(nonatomic, strong) NSArray                     *originLogsPath;
@property(nonatomic, strong) STMCTableEasyModel                     *selectedModel;
@property(nonatomic, strong) UIButton                     *shareAllButton;/**< <##> */
@end

@implementation STMonitorDDLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DDLog日志记录";
    [self configSubView];
    [self configfooter];
    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    NSArray * array = [STMonitorLogManger manger].allDDLogsPaths;
    self.originLogsPath = array;
    DDLogInfo(@"日志path数组%@",array);
    NSMutableArray * models = [NSMutableArray new];
    for (NSInteger i = 0;i< array.count;i++ ) {
        NSString * name = array[i];
        NSString * finshPath = [name componentsSeparatedByString:@"/"].lastObject;
       STMCTableEasyModel * model =  [[STMCTableEasyModel alloc] initWithTextString:finshPath detailString:@""];
        model.accessoryType = UITableViewCellAccessoryNone;
        if (i == array.count - 1) {
            model.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedModel = model;
        }
        [models addObject:model];
    }
    self.dataSouce = [models copy];
    [self.tableView reloadData];
}
#pragma mark --subView
- (void)configfooter{
    __weak typeof(self) weakSelf =  self;
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STMC_UIScrenWitdh, 100)];
    footer.backgroundColor = self.tableView.backgroundColor;
    
    UIButton * confimButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, 150 , 44)];
    [confimButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    confimButton.titleLabel.font = [UIFont systemFontOfSize:18];
    confimButton.layer.cornerRadius = 10;
    confimButton.clipsToBounds = YES;
    [confimButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confimButton setTitle:@"查看选中日志" forState:UIControlStateNormal];
    confimButton.backgroundColor = UIColor.brownColor;
    [confimButton addTarget:self action:@selector(catCurrentLog) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:confimButton];
    

    
    UIButton * shareAllButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, 150 , 44)];
    [shareAllButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    shareAllButton.titleLabel.font = [UIFont systemFontOfSize:18];
    shareAllButton.layer.cornerRadius = 10;
    shareAllButton.clipsToBounds = YES;
    [shareAllButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareAllButton setTitle:@"传输选中日志" forState:UIControlStateNormal];
    shareAllButton.backgroundColor = UIColor.brownColor;
    shareAllButton.stmc_right = STMC_UIScrenWitdh - 30;
    [shareAllButton addTarget:self action:@selector(uploadAllLogs) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:shareAllButton];
    self.shareAllButton = shareAllButton;
    
    self.tableView.tableFooterView = footer;
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
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = STMC_UIColorFromRGBA(0x999999);
    STMCTableEasyModel * model = self.dataSouce[indexPath.row];
    [cell setStmc_tableEasyModel:model];
    cell.accessoryType = model.accessoryType;
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    STMCTableEasyModel * model = self.dataSouce[indexPath.row];
    for (STMCTableEasyModel * existModel in self.dataSouce) {
        existModel.accessoryType = UITableViewCellAccessoryNone;
    }
    model.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedModel = model;
    [self.tableView reloadData];
    
}

#pragma mark --Action Method
- (void)catCurrentLog{
    if (!self.selectedModel) {
        //[SVProgressHUD showInfoWithStatus:@"您还没有选择任何日志"];
    }else{

        STMonitorLookPresentViewController * vc = [STMonitorLookPresentViewController new];
        vc.logs = @"加载中";
        [self presentViewController:vc animated:NO completion:nil];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            
            NSInteger index = [self.dataSouce indexOfObject:self.selectedModel];
            NSString * path = self.originLogsPath[index];
            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            vc.logs = str;

        });


    }

}
- (void)uploadAllLogs{
    //分享 微信无法打开多个分享
    if (!self.selectedModel) {
        //[SVProgressHUD showInfoWithStatus:@"您还没有选择任何日志"];
    }else{
        NSInteger index = [self.dataSouce indexOfObject:self.selectedModel];
        NSString * path = self.originLogsPath[index];
        NSURL *urlToShare = [NSURL fileURLWithPath:path];
        NSArray *activityItems = @[urlToShare];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [controller setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (activityError) {
                //[SVProgressHUD showErrorWithStatus:activityError.description];
            }
        }];
        //防止ipad crash
        UIPopoverPresentationController *popover = controller.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.shareAllButton;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }

}
@end

