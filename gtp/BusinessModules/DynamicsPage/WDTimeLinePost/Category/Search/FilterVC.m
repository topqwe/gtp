//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "FilterVC.h"

#import "HomeVM.h"

#import "MoreGridCell.h"

#import "StyleCell5.h"

#import "HomeSectionHeaderView.h"

#import "FilterHV.h"
#import "FilterSuspensionV.h"
#import "HomeFV.h"
#import "MADSearchBar.h"
#import "SearchVC.h"
#define kHeaderHeight   (235-30)
@interface FilterVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MADSearchBar *titleSearchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) FilterHV * hHV;
@property (nonatomic, strong) FilterSuspensionV*suspensionV;
@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;

@property (nonatomic, copy) NSDictionary*  cid;
@property (nonatomic, copy) NSDictionary* requestParams;

@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIButton * pageBtn;
@property (nonatomic, assign)BOOL isPageClick;

@end

@implementation FilterVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    FilterVC *vc = [[FilterVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)levSuccessMethod{
    [self requestList];
}

- (void)requestList{
    
    [self requestHomeListWithPage:1];
}
- (void)searchButtonClickItem:(UIButton*)sender{
    sender.selected = !sender.selected;
    [SearchVC pushFromVC:self requestParams:nil success:^(id data) {

    }];
//    SearchVC *vc = [[SearchVC alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
////    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:true completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    UIButton* btn = [UIButton new];
    btn.frame = CGRectMake(0,
                        0,  MAINSCREEN_WIDTH,

                           44);
    self.navigationItem.titleView = btn;
    self.titleSearchBar.userInteractionEnabled = NO;
    [btn addSubview:self.titleSearchBar];
    [btn addTarget:self action:@selector(searchButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self YBGeneral_baseConfig];
    [self initView];
    self.view.backgroundColor = kWhiteColor;
//
//    NSArray* arr = (NSArray*)(self.requestParams);
//    NSString* title =  arr[0];
//    self.navigationItem.title = title;
    
    
    [self.view addSubview:self.hv];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestTags];
        });
    
//    [self requestList];
}

- (void)requestTags{
    kWeakSelf(self);
    [self.vm network_getSCTagsWithPage:1 didAdd0Data:YES didAddLastData:NO success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
        kStrongSelf(self);
        if (lastSectionSumArr.count>3) {
            [self.hHV richElementsInCellWithModel:lastSectionSumArr WithDummy0Datas:dataArray];
        }
        
        [self.hHV actionBlock:^(NSArray* arr) {
            
            if (arr.count == 3) {
                HomeItem* item0 = arr.firstObject;
                HomeItem* item1 = arr[1];
                HomeItem* item2 = arr[2];
                self.cid = @{@"cid":item0.ID !=
                             -1?@[@(item0.ID)]:@[],
                             @"bid":item1.ID != -1?@[@(item1.ID)]:@[],
                             @"type":@(item2.ID),
                             @"sort":@(-1)};
            }else if (arr.count == 4){
                HomeItem* item0 = arr.firstObject;
                HomeItem* item1 = arr[1];
                HomeItem* item2 = arr[2];
                HomeItem* item3 = arr[3];
                self.cid = @{@"cid":item0.ID !=
                             -1?@[@(item0.ID)]:@[],
                             @"bid":item1.ID != -1?@[@(item1.ID)]:@[],
                             @"type":@(item2.ID),
                             @"sort":@(item3.ID)};
            }
            if ([self.cid isEqualToDictionary:GetUserDefaultWithKey(@"fcDic")]) {
                return;
            }
            [self requestList];
            
            SetUserDefaultKeyWithObject(@"fcDic", self.cid);
            
            [self.suspensionV richElementsInCellWithModel:arr];
        }];
        
        self.cid = @{@"type":@(-1),@"sort":@(-1)};
        [self requestList];
        if (lastSectionSumArr.count>2) {
            NSMutableArray* items2= [NSMutableArray array];
            for (int i=0; i<lastSectionSumArr.count-1; i++) {
                NSArray* arr = lastSectionSumArr[i];
                [items2 addObject:arr.firstObject];
            }
            [self.suspensionV richElementsInCellWithModel:items2];
            
        }
        
        
    } failed:^(id model){
        
    }];
    
}

