//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "HomeLVC.h"
#import "HomeView.h"

#import "HomeVM.h"

#import "BannerCell.h"
#import "StyleScCell1.h"
#import "StyleCell4.h"
#import "StyleCell8.h"

#import "StyleCell5.h"
#import "MoreGridCell.h"//s6
#import "StyleCell7.h"
#import "HomeMoreVC.h"

#import "GridCell.h"

#import "HomeOrderCell.h"
#import "HomeSectionHeaderView.h"
#import "HomeBFView.h"
#import "HomeHV.h"
#import "HomeFV.h"

@interface HomeLVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;


@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) HomeHV * hHV;


@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;

@property (nonatomic, assign) NSInteger  cid;
@end

@implementation HomeLVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
    
    
    
//    [self requestHomeListWithPage:1 WithCid:1];
    //监听程序进入前台
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidBecomeActive:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    [_tableView reloadData];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

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
    [self.vm network_postHomeListWithPage:page WithCid:self.cid success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
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
//            self.tableView.mj_footer.hidden = YES;
            //最后一页无数据
            
        }
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
    }
    
//    if (_sections.count>0) {
//        if (self.currentPage ==1) {
//            [self.tableView setScrollsToTop:true];
//        }else{
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_sections.count-1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//        }
//    }
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
    NSInteger type = [(_sections[section])[kIndexSection] integerValue];
    
    NSArray* indexInfos = (_sections[section])[kIndexInfo];
    
    IndexSectionUIStyle style = [(_sections[section])[kType] integerValue];
    if (type != IndexSectionZero&&indexInfos.count>0) {
        if (style == IndexSectionUIStyleFour
            ||
            style == IndexSectionUIStyleEight){
            return 0.1;
        }
        else {
        NSDictionary* model = (NSDictionary*)(_sections[section]);
        return [HomeSectionHeaderView viewHeight:model];
        }
        
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    NSInteger type = [(_sections[section])[kIndexSection] integerValue];

    NSArray* indexInfos = (_sections[section])[kIndexInfo];
    
    IndexSectionUIStyle style = [(_sections[section])[kType] integerValue];
    
    if (type != IndexSectionZero&&indexInfos.count>0) {
        if (style == IndexSectionUIStyleFour
                  ||
                  style == IndexSectionUIStyleEight){
            return [UIView new];
        }
        else {
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            [sectionHeaderView actionBlock:^(id data) {
                [HomeMoreVC pushFromVC:self requestParams:model[kIndexInfo] success:^(id data) {
                    
                }];
            }];
            return  sectionHeaderView;
        }
    }
    return [UIView new];
}


