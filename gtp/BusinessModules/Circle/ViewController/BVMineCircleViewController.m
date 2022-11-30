//
//  TMDynamicViewController.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "BVMineCircleViewController.h"
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
@interface BVMineCircleViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
STPhotoUrlImageBrowerControllerDelegate>
@property(nonatomic, strong) UICollectionView                     *collectionView;
@property(nonatomic, strong) NSIndexPath                          *currentIndexPath;

@property(nonatomic, strong) NSMutableArray<TMDynamicModel*>                     *dataSouce;/**< 数据源 */

@property(nonatomic, strong) UIView                     *topView;/**<  */
@property(nonatomic, strong) TMTagMenuView               *f_menuView;/**<  */
@property(nonatomic, strong) STPageView                     *pageView;/**< 广告 */
@property(nonatomic, strong) STPageControl                     *pageControll;/**<  */
@property(nonatomic, assign) NSInteger                     page;/**< <##> */
@property(nonatomic, strong) NSArray                     *bannerArray;/**<  */
@property(nonatomic, strong) NSArray                     *reginArray;/**<  */
@end

@implementation BVMineCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark --subView
- (void)configSubView{
    //collectionView
    //相册格式layout
    UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 5;
    flow.minimumInteritemSpacing = 5;
    flow.sectionInset = UIEdgeInsetsMake(0, sectionInsetx, 0, 10);
    flow.headerReferenceSize = CGSizeMake(UIScreenWidth, TMDynamicHeeaderHeight);
    flow.footerReferenceSize = CGSizeMake(UIScreenWidth, TMDynamicFooterHeight);
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
    
    self.collectionView.st_noreslutView = [[STNoresultView alloc] initWithFrame:CGRectMake(0, 100, UIScreenWidth, 300) title:@"暂无动态" buttonTitle:@"" buttonHandle:^(NSString *titleString) {
        
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
    //    if (model.video.count == 1) {
    //        return CGSizeMake(UIScreenWidth * 0.6, UIScreenWidth * 0.6 * 0.6);
    //    }
    //    if (model.images.count == 1) {
    //        return CGSizeMake(UIScreenWidth * 0.6, UIScreenWidth * 0.6 * 0.6);
    //    }
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(UIScreenWidth, TMDynamicFooterHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    TMDynamicModel * model = self.dataSouce[section];
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
        dic  = self.reginArray[index];
    }
    NSString * region_id = [dic[@"id"] description];
    if (region_id.length) {
        [paramDic setObject:region_id forKey:@"region_id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/userLists"];
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
