//
//  DSSlideView.m
//  DSSlideView
//


#import "DSSlideView.h"
#import "DSSlideCell.h"
#import "FGScrollView.h"

#define kTopSliderBarHeight 40
#define kSliderLineHeight 5
//#define kSliderLineWidth  25
@interface DSSlideView()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (assign, nonatomic) CGFloat leadspacing;
@property (assign, nonatomic) CGFloat topSliderBarHeight;
@property (assign, nonatomic) CGFloat sliderLineHeight;
@property (assign, nonatomic) BOOL isHiddenSLine;
@property (strong, nonatomic) id model;
///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;
@property (strong, nonatomic) NSArray* tabTitles;
///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *buttons;
///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife 下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;

///@brife TableViews的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) CGFloat sliderLineWidth;
///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 下面滑动的lineView
@property (strong, nonatomic) UIView *slideView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

@end

@implementation DSSlideView

-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count{
    self = [super initWithFrame:frame];
    
    if (self) {
        _mViewFrame = frame;
        _tabCount = count;
        _buttons = [NSMutableArray array];
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        [self initTopTabs];
        
        [self initSlideView];
        
        [self initScrollView];
        
        [self initDownTables];
        
        [self initDataSource];
        
        
        
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame WithTabs: (NSArray*) tabTitles{
    self = [super initWithFrame:frame];
    
    if (self) {
        _tabTitles = tabTitles;
        
        NSArray* fixeds = @[@"10",@"100",@"1000",@"11999"];
//        NSArray * array = [NSArray arrayWithArray:mutableArray];
  SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,fixeds);
        UserDefaultSynchronize;
        
        _leadspacing = 0.f;
        _topSliderBarHeight = kTopSliderBarHeight;
        _sliderLineHeight = kSliderLineHeight;
        _isHiddenSLine = NO;
//        _mViewFrame = frame;
//        _tabCount = tabTitles.count;
//        _buttons = [NSMutableArray array];
//        _topViews = [[NSMutableArray alloc] init];
//        _scrollTableViews = [[NSMutableArray alloc] init];
//
////        [self initDataSource];
//
//        [self initTopTabs];
//
//        [self initScrollView];
//
//        [self initDownTables];
//
//        [self initDataSource];
//
//        [self initSlideView];
//
    }
    
    return [self initWithFrame:frame WithCount:_tabTitles.count];
}

-(instancetype)initWithFrame:(CGRect)frame WithTabs: (NSArray*) tabTitles withModel:(id)model topSliderBarCentreXLeadSpacing:(CGFloat)leadspacing topSliderBarHeight:(CGFloat)topSliderBarHeight
            sliderLineHeight:(CGFloat)sliderLineHeight
isHiddenTopSliderBarSeparatorLine:(BOOL)isHiddenSLine{
    self = [super initWithFrame:frame];
    
    if (self) {
        _tabTitles = tabTitles;
        _model = model;
        NSArray* fixeds = @[@"10",@"100",@"1000",@"11999"];
        //        NSArray * array = [NSArray arrayWithArray:mutableArray];
    SetUserDefaultKeyWithObject(kFixedAccountsInPostAds,fixeds);
        UserDefaultSynchronize;
       
        _leadspacing = leadspacing;
        _topSliderBarHeight = topSliderBarHeight;
        _sliderLineHeight = sliderLineHeight;
        _isHiddenSLine = isHiddenSLine;
        
    }
    
    return [self initWithFrame:frame WithCount:_tabTitles.count];
}

#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <=6){
        width = (_mViewFrame.size.width -2*_leadspacing) / self.tabCount;
    }

    _slideView = [[UIView alloc] initWithFrame:CGRectMake((width-_sliderLineWidth)/2, _topSliderBarHeight - _sliderLineHeight, _sliderLineWidth, _sliderLineHeight)];
    [_slideView setBackgroundColor:[YBGeneralColor themeColor]];
    [_topScrollView addSubview:_slideView];
}


#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    
    for (int i = 1; i <= _tabCount; i ++) {
        
        NSMutableArray *tempArray  = [[NSMutableArray alloc] initWithCapacity:20];
        
        for (int j = 1; j <= 20; j ++) {
            
            NSString *tempStr = [NSString stringWithFormat:@"%d....%d条数据", i, j];
            [tempArray addObject:tempStr];
        }
        
        [_dataSource addObject:tempArray];
    }
}


