
#import "DynamicsCatVC.h"

#import "HomeVM.h"

#import "NewDynamicsVC.h"

#import "WDTimeLinePostVC.h"
#import "MyShareVC.h"
@interface DynamicsCatVC ()< UINavigationControllerDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView                *titleView;
@property (nonatomic, strong) JXCategoryTitleView                *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *listVCArray;

@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *selectedIDs;

@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIButton *redDotButton;
@property (nonatomic, assign) NSInteger msgIndex;
@end

@implementation DynamicsCatVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotify_DesMovieTimer object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)levSuccessMethod{
//    [self requestList];
}

- (void)requestList{
    self.selectedIDs = [NSMutableArray array];
    [self requestData];
}

- (void)funAdsButtonClickItem:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    NewDynamicsVC* nw  =[NewDynamicsVC new];
    nw.isFromAvatar = YES;
    [nw requestHomeListWithPage:1 WithDict:@{@"id":[UserInfoManager GetNSUserDefaults].data.ID}];
    [self.navigationController pushViewController:nw animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    self.arr = [NSMutableArray array];
    
    [self.view addSubview:self.titleView];
    
    [self.titleView addSubview:self.categoryView];
//    self.titleView.backgroundColor = [UIColor greenColor];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(-50);
//        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([YBFrameTool statusBarHeight]);//
        make.height.mas_equalTo([YBFrameTool navigationBarHeight]);
    }];
    
    self.redDotButton = [[UIButton alloc]init];
    self.redDotButton.hidden = YES;
    self.redDotButton.adjustsImageWhenHighlighted = NO;
//    self.clickButton.titleLabel.numberOfLines = 0;
//    self.clickButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.clickButton.titleLabel.font = kFontSize(18);
    self.redDotButton.layer.masksToBounds = YES;
    self.redDotButton.layer.cornerRadius = 14/2;
    self.redDotButton.layer.borderWidth = 0;
    [self.redDotButton setBackgroundColor:UIColor.redColor];
    [self.titleView addSubview:self.redDotButton];
    [self.redDotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.equalTo(self.titleView).offset(7);//
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(14);
//        make.height.mas_equalTo(30);
    }];
    
    self.clickButton = [[UIButton alloc]init];
//    self.clickButton.hidden = YES;
    [self.clickButton
         setImage:[UIImage imageNamed:@"M_userBtn"] forState:0];
    
    self.clickButton.adjustsImageWhenHighlighted = NO;
    self.clickButton.titleLabel.numberOfLines = 0;
    self.clickButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.clickButton.titleLabel.font = kFontSize(18);
//    self.clickButton.layer.masksToBounds = YES;
//    self.clickButton.layer.cornerRadius = [YBFrameTool navigationBarHeight]/2;
//    self.clickButton.layer.borderWidth = 0;
//    [self.clickButton setBackgroundColor:YBGeneralColor.themeColor];
    [self.clickButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//✍️
//    [self.clickButton setTitle:@"发动态" forState:UIControlStateNormal];
    [self.clickButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.view).offset([YBFrameTool statusBarHeight]);//
        make.height.mas_equalTo([YBFrameTool navigationBarHeight]);
        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(30);
    }];
    
    
    
    self.listVCArray = [NSMutableArray array];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView);
        make.centerX.equalTo(self.titleView);
        make.height.equalTo(self.titleView);
        make.left.equalTo(self.titleView);
    }];

    self.scrollView = [[UIScrollView alloc] init];
    [self.view  insertSubview:self.scrollView atIndex:0];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([YBFrameTool safeAdjustNavigationBarHeight]+5);
        make.bottom.equalTo(self.view).offset(0);
        //-[YBFrameTool safeAdjustTabBarHeight]
    }];

    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //FIXME:如果和自定义UIScrollView联动，删除纯UIScrollView示例
    self.categoryView.contentScrollView = self.scrollView;

    [self requestList];
    
}

- (void)requestData {
    
    [self.vm network_getSCTagsWithPage:1 didAdd0Data:NO didAddLastData:YES success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr) {
//        [self reloadSubData:lastSectionSumArr];//imodel
        } failed:^(id data) {
                
    }];
    
    
}

