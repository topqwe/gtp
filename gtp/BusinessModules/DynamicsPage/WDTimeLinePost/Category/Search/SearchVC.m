//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "SearchVC.h"

#import "MADSearchBar.h"
#import "HomeVM.h"

#import "SearchCell.h"

#import "SearchResultVC.h"
#import "HomeSectionHeaderView.h"

#import "HomeHV.h"
#import "HomeFV.h"

@interface SearchVC () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) MADSearchBar *titleSearchBar;
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
@property (nonatomic, strong) NSMutableArray *historyArray;
@end

@implementation SearchVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    SearchVC *vc = [[SearchVC alloc] init];
//    vc.block = block;
//    vc.requestParams = requestParams;
    vc.isFromSF = [requestParams boolValue];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];

    self.navigationItem.titleView = self.titleSearchBar;
    [self initView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestHomeListWithPage:1 WithCid:1];
//        });
    
    
//    NSArray* arr = (NSArray*)(self.requestParams);
//    NSString* title =  arr[0];
//    NSInteger subID = [arr[1] integerValue];
//    self.navigationItem.title = title;
//    [self requestHomeListWithPage:1 WithCid:1];
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
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotify_DesMovieTimer object:nil];
    [self.historyArray removeAllObjects];
    [self.historyArray addObjectsFromArray:[UserInfoManager GetNSUserDefaults].searchKeyArrs];
    [self showTheHistoryRecords];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
//    [self requestHomeListWithPage:1 WithCid:1];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{

}

