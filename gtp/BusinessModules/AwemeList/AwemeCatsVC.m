
#import "AwemeCatsVC.h"

#import "HomeVM.h"

#import "AwemeLVC.h"
//#import "AwemeJLVC.h"
#import "SearchVC.h"
#import "AVPlayerManager.h"
@interface AwemeCatsVC ()< UINavigationControllerDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView                *titleView;
@property (nonatomic, strong) JXCategoryTitleView                *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *listVCArray;

@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *selectedIDs;
@property (nonatomic, assign) NSInteger selectedID;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIButton *clickButton;
@end

@implementation AwemeCatsVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotify_DesMovieTimer object:nil];
    if (self.selectedIDs.count>0) {
        for (int i=0; i<self.selectedIDs.count; i++) {
            [self.listVCArray[i] applicationEnterBackground];
        }
    }
    [self.listVCArray[self.currentIndex] applicationBecomeActive];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [[AVPlayerManager shareManager] pauseAll];
    if (self.selectedIDs.count>0) {
        for (int i=0; i<self.selectedIDs.count; i++) {
            [self.listVCArray[i] applicationEnterBackground];
        }
    }
}

- (void)applicationBecomeActive {
//    [self.listVCArray[self.currentIndex] applicationBecomeActive];
//    if (self.selectedIDs.count>0) {
//        for (int i=0; i<self.selectedIDs.count; i++) {
//            [self.listVCArray[i] applicationEnterBackground];
//        }
//    }
    if (self.tabBarController.selectedIndex == 1) {
        [self.listVCArray[self.currentIndex] applicationBecomeActive];
    }
}

- (void)applicationEnterBackground {
//    [[AVPlayerManager shareManager] pauseAll];
//    [self.listVCArray[self.currentIndex] applicationEnterBackground];
    if (self.selectedIDs.count>0) {
        for (int i=0; i<self.selectedIDs.count; i++) {
            [self.listVCArray[i] applicationEnterBackground];
        }
    }
}
- (void)setUpNoti{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
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
    [SearchVC pushFromVC:self requestParams:@(1) success:^(id data) {

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNoti];
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
    
    self.clickButton = [[UIButton alloc]init];
//    self.clickButton.hidden = YES;
//        [icon0
//         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
    
    self.clickButton.adjustsImageWhenHighlighted = NO;
    self.clickButton.titleLabel.numberOfLines = 0;
    self.clickButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.clickButton.titleLabel.font = kFontSize(18);
    self.clickButton.layer.masksToBounds = YES;
    self.clickButton.layer.cornerRadius = [YBFrameTool navigationBarHeight]/2;
    self.clickButton.layer.borderWidth = 0;
//    [self.clickButton setBackgroundColor:YBGeneralColor.themeColor];
    [self.clickButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//✍️
//    [self.clickButton setTitle:@"🔍" forState:UIControlStateNormal];
    [self.clickButton setImage:kIMG(@"m_sfrightSearch") forState:0];
    self.clickButton.contentMode =  UIViewContentModeScaleAspectFit;
    [self.clickButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.view).offset([YBFrameTool statusBarHeight]);//
        make.height.mas_equalTo([YBFrameTool navigationBarHeight]);
        make.width.mas_equalTo(40);
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
        make.top.equalTo(self.view).offset(0);
        //[YBFrameTool safeAdjustNavigationBarHeight]+5
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
    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:[ApiConfig getAppApi:ApiType49] andType:All andWith:nil success:^(NSDictionary *dic) {
//       NSDictionary* result = dic[@"result"];
       if ([NSString getDataSuccessed:dic]) {
           CategoryModel* cmodel = [CategoryModel mj_objectWithKeyValues:dic];
           NSArray* arr =[HomeItem mj_objectArrayWithKeyValuesArray:cmodel.data];
//           [self reloadSubData:arr];//imodel
       }
       else{
              NSLog(@".......dataErr");
           }
       } error:^(NSError *error) {
           NSLog(@".......servicerErr");
       }];
}
/**
重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
*/
- (void)reloadSubData:(NSArray*)arr {
    [self.arr addObjectsFromArray:arr];
    
    NSMutableArray* names = [NSMutableArray array];
    for (HomeItem* data in arr) {
        [names addObject:data.name];
    }
    NSArray *titles = names;
    for (UIViewController *vc in self.listVCArray) {
        [vc.view removeFromSuperview];
    }
    [self.listVCArray removeAllObjects];

    
    [self.view layoutIfNeeded];
    
    [self.scrollView layoutIfNeeded];
    
    for (int i=0; i<titles.count ; i++) {
        AwemeLVC *listVC = [[AwemeLVC alloc] init];
        listVC.awemeType = AwemeMain;
//        listVC.view.backgroundColor = [UIColor orangeColor];
        listVC.view.frame = CGRectMake(i*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [listVC actionBlock:^(id data, id data2) {
            [listVC levPush];
        }];
        [self addChildViewController:listVC];
        [self.listVCArray addObject:listVC];
        [self.scrollView addSubview:listVC.view];
    }
    
//    BaseVC *rightVC = [[BaseVC alloc] init];
//    rightVC.view.frame = CGRectMake(2*self.scrollView.bounds.size.width, CGRectGetMaxY(self.titleView.frame), self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
//    rightVC.view.backgroundColor = [UIColor blueColor];
//    [self addChildViewController:rightVC];
//    [self.listVCArray addObject:rightVC];
//    [self.scrollView addSubview:rightVC.view];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*titles.count, self.scrollView.bounds.size.height);

    //触发首次加载
    HomeItem* data = arr[0];
    [self.listVCArray.firstObject requestHomeListWithPage:1 WithCid:[NSString stringWithFormat:@"%li",(long)data.ID]];

    self.categoryView.defaultSelectedIndex = 0;
    [self.selectedIDs addObject:@(data.ID)];
    self.currentIndex = self.categoryView.defaultSelectedIndex;
    self.selectedID = data.ID;
    [self.listVCArray[self.currentIndex] applicationBecomeActive];
    
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    HomeItem* data = self.arr[index];
    if (![self.selectedIDs containsObject:@(data.ID)]) {
        [self.listVCArray[index] requestHomeListWithPage:1 WithCid:[NSString stringWithFormat:@"%li",(long)data.ID]];
        [self.selectedIDs addObject:@(data.ID)];
    }
    self.currentIndex = index;
    self.selectedID = data.ID;
    if (self.selectedIDs.count>0) {
        for (int i=0; i<self.selectedIDs.count; i++) {
            [self.listVCArray[i] applicationEnterBackground];
        }
    }
    [self.listVCArray[self.currentIndex] applicationBecomeActive];
}
//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.delegate = self;
        _categoryView.titleColor = HEXCOLOR(0xB9B9B9);
        _categoryView.titleSelectedColor = HEXCOLOR(0xffffff);
        _categoryView.titleFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:18.0f];
        _categoryView.titleColorGradientEnabled = YES;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = YBGeneralColor.themeColor;
        lineView.indicatorWidth = 18;//JXCategoryViewAutomaticDimension;
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

