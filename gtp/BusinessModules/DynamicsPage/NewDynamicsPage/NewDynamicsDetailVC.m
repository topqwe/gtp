//
//  NewDynamicsViewController.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsDetailVC.h"
#import "NewDynamicsVC+Delegate.h"
#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"

#import "WDTimeLinePostVC.h"


@interface NewDynamicsDetailVC ()

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;




@end

@implementation NewDynamicsDetailVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    NewDynamicsDetailVC *vc = [[NewDynamicsDetailVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    vc.cid = [vc.requestParams.ID integerValue];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)postAction {
    WDTimeLinePostVC *vc = [[WDTimeLinePostVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:true completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = NO;
    if (self.playerView) {
        self.playerView.isLockScreen = NO;
//        self.playerView.isFullScreen = NO;
//        [self.playerView pause];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [SVProgressHUD dismiss];
    [JRMenuView dismissAllJRMenu];
    [self.bottomView hideView];
    if (self.playerView) {
        self.playerView.isLockScreen =YES;
        self.playerView.isFullScreen = NO;
        [self.playerView pause];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES;
}

-(void)levSuccessMethod{
    [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
        
//        self.myModel = model;
        HomeModel* mod = model;
        self.myModel.data = mod.data;
        [self requestHomeListWithPage:1 WithCid:self.cid];
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
    [self addNotification];
    [self requestUserInfoWithPage:1];
    self.title = @"帖子详情";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(postAction)];
    [self.view addSubview:self.dynamicsTable];
    [self.dynamicsTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.left.equalTo(self.view);
        make.center.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-YBFrameTool.safeAdjustTabBarHeight);
    }];
   
//    [self.view addSubview:self.commentInputTF];
    
    [self requestHomeListWithPage:1 WithCid:self.cid];
    
    self.bottomView = [[WTBottomInputView alloc]init];
    self.bottomView.textView.placeholder = @"请输入要说的话";
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bottomView];
//    [self.view addSubview:self.bottomView];
    [self.bottomView showView];
    self.bottomView.delegate = self;
}

#pragma mark - public requestData(HomeViewDelegate)
- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid{
   kWeakSelf(self);
    self.cid = cid;
    [self.vm network_postDynamicsDetailWithPage:page WithCid:self.cid success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
        kStrongSelf(self);
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
        [self.sections removeAllObjects];
//        [self.layoutsArr removeAllObjects];
        [self.dynamicsTable reloadData];
    }
    if (sections.count > 0) {
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
        [self.sections removeAllObjects];
        [self.sections addObjectsFromArray:sections];
//        [self.layoutsArr addObjectsFromArray:@[lastSectionArr.firstObject]];
//        if (self.sections.count>1) {
//            [self.layoutsArr removeAllObjects];
//            NSArray* fA = self.sections.firstObject[@"kIndexRow"];
//            [self.layoutsArr addObject:fA.firstObject];
//            [self setupTableViewHeader];
//        }
//        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment0" ofType:@"plist"];
//        NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//        
//        for (id dict in dataArray) {
//            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//            [self.layoutsArr addObject:layout];
//        }
        [self.dynamicsTable reloadData];
        
        [self.dynamicsTable.mj_footer endRefreshing];
        self.dynamicsTable.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
            if (page == 1) {
                self.dynamicsTable.mj_footer.hidden = YES;
            }
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
/**
 设置评论的头
 */
- (void)setupTableViewHeader
{    //这里要给cell添加一个父控件，为了不让cell高度减少
    UIView *view = [[UIView alloc] init];

    NewDynamicsTableViewCell *cell = [NewDynamicsTableViewCell cellWith:self.dynamicsTable];
    cell.layout = self.layoutsArr.firstObject;
    cell.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, [NewDynamicsTableViewCell cellHeightWithModel:cell.layout]);
//    cell.delegate = self;
    [view addSubview:cell];
    //这个父控件的高度就等于cell的高度
    [view setHeight:cell.frame.size.height];
    
    self.dynamicsTable.tableHeaderView = view;
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
        
        [HomeSectionHeaderView sectionHeaderViewWith:_dynamicsTable];
//        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
//            _dynamicsTable.estimatedRowHeight = 0;
//        }
        _dynamicsTable.estimatedRowHeight = 10000;
        kWeakSelf(self);
        [_dynamicsTable addMJHeaderWithBlock:^{
                     kStrongSelf(self);
                     self.currentPage = 1;
                     [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
         }];
         
        [_dynamicsTable addMJFooterWithBlock:^{
                     kStrongSelf(self);
                     ++self.currentPage;
            [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
         }];

        UITapGestureRecognizer * tableViewGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [self.commentInputTF resignFirstResponder];
            [self.bottomView.textView resignFirstResponder];
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
