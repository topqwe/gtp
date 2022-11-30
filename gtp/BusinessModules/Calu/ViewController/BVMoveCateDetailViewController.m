//
//  BVMineCollMovieViewController.m
//  BannerVideo
//
//  Created by Mac on 2019/3/27.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVMoveCateDetailViewController.h"
#import "BVMineCollMovieTableViewCell.h"

@interface BVMoveCateDetailViewController ()
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**< <##> */
@end

@implementation BVMoveCateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf =  self;
    self.tableView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 100, UIScreenWidth, 400) title:@"暂无数据" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendListRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf sendListRequest];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma --mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BVMineCollMovieTableViewCell.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier =  @"cell";
    BVMineCollMovieTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[BVMineCollMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    BVVideoEasyModel * model = self.dataSouce[indexPath.row];
    [cell updateMoveListUI];
    cell.model = model;
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BVVideoEasyModel * model = self.dataSouce[indexPath.row];
    [TMUtils gotoVideoDetailWithVideoId:model.v_id];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --NetWork Method
- (void)sendListRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (self.movie_id.length) {
        [paramDic setObject:self.movie_id forKey:@"id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Get/filmCateVideo"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"vdieos"];
                                                 NSArray * objArray = [BVVideoEasyModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (self.page == 1) {
                                                     self.dataSouce = objArray.mutableCopy;
                                                     [self.tableView.mj_header endRefreshing];
                                                     if (objArray.count) {
                                                         self.tableView.mj_footer.hidden = NO;
                                                     }
                                                     
                                                 }else{
                                                     [self.dataSouce addObjectsFromArray:objArray];
                                                     if (objArray.count) {
                                                         [self.tableView.mj_footer endRefreshing];
                                                     }else{
                                                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                     }
                                                 }
                                                 
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 [self.tableView reloadData];
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 [self.tableView.mj_header endRefreshing];
                                                 [self.tableView.mj_footer endRefreshing];
                                                 //                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end
