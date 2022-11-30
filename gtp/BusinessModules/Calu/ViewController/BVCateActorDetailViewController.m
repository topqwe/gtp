//
//  BVMineCollVideoViewController.m
//  BannerVideo
//
//  Created by Mac on 2019/3/27.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import "BVCateActorDetailViewController.h"
#import "BVMineCollVideoCollectionViewCell.h"
@interface BVCateActorDetailViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView                     *collectionView;/**<  */
@property(nonatomic, strong) NSMutableArray                     *dataSouce;/**<  */
@property(nonatomic, strong) UIView                     *header;/**<  */
@property(nonatomic, strong) BVActorModel                     *model;/**< <##> */
@property(nonatomic, assign) NSInteger                    page;/**< <##> */
@end

@implementation BVCateActorDetailViewController
- (void)setModel:(BVActorModel *)model{
    _model = model;
    [self configSubView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"演员信息";
    self.collectionView.frame = CGRectMake(0, TMUtils.navgationBarBootom, UIScreenWidth, TMUtils.tabBarTop  +49 - TMUtils.navgationBarBootom);
    __weak typeof(self) weakSelf =  self;
    self.collectionView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 100, UIScreenWidth, 400) title:@"暂无数据" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendListRequest];
        [weakSelf sendActorRequest];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf sendListRequest];
    }];
    self.collectionView.mj_footer.hidden = YES;
    [self.collectionView.mj_header beginRefreshing];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
}
#pragma mark --configSubView
- (void)configSubView{
    [self.header removeFromSuperview];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
    
    STButton * button = [[STButton alloc] initWithFrame:CGRectMake(0, 20, 70, 70)
                                                  title:nil
                                             titleColor:nil
                                              titleFont:0
                                           cornerRadius:35
                                        backgroundColor:nil
                                        backgroundImage:nil
                                                  image:nil];
    button.centerX = UIScreenWidth / 2;
    [self.header addSubview:button];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.image] forState:UIControlStateNormal];
    
    STLabel * titleLabel = [[STLabel alloc] initWithFrame:CGRectMake(0, button.bottom, UIScreenWidth, 30)
                                                    text:self.model.name
                                               textColor:FirstTextColor
                                                    font:15
                                             isSizetoFit:NO
                                           textAlignment:NSTextAlignmentCenter];
    [self.header addSubview:titleLabel];
    
    
    
    STButton * cobutton = [[STButton alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, 70, 32)
                                                  title:@"收藏"
                                             titleColor:UIColor.whiteColor
                                              titleFont:15
                                           cornerRadius:16
                                        backgroundColor:TM_ThemeBackGroundColor
                                        backgroundImage:nil
                                                  image:nil];
    cobutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cobutton setTitle:@"已收藏" forState:UIControlStateSelected];
    if (self.model.is_collection.boolValue == YES) {
        cobutton.backgroundColor = TM_backgroundColor;
    }
    __weak typeof(self) weakSelf =  self;
    cobutton.selected = self.model.is_collection.boolValue;
    [cobutton setClicAction:^(UIButton *sender) {
        [BVCateDataController sendCollectActorRequestWithActor_id:weakSelf.actor_id handle:^(NSError *error, BOOL success, NSDictionary *resp) {
            if (success) {
                sender.selected = !sender.selected;
                if (sender.selected) {
                    sender.backgroundColor = TM_backgroundColor;
                }else{
                    sender.backgroundColor = TM_ThemeBackGroundColor;
                }
            }
        }];
    }];
    cobutton.centerX = UIScreenWidth / 2;
    [self.header addSubview:cobutton];
    
    
    STLabel * contentLabel = [[STLabel alloc] initWithFrame:CGRectMake(10, cobutton.bottom + 5, UIScreenWidth - 20, 30)
                                                     text:self.model.ac_description
                                                textColor:FirstTextColor
                                                     font:14
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    [NSString lableAutoAdjustheightWithLabel:contentLabel];
    [self.header addSubview:contentLabel];
    
    self.header.height = contentLabel.bottom + 15;
    [self.header st_showBottomLine];
    self.header.height = contentLabel.bottom + 15 + 10;
    [self.collectionView addSubview:self.header];
    [self.collectionView reloadData];
    
    self.collectionView.st_noreslutView.top = self.header.bottom;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [TMUtils navgationBarBootom], UIScreenWidth, [TMUtils tabBarTop]  - [TMUtils navgationBarBootom]) collectionViewLayout:flow];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册
        [_collectionView registerClass:[BVMineCollVideoCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (ios11) {
            if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
                [_collectionView performSelector:@selector(setContentInsetAdjustmentBehavior:) withObject:@(2) afterDelay:0];
            }
        }
        _collectionView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 100, UIScreenWidth, 300) title:@"暂无动态" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
            
        }];
    }
    return _collectionView;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(self.header.height,12 ,0, 12);
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
    CGFloat witdh = (UIScreenWidth - 24 - 5 - 1)/2;
    return CGSizeMake(witdh, witdh * 0.8);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BVMineCollVideoCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark --NetWork Method
- (void)sendActorRequest{
    [BVCateDataController sendFetchActorRequestWith:self.actor_id handle:^(bool success, BVActorModel * _Nonnull model) {
        if (success) {
            self.model = model;
        }
    }];
}
- (void)sendListRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (self.actor_id.length) {
        [paramDic setObject:self.actor_id forKey:@"id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Performer/videoListByPerformer"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"videoList"];
                                                 NSArray * objArray = [BVVideoEasyModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (self.page == 1) {
                                                     self.dataSouce = objArray.mutableCopy;
                                                     [self.collectionView.mj_header endRefreshing];
                                                     if (objArray.count) {
                                                         self.collectionView.mj_footer.hidden = NO;
                                                     }
                                                     
                                                 }else{
                                                     [self.dataSouce addObjectsFromArray:objArray];
                                                     if (objArray.count) {
                                                         [self.collectionView.mj_footer endRefreshing];
                                                     }else{
                                                         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                     }
                                                 }
                                                 
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 [self.collectionView reloadData];
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 [self.collectionView.mj_header endRefreshing];
                                                 [self.collectionView.mj_footer endRefreshing];
                                                 //                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end
