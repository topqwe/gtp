//
//  SVAllCateViewController.m
//  sixnineVideo
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 猪八戒. All rights reserved.
//

#import "BVAllCateVideoViewController.h"
#import "BVVideoCollectionViewCell.h"
@interface BVAllCateVideoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property(nonatomic, strong) UICollectionView                     *collectionView;/**< coll */
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**< 数据源 */

@property(nonatomic, strong) NSMutableArray                     *menuArray;/**< 菜单栏 */
@property(nonatomic, strong) TMTagMenuView                     *subMenuView;/**< 副菜单 */
@property(nonatomic, assign) NSInteger                     page;/**< <##> */
@end

@implementation BVAllCateVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.view.backgroundColor = UIColor.whiteColor;
    [self sendHomeCategoryRequest];
    // Do any additional setup after loading the view.
}
#pragma mark --configSubView
- (void)configSubView{
    __weak typeof(self) weakSelf =  self;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, TMUtils.navgationBarBootom, UIScreenWidth,65)];
    headerView.backgroundColor = UIColor.whiteColor;
    [headerView st_showBottomShadow];
    [self.view addSubview:headerView];
    
    //配置
    UIColor *bgColor = TM_ThemeBackGroundColor;
    ({
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 65)];
        [headerView addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (ios11 && [scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            [scrollView setContentInsetAdjustmentBehavior:@(2)];
        }
        NSArray * titlesArray = [self.menuArray st_arrayFromObjKeyName:@"obj.name"];
        if (!titlesArray.count) {
            return;
        }
        TMTagMenuView * menuView = [[TMTagMenuView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth - 30, 45 )];
        menuView.direction = TMTagMenuViewDirectionHorizontal;
        //        menuView.allArray = @[@"综合",@"美少女",@"五码",@"火影忍者",@"知否知否",@"昨夜雨疏风骤",@"波多野结衣"];
        
        
        menuView.buttonSelectedBoderColor = UIColor.clearColor;
        menuView.buttonBoderColor = UIColor.clearColor;;
        
        menuView.buttonBackGroundColor = UIColor.clearColor;
        menuView.buttonSelctedBackGroundColor = bgColor;
        
        
        menuView.allArray = titlesArray;
        
        menuView.cornerRadius = 20;
        
        
        
        menuView.butTitleColor = FirstTextColor;
        menuView.butTitleSelectedColor = UIColor.whiteColor;
        
        
        
        [scrollView addSubview:menuView];
        scrollView.contentSize = CGSizeMake(menuView.width, 0);
        
        [menuView setOnSlectedTagView:^(TMTagMenuView *tagView, NSString *title, NSInteger index) {
            [weakSelf.collectionView.mj_header beginRefreshing];
            weakSelf.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakSelf.page ++ ;
                [weakSelf sendCateListRequest];
            }];
        }];
        self.subMenuView = menuView;
        
        if (self.cateName) {
            menuView.chosedArray = @[self.cateName];
            UIButton * mebubutton = [menuView findButtonWithTitle:self.cateName];
            [scrollView setContentOffset:CGPointMake(mebubutton.left, 0) animated:YES];
            //            [self sendCateListRequest];
        }else{
            menuView.chosedArray = @[titlesArray.firstObject];
        }
    });
    self.collectionView.frame = CGRectMake(0, headerView.bottom, UIScreenWidth, TMUtils.tabBarTop - headerView.bottom + 49);
    [self.view addSubview:self.collectionView];
    [_collectionView.mj_header beginRefreshing];
    
    [self.view bringSubviewToFront:headerView];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.sectionInset = UIEdgeInsetsMake(5,12 ,5, 12);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [TMUtils navgationBarBootom], UIScreenWidth, [TMUtils tabBarTop]  - [TMUtils navgationBarBootom]) collectionViewLayout:flow];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //        _collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录背景"]];
        //注册
        [_collectionView registerClass:[BVVideoCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        __weak typeof(self) weakSelf =  self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf sendCateListRequest];
        }];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++ ;
            [weakSelf sendCateListRequest];
        }];
        
        _collectionView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 100, UIScreenWidth, 300) title:@"暂无数据" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
            
        }];
    }
    return _collectionView;
}
#pragma --mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSouce.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat twoWitdh = (UIScreenWidth - 24 - 10 )/2 - 0.01;
    return CGSizeMake(twoWitdh, twoWitdh * 140.0/171.0);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BVVideoCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    BVVideoEasyModel * model = self.dataSouce[indexPath.row];
    item.model = model;
    return item;
}
#pragma --mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BVVideoEasyModel * model = self.dataSouce[indexPath.row];
    [TMUtils gotoVideoDetailWithVideoId:model.v_id];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
#pragma mark --Action Method
- (void)st_rightBarAction:(id)sender{
    
}
#pragma mark --NetWork Method
- (void)sendCateListRequest{
    NSArray * titlesArray = self.subMenuView.allArray;
    NSString * chosedName = self.subMenuView.finshChosedArray.lastObject;
    NSInteger index = [titlesArray indexOfObject:chosedName];
    NSDictionary * dic;
    if (index > titlesArray.count - 1) {
        dic  = self.menuArray.firstObject;
    }else{
        dic  = self.menuArray[index];
    }
    
    NSString * c_id = [dic[@"id"] description];
    
    //    [SVProgressHUD showWithStatus:@"请稍后"];
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    if (c_id.length) {
        [paramDic setObject:c_id forKey:@"id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Get/cateVideo"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"vdieos"];
                                                 NSArray * dataSouce = [BVVideoEasyModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (self.page == 1) {
                                                     self.dataSouce = dataSouce.mutableCopy;
                                                     __weak typeof(self) weakSelf =  self;
                                                     self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                                         weakSelf.page ++ ;
                                                         [weakSelf sendCateListRequest];
                                                     }];
                                                 }else{
                                                     if (dataSouce.count) {
                                                         [self.dataSouce addObjectsFromArray:dataSouce];
                                                         [self.collectionView.mj_footer endRefreshing];
                                                     }else{
                                                         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                     }
                                                     
                                                 }
                                                 [self.collectionView reloadData];
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 [self.collectionView.mj_header endRefreshing];
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 self.dataSouce = NSMutableArray.new;
                                                 [self.collectionView reloadData];
                                                 [self.collectionView.mj_header endRefreshing];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
- (void)sendHomeCategoryRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
     NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Get/cateList"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 //                                                 [STNetWrokManger shownNormalRespMsgWithResponse:responseObject];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"cates"];
                                                 self.menuArray = array.mutableCopy;
                                                 [self configSubView];
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end

