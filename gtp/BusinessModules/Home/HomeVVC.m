//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "HomeVVC.h"
#import "HomeView.h"

#import "HomeVM.h"

#import "AccountCell.h"
#import "GridCell.h"
//#import "AutoScrollCell.h"
#import "HomeOrderCell.h"
#import "HomeSectionHeaderView.h"

#import "HomeHV.h"
#import "HomeFV.h"

#import "FloatingButton.h"
#import "TurntableView.h"
#import "SlotAnimateView.h"

#import "PostAdsVC.h"
#import "OrdersVC.h"
//#import "DataStatisticsVC.h"
#import "ExchangeVC.h"
#import "OrderDetailVC.h"

@interface HomeVVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;


@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) HomeHV * hHV;

@property (nonatomic, strong)FloatingButton *floatBtn;
@property (nonatomic, strong) SlotAnimateView *slotAnimateView;
@property (nonatomic, strong)WItem* resultItem;

@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;
@end

@implementation HomeVVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
    [self requestHomeListWithPage:1];
    //监听程序进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initView {
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:self.floatBtn];
}

-(void)netwoekingErrorDataRefush{
//    [self  requestHomeListWithPage:1];
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getHomeListWithPage:page WithParams:@(1) success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
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
    //每一次刷新数据时，重置初始时间
    _start = CFAbsoluteTimeGetCurrent();
    self.currentPage = page;
    if (self.currentPage == 1) {
        self.tableView.tableFooterView = [UIView new];
        [self.sections removeAllObjects];
        [self.tableView reloadData];
    }
    if (sections.count > 0) {
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
        [self.sections removeAllObjects];
        [self.sections addObjectsFromArray:sections];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            //最后一页无数据
            self.tableView.tableFooterView = self.fv;
             self.hFV.userInteractionEnabled = true;
             [self.hFV richElementsInCellWithModel:lastSectionArr];
             [self.hFV actionBlock:^(id data) {
                 
                 
             }];
        }
        
        
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
//    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    return [(_sections[section])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }

    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionThree:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            return [HomeSectionHeaderView viewHeight:model];
        }
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];

    switch (type) {
        case IndexSectionThree:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            return  sectionHeaderView;
        }
            break;

        default:
            return [UIView new];
            break;
    }
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
            return 12.f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        {
            AccountCell *cell = [AccountCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            GridCell *cell = [GridCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(NSDictionary *dataModel) {
                EnumActionTag type = [dataModel[kType] integerValue];
                [self clickEvent:@(type) withData:itemData];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
//        case IndexSectionTwo:
//        {
//            AutoScrollCell *cell = [AutoScrollCell cellWith:tableView];
//            [cell richElementsInCellWithModel:itemData];
//            return cell;
//
//        }
//            break;
        case IndexSectionThree:
        {
            HomeOrderCell *cell = [HomeOrderCell cellWith:tableView];
            NSInteger second = [itemData integerValue] - round(CFAbsoluteTimeGetCurrent()-_start);
//            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:second];
            return cell;
            
        }
            break;
        default:{
//            BaseCell *cell = [BaseCell cellWith:tableView];
//            cell.hideSeparatorLine = YES;
//            cell.frame = CGRectZero;
//            return cell;
       static NSString *name=@"defaultCell";
                               
       UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:name];
           
       if (cell==nil) {
           cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
       }
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
       cell.frame = CGRectZero;

       return cell;
        }
            break;
    }
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            return [AccountCell cellHeightWithModel];
            break;
            
        case IndexSectionOne:
            return [GridCell cellHeightWithModel:itemData];
            break;
//        case IndexSectionTwo:
//            return [AutoScrollCell cellHeightWithModel:itemData];
//            break;
        case IndexSectionThree:
        {
            NSInteger second = [itemData integerValue] - round(CFAbsoluteTimeGetCurrent()-_start);
            return [HomeOrderCell cellHeightWithModel:second];
        }
            break;
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        
        case IndexSectionTwo:
        {
            [self clickEvent:@(EnumActionTag4) withData:itemData];
        }
            break;
        default:
            
            break;
    }
}
#pragma mark - clickEvent
- (void)clickEvent:(id) data withData:(id)data2{
    EnumActionTag type = [data integerValue];
    switch (type) {
        case EnumActionTag0:
        {
            [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeCreate) success:^(id data) {
                
            }];
        }
            break;
        case EnumActionTag1:
        {
            [OrdersVC pushFromVC:self];
        }
            break;
        case EnumActionTag2:
        {
//            [DataStatisticsVC pushFromVC:self];
        }
            break;
        case EnumActionTag3:
        {
            [ExchangeVC pushFromVC:self];
        }
            break;
        case EnumActionTag4:
        {
            OrderDetailVC *moreVc = [[OrderDetailVC alloc] init];
            [self.navigationController pushViewController:moreVc animated:YES];
//                [OrderDetailVC pushViewController:self requestParams:data2 success:^(id data) {
//
//                }];
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
       kWeakSelf(self);
       [_tableView addMJHeaderWithBlock:^{
                    kStrongSelf(self);
                    self.currentPage = 1;
                    [self requestHomeListWithPage:self.currentPage];
        }];
        
       [_tableView addMJFooterWithBlock:^{
                    kStrongSelf(self);
                    ++self.currentPage;
                    [self requestHomeListWithPage:self.currentPage];
        }];
    }
    return _tableView;
}

