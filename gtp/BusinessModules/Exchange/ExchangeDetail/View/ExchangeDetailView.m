//
//  PostAdsView.m
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeDetailView.h"
#import "ExchangeDetailCell.h"

#import "BaseCell.h"


#import "ExchangeDetailSectionHeaderView.h"

#import "ExchangeDetailVM.h"

@interface ExchangeDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, strong) UIView *line;
@end

@implementation ExchangeDetailView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    _tableView.backgroundColor = kWhiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.contactBtn];
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:0);
        make.leading.equalTo(@24);
        make.trailing.equalTo(@-24);
        make.height.equalTo(@42);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contactBtn.mas_top).offset(-3.5);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@.5);
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
        
        [self layoutBottomButton];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}
-(void)layoutBottomButton{
    NSDictionary* infoData = ((_sections[0])[kIndexInfo]);
    ExchangeType etype = [infoData[kType] integerValue];
    [self.contactBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    switch (etype) {
        case ExchangeTypePayed:
        {
            [self.contactBtn setTitle:@"查看Txid" forState:UIControlStateNormal];
            [self.contactBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@42);
            }];
            [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
            }];
        }
            break;
        case ExchangeTypeHandling:
        {
            [self.contactBtn setTitle:@"撤销哥哥" forState:UIControlStateNormal];
            [self.contactBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@42);
            }];
            [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
            }];
        }
            break;
            
        default:
        {
            [self.contactBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
            break;
    }
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
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
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
            return 15;
            break;
        case IndexSectionOne:
            return [ExchangeDetailSectionHeaderView viewHeight];
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
        case IndexSectionZero:{
            UIView * sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 15)];
            sectionHeaderView.backgroundColor = kWhiteColor;
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
            line.backgroundColor = RGBCOLOR(228, 229,232);
            [sectionHeaderView addSubview:line];
            
            return sectionHeaderView;
        }
            break;
        case IndexSectionOne:{
            ExchangeDetailSectionHeaderView * sectionHeaderView = (ExchangeDetailSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ExchangeDetailSectionHeaderReuseIdentifier];
            
            return sectionHeaderView;
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
    NSDictionary* itemData = ((_sections[section])[kIndexInfo]);
    ExchangeType etype = [itemData[kType] integerValue];
    
    switch (type) {
        case IndexSectionOne:
            return [ExchangeDetailSectionFooterView viewHeightWithType:etype];;
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
    NSDictionary* itemData = ((_sections[section])[kIndexInfo]);
    ExchangeType etype = [itemData[kType] integerValue];
    NSString *sectionTitle = itemData[kTit];
    NSString *sectionSubTitle = itemData[kSubTit];
    
    switch (type) {
        case IndexSectionOne:
        {
            ExchangeDetailSectionFooterView * sectionHeaderView = (ExchangeDetailSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ExchangeDetailSectionFooterReuseIdentifier];
            [sectionHeaderView setDataWithType:etype withTitle:sectionTitle withSubTitle:sectionSubTitle];
            
            return sectionHeaderView;
        }
            break;
        default:{
            
            return nil;
        }
            break;
            
    }
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    
    NSDictionary* infoData = ((_sections[section])[kIndexInfo]);
    ExchangeType etype = [infoData[kType] integerValue];
    
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    
    
    
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
        {
            ExchangeDetailCell *cell = [ExchangeDetailCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData withExchangeType:etype];
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
        case IndexSectionOne:
            return [ExchangeDetailCell cellHeightWithModel:itemData];
            break;
        default:
            return 0;
            break;
    }
        
}


#pragma mark - getter
- (UIView*)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = HEXCOLOR(0xe6e6e6);
    }
    return _line;
}
- (UIButton*)contactBtn{
    if (!_contactBtn) {
        _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.tag =  i;
        _contactBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_contactBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
        _contactBtn.adjustsImageWhenHighlighted = NO;
        
//        [_contactBtn setImage:[UIImage imageNamed:@"iconCont"] forState:UIControlStateNormal];
//        [_contactBtn setImage:[UIImage imageNamed:@"iconCont"] forState:UIControlStateSelected];
        
        [_contactBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
        _contactBtn.layer.masksToBounds = YES;
        _contactBtn.layer.borderWidth =1;
        _contactBtn.layer.cornerRadius =4;
        _contactBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        _contactBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_contactBtn addTarget:self action:@selector(clickContactBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_contactBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _contactBtn;
}
-(void)clickContactBtn:(UIButton*)btn{
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [ExchangeDetailSectionHeaderView sectionHeaderViewWith:_tableView];
        [ExchangeDetailSectionFooterView sectionFooterViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate exchangeDetailView:self requestListWithPage:self.currentPage];
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
