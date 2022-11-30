//
//  TMDynamicViewController.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicViewController.h"
#import "UICollectionView+STNoresult.h"
#import "TMDynamicHeeaderReusableView.h"
#import "TMDynamicCollectionViewCell.h"
#import "TMDynamicFooterReusableView.h"
#import "STPhotoUrlImageBrowerController.h"
#import "TMDynamicDetailViewController.h"
#import "TMDynamicModel.h"
#import "STPageView.h"
#define dynamicHeaderReuseIndetfier @"dynamicHeaderReuseIndetfier"
#define dynamicCellReuseIndetfier @"dynamicCellReuseIndetfier"
#define dynamicFooterReuseIndetfier @"dynamicFooterReuseIndetfier"
#define sectionInsetx 70
#define itemCellWitdh (UIScreenWidth - sectionInsetx - 15 - 10)/3
@interface TMDynamicViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
STPhotoUrlImageBrowerControllerDelegate>
@property(nonatomic, strong) UICollectionView                     *collectionView;
@property(nonatomic, strong) NSIndexPath                          *currentIndexPath;

@property(nonatomic, strong) NSMutableArray<TMDynamicModel*>                     *dataSouce;/**< 数据源 */

@property(nonatomic, strong) NSMutableArray<BVAdverModel*>                     *adverArray;/**< 广告数组*/

@property(nonatomic, strong) UIView                     *topView;/**<  */
@property(nonatomic, strong) TMTagMenuView               *f_menuView;/**<  */
@property(nonatomic, strong) STPageView                     *pageView;/**< 广告 */
@property(nonatomic, strong) STPageControl                     *pageControll;/**<  */
@property(nonatomic, assign) NSInteger                     page;/**< <##> */
@property(nonatomic, strong) NSArray                     *bannerArray;/**<  */
@property(nonatomic, strong) NSArray                     *reginArray;/**<  */
@end