- (UIView *)hv {
    if (!_hv) {
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.statusBarHeight)];
        
        _hv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_hv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(YBFrameTool.statusBarHeight);
            make.centerX.mas_equalTo(self.hv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.statusBarHeight;
        self.hHV = [[HomeHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:-topMar];
        
    }
    return _hv;
}

- (UIView *)fv {
    if (!_fv) {
        _fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.iphoneBottomHeight)];
        
        _fv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_fv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-YBFrameTool.iphoneBottomHeight);
            make.centerX.mas_equalTo(self.fv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.iphoneBottomHeight;
        self.hFV = [[HomeFV alloc]initWithFrame:CGRectZero InSuperView:_fv withTopMargin:-topMar];
        
    }
    return _fv;
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

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}


-(FloatingButton *)floatBtn{
    if(!_floatBtn){
        _floatBtn = [FloatingButton buttonWithType:0];
        _floatBtn.layer.cornerRadius = 30;
        _floatBtn.layer.masksToBounds = true;
        [_floatBtn setBackgroundImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [_floatBtn addTarget:self action:@selector(floatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _floatBtn.frame = CGRectMake(self.view.width - 12 - 60, self.view.height * 1242/2248, 60, 60);

        _floatBtn.safeInsets = UIEdgeInsetsMake(0, 0, YBFrameTool.iphoneBottomHeight + 50, 0);
        _floatBtn.parentView = self.view;
        [self.view addSubview:_floatBtn];
    }
    return _floatBtn;
}

- (void)setupContent{
    _slotAnimateView.hidden = YES;
//    WelfareWinPopView* popupView = [[WelfareWinPopView alloc]init];
//    [popupView richElementsInViewWithModel:self.aModel];
//    [popupView showInView:self.view];
//    [popupView actionBlock:^(id data) {
//        [self requestHomeListWithPage:1];
//
//    }];
}

- (void) setAnimate {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupContent];
    });
}

- (void)setupAnimateView {
    _slotAnimateView = [SlotAnimateView customView];
    _slotAnimateView.frame = CGRectMake(10, YBFrameTool.navigationBarHeight + 10, MAINSCREEN_WIDTH - 20, MAINSCREEN_HEIGHT - YBFrameTool.navigationBarHeight - YBFrameTool.iphoneBottomHeight - 10 - 70);
    [self.view addSubview:_slotAnimateView];
    _slotAnimateView.nowPriceLab.hidden = true;
    _slotAnimateView.originalPriceLab.hidden = true;
    _slotAnimateView.titleImg.hidden = true;
    _slotAnimateView.diamondImg.hidden = true;

    for (int i=0; i<[self.lastSectionArr count]; i++) {
        WItem *model = self.lastSectionArr[i];
        [_slotAnimateView.iconArray addObject: model];
    }
    [_slotAnimateView.iconUrlArray addObject: self.resultItem];

    [_slotAnimateView setupOneAnimationView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
