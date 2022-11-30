
//
//  SVFindViewController.m
//  sixnineVideo
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 猪八戒. All rights reserved.
//

#import "BVMovieViewController.h"
#import "SVFindTableViewCell.h"
@interface BVMovieViewController ()<ZFPlayerDelegate>
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**< <##> */
@property(nonatomic, weak) ZFPlayerView                     *lastplayerView;/**< <##> */
@end

@implementation BVMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self vhl_setNavBarHidden:YES];
    [self vhl_setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.pagingEnabled = YES;
    self.tableView.backgroundColor = UIColor.blackColor;
    
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    [self sendFindRequest];
    self.tabBarController.tabBar.backgroundColor = UIColor.clearColor;
    self.tabBarController.tabBar.backgroundImage =  [self imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
    self.tabBarController.tabBar.shadowImage = [UIImage new];
    self.tabBarController.selectedIndex = 1;
};

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.lastplayerView pause];
    NSArray * array = [self.tableView visibleCells];
    for (SVFindTableViewCell * ecell in array) {
        [ecell.playerView pause];
    }
    self.tabBarController.tabBar.backgroundColor = UIColor.whiteColor;
    self.tabBarController.tabBar.barTintColor = UIColor.whiteColor;
}
#pragma --mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSouce.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SVFindTableViewCell.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier =  @"cell";
    SVFindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SVFindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    BVVideoEasyModel * model = self.dataSouce[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
 
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    SVFindTableViewCell * fcell  = (id)cell;
    [fcell.playerView pause];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = self.tableView.contentOffset.y / (UIScreenHeight-0.01);
    SVFindTableViewCell * fcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:page]];
    
    [self.lastplayerView pause];
    NSArray * array = [self.tableView visibleCells];
    for (SVFindTableViewCell * ecell in array) {
        [ecell.playerView pause];
    }
    
    self.lastplayerView = fcell.playerView;
    fcell.playerView.delegate = self;

    [fcell.playerView play];
    return;
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.top = UIScreenHeight;
    }];
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BVVideoEasyModel * model = self.dataSouce[indexPath.section];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    if (self.tabBarController.selectedIndex != 1) {
        //防止切换到其他页面，tabbar 消失
        return;
    }
    return;
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.top = UIScreenHeight;
    }];
}
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    return;
    if (self.lastplayerView.controlView == controlView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.top = TMUtils.tabBarTop;
        }];
    }

}

#pragma mark --Action Method
- (void)st_rightBarAction:(id)sender{
   
}
#pragma mark --NetWork Method
- (void)sendFindRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Get/videoList"];
    [paramDic setObject:@"100" forKey:@"limit"];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
      method:STHttpRequestTypePost
  parameters:paramDic
     success:^(NSURLSessionDataTask *operation, id responseObject) {
         //                                                 [SVProgressHUD dismiss];
         
         NSArray * array = responseObject[@"data"][@"list"];
         array = [NSArray st_safeArrayWithValue:array];
         NSArray * dataSouce = [BVVideoEasyModel mj_objectArrayWithKeyValuesArray:array];
         if (self.page == 1) {
             self.dataSouce = dataSouce.mutableCopy;
             
         }else{
             if (dataSouce.count) {
                 [self.dataSouce addObjectsFromArray:dataSouce];
                 [self.tableView.mj_footer endRefreshing];
             }else{
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
             }
             
         }
//                                                 self.lastplayerView = nil;
         [self.tableView setContentOffset:CGPointMake(0, self.dataSouce.count/2 * UIScreenHeight) animated:NO];
         [self scrollViewDidEndDecelerating:self.tableView];
         [self.tableView reloadData];
         
         [self.tableView.mj_header endRefreshing];
         // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
         
         DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
         
         
     } failure:^(NSString *stateCode, STError *error,NSError *originError) {
         //                                                 [SVProgressHUD dismiss];
         DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                    url,paramDic,error.desc,error.code);
         [self.tableView.mj_header endRefreshing];
     }];
}
@end
