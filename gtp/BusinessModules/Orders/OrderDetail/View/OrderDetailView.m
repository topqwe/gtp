//
//  PostAdsView.m


#import "OrderDetailView.h"
#import "OrderDetailCell.h"
#import "BaseCell.h"
#import "OrderDetailSectionHeaderView.h"

#import "OrderDetailVM.h"

@interface OrderDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation OrderDetailView

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
    return [OrderDetailSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    OrderDetailSectionHeaderView * sectionHeaderView = (OrderDetailSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderDetailSectionHeaderReuseIdentifier];
    [sectionHeaderView richElementsInViewWithModel:itemData];
    return sectionHeaderView;
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    OrderType type = [itemData[kType] integerValue];
    return [OrderDetailSectionFooterView viewHeightWithType:type];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    OrderDetailSectionFooterView * sectionHeaderView = (OrderDetailSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderDetailSectionFooterReuseIdentifier];
    [sectionHeaderView richElementsInViewWithModel:itemData];
    [sectionHeaderView actionBlock:^(id data,id data2) {
        if (self.block) {
            self.block(data,data2);
        }
    }];
    return sectionHeaderView;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailCell *cell = [OrderDetailCell cellWith:tableView];
    
    NSDictionary* dic = (_sections[0][kIndexRow])[indexPath.row];
    //            WData* wData = (WData*)itemData;
    [cell richElementsInCellWithModel:dic WithArr:_sections[0][kIndexRow] WithIndexPath:indexPath];
    
    return cell;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [OrderDetailCell cellHeightWithModel:(_sections[0][kIndexRow])[indexPath.row]];
        
}

#pragma mark - getter
- (UIButton*)contactBtn{
    if (!_contactBtn) {
        _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactBtn.tag =  EnumActionTag2;
        _contactBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_contactBtn setTitleColor:HEXCOLOR(0xe27500) forState:UIControlStateNormal];
        [_contactBtn setTitle:@"联系可可家" forState:UIControlStateNormal];
        _contactBtn.adjustsImageWhenHighlighted = NO;
        
        [_contactBtn setImage:[UIImage imageNamed:@"iconCont"] forState:UIControlStateNormal];
        [_contactBtn setImage:[UIImage imageNamed:@"iconCont"] forState:UIControlStateSelected];
        [_contactBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
        _contactBtn.layer.masksToBounds = YES;
        _contactBtn.layer.borderWidth =1;
        _contactBtn.layer.borderColor = HEXCOLOR(0xf0f1f3).CGColor;
        _contactBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_contactBtn addTarget:self action:@selector(clickContactBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_contactBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _contactBtn;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

-(void)clickContactBtn:(UIButton*)btn{
    NSDictionary* itemData = _sections[0];
    if (self.block) {
        self.block(@(btn.tag),itemData);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [OrderDetailSectionHeaderView sectionHeaderViewWith:_tableView];
        [OrderDetailSectionFooterView sectionFooterViewWith:_tableView];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate orderDetailView:self requestListWithPage:self.currentPage];
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