#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    NSInteger type = [(_sections[section])[kIndexSection] integerValue];
    
    NSArray* indexInfos = (_sections[section])[kArr];
    
    IndexSectionUIStyle style = [(_sections[section])[kType] integerValue];
    if (type != IndexSectionZero&&indexInfos.count>0) {
//        if (style != IndexSectionUIStyleFour) {
        NSDictionary* model = (NSDictionary*)(_sections[section]);
        return [HomeBFView viewHeight:model];
//        }
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    NSInteger type = [(_sections[section])[kIndexSection] integerValue];

    NSArray* indexInfos = (_sections[section])[kArr];
    
    IndexSectionUIStyle style = [(_sections[section])[kType] integerValue];
    
    if (type != IndexSectionZero&&indexInfos.count>0) {
//        if (style != IndexSectionUIStyleFour) {
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            HomeBFView * sectionHeaderView = (HomeBFView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeBFViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            [sectionHeaderView actionBlock:^(id data, id data2) {
                HomeItem* item = data2;
                switch ([data integerValue]) {
                    case BannerTypeVideo:
                    {
                        [self pushMoviePlayerVC:item];
                    }
                        break;
                    case BannerTypeH5:
                    {
                        if (item.url.length > 0) {
                            NSURL *url = [NSURL URLWithString:item.url];
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                        break;
                    case BannerTypeJumpPW:
                    {
                        [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                            [self requestHomeListWithPage:1 WithCid:self.cid];
                        }];
                    }
                        break;
                    case BannerTypeForV:
                    {
                        [LevelVC pushFromVC:self
                               requestParams:@0
                                     success:^(id data) {
                            [self requestHomeListWithPage:1 WithCid:self.cid];
                        }];
                    }
                        break;
                    case BannerTypeForB:
                    {
                        [LevelVC pushFromVC:self
                               requestParams:@1
                                     success:^(id data) {
                            [self requestHomeListWithPage:1 WithCid:self.cid];
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        
            return  sectionHeaderView;
//        }
    }
    return [UIView new];
}

#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    NSInteger type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    id itemSecInfo = (_sections[section])[kIndexInfo];
    if (type == IndexSectionZero) {
        BannerCell *cell = [BannerCell cellWith:tableView];
        [cell richElementsInCellWithModel:itemData];
        [cell actionBlock:^(id data, id data2) {
            HomeItem* item = data2;
            switch ([data integerValue]) {
                case BannerTypeVideo:
                {
                    [self pushMoviePlayerVC:item];
                }
                    break;
                case BannerTypeH5:
                {
                    if (item.url.length > 0) {
                        NSURL *url = [NSURL URLWithString:item.url];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
                    break;
                case BannerTypeJumpPW:
                {
                    [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                        [self requestHomeListWithPage:1 WithCid:self.cid];
                    }];
                }
                    break;
                case BannerTypeForV:
                {
                    [LevelVC pushFromVC:self
                           requestParams:@0
                                 success:^(id data) {
                        [self requestHomeListWithPage:1 WithCid:self.cid];
                    }];
                }
                    break;
                case BannerTypeForB:
                {
                    [LevelVC pushFromVC:self
                           requestParams:@1
                                 success:^(id data) {
                        [self requestHomeListWithPage:1 WithCid:self.cid];
                    }];
                }
                    break;
                default:
                    break;
            }
        }];
        return cell;
    }else{
        NSDictionary* dic = itemData;
        NSArray* arr = dic.allValues[0];
        IndexSectionUIStyle style = [dic.allKeys[0] integerValue];
        if (arr.count>0) {
            if (style == IndexSectionUIStyleFour){
                StyleCell4 *cell = [StyleCell4 cellWith:tableView];
                [cell richElementsInCellWithModel:itemData withInfo:itemSecInfo];
                [cell actionBlock:^(id data) {
                    if ([data isKindOfClass:[NSArray class]]) {
                        [HomeMoreVC pushFromVC:self requestParams:data success:^(id data) {
                        }];
                    }else{
                        [self pushMoviePlayerVC:data];
                    }
                    
                }];
                return cell;
            }
            if (style == IndexSectionUIStyleEight){
                StyleCell8 *cell = [StyleCell8 cellWith:tableView];
                [cell richElementsInCellWithModel:itemData withInfo:itemSecInfo];
                [cell actionBlock:^(id data) {
                    if ([data isKindOfClass:[NSArray class]]) {
                        [HomeMoreVC pushFromVC:self requestParams:data success:^(id data) {
                        }];
                    }else{
                        [self pushMoviePlayerVC:data];
                    }
                    
                }];
                return cell;
            }
            
                
            if (style == IndexSectionUIStyleFive) {
                
                StyleCell5 *cell = [StyleCell5 cellWith:tableView];
                [cell richElementsInCellWithModel:itemData];
                [cell actionBlock:^(id data) {
                    [self pushMoviePlayerVC:data];
                }];
                return cell;
            }
            if (style == IndexSectionUIStyleSix) {
                
                MoreGridCell *cell = [MoreGridCell cellWith:tableView];
                cell.style = IndexSectionUIStyleSix;
                [cell richElementsInCellWithModel:arr];
                [cell actionBlock:^(id data) {
                    [self pushMoviePlayerVC:data];
                }];
                return cell;
            }
            if (style == IndexSectionUIStyleSeven) {
                if (arr.count > 1) {
                    StyleCell7 *cell = [StyleCell7 cellWith:tableView];
                    [cell richElementsInCellWithModel:itemData];
                    [cell actionBlock:^(id data) {
                        [self pushMoviePlayerVC:data];
                    }];
                    return cell;
                }else if (arr.count ==1){
                    StyleCell5 *cell = [StyleCell5 cellWith:tableView];
                    [cell richElementsInCellWithModel:itemData];
                    [cell actionBlock:^(id data) {
                        [self pushMoviePlayerVC:data];
                    }];
                    return cell;
                }
                
            }
            
            if (style < IndexSectionUIStyleFour) {
                if (arr.count >1) {
                    StyleCell1 *cell = [StyleCell1 cellWith:tableView];
                    [cell richElementsInCellWithModel:itemData];
                    [cell actionBlock:^(id data) {
                        [self pushMoviePlayerVC:data];
                    }];
                    return cell;
                }else if (arr.count ==1){
                    MoreGridCell *cell = [MoreGridCell cellWith:tableView];
                    [cell richElementsInCellWithModel:arr];
                    [cell actionBlock:^(id data) {
                        [self pushMoviePlayerVC:data];
                    }];
                    return cell;
                }
                
            }
            
                    
        }
        
    }
    static NSString *name=@"defaultCell";
                            
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:name];
        
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.frame = CGRectZero;

    return cell;
}
- (NSMutableArray *)heightArray{
   if (_heightArray == nil) {
       _heightArray = [NSMutableArray array];
   }
   return _heightArray;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
//    NSInteger type = [_sections[section][kIndexSection] integerValue];
//    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
//    CGFloat itemHeight = [((_sections[section])[kIndexHeight])[indexPath.row] floatValue];
    CGFloat height = 0.1f;
    height = [((_sections[section])[kIndexHeight])[indexPath.row] floatValue];

//    if (type == IndexSectionZero) {
//        height = [BannerCell cellHeightWithModel];
//        [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//    }else{
////        return [StyleCell1 cellHeightWithItem:itemData];
//        NSDictionary* dic = itemData;
//        NSArray* arr = dic.allValues[0];
//        IndexSectionUIStyle style = [dic.allKeys[0] integerValue];
//        if (arr.count>0) {
//            if (style == IndexSectionUIStyleFour){
//                height = [StyleCell4 cellHeightWithModel];
//                [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//            }
//            if (style == IndexSectionUIStyleEight){
//                height = [StyleCell8 cellHeightWithModel];
//                [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//            }
//            if (style == IndexSectionUIStyleFive) {
//                height = [StyleCell5 cellHeightWithModel:itemData];
//                [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//            }
//
//            if (style == IndexSectionUIStyleSix) {
//                height = [MoreGridCell cellHeightWithModel:arr];
//                [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//            }
//
//            if (style == IndexSectionUIStyleSeven) {
//                if (arr.count > 1) {
//                    height = [StyleCell7 cellHeightWithModel:itemData];
//                    [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//                }else if (arr.count ==1){
//                    height = [StyleCell5 cellHeightWithModel:itemData];
//                    [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//                }
//            }
//
//            if (style < IndexSectionUIStyleFour) {
//                if (arr.count > 1) {
//                    height = [StyleScCell1 cellHeightWithModel:itemData];
//                    [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//                }else if (arr.count ==1){
//                    height = [MoreGridCell cellHeightWithModel:arr];
//                    [self.heightArray addObject:[NSNumber numberWithDouble:height]];
//                }
//
//            }
//
//        }
//    }

    return  height;
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
- (void)pushMoviePlayerVC:(id) data{
//    [MoviePlayerVC pushFromVC:self requestParams:data success:^(id data) {
//
//    }];
    [ShowFilmVC pushFromVC:self requestParams:data success:^(id data) {

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
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
        [HomeBFView sectionHeaderViewWith:_tableView];
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
