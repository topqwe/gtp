//
//  NewDynamicsViewController.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsVC.h"
#import "NewDynamicsVC+Delegate.h"
#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"

#import "WDTimeLinePostVC.h"
#import "FilterHV.h"
#import "NewDynamicsHV.h"
#import "SelectCityListVC.h"

#define kHeaderHeight   (85-30)
@interface NewDynamicsVC ()
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) NewDynamicsHV * nHV;
@property (nonatomic, strong) FilterHV * hHV;
@property (nonatomic, strong) UIButton *clickButton;
@property(nonatomic,strong)UIButton *postBtn;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong) NSMutableDictionary*  dict;
@property (nonatomic, assign) NSInteger  cid;

@end

@implementation NewDynamicsVC
- (UIView *)hv {
    if (!_hv) {
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, self.isFromAvatar?253:kHeaderHeight)];
        
        _hv.backgroundColor = [UIColor clearColor];
        
        NSInteger topMar = 5;
//        +YBFrameTool.statusBarHeight;
        if (self.isFromAvatar) {
            self.nHV = [[NewDynamicsHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:0];//h=150
            return _hv;
        }
        
        
        self.hHV = [[FilterHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:topMar];//h=150
        self.hHV.backgroundColor = kClearColor;
        UIImageView* line0 = [[UIImageView alloc]init];
        [_hv addSubview:line0];
        line0.hidden = YES;
        line0.backgroundColor = HEXCOLOR(0x8FAEB7);
        [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hv.mas_left).offset(0);
            make.centerX.mas_equalTo(self.hv);
            make.height.equalTo(@.5);
            make.bottom.mas_equalTo(0);
        }];
        
        self.clickButton = [[UIButton alloc]init];
        self.clickButton.tag = 201;
        
        self.clickButton.adjustsImageWhenHighlighted = NO;
        self.clickButton.titleLabel.numberOfLines = 0;
        self.clickButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.clickButton.titleLabel.font = kFontSize(14);
    //        titButton.layer.masksToBounds = YES;
    //        titButton.layer.cornerRadius = 8;
    //        button.layer.borderWidth = 0;
        [self.clickButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        self.clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        NSString* city = GetUserDefaultWithKey(kLocationCity);
        [self.clickButton
                 setImage:[UIImage imageNamed:@"M_location"] forState:0];
        [self.clickButton setTitle:city.length>0?city:@"全国" forState:UIControlStateNormal];
        [self.clickButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        self.clickButton.hidden = YES;
        [self.clickButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];

//        [clickButton setBackgroundColor:UIColor.redColor];
        
        [_hv addSubview:self.clickButton];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
//            make.bottom.mas_equalTo(0);
            make.bottom.mas_equalTo(-8);
//            make.centerX.mas_equalTo(self.hv);
            
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(50);
        }];
    }
    return _hv;
}
- (void)funAdsButtonClickItem:(UIButton*)sender{
    if (sender.tag == 201) {
        sender.selected = !sender.selected;
        SelectCityListVC* selectCityVC = [[SelectCityListVC alloc] init];
        selectCityVC.didSelectCity = ^(NSString *city) {
            [self.clickButton
                     setImage:[UIImage imageNamed:@"M_location"] forState:0];
            [self.clickButton setTitle:city forState:0];
            if (!self.clickButton.hidden) {
                if (![city isEqualToString:@"全国"]) {
                    self.dict[@"location_name"] = city;
                }else{
                    self.dict[@"location_name"] = @"";
                }
                [self requestHomeListWithPage:1];
            }
            
            [self.clickButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        };
        
        [self.navigationController pushViewController:selectCityVC animated:YES];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)postAction {
    
    NSInteger idd = [self.dict[@"cid_2"] integerValue] > 0 ? [self.dict[@"cid_2"] integerValue] :self.cid;
    [WDTimeLinePostVC pushFromVC:self requestParams:@(idd) success:^(id data) {
        [self requestHomeListWithPage:1];
    }];
//    WDTimeLinePostVC *vc = [[WDTimeLinePostVC alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
////    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:true completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = NO;
    
    if(self.isFromAvatar){
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [SVProgressHUD dismiss];
    [JRMenuView dismissAllJRMenu];
    if(self.isFromAvatar){
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES;
}
-(UIButton *)postBtn
{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _postBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _postBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [_postBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        _postBtn.backgroundColor = YBGeneralColor.themeColor;
        [_postBtn bk_addEventHandler:^(id sender) {
            [self postAction];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

-(void)levSuccessMethod{
    [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
        
//        self.myModel = model;
        HomeModel* mod = model;
        self.myModel.data = mod.data;
        [self requestHomeListWithPage:1];
    } failed:^(id data) {
            
    }];
    
}

- (void)requestUserInfoWithPage:(NSInteger)page{
    [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
//        self.myModel = model;
        HomeModel* mod = model;
        self.myModel.data = mod.data;
    } failed:^(id data) {
            
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.myModel = [HomeModel new];
    self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:kHeaderHeight withCustomTitle: @"" withCustomImageName:@""];
    self.dataEmptyView.hidden = NO;
    [self addNotification];
    [self requestUserInfoWithPage:1];
    self.dict = [NSMutableDictionary dictionary];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(postAction)];
    if (!self.isFromAvatar) {
        [self.view addSubview:self.hv];
    }
    
    
    [self.view addSubview:self.dynamicsTable];
    [self.dynamicsTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.bottom.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view.mas_top).offset(_isFromAvatar?0:kHeaderHeight);
        make.center.equalTo(self.view);
    }];
    if (self.isFromAvatar) {
        self.dynamicsTable.tableHeaderView = self.hv;
    }
   
    [self.view addSubview:self.commentInputTF];
    if (self.isFromAvatar) {
        return;
    }
    [self.view addSubview:self.postBtn];
    [_postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-72);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    _postBtn.backgroundColor = [UIColor clearColor];//imodel
    _postBtn.layer.masksToBounds = true;
    _postBtn.layer.cornerRadius = 80/2;
    _postBtn.contentMode = UIViewContentModeScaleAspectFill;
    _postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _postBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}

-(void)richOnlyElementsInCellWithModel:(id)model{
    HomeItem* data = model[0];
    _postBtn.hidden = data.is_allow_post?NO:YES;
    _clickButton.hidden =  data.can_select_city?NO:YES;
    if (data.childs !=nil && data.childs.count>0 ) {
        self.hHV.hidden = NO;
        [self.dynamicsTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(kHeaderHeight);
                    
        }];
        [self.hHV richOnlyElementsInCellWithModel:model didDefaultSelectFirst:YES didAllowsInvertSelection:NO];
        [self.hHV actionBlock:^(NSArray* arr) {
//            NSDictionary* dict = [NSDictionary dictionary];
            if (arr.count == 1){
                HomeItem* item0 = arr.firstObject;
//                dict = @{
//                             @"cid_2":@(item0.ID),
//                             @"cid_1":@(self.cid)};
//                self.dict = [dict mutableCopy];
                self.dict[@"cid_2"] = @(item0.ID);
                self.dict[@"cid_1"] = @(self.cid);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self requestHomeListWithPage:1];
                    });
                
            }
    //        if ([self.cid isEqualToDictionary:GetUserDefaultWithKey(@"fcDic")]) {
    //            return;
    //        }
    //        SetUserDefaultKeyWithObject(@"fcDic", self.cid);
            
        }];
    }else{
        self.hHV.hidden = YES;
        [self.dynamicsTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(0);
                    
        }];
    }
}
- (void) requestHomeListWithPage:(NSInteger)page{
    [self requestHomeListWithPage:page WithDict:self.dict];
}
#pragma mark - public requestData(HomeViewDelegate)
- (void) requestHomeListWithPage:(NSInteger)page WithDict:(NSDictionary*)dict{
   kWeakSelf(self);
    self.dict = [dict mutableCopy];
    if (!self.isFromAvatar) {
        self.cid = [self.dict[@"cid_1"] integerValue];
    }
    
//    if (self.clickButton.hidden) {
//        if ([self.dict.allKeys containsObject:@"location_name"]) {
//            [self.dict removeObjectForKey:@"location_name"];
//        }
//    }
    [self.vm network_postDynamicsListWithPage:page WithCid:self.dict withSource:self.isFromAvatar success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
        kStrongSelf(self);
        if (lastSectionSumArr>0&&self.isFromAvatar) {
            [self.nHV richElementsInCellWithModel:lastSectionSumArr.firstObject];
        }
        [self requestHomeListSuccessWithArray:dataArray WithLastSectionArr:lastSectionArr WithLastSectionSumArr:lastSectionSumArr WithPage:page];
    } failed:^(id model){
        kStrongSelf(self);
//        [self requestHomeListSuccessWithArray:model WithPage:page];
        [self requestHomeListFailed];
    }];
}

