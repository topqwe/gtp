//
//  PostAdsView.m
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsDetailView.h"
#import "PostAdsDetailCell.h"

#import "BaseCell.h"


#import "PostAdsDetailSectionHeaderView.h"

#import "PostAdsDetailVM.h"

@interface PostAdsDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIButton *contactBtn;

@end

@implementation PostAdsDetailView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.contactBtn];
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:0);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@49);
    }];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array {
    
    if (array.count > 0) {
        if (self.currentPage == 0) {
            [self.sections removeAllObjects];
        }
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;//dont set 1, even if one section, multi rows[@"k"]
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(_sections[0])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [PostAdsDetailSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary* itemData = _sections[0];
    PostAdsDetailType type = [itemData[kType] integerValue];
    NSString *sectionTitle = itemData[kTit];
    NSString *sectionSubTitle = itemData[kSubTit];
    NSString *sectionImg = itemData[kImg];
    PostAdsDetailSectionHeaderView * sectionHeaderView = (PostAdsDetailSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAdsDetailSectionHeaderReuseIdentifier];
    [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle withImg:sectionImg];
    return sectionHeaderView;
    
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    PostAdsDetailType type = [itemData[kType] integerValue];
    return [PostAdsDetailSectionFooterView viewHeightWithType:type];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    PostAdsDetailType type = [itemData[kType] integerValue];
    NSDictionary* dic =itemData[kIndexSection];
    NSString *sectionTitle = dic[kTit];
    NSString *sectionSubTitle = dic[kSubTit];
    
    PostAdsDetailSectionFooterView * sectionHeaderView = (PostAdsDetailSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAdsDetailSectionFooterReuseIdentifier];
    [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
    [sectionHeaderView actionBlock: ^(id data){
        if (self.block) {
            self.block(data);
        }
    }];
    return sectionHeaderView;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostAdsDetailCell *cell = [PostAdsDetailCell cellWith:tableView];
    
    NSDictionary* dic = (_sections[0][kIndexRow])[indexPath.row];
    //            WData* wData = (WData*)itemData;
    [cell richElementsInCellWithModel:dic];
    
    return cell;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [PostAdsDetailCell cellHeightWithModel:(_sections[0][kIndexRow])[indexPath.row]];
        
}
-(void)onGridCellClick:(NSDictionary *)dataModel{
    if (self.clickGridRowBlock) {
        self.clickGridRowBlock(dataModel);
    }
//    HomeMoreVC *moreVc = [[HomeMoreVC alloc] init];
//    moreVc.moreEnterType = Others;
//    moreVc.naviTitle = dataModel[kArr];
//    moreVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:moreVc animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [PostAdsDetailSectionHeaderView sectionHeaderViewWith:_tableView];
        [PostAdsDetailSectionFooterView sectionFooterViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate postAdsDetailView:self requestListWithPage:self.currentPage];
        }
//                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
//        }
         ];
    }
    return _tableView;
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

@end