@implementation TMDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0)];
    [self.collectionView addSubview:self.topView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [BVCircleDataController sendGroupGetReginAndBannerRequestWithHandle:^(NSArray<BVAdverModel *> * _Nonnull banerArray, NSArray * _Nonnull reginArray) {
        self.bannerArray = banerArray;
        self.reginArray = reginArray ;
        [self configTopView];
    }];
}
- (void)setAdverArray:(NSMutableArray<BVAdverModel *> *)adverArray{
    _adverArray = adverArray;
    [self updateAdver];
}
- (void)updateAdver{
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataSouce.count; i ++ ) {
        if ((i+1) % 5 == 0 ) {
            TMDynamicModel * dyModel = self.dataSouce[i];
            if (!dyModel.cus_adver) {
                BVAdverModel * admodel;
                if (self.adverArray.count > index) {
                   admodel = self.adverArray[index];
                   index ++ ;
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:admodel.image] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (image) {
                            dyModel.cus_adver = admodel;
                            dyModel.cus_imageHeight = UIScreenWidth * (image.size.height / image.size.width)   ;
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:i]];
                        }
                    }];
                }
                
            }
        }
    }
}
- (NSMutableArray*)dataSouceNoAdverArray{
    NSMutableArray * dealArray = NSMutableArray.new;
    for (TMDynamicModel * model in self.dataSouce) {
        if (!model.cus_adver) {
            [dealArray addObject:model];
        }
    }
    return  dealArray;
}
#pragma mark --subView
- (void)configTopView{
    for (UIView * view in self.topView.subviews) {
        [view removeFromSuperview];
    }
    __weak typeof(self) weakSelf =  self;
    NSArray * array = [self.reginArray st_arrayFromObjKeyName:@"obj.name"];
    
    if (self.bannerArray.count) {
        self.pageView = [[STPageView alloc] initWithFrame:CGRectMake(0, 10, UIScreenWidth, 200)];
        self.pageView.autoMoveDuring = 4;
        self.pageView.pageControl.hidden = YES;
        self.pageView.pageControl.height = 230;
        self.pageView.backgroundColor = UIColor.clearColor;
        NSMutableArray * imageUrlArray = NSMutableArray.new;
        for (BVAdverModel * model in self.bannerArray) {
            [imageUrlArray addObject:model.image];
        }
        self.pageView.imageUrlArray = imageUrlArray;
        self.pageView.animationType = FSPagerViewTransformerTypeLinear;
        [self.pageView setOnSelectedBannerHandle:^(NSInteger index) {
            
            BVAdverModel * model = weakSelf.bannerArray[index];
            [TMUtils gotoAdverController:model];
        }];
        [self.pageView setScrollDidScroll:^(NSInteger currentIndex) {
            weakSelf.pageControll.currentPage = currentIndex;
        }];
        [self.topView addSubview:self.pageView];
        
        self.pageControll = [[STPageControl alloc] initWithPages:self.pageView.imageUrlArray.count handle:^(NSInteger tag) {
            
        }];
        //    self.pageControll.frame = CGRectMake(0, self.pageView.bottom, 160, 20);
        self.pageControll.top = self.pageView.bottom-25 - 40 ;
        self.pageControll.centerX = UIScreenWidth / 2;
        self.pageControll.pageIndicatorTintColor = UIColor.grayColor;
        self.pageControll.currentPageIndicatorTintColor = UIColor.whiteColor;
        [self.topView addSubview:self.pageControll];
        self.topView.height = self.pageControll.bottom + 20 ;
    }
    
    if (array.count) {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.height, UIScreenWidth, 65)];
        [self.topView addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (ios11 && [scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            [scrollView setContentInsetAdjustmentBehavior:@(2)];
        }
        
        
        TMTagMenuView * menuView = [[TMTagMenuView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth - 30, 45 )];
        menuView.direction = TMTagMenuViewDirectionHorizontal;
        
        menuView.cornerRadius = 20;
        
        menuView.buttonSelectedBoderColor = TM_ThemeBackGroundColor;
        menuView.buttonBoderColor = UIColor.clearColor;;
        
        menuView.buttonBackGroundColor = TM_backgroundColor;
        menuView.buttonSelctedBackGroundColor = TM_ThemeBackGroundColor;
        
        menuView.butTitleColor = FirstTextColor;
        menuView.butTitleSelectedColor = UIColor.whiteColor;
        
        menuView.allArray = array;
        menuView.chosedArray = @[@"全部"];
        
        [scrollView addSubview:menuView];
        scrollView.contentSize = CGSizeMake(menuView.width, 0);
        
        [menuView setOnSlectedTagView:^(TMTagMenuView *tagView, NSString *title, NSInteger index) {
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
        self.f_menuView = menuView;
        self.topView.height =  scrollView.bottom;
    }

    [self.collectionView reloadData];
    
}
- (void)configSubView{
    //collectionView
    //相册格式layout
    UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 5;
    flow.minimumInteritemSpacing = 5;
    flow.sectionInset = UIEdgeInsetsMake(0, sectionInsetx, 0, 10);
//    flow.headerReferenceSize = CGSizeMake(UIScreenWidth, TMDynamicHeeaderHeight);
//    flow.footerReferenceSize = CGSizeMake(UIScreenWidth, TMDynamicFooterHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, [TMUtils tabBarTop] - [TMUtils navgationBarBootom]) collectionViewLayout:flow];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册
    [self.collectionView registerClass:[TMDynamicHeeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dynamicHeaderReuseIndetfier];
    [self.collectionView registerClass:[TMDynamicCollectionViewCell class] forCellWithReuseIdentifier:dynamicCellReuseIndetfier];
    [self.collectionView registerClass:[TMDynamicFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dynamicFooterReuseIndetfier];
    
    __weak typeof(self) weakSelf =  self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendListRequest];
       
    }];
   // [self.collectionView.mj_header  beginRefreshing];
    //适配
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf sendListRequest];
    }];
    [self.collectionView.mj_header  beginRefreshing];
    self.collectionView.mj_footer.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (ios11) {
        if ([self.collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            [self.collectionView performSelector:@selector(setContentInsetAdjustmentBehavior:) withObject:@(2) afterDelay:0];
        }
    }
    
    self.collectionView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 240, UIScreenWidth, 300) title:@"暂无动态" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
    }];
}
#pragma --mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSouce.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TMDynamicModel * model = self.dataSouce[section];
    if (model.video_id.length) {
        return 1;
    }else{
        return model.images.count;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMDynamicModel * model = self.dataSouce[indexPath.section];
    return CGSizeMake(itemCellWitdh, itemCellWitdh);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf =  self;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TMDynamicHeeaderReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dynamicHeaderReuseIndetfier forIndexPath:indexPath];
        
        [header.iconButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedIconWithIndePath:indexPath];
        }];
        [header.detailButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedCommentButton:indexPath];
        }];
        
        header.model = self.dataSouce[indexPath.section];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelctedHeaderView:)];
        header.userInteractionEnabled = YES;
        header.tag = 10000 + indexPath.section;
        [header addGestureRecognizer:tap];
        
        return header;
    }else{
        //footer
        TMDynamicModel *  model = self.dataSouce[indexPath.section];
        TMDynamicFooterReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dynamicFooterReuseIndetfier forIndexPath:indexPath];
        footer.model = self.dataSouce[indexPath.section];
        [footer.goodButton setClicAction:^(UIButton *sender) {
            [BVCircleDataController sendGoodRequestWithD_id:model.dy_id handle:^(NSError *error, BOOL success, NSDictionary *resp) {
                if (success) {
                    sender.selected = !sender.selected;
                    if (model.islove) {
                        model.love = @(model.love.integerValue-1).description;
                    }else{
                        model.love = @(model.love.integerValue+1).description;
                    }
                    [sender setTitle:model.love forState:UIControlStateNormal];
                    model.islove = !model.islove;
                    
                }
            }];
        }];
        [footer.commentButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedCommentButton:indexPath];
        }];
        return footer;
    }
}
- (void)onSelctedHeaderView:(UITapGestureRecognizer*)tap{
    NSInteger section = tap.view.tag - 10000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self onSelctedCommentButton:indexPath];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    TMDynamicModel * model = self.dataSouce[section];
    if (model.cus_adver) {
        return CGSizeMake(UIScreenWidth, TMDynamicFooterHeight + model.cus_imageHeight);
    }
    return CGSizeMake(UIScreenWidth, TMDynamicFooterHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    TMDynamicModel * model = self.dataSouce[section];
    if (section == 0) {
        CGFloat height = model.cus_cellHeight + self.topView.height;
      return  CGSizeMake(UIScreenWidth, height);
    }
    return CGSizeMake(UIScreenWidth, model.cus_cellHeight);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMDynamicCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:dynamicCellReuseIndetfier forIndexPath:indexPath];
    TMDynamicModel * model = self.dataSouce[indexPath.section];
    if (model.video_id.length) {
        item.videoModel = model.video;
    }else{
       item.imageModel = model.images[indexPath.row];
    }
    return item;
}
#pragma --mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"点击了cell, IndexPath = %@",indexPath);
    TMDynamicModel * dmodel = self.dataSouce[indexPath.section];
    if (dmodel.video_id.length) {
        TTVideoPlayViewController * vc = TTVideoPlayViewController.new;
        vc.url  = dmodel.video.link;
        vc.img_url  = dmodel.video.image;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else{
        
    }
    
    NSMutableArray * array = [NSMutableArray new];
    NSInteger num = dmodel.images.count;
    for (NSInteger i = 0; i<num; i ++) {
        TMDynamicImageModel *  imageModel = dmodel.images[i];
        STUrlPhotoModel * model = [STUrlPhotoModel new];
//        model.thumbImage = [UIImage imageNamed:@"1"];
        model.originImageUrl = imageModel.max;
        model.thumbImageUrl = imageModel.max;
        [array addObject:model];
    }
    STPhotoUrlImageBrowerController * vc = [[STPhotoUrlImageBrowerController alloc] initWithArray:array curentIndex:indexPath.row];
    vc.themeColor   = TM_ThemeBackGroundColor;
    vc.STPhotoUrlImageBrowerControllerdelegate = self;
    self.currentIndexPath = indexPath;
    vc.shouldHideBottomView = YES;
    [self presentViewController:vc animated:NO completion:nil];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
#pragma mark --STPhotoUrlImageBrowerControllerdelegate
- (UIView*)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath*)indexPath model:(STUrlPhotoModel*)model{
    //当前对于此collectionView的位置
    NSIndexPath * nowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_currentIndexPath.section];
    TMDynamicCollectionViewCell * cell = (TMDynamicCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:nowIndexPath];
    return cell.itemImageView;
    
}
- (void)rightBarActionFromController:(STPhotoUrlImageBrowerController*)controller currentIndexPath:(NSIndexPath *)curentIndexpath{
    STUrlBrowserCollectionViewCell * cell = (STUrlBrowserCollectionViewCell*)[controller.collectionView cellForItemAtIndexPath:curentIndexpath];
    if (!cell.imageView.image) {
        [SVProgressHUD showInfoWithStatus:@"正在加载"];
        return;
    }
    [controller st_showActionSheet:@[@"保存",@"取消"] andWithBlock:^(int tag) {
        if (tag == 0) {
            [PHPhotoLibrary saveImageToAssetsLibrary:cell.imageView.image libraryName:NSBundle.st_applictionDisplayName successHandle:^{
                [SVProgressHUD showSuccessWithStatus:@"保存到相册成功"];
            } errorHandle:^(STSaveImageError error) {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }];
        }
    }];
   
}
#pragma mark --Action Method
- (void)onSelctedIconWithIndePath:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的头像",indexPath);
    TMDynamicModel *model = self.dataSouce[indexPath.section];

}
- (void)onSelctedCommentButton:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的评论",indexPath);
    TMDynamicModel *model = self.dataSouce[indexPath.section];
    TMDynamicDetailViewController * vc = [TMDynamicDetailViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onSelctedGoodButton:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的点赞",indexPath);
    TMDynamicModel *model = self.dataSouce[indexPath.section];
}
#pragma mark --NetWork Method
- (void)sendListRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    
    NSArray * titlesArray = self.f_menuView.allArray;
    NSString * chosedName = self.f_menuView.finshChosedArray.lastObject;
    NSInteger index = [titlesArray indexOfObject:chosedName];
    NSDictionary * dic;
    if (index > titlesArray.count - 1) {
        dic  = self.reginArray.firstObject;
    }else{
        if (titlesArray.count) {
            dic  = self.reginArray[index];
        }
    }
    NSString * region_id = [dic[@"id"] description];
    if (region_id.length) {
        [paramDic setObject:region_id forKey:@"region_id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/lists"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 //                                                 [STNetWrokManger shownNormalRespMsgWithResponse:responseObject];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"circleList"];
                                                 NSArray * objArray = [TMDynamicModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (self.page == 1) {
                                                     self.dataSouce = objArray.mutableCopy;
                                                     [self.collectionView.mj_header endRefreshing];
                                                     if (objArray.count) {
                                                         self.collectionView.mj_footer.hidden = NO;
                                                     }
                                                      [self sendRandAdverRequest];
                                                     [self.collectionView reloadData];
                                                 }else{
                                                     [self.dataSouce addObjectsFromArray:objArray];
                                                     if (objArray.count) {
                                                         [self.collectionView.mj_footer endRefreshing];
                                                     }else{
                                                         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                     }
                                                     [self.collectionView reloadData];
                                                     [self updateAdver];
                                                 }
                                                 
                                                 // DDLogInfo(@"json = \n%@",modelDic.mj_JSONString);
                                                 
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
//获取随机广告
- (void)sendRandAdverRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/getAdvertByRand"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"banner"];
                                                 NSArray * objArray = [BVAdverModel mj_objectArrayWithKeyValuesArray:array];
                                                 self.adverArray = objArray.mutableCopy;
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end
