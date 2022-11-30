//
//  BVCateActorViewController.m
//  BannerVideo
//
//  Created by apple on 2019/3/31.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCateActorViewController.h"

@interface BVCateActorViewController ()
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**< <##> */
@property(nonatomic, strong) TMTagMenuView                     *menuView;/**<  */
@property(nonatomic, strong) TMTagMenuView                     *typeView;/**<  */
@property(nonatomic, strong) STNoresultView                     *noresuletView;/**< <##> */
@end

@implementation BVCateActorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, TMUtils.tabBarTop - TMUtils.navgationBarBootom);
    __weak typeof(self) weakSelf =  self;
    [self configTableHeaderView];
    self.noresuletView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.height + 30, UIScreenWidth, 400) title:@"暂无数据" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
    }];
    [self.tableView addSubview:self.noresuletView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendListRequest];
    }];
    [self configFooterView];
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (void)configMJFooter{
    __weak typeof(self) weakSelf =  self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf sendListRequest];
    }];
}
#pragma mark --configSubView
- (void)configTableHeaderView{
    __weak typeof(self) weakSelf =  self;
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
    NSArray * array = @[@"全部",@"人气最高",@"片量最多"];
    if (array.count) {
        TMTagMenuView * menuView = [[TMTagMenuView alloc] initWithFrame:CGRectMake(5, 0, UIScreenWidth - 30, 45 )];
        menuView.cornerRadius = 16;
        menuView.forceButtonHeight = 32;
        menuView.buttonSelectedBoderColor = TM_ThemeBackGroundColor;
        menuView.buttonBoderColor = UIColor.clearColor;;
        
        menuView.buttonBackGroundColor = TM_backgroundColor;
        menuView.buttonSelctedBackGroundColor = TM_ThemeBackGroundColor;
        
        menuView.butTitleColor = FirstTextColor;
        menuView.butTitleSelectedColor = UIColor.whiteColor;
        
        menuView.allArray = array;
        menuView.chosedArray = @[@"全部"];
        
        
        [menuView setOnSlectedTagView:^(TMTagMenuView *tagView, NSString *title, NSInteger index) {
            [weakSelf configMJFooter];
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        self.menuView = menuView;
        [header addSubview:self.menuView];
    }
    
    NSMutableArray * typeArray = NSMutableArray.new;
    ({
        [typeArray addObject:@"全部"];
        [typeArray addObject:@"A"];
        [typeArray addObject:@"B"];
        [typeArray addObject:@"C"];
        [typeArray addObject:@"D"];
        [typeArray addObject:@"E"];
        [typeArray addObject:@"F"];
        [typeArray addObject:@"G"];
        [typeArray addObject:@"H"];
        [typeArray addObject:@"I"];
        [typeArray addObject:@"J"];
        [typeArray addObject:@"K"];
        [typeArray addObject:@"L"];
        [typeArray addObject:@"M"];
        [typeArray addObject:@"N"];
        [typeArray addObject:@"O"];
        [typeArray addObject:@"P"];
        [typeArray addObject:@"Q"];
        [typeArray addObject:@"R"];
        [typeArray addObject:@"S"];
        [typeArray addObject:@"T"];
        [typeArray addObject:@"U"];
        [typeArray addObject:@"V"];
        [typeArray addObject:@"W"];
        [typeArray addObject:@"X"];
        [typeArray addObject:@"Y"];
        [typeArray addObject:@"Z"];
    });
    if (typeArray.count) {
        STLabel * titleLabel = [[STLabel alloc] initWithFrame:CGRectMake(15, self.menuView.bottom , 100, 40)
                                                         text:@"演员姓名:"
                                                   textColor:FirstTextColor
                                                        font:15
                                                 isSizetoFit:NO
                                               textAlignment:NSTextAlignmentLeft];
        [NSString lableAutoAdjustWitdhWithLabel:titleLabel];
        [header addSubview:titleLabel];
        
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(titleLabel.right + 5, self.menuView.bottom - 10 , UIScreenWidth- titleLabel.right - 10, 40)];
        [header addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (ios11 && [scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            [scrollView setContentInsetAdjustmentBehavior:@(2)];
        }
        TMTagMenuView * menuView = [[TMTagMenuView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth - 30,40 )];
        menuView.direction = TMTagMenuViewDirectionHorizontal;
        

        
        menuView.buttonSelectedBoderColor = UIColor.clearColor;
        menuView.buttonBoderColor = UIColor.clearColor;;
        
        menuView.buttonBackGroundColor = UIColor.clearColor;
        menuView.buttonSelctedBackGroundColor = UIColor.clearColor;
        
        menuView.butTitleColor = FirstTextColor;
        menuView.butTitleSelectedColor = TM_ThemeBackGroundColor;
        
        menuView.allArray = typeArray;
        menuView.chosedArray = @[@"全部"];
        
        [scrollView addSubview:menuView];
        scrollView.contentSize = CGSizeMake(menuView.width, 0);
        
        [menuView setOnSlectedTagView:^(TMTagMenuView *tagView, NSString *title, NSInteger index) {
            [weakSelf.tableView.mj_header beginRefreshing];
            [weakSelf configMJFooter];
        }];
        self.typeView = menuView;
        header.height =  scrollView.bottom;
    }
    
    self.tableView.tableHeaderView = header;
}
- (void)configFooterView{
    
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0)];
    NSArray * array = self.dataSouce;
    CGFloat menuWith = UIScreenWidth / 4;
    CGFloat menuheight = 110  ;
    for (NSInteger i = 0; i < array.count; i ++) {
        BVActorModel * model = self.dataSouce[i];
        STMenuControl * menu = [[STMenuControl alloc] initWithFrame:CGRectMake(0, 0, menuWith, menuheight ) imageName:@"" title:model.name titleColor:FirstTextColor];
        menu.left = i%4 * menuWith;
        menu.top = i/4 * menuheight + 20;
        [footer addSubview:menu];
        menu.imageButton.frame = CGRectMake(15, 0, 60,60 );
        menu.imageButton.centerX = menuWith/2;
        menu.imageButton.clipsToBounds = YES;
        menu.imageButton.layer.cornerRadius = (menu.imageButton.height)/2;
        menu.titleLable.height = 30;
        menu.titleLable.top = menu.imageButton.bottom  + 10  ;
        
        [menu.imageButton sd_setImageWithURL:[NSURL URLWithString:model.image]];
        footer.height = menu.bottom ;
        [menu setOnSelctedControl:^(STMenuControl *control) {
            [TMUtils gotoActorDetailWithActorID:model.actor_id];
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
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/performerList"];
    ({
        if ([self.menuView.finshChosedArray.lastObject isEqualToString:@"人气最高"]) {
            url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/performerPopularityList"];
        }
        if ([self.menuView.finshChosedArray.lastObject isEqualToString:@"片量最多"]) {
            url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/performerListByFilmNum"];
        }
    });
    ({
        NSString * title = self.typeView.finshChosedArray.lastObject;
        if (![title isEqualToString:@"全部"]) {
            [paramDic setObject:title forKey:@"letter"];
        }
    });
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"performerList"];
                                                 NSArray * objArray = [BVActorModel mj_objectArrayWithKeyValuesArray:array];
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
                                                 self.noresuletView.hidden = self.dataSouce.count;
                                                 [self configFooterView];
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