/**
重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
*/
- (void)reloadSubData:(NSArray*)arr{
    [self.arr addObjectsFromArray:arr[0]];
    
    NSMutableArray* names = [NSMutableArray array];
    for (HomeItem* data in arr[0]) {
        [names addObject:data.name];
    }
    NSArray *titles = names;
    for (UIViewController *vc in self.listVCArray) {
        [vc.view removeFromSuperview];
    }
    [self.listVCArray removeAllObjects];

    
    [self.view layoutIfNeeded];
    
    [self.scrollView layoutIfNeeded];
    
    NSInteger defaultIndex = 0;
    for (int i=0; i<titles.count; i++) {
        NSString* title = titles[i];
        if ([title containsString:@"推荐"]) {
            defaultIndex = i;
        }
        if ([title containsString:@"消息"]) {
            self.msgIndex = i;
            MyShareVC *rightVC = [[MyShareVC alloc] init];
            rightVC.requestParams = 2;
            [rightVC actionBlock:^(id  _Nonnull data) {
                self.redDotButton.hidden = [data integerValue]==0?NO:YES;
            }];
            rightVC.view.frame = CGRectMake(i*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            rightVC.view.backgroundColor = [UIColor whiteColor];
            [self addChildViewController:rightVC];
            [self.listVCArray addObject:rightVC];
            [self.scrollView addSubview:rightVC.view];
        }else{
        NewDynamicsVC *listVC = [[NewDynamicsVC alloc] init];
//        listVC.view.backgroundColor = [UIColor orangeColor];
        listVC.view.frame = CGRectMake(i*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self addChildViewController:listVC];
        [self.listVCArray addObject:listVC];
        [self.scrollView addSubview:listVC.view];
        }
    }
    
//    BaseVC *rightVC = [[BaseVC alloc] init];
//    rightVC.view.frame = CGRectMake((titles.count -1)*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
//    rightVC.view.backgroundColor = [UIColor whiteColor];
//    [self addChildViewController:rightVC];
//    [self.listVCArray addObject:rightVC];
//    [self.scrollView addSubview:rightVC.view];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*titles.count, self.scrollView.bounds.size.height);

    //触发首次加载
    HomeItem* data = arr[0][defaultIndex];
    HomeItem* data1 = [self returnData1:data];
    NewDynamicsVC* nVC = self.listVCArray[defaultIndex];
    nVC.myModel.state = [NSString stringWithFormat:@"%li",(long)data1.restricted];
    [nVC  requestHomeListWithPage:1 WithDict:@{
        @"cid_2":@(data1.ID),
        @"cid_1":@(data.ID)}];
    [nVC richOnlyElementsInCellWithModel:@[data]];
    [self.selectedIDs addObject:@(data.ID)];
    
    self.categoryView.defaultSelectedIndex = defaultIndex;
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
}
- (HomeItem*)returnData1:(HomeItem*)data{
    HomeItem* data1 = [HomeItem new];
    NSMutableArray* items1= [NSMutableArray array];
    
    if (data.childs !=nil && data.childs.count>0 ) {
        for (HomeItem* it in [HomeItem mj_objectArrayWithKeyValuesArray:data.childs]) {
            if ([data.mark isEqualToString:@"red"]) {
                it.restricted = 1;
            }
            [items1 addObject:it];
        }
        
    }
    if (items1.count>0) {
        data1 = items1.firstObject;
    }
    return data1;
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    HomeItem* data = self.arr[index];
    HomeItem* data1 = [self returnData1:data];
    if (index != self.msgIndex) {
    if (![self.selectedIDs containsObject:@(data.ID)]) {
        
            NewDynamicsVC* nVC = self.listVCArray[index];
            nVC.myModel.state = [NSString stringWithFormat:@"%li",(long)data1.restricted];
            [nVC requestHomeListWithPage:1 WithDict:@{
                @"cid_2":@(data1.ID),
                @"cid_1":@(data.ID)}];
            [nVC richOnlyElementsInCellWithModel:@[data]];
        }
        
        [self.selectedIDs addObject:@(data.ID)];
    }else{
        MyShareVC *rightVC = self.listVCArray[index];
        rightVC.requestParams = 2;
//        [rightVC requestHomeListWithPage:1 WithCid:1];
        [rightVC actionBlock:^(id  _Nonnull data) {
            self.redDotButton.hidden = [data integerValue]==0?NO:YES;
        }];
    }
}
//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.delegate = self;
        _categoryView.titleColor = HEXCOLOR(0x000000);
        _categoryView.titleSelectedColor = YBGeneralColor.themeColor;
        _categoryView.titleFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleColorGradientEnabled = YES;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = YBGeneralColor.themeColor;
        lineView.indicatorWidth = 6;//JXCategoryViewAutomaticDimension;
        lineView.indicatorHeight = 6;
        lineView.indicatorCornerRadius = 6/2;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [UIView new];
    }
    return _titleView;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

- (void)dealloc {
    // 点击返回 或 侧滑返回
    //NSLog(@"playerVC dealloc");
}
@end