- (void)initView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)netwoekingErrorDataRefush{
//    [self  requestHomeListWithPage:1];
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid{
   kWeakSelf(self);
    self.cid = cid;
    if (self.isFromSF) {
        NSMutableArray* arr = [NSMutableArray array];
        self.tableView.tableFooterView = [UIView new];
        [self.sections removeAllObjects];
        [self.tableView reloadData];
        self.tableView.mj_header.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        NSArray* tits = @[@"精选推荐",@"黑丝美腿",@"韩国主播",@"激情偷拍",@"制服诱惑",@"巨乳美女",@"清纯萝莉",@"推特网红"];
        for (int i=0; i<tits.count; i++) {
            HomeItem* it = [HomeItem new];
            it.ID = -(i+1);
            it.name = tits[i];
            it.cover_img = [NSString stringWithFormat:@"priorty%i",i+1];
            [arr addObject:it];
        }
        
//        [_lastSectionSumArr addObjectsFromArray:data];
        [self.sections addObject:@{

                kIndexSection: @(IndexSectionOne),
                kIndexInfo:@[@"分类",@(0),@""],
                kIndexRow: @[arr]}//data.t.arr
         ];
        [self.tableView reloadData];
        return;
    }
    [self.vm network_getHotTagsWithPage:page success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
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
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
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
        case IndexSectionZero:
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            return [HomeSectionHeaderView viewHeight:model];//
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
        case IndexSectionZero:
        case IndexSectionOne:{
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
        case IndexSectionZero:
        case IndexSectionOne:
        {
            if (self.isFromSF) {
                AwemeSearchCell *cell = [AwemeSearchCell cellWith:tableView];
                cell.awemeType = AwemeTargetPush;
                [cell richElementsInCellWithModel:itemData];
                [cell actionBlock:^(id data) {
                    [self pushSearchResultVC:data];
                }];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
            SearchCell *cell = [SearchCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(id data) {
                [self pushSearchResultVC:data];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            }
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

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;

    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {

        case IndexSectionOne:
            return self.isFromSF?[AwemeSearchCell cellHeightWithModel:itemData]: UITableViewAutomaticDimension;
            break;

        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

#pragma mark ---searchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"字数不能超过8" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:nil completion:nil];
        [searchBar setText:[searchText substringToIndex:8]];
    }
    
//    [self.viewModel filterObjectsWithKeyWords:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"========search");
    //store the records,  records are not contain the blank, so should remove the blank record
    NSString *regex = @"\\s*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:searchBar.text]) {
        if (![self.historyArray containsObject:searchBar.text]) {
            [self.historyArray insertObject:searchBar.text atIndex:0];
            
            [self showTheHistoryRecords];
            
//            [self requestHomeListWithPage:1 WithCid:1];
        }
        [self pushSearchResultVC:[NSString stringWithFormat:@"%@",searchBar.text]];
    }
    
//    _historyViewController.historyRecords = _historyArray;
//    [self hiddenTheHistoryRecords];
    [searchBar resignFirstResponder];
    if ([searchBar.text isEqualToString:@"886668"]) {
        [self changeUrlEnvironment];
    }
    // do sth about get search result
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // when we start to write sth, the record should display to us
    if (self.historyArray.count != 0) {
//        _historyViewController.historyRecords = _historyArray;
//        [self showTheHistoryRecords];
        [searchBar becomeFirstResponder];
    }
}

#pragma  mark- history records

- (void)showTheHistoryRecords
{
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    NSArray* subArr = @[];
    if (self.historyArray.count>10) {
        subArr = [self.historyArray subarrayWithRange:NSMakeRange(0, 10)];
    }else{
        subArr = [self.historyArray mutableCopy];
    }
    userInfoModel.searchKeyArrs = [NSArray arrayWithArray:subArr];
    [UserInfoManager SetNSUserDefaults:userInfoModel];
    
    
    if (userInfoModel.searchKeyArrs.count>0) {
        self.tableView.tableHeaderView = self.hv;
        [self.hHV richElementsInCellWithModel:userInfoModel.searchKeyArrs];
        [self.hHV actionBlock:^(id data) {
            [self pushSearchResultVC:data];
        }];
    }
}

- (void)hiddenTheHistoryRecords
{
    [self.historyArray removeAllObjects];
    UserInfoModel* userInfoModel = [UserInfoManager GetNSUserDefaults];
    NSArray* subArr = @[];
    userInfoModel.searchKeyArrs = [NSArray arrayWithArray:subArr];
    [UserInfoManager SetNSUserDefaults:userInfoModel];
    self.tableView.tableHeaderView = nil;
}

- (void)pushSearchResultVC:(id)requestParams{
    [SearchResultVC pushFromVC:self requestParams:requestParams isFromSF:self.isFromSF success:^(id data) {
            
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
       kWeakSelf(self);
       [_tableView addMJHeaderWithBlock:^{
                    kStrongSelf(self);
                    self.currentPage = 1;
                    [self requestHomeListWithPage:self.currentPage WithCid:1];
        }];
//
//       [_tableView addMJFooterWithBlock:^{
//                    kStrongSelf(self);
//                    ++self.currentPage;
//           [self requestHomeListWithPage:self.currentPage WithCid:1];
//        }];
    }
    return _tableView;
}

- (UIView *)hv {
    if (!_hv) {
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MAINSCREEN_WIDTH, 60+20+YBFrameTool.statusBarHeight)];
        
        _hv.backgroundColor = [UIColor whiteColor];
        
        UIButton *titleBtn = [[UIButton alloc]init];
//        [icon0 setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [titleBtn setTitle:@"搜索历史" forState:0];
         titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
         titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         titleBtn.titleLabel.font = kFontSize(18);
         titleBtn.titleLabel.numberOfLines = 1;//0
         titleBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
         [titleBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        [titleBtn setBackgroundColor:kClearColor];
        titleBtn.adjustsImageWhenHighlighted = NO;
        [_hv addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
//            make.centerX.mas_equalTo(self.hv);
            make.height.mas_equalTo(20);
        }];
        
        UIButton *icon0 = [[UIButton alloc]init];
//        [icon0 setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setTitle:@"清除" forState:0];
         icon0.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
         icon0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         icon0.titleLabel.font = kFontSize(18);
         icon0.titleLabel.numberOfLines = 1;//0
         icon0.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
         [icon0 setTitleColor:YBGeneralColor.themeColor forState:UIControlStateNormal];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_hv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(10);
//            make.centerX.mas_equalTo(self.hv);
            make.height.mas_equalTo(20);
        }];
        [icon0 addTarget:self action:@selector(hiddenTheHistoryRecords) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger topMar = 30;
        self.hHV = [[HomeHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:topMar];
        
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

- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
- (MADSearchBar *)titleSearchBar
{
    if (!_titleSearchBar) {
        _titleSearchBar = [[MADSearchBar alloc] initWithFrame:CGRectMake(0,
                                                                    0,  MAINSCREEN_WIDTH,
                                     
                                                                         44)];
        _titleSearchBar.backgroundColor = UIColor.clearColor;
        //    self.titleSearchBar.barStyle = UIBarStyleBlackTranslucent;
            _titleSearchBar.placeholder = @"点击搜索";
            _titleSearchBar.tintColor = YBGeneralColor.themeColor;
        //    [self.titleSearchBar setPositionAdjustment:UIOffsetMake(15, 5) forSearchBarIcon:UISearchBarIconSearch];
            for (UIView *subView in _titleSearchBar.subviews) {
                if ([subView isKindOfClass:[UIView  class]]) {
                    [[subView.subviews objectAtIndex:0] removeFromSuperview];
                    if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                        UITextField *textField = [subView.subviews objectAtIndex:0];
                        textField.backgroundColor = HEXCOLOR(0xECECEC);
                        
                        //设置输入框边框的颜色
                        textField.layer.masksToBounds = true;
                        textField.layer.cornerRadius = 44/2;
        //                textField.layer.borderColor = [UIColor clearColor].CGColor;
        //                textField.layer.borderWidth = 1;
                        
                        //设置输入字体颜色
                        textField.textColor = YBGeneralColor.themeColor;
                        
                        //设置默认文字颜色
                        UIColor *color = [UIColor lightTextColor];
                        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"点击搜索"
                                                                                            attributes:@{NSForegroundColorAttributeName:color}]];
                        //修改默认的放大镜图片
        //                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        //                imageView.backgroundColor = [UIColor clearColor];
        //                imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
        //                textField.leftView = imageView;
                    }
                }
            }
            _titleSearchBar.delegate = self;
    }
    return _titleSearchBar;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
