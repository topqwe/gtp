//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "EviVC.h"

#import "HomeVM.h"

#import "AwemeSearchCell.h"

#import "HomeSectionHeaderView.h"

#import "HomeHV.h"
#import "HomeFV.h"

@interface EviVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) HomeHV * hHV;

@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;

@property (nonatomic, assign) NSInteger  cid;
@property (nonatomic, copy) NSDictionary* requestParams;
@end

@implementation EviVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    EviVC *vc = [[EviVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)levSuccessMethod{
    [self requestList];
}

- (void)requestList{
    NSArray* arr = (NSArray*)(self.requestParams);
    NSInteger subID = [arr[1] integerValue];
    [self requestHomeListWithPage:1 WithCid:subID];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
    
    NSArray* arr = (NSArray*)(self.requestParams);
    NSString* title =  arr[0];
    self.navigationItem.title = title;
    
    [self requestList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.fd_interactivePopDisabled = YES;
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{

}

- (void)initView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(YBFrameTool.statusBarHeight);
    }];
}

-(void)netwoekingErrorDataRefush{
//    [self  requestHomeListWithPage:1];
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid{
   kWeakSelf(self);
    self.cid = cid;
    
    [self.vm network_getSVListWithPage:page WithCid:@(self.cid) WithSource:AwemeLivi success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
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
        [self.sections removeAllObjects];//imodel
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            self.tableView.mj_footer.hidden = YES;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
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
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            return 10.1f;//[HomeSectionHeaderView viewHeight:model];
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
        case IndexSectionOne:{
//            NSDictionary* model = (NSDictionary*)(_sections[section]);
//            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
//            [sectionHeaderView richElementsInViewWithModel:model];
            UIView* v = [UIView new];
            v.backgroundColor = UIColor.whiteColor;
            return  v;
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
            return 0.1f;
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
        case IndexSectionOne:
        {
            AwemeSearchCell *cell = [AwemeSearchCell cellWith:tableView];
            cell.awemeType = AwemeLivi;
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(HomeItem* item) {
                [self pushMoviePlayerVC:item];
                
            }];
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
#pragma mark - clickEvent
- (void)pushMoviePlayerVC:(id) data{
    HomeItem* it = data;
//    AwemeLVC *controller = [[AwemeLVC alloc] initWithVideoData:self.lastSectionSumArr currentIndex:it.parent_id pageIndex:self.currentPage pageSize:10 awemeType:AwemeLiviPush uid:@"100"];
    AwemeLVC *controller = [[AwemeLVC alloc] initWithVideoData:[@[it] mutableCopy]  currentIndex:0 pageIndex:self.currentPage pageSize:10 awemeType:AwemeLiviPush uid:@"100"];
    [self.navigationController pushViewController:controller animated:NO];
    [controller actionBlock:^(id data, id data2) {
        [self levPush];
    }];
}
- (void)levPush{//@(self.aweme.limit-1)
    [LevelVC pushFromVC:self
           requestParams:0
                 success:^(id data) {
//                        [self requestFilmData:self.requestParams];
//        self.isPaid = YES;
        [self levSuccessMethod];
    }];
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
            
        case IndexSectionOne:
            return [AwemeSearchCell cellHeightWithModel:itemData];
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
//            [self clickEvent:@(EnumActionTag4) withData:itemData];
        }
            break;
        default:
            
            break;
    }
}
#pragma mark - clickEvent
- (void)clickEvent:(id) data withData:(id)data2{
//    EnumActionTag type = [data integerValue];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
       kWeakSelf(self);
       [_tableView addMJHeaderWithBlock:^{
                    kStrongSelf(self);
                    self.currentPage = 1;
                    [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
        }];
        
       [_tableView addMJFooterWithBlock:^{
                    kStrongSelf(self);
                    ++self.currentPage;
           [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
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


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
