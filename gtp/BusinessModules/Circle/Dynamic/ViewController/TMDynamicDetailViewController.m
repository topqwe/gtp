//
//  LBDynamicDetailViewController.m
//  LangBa
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicDetailViewController.h"
#import "TMDynamicHeeaderReusableView.h"
#import "TMDynamicFooterReusableView.h"
#import "TMDynamicCollectionViewCell.h"
#import "STPhotoUrlImageBrowerController.h"
#import "TMDynamicCommentTableViewCell.h"
#import "STTextView.h"
#import "TMComentModel.h"
#define dynamicHeaderReuseIndetfier @"dynamicHeaderReuseIndetfier"
#define dynamicCellReuseIndetfier @"dynamicCellReuseIndetfier"
#define dynamicFooterReuseIndetfier @"dynamicFooterReuseIndetfier"
#define sectionInsetx 70
#define itemCellWitdh (UIScreenWidth - sectionInsetx - 15 - 10)/3
@interface TMDynamicDetailViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
STPhotoUrlImageBrowerControllerDelegate,
UITextViewDelegate>
@property(nonatomic, strong) UICollectionView                     *collectionView;
@property(nonatomic, strong) STTextView                          *textView;
@property(nonatomic, strong) UIView                             *bootomView;
@property(nonatomic, strong) NSMutableArray  <TMComentModel*>                   *dataSouce;
@property(nonatomic, strong) NSIndexPath                          *currentIndexPath;


@end

@implementation TMDynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态详情";
    [self configSubView];
    [self configBootomView];
    [self addNotifacations];
    // Do any additional setup after loading the view.
}