#pragma mark - public processData
- (void)requestHomeListSuccessWithArray:(NSArray *)sections WithLastSectionArr:(NSArray *)lastSectionArr WithLastSectionSumArr:(NSArray *)lastSectionSumArr WithPage:(NSInteger)page{
    
    self.currentPage = page;
    if (self.currentPage == 1) {
        self.dynamicsTable.tableFooterView = [UIView new];
//        [self.sections removeAllObjects];
        [self.layoutsArr removeAllObjects];
        [self.dynamicsTable reloadData];
//        if (self.dataEmptyView) {
//            [self.dataEmptyView removeFromSuperview];
//        }
//        UIButton* btn0 = _funcBtns[0];
//        [self.view layoutIfNeeded];
        
        if(!lastSectionArr||lastSectionArr.count==0){
            self.dataEmptyView.hidden = false;
        }else{
            self.dataEmptyView.hidden = true;
        }
        if(self.isFromAvatar)self.dataEmptyView.hidden = true;
    }
    if (lastSectionArr.count > 0) {
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
//        [self.sections removeAllObjects];
        [self.layoutsArr addObjectsFromArray:lastSectionArr];
        [self.layoutsArr removeAllObjects];//imodel
        [self.dynamicsTable reloadData];
        
        [self.dynamicsTable.mj_footer endRefreshing];
        self.dynamicsTable.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
//            self.dynamicsTable.mj_footer.hidden = YES;
            //最后一页无数据
        }
        
    } else {
        [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
//        self.dynamicsTable.mj_footer.hidden = YES;//in 2 ways, footer no request
    }
    
    [self.dynamicsTable.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
//    [self.sections removeAllObjects];
    [self.dynamicsTable reloadData];
    [self.dynamicsTable.mj_header endRefreshing];
    [self.dynamicsTable.mj_footer endRefreshing];
}
#pragma mark - 上拉加载更多数据
- (void)dragUpToLoadMoreData
{
    [self.dynamicsTable.mj_footer beginRefreshing];
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    // 设置文字
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中......" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];

    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];

    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];

    // 设置footer
    self.dynamicsTable.mj_footer = footer;
}
- (void)loadMoreData
{
    //执行事件
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment1" ofType:@"plist"];
        NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        
        for (id dict in dataArray) {
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }
        [self.dynamicsTable reloadData];
        [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
}
#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dynamicsTable.backgroundColor = UIColor.clearColor;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
            _dynamicsTable.estimatedRowHeight = 0;
        }
        kWeakSelf(self);
        [_dynamicsTable addMJHeaderWithBlock:^{
                     kStrongSelf(self);
                     self.currentPage = 1;
                     [self requestHomeListWithPage:self.currentPage];
         }];
         
        [_dynamicsTable addMJFooterWithBlock:^{
                     kStrongSelf(self);
                     ++self.currentPage;
            [self requestHomeListWithPage:self.currentPage];
         }];

        UITapGestureRecognizer * tableViewGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [self.commentInputTF resignFirstResponder];
        }];
        
        tableViewGesture.cancelsTouchesInView = NO;
        [_dynamicsTable addGestureRecognizer:tableViewGesture];
    }
    return _dynamicsTable;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

-(UITextField *)commentInputTF
{
    if (!_commentInputTF) {
        _commentInputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, MAINSCREEN_WIDTH, 49)];
        _commentInputTF.backgroundColor = [UIColor lightGrayColor];
        _commentInputTF.delegate = self;
        _commentInputTF.textColor = [UIColor whiteColor];
    }
    return _commentInputTF;
}

#pragma mark--添加通知---
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGRect frame = _commentInputTF.frame;
    frame.origin.y = MAINSCREEN_HEIGHT;
    _commentInputTF.frame = frame;
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;

//    self.y = 0;
//    self.height = WTHeight;
    self.commentInputTF.y = MAINSCREEN_HEIGHT-YBFrameTool.safeAdjustTabBarHeight;

    [UIView animateWithDuration:duration animations:^{
        self.commentInputTF.y = keyboardY- 49;
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect frame = _commentInputTF.frame;
//    frame.origin.y = keyBoardFrame.origin.y - YBFrameTool.safeAdjustTabBarHeight;
//    _commentInputTF.frame = frame;
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification
{

}
@end