- (void)funAdsButtonClickItem:(UIButton*)sender{
    if (sender.tag == 201) {
        sender.selected = !sender.selected;
        [sender setImage:sender.isSelected ? [UIImage imageNamed:@"m_alterStyle1"]:[UIImage imageNamed:@"m_alterStyle0"] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else{
        NSMutableArray* arr = [NSMutableArray array];
        for (int i = 1; i<101; i++) {
            [arr addObject:[NSString stringWithFormat:@"%i",i]];
        }
        [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:arr selectIndex:self.currentPage-1 resultBlock:^(BRResultModel * _Nullable resultModel) {
//            self.typeString = resultModel.value;
            self.isPageClick = YES;
            [self requestHomeListWithPage:[resultModel.value integerValue]];
            

        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [FunctionMenuView dismissAllJRMenu];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [FunctionMenuView dismissAllJRMenu];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated{

}

- (void)initView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view.mas_top).offset(kHeaderHeight);
        make.center.equalTo(self.view);
//        make.edges.equalTo(self.view);
    }];
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
//
//
//    if (object == self.tableView) {
//
//    //如果是这个对象就可以获得contentOffset的值然后判断是正或者负，来判断上拉下拉。
//    CGPoint point = [((NSValue *)[self.tableView  valueForKey:@"contentOffset"]) CGPointValue];
//        if (point.y > kHeaderHeight) {
//            [self.suspensionV contentOffShow:NO];
//            self.hv.hidden = YES;
//        }else{
//
//            [self.suspensionV contentOffShow:NO];
//            self.hv.hidden = NO;
//        }
//
//    }
//
//}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

//    if (scrollView.panGestureRecognizer.state != UIGestureRecognizerStateChanged) return;
    
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view];
    
    if(velocity.y >0 ){
    //向下滑动
        self.hv.hidden = NO;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(kHeaderHeight);
        }];
        
    }else{
    //向上滑动
        self.hv.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(0);
        }];
    }
}

-(void)netwoekingErrorDataRefush{
//    [self  requestHomeListWithPage:1];
}
#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page{
   kWeakSelf(self);
    [self.pageBtn setTitle:[NSString stringWithFormat:@"选择页数 当前第%li页",page] forState:UIControlStateNormal];
//    self.currentPage = page;

    [self.vm network_getSCPageResultWithPage:page WithCid:self.cid  withPageClick:self.isPageClick WithSearchSource:SearchRecordSourceTags success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
        kStrongSelf(self);
        [self requestHomeListSuccessWithArray:dataArray WithLastSectionArr:lastSectionArr WithLastSectionSumArr:lastSectionSumArr WithPage:page];
        self.isPageClick = NO;
    } failed:^(id model){
        kStrongSelf(self);
//        [self requestHomeListSuccessWithArray:model WithPage:page];
        [self requestHomeListFailed];
        self.isPageClick = NO;
    }];
}

