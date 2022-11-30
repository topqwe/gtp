//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "AccountStatedVC.h"
#import "HomeVM.h"
#import "CalendarView.h"
#import "AccountStatedCell.h"
#import "AccountStatedSectionHV.h"
@interface AccountStatedVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *sectionsHeaderDatas;
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) UIView * dataEmptyView;
@end

@implementation AccountStatedVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccessBlockMethod) name:kNotify_IsLoginRefresh object:nil];
    [self YBGeneral_baseConfig];
    [self initView];
    
    self.dayString = [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]];
    [self requestListSuccessWithArray];
}

- (void)privateMethod {
    Method method = class_getInstanceMethod(class_getSuperclass(self.class), sel_registerName("loginSuccessBlockMethod"));
    void (*super_func)(id,SEL) = (void *)method_getImplementation(method);
    if (super_func) super_func(self, sel_registerName("loginSuccessBlockMethod"));
}

- (void)loginSuccessBlockMethod{
   [super loginSuccessBlockMethod];
//    self.dayString = [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]];
    if (self.dayString != [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]]) {
        [self requestListSuccessWithArray];
    }
   
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
    _funcBtns = [NSMutableArray array];
    
    CalendarView *calendarView = [[CalendarView alloc]init];
    [self.view addSubview:calendarView];
//    calendarView.showChineseCalendar = true;
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@360);
    }];
    [calendarView selectDateOfMonth:^(NSInteger year, NSInteger month, NSInteger day) {
        NSString* str = [NSString dateStrWithString:[NSString stringWithFormat:@"%@.%@",[NSString stringWithFormat:@"%ld.%ld",year,month],[NSString stringWithFormat:@"%ld",day]] formatString:[NSString ymdSeparatedByPointFormatString]];
        self.dayString = str;
        [self requestListSuccessWithArray];
//        NSLog(@".......%@",str);
    }];
    
    
    UIImageView* sectionLine = [[UIImageView alloc]init];
    sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
    [self.view addSubview:sectionLine];
    [sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(calendarView.mas_bottom).offset(14);
        make.height.equalTo(@2);
        make.leading.equalTo(@13);
        make.centerX.equalTo(self.view);
    }];
    
    NSArray* subtitleArray =@[
    @{@"未超出预算":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"超出预算":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"预算平衡":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
        
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_funcBtns addObject:button];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionLine.mas_bottom).offset(13);
        make.height.equalTo(@40);
    }];

    UIButton* btn0 = _funcBtns[0];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn0.mas_bottom).offset(0);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
//
//    [self.view layoutIfNeeded];
//    self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:CGRectGetMaxY(btn0.frame) withCustomTitle:@"暂无记录"];
}

- (void)requestListSuccessWithArray{
    _sectionsHeaderDatas = [NSMutableArray array];
    if(self.sections.count>0)[self.sections removeAllObjects];
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
    
    NSArray* array = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeDayAllStated withDistinction:AccountingDistinctionTypeDayAllStated withDistinctionTime:self.dayString withDistinctionBalanceSource:@""];
    
    [self.sections addObjectsFromArray:array];
//    if(!_sections||_sections.count==0)return;
    [self.tableView reloadData];
    
   
    NSArray* dayTotalarray = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeDayBalanceTotalStated withDistinction:AccountingDistinctionTypeDayAllStated withDistinctionTime:self.dayString withDistinctionBalanceSource:@""];
    [_sectionsHeaderDatas addObjectsFromArray:dayTotalarray];
    
    if (self.dataEmptyView) {
        [self.dataEmptyView removeFromSuperview];
    }
    UIButton* btn0 = _funcBtns[0];
    [self.view layoutIfNeeded];
    self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:CGRectGetMaxY(btn0.frame) withCustomTitle:[NSString stringWithFormat:@"%@\n暂无记录现在去记录",self.dayString] withCustomImageName:@""];
    if(!_sections||_sections.count==0){
        self.dataEmptyView.hidden = false;
    }else{
        self.dataEmptyView.hidden = true;
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sections.count;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!_sections||_sections.count==0)return 0.1f;
    return [AccountStatedSectionHV viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if(!_sections||_sections.count==0)return [UIView new];
    if(!_sectionsHeaderDatas||_sectionsHeaderDatas.count==0)return [UIView new];
    NSDictionary* data = (NSDictionary*)(_sectionsHeaderDatas[0]);
    
    AccountStatedSectionHV * sectionHeaderView = (AccountStatedSectionHV *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:AccountStatedSectionHVReuseIdentifier];
    [sectionHeaderView richElementsInViewWithModel:data];
    
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
    [cell richElementsInCellWithModel:_sections[indexPath.row]];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AccountStatedCell cellHeightWithModel:_sections[indexPath.row]];
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


- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

@end
