//
//  BVCateActorViewController.m
//  BannerVideo
//
//  Created by apple on 2019/3/31.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCateMovieViewController.h"
#import "BVCateMovieModel.h"
#import "BVMoveCateDetailViewController.h"
@interface BVCateMovieViewController ()
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**< <##> */
@property(nonatomic, strong) STNoresultView                     *noresuletView;/**< <##> */
@end

@implementation BVCateMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, TMUtils.tabBarTop - TMUtils.navgationBarBootom);
    __weak typeof(self) weakSelf =  self;
    self.noresuletView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.height + 30, UIScreenWidth, 400) title:@"暂无数据" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
    }];
    [self.tableView addSubview:self.noresuletView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendListRequest];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.page ++ ;
//        [weakSelf sendListRequest];
//    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (void)configFooterView{
    __weak typeof(self) weakSelf =  self;
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0)];
    NSArray * array = self.dataSouce;
    CGFloat menuWith = UIScreenWidth / 3;
    CGFloat menuheight = 200  ;
    for (NSInteger i = 0; i < array.count; i ++) {
        BVCateMovieModel * model = self.dataSouce[i];
        STMenuControl * menu = [[STMenuControl alloc] initWithFrame:CGRectMake(0, 0, menuWith, menuheight ) imageName:@"" title:model.name titleColor:FirstTextColor];
        menu.left = i%3 * menuWith;
        menu.top = i/3 * menuheight + 5;
        [footer addSubview:menu];
        menu.imageButton.frame = CGRectMake(5, 0, menuWith-10,menuheight-30 );
        menu.imageButton.centerX = menuWith/2;
        menu.imageButton.clipsToBounds = YES;
        menu.imageButton.layer.cornerRadius = 4;
        menu.titleLable.height = 30;
        menu.titleLable.top = menu.imageButton.bottom;
        
        [menu.imageButton sd_setImageWithURL:[NSURL URLWithString:model.image]];
        footer.height = menu.bottom ;
        [menu setOnSelctedControl:^(STMenuControl *control) {
            BVMoveCateDetailViewController * vc = BVMoveCateDetailViewController.new;
            vc.movie_id = model.cat_id;
            vc.title = model.name;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        footer.height = menu.bottom + 20;
    }
    self.tableView.tableFooterView = footer;
    [self.tableView reloadData];
    
}
#pragma mark --NetWork Method
- (void)sendListRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Get/filmCateList"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 //                                                 [STNetWrokManger shownNormalRespMsgWithResponse:responseObject];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"cates"];
                                                 NSArray * objArray = [BVCateMovieModel mj_objectArrayWithKeyValuesArray:array];
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
                                                 [self configFooterView];
                                                 self.noresuletView.hidden = self.dataSouce.count;
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
