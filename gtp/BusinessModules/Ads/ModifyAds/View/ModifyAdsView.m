//
//  PostAdsView.m
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ModifyAdsView.h"
#import "ExchangeDetailCell.h"
#import "PostAdsRestrictCell.h"
#import "PostAdsReplyCell.h"

#import "BaseCell.h"

#import "ModifyAdsSectionHeaderView.h"
#import "PostAdsSectionHeaderView.h"

#import "ModifyAdsVM.h"

@interface ModifyAdsView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation ModifyAdsView

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
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
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
    return _sections.count;//dont set 1, even if one section, multi rows[@"k"]
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(_sections[section])[kIndexRow] count];;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionZero:
            return [ModifyAdsSectionHeaderView viewHeight];
            break;
        case IndexSectionOne:
        case IndexSectionTwo:
            return [PostAdsSectionHeaderView viewHeight];
            break;
        default:
            return 0.1f;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf);
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    NSString *sectionTitle = @"";
    NSString *sectionSubTitle = @"";
    
    
    sectionTitle =  (NSString*)(_sections[section])[kTit];
    sectionSubTitle = (NSString*)(_sections[section])[kSubTit];
    
    switch (type) {
        case IndexSectionZero:
        {
            ModifyAdsSectionHeaderView * sectionHeaderView = (ModifyAdsSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ModifyAdsSectionHeaderReuseIdentifier];
            [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle withImg:@""];
            return sectionHeaderView;
        }
        case IndexSectionOne:
        case IndexSectionTwo:
        {
            PostAdsSectionHeaderView * sectionHeaderView = (PostAdsSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAdsSectionHeaderReuseIdentifier];
            
            [sectionHeaderView setMddifyAdsDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
            sectionHeaderView.clickSectionBlock = ^(NSString* sec){
                [weakSelf sectionHeaderSubBtnClickTag:sec];
            };
            return sectionHeaderView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }
    
    
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
            return 11.f;
            break;
        case IndexSectionTwo:
            return [ModifyAdsSectionFooterView viewHeightWithType:type];
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    NSString *sectionTitle = @"";
    NSString *sectionSubTitle = @"";
//
//    NSArray* arr = (NSArray*)(_sections[section])[kIndexInfo];
//    sectionTitle =  arr[0];
//    sectionSubTitle = arr[1];

    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
        {
            UIView* sectionFooterView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 11.f)];
            sectionFooterView.backgroundColor = kWhiteColor;
            
            return sectionFooterView;
        }
            break;
        case IndexSectionTwo:
        {
            ModifyAdsSectionFooterView * sectionHeaderView = (ModifyAdsSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ModifyAdsSectionFooterReuseIdentifier];
            [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
            [sectionHeaderView actionBlock:^(id data) {
                if(self.block){
                    self.block(data);
                }
            }];
            
            return sectionHeaderView;
        }
            break;
        default:{
            
            return nil;
        }
            break;
            
    }
    return nil;
    
    
}
-(void)actionBlock:(ActionBlock)block{
    self.block = block;
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
            ExchangeDetailCell *cell = [ExchangeDetailCell cellWith:tableView];
            
            NSDictionary* dic = (_sections[0][kIndexRow])[indexPath.row];
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:dic withExchangeType:ExchangeTypeAll];
            
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            PostAdsReplyCell *cell = [PostAdsReplyCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            
            return cell;
            
        }
            break;
        case IndexSectionTwo:
        {
            PostAdsRestrictCell *cell = [PostAdsRestrictCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            
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
            return [ExchangeDetailCell cellHeightWithModel:itemData];
            break;
        case IndexSectionOne:
        {
            return [PostAdsReplyCell cellHeightWithModel:itemData];
        }
            break;
        case IndexSectionTwo:
        {
            return [PostAdsRestrictCell cellHeightWithModel:itemData];
        }
            break;
        default:
            return 0;
            break;
    }

            
        
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
        [ModifyAdsSectionHeaderView sectionHeaderViewWith:_tableView];
        [PostAdsSectionHeaderView sectionHeaderViewWith:_tableView];
        [ModifyAdsSectionFooterView sectionFooterViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate modifyAdsView:self requestListWithPage:self.currentPage];
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
