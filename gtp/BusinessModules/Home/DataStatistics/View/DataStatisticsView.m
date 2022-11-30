//
//  PostAdsView.m
//  gtp
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "DataStatisticsView.h"

#import "DataStatisticsSlideCell.h"


#import "DataStatisticsSectionHeaderView.h"

#import "DataStatisticsVM.h"

@interface DataStatisticsView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation DataStatisticsView

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
    
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
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
    
    return 1;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [DataStatisticsSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary* itemData = ((_sections[section])[0]);
    NSString* sectionTitle= itemData[kTit];
    NSString* sectionSubTitle= itemData[kSubTit];
            
            DataStatisticsSectionHeaderView * sectionHeaderView = (DataStatisticsSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:DataStatisticsSectionHeaderReuseIdentifier];
            [sectionHeaderView setDataWithType:IndexSectionZero withTitle:sectionTitle withSubTitle:sectionSubTitle];
            sectionHeaderView.clickSectionBlock = ^(NSString* sec){
//                [weakSelf sectionHeaderSubBtnClickTag:sec];
            };
            //    sectionHeaderView.delegate =self;
            return sectionHeaderView;
    
    
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
  
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [DataStatisticsSectionFooterView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = ((_sections[section])[0]);
    NSArray* datas = itemData[kIndexInfo];
    NSString* sectionTitle= datas[0];
    NSString* sectionSubTitle= datas[1];
    
    DataStatisticsSectionFooterView * sectionHeaderView = (DataStatisticsSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:DataStatisticsSectionFooterReuseIdentifier];
    [sectionHeaderView setDataWithType:IndexSectionZero withTitle:sectionTitle withSubTitle:sectionSubTitle];
    
    return sectionHeaderView;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DataStatisticsSubDataItem* itemData = ((_sections[indexPath.section])[indexPath.row]);
    NSDictionary* itemData = ((_sections[indexPath.section])[indexPath.row]);
    
    DataStatisticsSlideCell *cell = [DataStatisticsSlideCell cellWith:tableView];
    [cell richElementsInCellWithModel:itemData];
//            cell.clickGridRowBlock = ^(NSDictionary *dataModel) {
//                [weakSelf onGridCellClick:dataModel];
//            };
            
            return cell;
          
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary* itemData = ((_sections[indexPath.section])[indexPath.row]);
    return [DataStatisticsSlideCell cellHeightWithModel];
        
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
        [DataStatisticsSectionHeaderView sectionHeaderViewWith:_tableView];
        [DataStatisticsSectionFooterView sectionFooterViewWith:_tableView];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate dataStatisticsView:self requestListWithPage:self.currentPage];
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
