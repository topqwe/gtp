//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "AccountPurseVC.h"
#import "HomeVM.h"
#import "AccountPurseCell.h"
#import "AccountBalanceSourceVC.h"
#import "AccountEditAmountVC.h"
@interface AccountPurseVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) HomeVM *vm;

@end

@implementation AccountPurseVC

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.backgroundColor = HEXCOLOR(0xf59b22);
    [self.view addSubview:button];
    button.tag = 1;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)requestListSuccessWithArray{
    if(self.sections.count>0)[self.sections removeAllObjects];
    NSArray* array = [UserInfoManager GetNSUserDefaults].purseArr;
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
    
    for (NSDictionary* dic in array) {
        NSArray* allBalanceFromSameSourceMutArr = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeAllSameSourceBalanceStated withDistinction:AccountingDistinctionTypeAllBalanceFromSameSource withDistinctionTime:@"" withDistinctionBalanceSource:dic[kSubTit]];
        NSDecimalNumber* totalInputNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@"0"]];
        if ([[dic allKeys] containsObject:kAmount]) {
             totalInputNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",dic[kAmount]]];
        }
        NSDecimalNumber*finalNum = [totalInputNum decimalNumberByAdding:allBalanceFromSameSourceMutArr[0][kTotal]];
        NSMutableDictionary* dicMut = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([finalNum compare:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@"0"]]] != NSOrderedSame ) {
            [dicMut addEntriesFromDictionary:@{kTotal:[NSString stringWithFormat:@"%@",finalNum]}];
            
        }
        else{
            [dicMut addEntriesFromDictionary:@{kTotal:[NSString stringWithFormat:@"%@",@"0"]}];
        }
        [self.sections addObject:@[dicMut]];
    }
    [self.tableView reloadData];
    
    
    NSNumber* totalN = @(0);
//    for (int i=0; i< array.count; i++) {
//        NSDictionary* dic = array[i];
//        if (![[dic allKeys] containsObject:kAmount]) {
//            continue;
//        }
//        totalN = [NSString getPropertAmountNumberByArray:array];
//    }
    totalN = [NSString getPropertAmountNumberByArray:array];
    NSDecimalNumber* totalInputNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",totalN]];
    
    
    NSArray* allBalanceArr = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeAllBalanceTotalStated withDistinction:AccountingDistinctionTypeNone withDistinctionTime:@"" withDistinctionBalanceSource:@""];
    
    NSDecimalNumber*finalNum = [totalInputNum decimalNumberByAdding:allBalanceArr[0][kTotal]];
    
    UIButton* button = [self.view viewWithTag:1];
    button.titleLabel.numberOfLines = 0;
    [button setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",@"我的钱包"] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont boldSystemFontOfSize:18] subString:[NSString stringWithFormat:@"ø净资产\n¥%@",finalNum] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13) numInSubColor:HEXCOLOR(0xffffff) numInSubFont:[UIFont boldSystemFontOfSize:16]] forState:UIControlStateNormal];
        
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
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [UIView new];
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.f;
           
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountPurseCell *cell = [AccountPurseCell cellWith:tableView];
    [cell richElementsInCellWithModel:_sections[indexPath.section][0]];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AccountPurseCell cellHeightWithModel:_sections[indexPath.section][0]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _sections[indexPath.section][0];
    if ([dic.allKeys containsObject:kTotal]) {
        [AccountBalanceSourceVC pushFromVC:self requestParams:dic success:^(id data) {
            [self requestListSuccessWithArray];
        }];
    }else{
        [AccountEditAmountVC pushFromVC:self requestParams:dic success:^(id data) {
            [self requestListSuccessWithArray];
        }];
    }
    
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
//        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
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

@end