#pragma mark - public processData
- (void)requestHomeListSuccessWithArray:(NSArray *)sections WithLastSectionArr:(NSArray *)lastSectionArr WithLastSectionSumArr:(NSArray *)lastSectionSumArr WithPage:(NSInteger)page{
    self.currentPage = page;
    if (self.currentPage == 1) {
        self.tableView.tableFooterView = [UIView new];
        [self.sections removeAllObjects];
        [self.tableView reloadData];
        if (self.dataEmptyView) {
            [self.dataEmptyView removeFromSuperview];
        }
//        UIButton* btn0 = _funcBtns[0];
//        [self.view layoutIfNeeded];
        self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:kHeaderHeight withCustomTitle:@"暂无匹配结果" withCustomImageName:@"Search_icon_dataEmpty"];
        if(!sections||sections.count==0){
            self.dataEmptyView.hidden = false;
        }else{
            self.dataEmptyView.hidden = true;
        }
    }
    if (sections.count > 0) {
        self.dataEmptyView.hidden = true;
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
//            self.tableView.mj_footer.hidden = YES;
        }
        
    } else {
//        self.dataEmptyView.hidden = true;
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
            if (self.clickButton.selected) {
                
                MoreGridCell *cell = [MoreGridCell cellWith:tableView];
                [cell richElementsInCellWithModel:itemData];
                [cell actionBlock:^(id data) {
                    [self pushMoviePlayerVC:data];
                }];
                return cell;
            }
            else{
                StyleCell5 *cell = [StyleCell5 cellWith:tableView];
                [cell richElementsInCellWithModel:itemData];
                [cell actionBlock:^(id data) {
                    [self pushMoviePlayerVC:data];
                }];
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
- (void)pushMoviePlayerVC:(id) data{
//    [MoviePlayerVC pushFromVC:self requestParams:data success:^(id data) {
//
//    }];
    [ShowFilmVC pushFromVC:self requestParams:data success:^(id data) {

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
            return self.clickButton.selected?[MoreGridCell cellHeightWithModel:itemData]:[StyleCell5 cellHeightWithModel:itemData];
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
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        UIView* headV =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, kHeaderHeight)];
//        _tableView.tableHeaderView = headV;
////        _tableView.tableFooterView = self.fv;
//        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
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
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, kHeaderHeight)];
        
        _hv.backgroundColor = [UIColor whiteColor];
        
        
        
        NSInteger topMar = 5;
//        +YBFrameTool.statusBarHeight;
        self.hHV = [[FilterHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:topMar];//h=150
        
        UIImageView* line0 = [[UIImageView alloc]init];
        [_hv addSubview:line0];
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
        self.clickButton.titleLabel.font = kFontSize(18);
    //        titButton.layer.masksToBounds = YES;
    //        titButton.layer.cornerRadius = 8;
    //        button.layer.borderWidth = 0;
        [self.clickButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        self.clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.clickButton
                 setImage:[UIImage imageNamed:@"m_alterStyle0"] forState:0];
//        [self.clickButton setTitle:@"切换风格" forState:UIControlStateNormal];
        [self.clickButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];

//        [clickButton setBackgroundColor:UIColor.redColor];
        
        [_hv addSubview:self.clickButton];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
//            make.bottom.mas_equalTo(0);
            make.bottom.mas_equalTo(-8);
//            make.centerX.mas_equalTo(self.hv);
            
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        
        self.pageBtn = [[UIButton alloc]init];
        self.pageBtn.tag = 200;
//        [pageBtn
//         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [self.pageBtn setBackgroundColor:kClearColor];
        self.pageBtn.adjustsImageWhenHighlighted = NO;
         self.pageBtn.titleLabel.numberOfLines = 0;
         self.pageBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
         self.pageBtn.titleLabel.font = kFontSize(18);
     //        titButton.layer.masksToBounds = YES;
     //        titButton.layer.cornerRadius = 8;
     //        button.layer.borderWidth = 0;
         [self.pageBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
         self.pageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         self.pageBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
         [self.pageBtn setTitle:@"" forState:UIControlStateNormal];
         [self.pageBtn addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [_hv addSubview:self.pageBtn];
        self.pageBtn.hidden = YES;
        [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-1);
//            make.centerX.mas_equalTo(self.hv);
            
            make.width.mas_equalTo(190);
            make.height.mas_equalTo(50);
        }];
        
    }
    return _hv;
}

- (FilterSuspensionV *)suspensionV{
    if (!_suspensionV) {
        NSInteger topMar = 0;
//        +YBFrameTool.statusBarHeight;
        _suspensionV = [[FilterSuspensionV alloc]initWithFrame:CGRectZero InSuperView:self.view withTopMargin:topMar];//h=150
        [_suspensionV contentOffShow:NO];
        
    }
    return _suspensionV;
}
- (UIView *)fv {
    if (!_fv) {
        _fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.iphoneBottomHeight)];
        
        _fv.backgroundColor = [UIColor clearColor];
        
        UIButton *pageBtn = [[UIButton alloc]init];
        [pageBtn
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [pageBtn setBackgroundColor:kClearColor];
        pageBtn.adjustsImageWhenHighlighted = NO;
        [_fv addSubview:pageBtn];
        [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (MADSearchBar *)titleSearchBar
{
    if (!_titleSearchBar) {
        _titleSearchBar = [[MADSearchBar alloc] initWithFrame:CGRectMake(0,
                                                                    0,  MAINSCREEN_WIDTH-20,
                                     
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
