//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "AccountBalanceSourceVC.h"
#import "AccountStatedCell.h"
#import "AccountStatedSectionHV.h"
#import "HomeVM.h"
#import "AccountPurseCell.h"
#import "AccountEditAmountVC.h"
@interface AccountBalanceSourceVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *verticalFuncBtns;
@property (nonatomic, strong) NSMutableArray *funcBtns;

@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation AccountBalanceSourceVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    AccountBalanceSourceVC *vc = [[AccountBalanceSourceVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccessBlockMethod) name:kNotify_IsLoginRefresh object:nil];
    [self YBGeneral_baseConfig];
    [self initView];
    
    [self requestListSuccessWithArray];
}

-(void)loginSuccessBlockMethod{
    [self requestListSuccessWithArray];
}

- (void)initView {
    _funcBtns = [NSMutableArray array];
    _verticalFuncBtns = [NSMutableArray array];
    self.title = self.requestParams[kSubTit];
    
    UIView *hv = [[UIView alloc]init];
    hv.userInteractionEnabled = true;
    hv.backgroundColor = HEXCOLOR(0xf59b22);
    [self.view addSubview:hv];
    hv.tag = 1;
    [hv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    for (int i = 0; i < 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.numberOfLines = 0;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [hv addSubview:button];
        [_verticalFuncBtns addObject:button];
    }
    
    UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saftBtn.titleLabel.font = kFontSize(13);
    [saftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saftBtn.tag = 0;
    saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    saftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [hv addSubview:saftBtn];
    [_verticalFuncBtns addObject:saftBtn];
    
    [_verticalFuncBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:12 leadSpacing:13 tailSpacing:62];
    
    [_verticalFuncBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hv).offset(13);
        make.height.equalTo(@36);
    }];


    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.numberOfLines = 0;
        [hv addSubview:button];
        [_funcBtns addObject:button];
    }
    
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(hv.mas_bottom).offset(-13);
        make.height.equalTo(@36);
    }];
        
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hv.mas_bottom).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)requestListSuccessWithArray{
    UIButton* vbtn0 = _verticalFuncBtns[0];
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
    
    NSArray* purses = [UserInfoManager GetNSUserDefaults].purseArr;
    NSArray* allBalanceFromSameSourceMutArr = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeAllSameSourceBalanceStated withDistinction:AccountingDistinctionTypeAllBalanceFromSameSource withDistinctionTime:@"" withDistinctionBalanceSource:self.requestParams[kSubTit]];
    
    for (NSDictionary* dic in purses) {
        if (![dic[kSubTit] isEqualToString:self.requestParams[kSubTit]]) {
            continue;
        }
        NSDecimalNumber* totalInputNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@"0"]];
        if ([[dic allKeys] containsObject:kAmount]) {
             totalInputNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",dic[kAmount]]];
        }
        NSDecimalNumber*finalNum = [totalInputNum decimalNumberByAdding:allBalanceFromSameSourceMutArr[0][kTotal]];
        NSMutableDictionary* dicMut = [NSMutableDictionary dictionary];
        [dicMut addEntriesFromDictionary:self.requestParams];
//        if ([finalNum compare:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@"0"]]] != NSOrderedSame ) {
//            if ([dicMut.allKeys containsObject:kTotal]) {
                [dicMut setObject:[NSString stringWithFormat:@"%@",finalNum] forKey:kTotal];
                self.requestParams = [dicMut mutableCopy];
//            }
//        }
//        else{
//            [self.navigationController popViewControllerAnimated:true];
//        }
    }
    [vbtn0 setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"¥%@",self.requestParams[kTotal]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:16] subString:[NSString stringWithFormat:@"%@",@"修改"] subStringColor:HEXCOLOR(0xff0000) subStringFont:kFontSize(10)] forState:UIControlStateNormal];
    [vbtn0 addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* vbtn1 = _verticalFuncBtns[1];
    [vbtn1 setTitle:[NSString currentDataStringWithFormatString:[NSString ymSeparatedBySlashFormatString]] forState:UIControlStateNormal];
    
    NSArray* monthBalanceFromSameSourceMutArr = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeMonthSameSourceBalanceStated withDistinction:AccountingDistinctionTypeMonthBalanceFromSameSource withDistinctionTime:vbtn1.titleLabel.text withDistinctionBalanceSource:self.requestParams[kSubTit]];
    UIButton* btn0 = _funcBtns[0];
    btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn0 setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"¥%@",monthBalanceFromSameSourceMutArr[0][kTit]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:13] subString:[NSString stringWithFormat:@"(%@)",@"流出"] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13)] forState:UIControlStateNormal];
    
    UIButton* btn1 = _funcBtns[1];
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn1 setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"¥%@",monthBalanceFromSameSourceMutArr[0][kSubTit]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:13] subString:[NSString stringWithFormat:@"(%@)",@"流入"] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13)] forState:UIControlStateNormal];
    
    
    if(self.sections.count>0)[self.sections removeAllObjects];
    
    NSArray* daysInMonthBalanceFromSameSourceMutArr = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeMonthSameDaySameSourceBalanceStated withDistinction:AccountingDistinctionTypeMonthBalanceFromSameSource withDistinctionTime:vbtn1.titleLabel.text withDistinctionBalanceSource:self.requestParams[kSubTit]];
    for (NSDictionary* dic in daysInMonthBalanceFromSameSourceMutArr) {
        [self.sections addObject:dic];
    }
    [self.tableView reloadData];
}
- (void)funAdsButtonClickItem:(UIButton*)btn{
    [AccountEditAmountVC pushFromVC:self requestParams:self.requestParams success:^(id data) {
        [self requestListSuccessWithArray];
    }];
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* arr = _sections[section];
    return arr.count;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [AccountStatedSectionHV balanceSourceHVHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if(!_sections||_sections.count==0)return [UIView new];
    NSDictionary* data = (NSDictionary*)(_sections[section][0]);
    
    AccountStatedSectionHV * sectionHeaderView = (AccountStatedSectionHV *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:AccountStatedSectionHVReuseIdentifier];
    [sectionHeaderView richElementsInBalanceSourceHVWithModel:data];

    return sectionHeaderView;
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountStatedCell *cell = [AccountStatedCell cellWith:tableView];
    [cell richElementsInCellWithModel:_sections[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AccountStatedCell cellHeightWithModel:_sections[indexPath.section][indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [AccountStatedSectionHV sectionHeaderViewWith:_tableView];
        [_tableView registerClass:[AccountStatedSectionHV class] forHeaderFooterViewReuseIdentifier:@"AccountStatedSectionHV"];
        
//       kWeakSelf(self);
//        [_tableView YBGeneral_addRefreshHeader:^{
//            kStrongSelf(self);
//            self.currentPage = 1;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
//        }
//                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
//        }
//         ];
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
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
-(void)dealloc{
    if (self.block) {
        self.block(@(1));
    }
}
@end
