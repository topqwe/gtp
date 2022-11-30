//
//  PostAdsView.m
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeView.h"
#import "ExchangeAccountCell.h"
#import "ExchangeStatusCell.h"
#import "BaseCell.h"

#import "ExchangeSectionHeaderView.h"

#import "ExchangeVM.h"

@interface ExchangeView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation ExchangeView

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
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page {
    
    if (array.count > 0) {
        self.currentPage = page;
        if (self.currentPage == 1) {
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
            return 5;
            break;
        case IndexSectionOne:
            return .1f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
//    HomeMoreVC *moreVc = [[HomeMoreVC alloc] init];
//    moreVc.moreEnterType = Others;
//    moreVc.naviTitle = sec;
//    moreVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:moreVc animated:YES];
  
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
            return [ExchangeSectionHeaderView viewHeight];
            break;
        case IndexSectionOne:
            return .1f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    NSString *sectionTitle = @"";
    NSString *sectionSubTitle = @"";
    
    //    id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionZero: {
            NSString* data = (NSString*)(_sections[section])[kIndexInfo];
            sectionTitle =  data;
            sectionSubTitle = @"";
            WS(weakSelf) ;
            
            ExchangeSectionHeaderView * sectionHeaderView = (ExchangeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ExchangeSectionHeaderReuseIdentifier];
            [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
            sectionHeaderView.clickSectionBlock = ^(NSString* sec){
                [weakSelf sectionHeaderSubBtnClickTag:sec];
            };
            //    sectionHeaderView.delegate =self;
            return sectionHeaderView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        {
            ExchangeAccountCell *cell = [ExchangeAccountCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(id data) {
                if (self.block) {
                    self.block(data);
                }
            }];
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            ExchangeStatusCell *cell = [ExchangeStatusCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            
            return cell;
            
        }
            break;
        default:{
            BaseCell *cell = [BaseCell cellWith:tableView];
            cell.hideSeparatorLine = YES;
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
            return [ExchangeAccountCell cellHeightWithModel:itemData];
            break;
            
        case IndexSectionOne:
            return [ExchangeStatusCell cellHeightWithModel:itemData];
            break;
            
        default:
            return 0;
            break;
    }
}

-(void)actionBlock:(ActionBlock)block{
    self.block= block;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
            
        case IndexSectionOne:{
            if (self.block) {
                self.block(itemData);
            }
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
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [ExchangeSectionHeaderView sectionHeaderViewWith:_tableView];
        
       kWeakSelf(self);
       [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate exchangeView:self requestListWithPage:self.currentPage];
        }
        footer:^{
            kStrongSelf(self);
            ++self.currentPage;
            [self.delegate exchangeView:self requestListWithPage:self.currentPage];
        }
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