#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    _scrollView = [[FGScrollView alloc] initWithFrame:CGRectMake(0, _topSliderBarHeight, _mViewFrame.size.width, _mViewFrame.size.height - _topSliderBarHeight)];
    //ScreenHeight - HeaderTab - statusBarHeight - navigationBarHeight
    //放在cell 不用 - s&n
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, 0);//限制上下滑动_scrollView.frame.size.height
    _scrollView.backgroundColor = kWhiteColor;
    
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <=6){
        width = (_mViewFrame.size.width -2*_leadspacing) / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(_leadspacing, 0, _mViewFrame.size.width-2*_leadspacing, _topSliderBarHeight)];
    _topMainView.backgroundColor = HEXCOLOR(0xf2f1f6);
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _topMainView.size.width,_isHiddenSLine?_topSliderBarHeight: _topSliderBarHeight-1)];
 _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 6) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, _topSliderBarHeight);

    } else {
        _topScrollView.contentSize = CGSizeMake(_topMainView.size.width, _topSliderBarHeight);
    }
    
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    
    _sliderLineWidth = [NSString getTextWidth:_tabTitles[0] withFontSize:kFontSize(13) withHeight:_topSliderBarHeight];
    for (int i = 0; i < _tabCount; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, _topSliderBarHeight)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        if (i % 2) {
//            view.backgroundColor = [UIColor grayColor];
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, view.frame.size.height)];
        button.tag = i;
        [button setTitle:_tabTitles!=nil?[NSString stringWithFormat:@"%@", _tabTitles[i]]:[NSString stringWithFormat:@"按钮%d", i+1] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x4a4a4a) forState:UIControlStateNormal];
        [button setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateSelected];
        button.titleLabel.font = kFontSize(13);
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [_buttons addObject:button];
        
        
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
    //Custom
    UIButton *button0 = _buttons[0];
    button0.selected = YES;
    //        [self tabButton:_buttons[0]];
}

-(void)scrollToIndex:(NSInteger)index{
    [self tabButton:_buttons[index]];
}
-(void)fixedScrollToIndex:(NSInteger)index{
    //Custom cancel
    UIButton *button = _buttons[index];
    button.selected = YES;
    
    [_scrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
    _scrollView.scrollEnabled = NO;
}
#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    if (_scrollView.scrollEnabled == NO) {
        //
        return ;
    }
    for (int i = 0; i < _buttons.count; i++) {
        UIButton *btn = (UIButton *)_buttons[i];
        [btn setSelected:NO];
    }
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    
//    UIButton *button = sender;
//    [button setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [_scrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    for (int i = 0; i < _tabCount; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * _mViewFrame.size.width, 0, _mViewFrame.size.width, _scrollView.frame.size.height)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;

        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
    }
    
}
#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    
    [self changeBackColorWithPage:pageNumber];
    
    UITableView *currentTable = _scrollTableViews[_currentPage];
    
    [currentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    [currentTable reloadData];

    
//    int tabviewTag = pageNumber % 2;
//
//    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _scrollView.frame.size.height);
//
//    UITableView *reuseTableView = _scrollTableViews[_currentPage];
//    reuseTableView.frame = tableNewFrame;
//    [reuseTableView reloadData];
}


- (void) changeBackColorWithPage: (NSInteger) currentPage {

    for (int i = 0; i < _topViews.count; i ++) {
        UIView *tempView = _topViews[i];
        
        UIButton *button = [tempView subviews][0];
        if (i == currentPage) {
//            tempView.backgroundColor = [UIColor greenColor];
            button.titleLabel.textColor = [YBGeneralColor themeColor];
        } else {
//            tempView.backgroundColor = [UIColor grayColor];
            button.titleLabel.textColor = HEXCOLOR(0x9b9b9b);
        }
    }
}

#pragma mark -- scrollView的代理方法

-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }

}
///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
//            UITableView *currentTable = _scrollTableViews[_currentPage];
//            [currentTable reloadData];
        
        [self updateTableWithPageNumber:_currentPage];

        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        //contentOffset system <-> frame system
        if (self.tabCount <= 6) {
             frame.origin.x = (scrollView.contentOffset.x*_topScrollView.size.width)/_mViewFrame.size.width /_tabCount;
        } else {
//             frame.origin.x = scrollView.contentOffset.x/6;
            frame.origin.x = (scrollView.contentOffset.x*_topScrollView.size.width)/_mViewFrame.size.width /6;
            
        }
        frame.origin.x +=  (_topScrollView.size.width / self.tabCount - _sliderLineWidth)/2;
       
        _slideView.frame = frame;
    }
    
}


#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSMutableArray *tempArray = _dataSource[_currentPage];
//    return tempArray.count;
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DSSlideCell cellHeightWithModelWithType:_currentPage WithModel:_model];
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSSlideCell *cell = [DSSlideCell cellWith:tableView];
    if ([tableView isEqual:_scrollTableViews[_currentPage]]) {
        
//        cell.tipTitle.text = _dataSource[_currentPage][indexPath.row];//_currentPage%2
        [cell richElementsInCellWithType:_currentPage WithModel:_model];
    }
   
    return cell;
}
@end