#pragma mark --Notifacation
- (void)addNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lb_keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lb_keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)lb_keyboardWillChangeFrameNotification:(NSNotification*)notify{
    
    // 动画的持续时间
    NSDictionary *userInfo = notify.userInfo;
    //double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bootomView.bottom = keyboardF.origin.y ;
}
- (void)lb_keyboardWillHideNotification:(NSNotification*)notify{
    // 动画的持续时间
    NSDictionary *userInfo = notify.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘的frame
    [UIView animateWithDuration:duration animations:^{
        self.bootomView.top = TMUtils.tabBarTop;
    }];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)configSubView{
    
    //collectionView
    UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 5;
    flow.minimumInteritemSpacing = 5;
    flow.sectionInset = UIEdgeInsetsMake(0, sectionInsetx, 0, 10);
    //根据model计算
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, [self collectionViewHeight])
                                             collectionViewLayout:flow];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    //注册
    [self.collectionView registerClass:[TMDynamicHeeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dynamicHeaderReuseIndetfier];
    [self.collectionView registerClass:[TMDynamicCollectionViewCell class] forCellWithReuseIdentifier:dynamicCellReuseIndetfier];
    [self.collectionView registerClass:[TMDynamicFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dynamicFooterReuseIndetfier];
    
    self.tableView.tableHeaderView = self.collectionView;
    self.tableView.frame = CGRectMake(0, TMUtils.navgationBarBootom, UIScreenWidth, TMUtils.tabBarTop - TMUtils.navgationBarBootom);
    self.tableView.contentInset = UIEdgeInsetsZero;
    __weak typeof(self) weakSelf =  self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf sendCommentListRequest];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf sendCommentListRequest];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (CGFloat)collectionViewHeight
{
    TMDynamicModel * model = self.model;
    CGFloat headerHeight =  model.cus_cellHeight;// 头部高度
    CGFloat cellHeight = (UIScreenWidth - sectionInsetx - 15 - 10)/3;
    //cell 高度
    CGFloat cellHeghts = cellHeight;
    if (self.model.images.count) {
        cellHeghts =  ((self.model.images.count-1) / 3 + 1 ) * cellHeight;
    } 
    //footer 高度
    CGFloat footerHeight = TMDynamicFooterHeight;
    return headerHeight + cellHeghts + footerHeight  ;
}
- (void)configBootomView{
    __weak typeof(self) weakSelf =  self;
    UIView * bootomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 49)];
    bootomView.backgroundColor = [UIColor whiteColor];
    bootomView.top = TMUtils.tabBarTop;
    [bootomView st_showTopShadow];
    [self.view addSubview:bootomView];
    
    STButton * commentButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)
                                                         title:@"评论"
                                                    titleColor:TM_ThemeBackGroundColor
                                                     titleFont:15
                                                  cornerRadius:0
                                               backgroundColor:nil
                                               backgroundImage:nil
                                                         image:nil];
    commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    commentButton.right = UIScreenWidth;
    [commentButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelctedFinshCommentButton];
    }];
    [bootomView addSubview:commentButton];
    
    UIView * graView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, commentButton.left - 20, 40)];
    graView.layer.cornerRadius = 5;
    graView.clipsToBounds = YES;
    graView.backgroundColor = TM_backgroundColor;
    [bootomView addSubview:graView];
    self.textView = [[STTextView alloc] initWithFrame:CGRectMake(3, 0, graView.width - 6, graView.height)];
    self.textView.placeholder = @"快来评论吧";
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    [graView addSubview:self.textView];
    self.bootomView = bootomView;
}
#pragma --mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TMDynamicModel * model = self.model;
    if (model.video_id.length) {
        return 1;
    }else{
        return model.images.count;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMDynamicModel * model = self.model;
    return CGSizeMake(itemCellWitdh, itemCellWitdh);
}
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf =  self;
    TMDynamicModel * model = self.model;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TMDynamicHeeaderReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dynamicHeaderReuseIndetfier forIndexPath:indexPath];
        
        [header.iconButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedIconWithIndePath:indexPath];
        }];
        [header.detailButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedCommentButton:indexPath];
        }];
        header.detailButton.hidden = YES;
        header.model = model;
        return header;
    }else{
        //footer
        TMDynamicFooterReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dynamicFooterReuseIndetfier forIndexPath:indexPath];
        footer.model = model;
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
        footer.adverImageView.hidden = YES;
        return footer;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(UIScreenWidth, TMDynamicFooterHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    TMDynamicModel * model = self.model;
    return CGSizeMake(UIScreenWidth, model.cus_cellHeight);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMDynamicCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:dynamicCellReuseIndetfier forIndexPath:indexPath];
    TMDynamicModel * model = self.model;
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
    TMDynamicModel * dmodel = self.model;
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
    NSIndexPath * nowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
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
#pragma --mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TMComentModel * model = self.dataSouce[indexPath.row];
    if (!model.cus_cellHeight) {
        [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return model.cus_cellHeight;
    }
    return model.cus_cellHeight;
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
    TMDynamicCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TMDynamicCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    TMComentModel * model = self.dataSouce[indexPath.row];
    cell.model = model;
    [cell.goodButton setClicAction:^(UIButton *sender) {
        [BVCircleDataController senGoodCommentRequestWithc_id:model.com_id handle:^(NSError *error, BOOL success, NSDictionary *resp) {
            if (success) {
                sender.selected = !sender.selected;
                model.islove = !model.islove;
                
            }
        }];
    }];
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark --Action Method
- (void)onSelctedFinshCommentButton{
    if (!self.textView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入内容"];
        return;
    }
    [BVCircleDataController sendAddCommentRequestWithd_id:self.model.dy_id content:self.textView.text handle:^(NSError *error, BOOL success, NSDictionary *resp) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功，等待管理员审核通过"];
            self.textView.text = @"";
            self.textView.label.hidden = NO;
        }
    }];
}
- (void)onSelctedIconWithIndePath:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的头像",indexPath);

    
}
- (void)onSelctedCommentButton:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的评论",indexPath);
    
}
- (void)onSelctedGoodButton:(NSIndexPath*)indexPath{
    DDLogInfo(@"点击了%@的点赞",indexPath);

}
#pragma mark --NetWork Method
- (void)sendCommentListRequest{
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (self.model.dy_id.length) {
        [paramDic setObject:self.model.dy_id forKey:@"id"];
    }
    [paramDic setObject:@(self.page) forKey:@"page"];
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/commentList"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 //                                                 [STNetWrokManger shownNormalRespMsgWithResponse:responseObject];
                                                 NSArray * array = [responseObject valueForKey:@"data"][@"commentList"];
                                                 NSArray * objArray = [TMComentModel mj_objectArrayWithKeyValuesArray:array];
                                                 if (self.page == 1) {
                                                     self.dataSouce = objArray.mutableCopy;
                                                     [self.tableView.mj_header endRefreshing];
                                                     if (objArray.count > 10) {
                                                         self.collectionView.mj_footer.hidden = NO;
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

