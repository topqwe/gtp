//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "ShowFilmVC.h"
#import "HomeVM.h"

#import "ShowFilmInfoCell.h"
#import "ShowFilmBannerCell.h"
#import "ShowFilmMoreCell.h"
#import "StyleCell5.h"

#import "HomeSectionHeaderView.h"

#import "HomeHV.h"
#import "HomeFV.h"


#import "PreviewPopUpView.h"

@interface ShowFilmVC () <UITableViewDelegate, UITableViewDataSource,SuperPlayerDelegate>
@property (nonatomic, strong) SuperPlayerView* playerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) HomeHV * hHV;

@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;

@property (nonatomic, assign) NSInteger  cid;
@property (nonatomic, assign) NSInteger  fid;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, strong) UIButton *levBut;
@property (nonatomic, strong)HomeItem* item;

@property (nonatomic, strong)UIView* videoView;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) TwoDataBlock timeBlock;

@property (nonatomic, strong)PreviewPopUpView* popupView;

@property(nonatomic, assign) BOOL isPaid;
@property(nonatomic, assign) BOOL isPushLev;
@end

@implementation ShowFilmVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    ShowFilmVC *vc = [[ShowFilmVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)requestFilmData:(HomeItem*)item{
    
    NSInteger fID = item.ID;
    
    kWeakSelf(self);
    [self.vm network_postShowFilmWithPage:1 WithFid:fID success:^(HomeItem * _Nonnull data) {
        kStrongSelf(self);
        if (self.popupView) {
            [self.popupView disMissView];
        }
        self.item = data;
//        self.item.limit = 1;//test
        [self inputFilmData];
        [self requestHomeListWithPage:1 WithHomeItem:self.item];
    } failed:^(id data,id data1) {
        if ([data intValue] == 910) {
            self.item = data1;
            
            [self inputFilmData];
            [self requestHomeListWithPage:1 WithHomeItem:self.item];
            [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                    [self levSuccessMethod];
                }];
            
        }
    }];
}

- (void)levSuccessMethod{
    [self requestFilmData:self.requestParams];
}

- (void)getNotificationAction:(NSNotification *)notification{
//    NSDictionary * infoDic = [notification object];
    [self distoryTimer];
    [_playerView resetPlayer];
}
//View controller-based status bar appearance Yes
- (BOOL)prefersStatusBarHidden
{
//    return YES;//隐藏为YES，显示为NO//plist必须yes
    return self.playerView.isFullScreen;
    
}

//-(BOOL)shouldAutorotate{
//    if (self.playerView.isLockScreen) {
//        return NO;
//    }
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self prefersStatusBarHidden];
//    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(getNotificationAction:) name:kNotify_DesMovieTimer object:nil];
        
    [self YBGeneral_baseConfig];
    self.view.backgroundColor = kBlackColor;
    [self initView];
    
    HomeItem* item = self.requestParams;
    
    [self requestFilmData:item];
    
    //监听程序进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.fd_interactivePopDisabled = YES;
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = NO;
    
    
//    if (self.isPaid) {
//        if (self.popupView) {
//            [self.popupView disMissView];
//        }
//        [self requestFilmData:self.requestParams];
//        self.isPaid = NO;
//    }else
//    if (_playerView&&self.item.limit>0) {
//        if(self.timer)[self.timer setFireDate:[NSDate date]];
//        [_playerView resume];
//    }else if(_playerView&&self.item.limit == 0){
//        [_playerView resume];
//    }////popup在，也会在后面默默播，所以屏蔽
//    if (self.popupView) {
//        self.playerView.isLockScreen = YES;
//    }else{
//        self.playerView.isLockScreen = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (_playerView&&self.item.limit>0) {
        if(self.timer)[self.timer setFireDate:[NSDate distantFuture]];
        [_playerView pause];
    }
    else{
//        if (self.playerView&&self.item.limit == 0){
            NSString* key = self.item.hls_url;
            CGFloat ctime = self.playerView.playCurrentTime;
            if (ctime > 0) {
                //self.item.duration_seconds
                SetUserFloatKeyWithObject(key, ctime);
            }
//        }
        [self distoryTimer];
        [_playerView pause];
    }
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; 
}

-(void)superPlayerBackAction:(SuperPlayerView *)player{
    [self distoryTimer];
    [_playerView resetPlayer];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)initView {
    [self.view addSubview:self.tableView];
    
    UIView* videoView = [UIView new];
    self.videoView = videoView;
    [self.view addSubview:videoView];
//    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset([YBFrameTool statusBarHeight]);//34 : 20
//            make.leading.trailing.offset(0);
//            make.height.equalTo(videoView.mas_width).multipliedBy(9 / 16.0f);
//        }];
    videoView.frame = CGRectMake(0, [YBFrameTool statusBarHeight], MAINSCREEN_WIDTH, (MAINSCREEN_WIDTH*9)/16);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置代理，用于接受事件
    _playerView.delegate = self;
    // 设置父View，_playerView会被自动添加到holderView下面
    _playerView.fatherView = videoView;
//    _playerView.isFullScreen = true;

    _playerView.layoutStyle = SuperPlayerLayoutStyleFullScreen;
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = @"";
    // 开始播放
    [_playerView playWithModel:playerModel];
    
    self.playerView.controlView.disableCaptureBtn = true;
    self.playerView.controlView.disableDanmakuBtn = true;
    self.playerView.controlView.disableMoreBtn = true;
//    self.playerView.controlView.resolutionView.hidden = YES;
//    self.playerView.controlView.resolutionBtn.hidden = YES;
//
//    self.playerView.controlView.fullScreenBtn.hidden = YES;
//    self.playerView.controlView.videoSlider.hidden = YES;
//    self.playerView.controlView.startBtn.hidden = YES;
//    self.playerView.controlView.totalTimeLabel.hidden = YES;
//    self.playerView.controlView.currentTimeLabel.hidden = YES;
//
//    self.playerView.isLockScreen = YES;
    
    
    UIButton *levBut = [[UIButton alloc]init];
    self.levBut = levBut;
//    levBut.userInteractionEnabled = NO;
    levBut.tag = 8002;
    [self.playerView addSubview:levBut];
    [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(180);
    }];
    levBut.layer.cornerRadius = 36/2;
    levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    levBut.titleLabel.font = kFontSize(15);
    [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
    levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    levBut.layer.masksToBounds = true;
    
    
    
    UIButton *timeBtn = [[UIButton alloc]init];
    self.timeBtn = timeBtn;
    timeBtn.userInteractionEnabled = NO;
    timeBtn.tag = 8003;
    [videoView addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(videoView.mas_bottom).offset(-20);
        make.left.mas_equalTo(videoView.mas_left).offset(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(60);
//            make.width.mas_equalTo(MAINSCREEN_WIDTH/3);
//            make.centerX.mas_equalTo(cell.contentView);
    }];
    timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    timeBtn.titleLabel.font = kFontSize(13);
    
//    timeBut.layer.masksToBounds = true;
//    timeBut.layer.cornerRadius = 15/2;
    timeBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(videoView.mas_bottom).offset(5);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)netwoekingErrorDataRefush{
//    [self  requestHomeListWithPage:1];
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithHomeItem:(HomeItem*)item{
   kWeakSelf(self);
    
    [self.vm network_postRecommendWithPage:page WithHomeItem:item  success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
            kStrongSelf(self);
            [self requestHomeListSuccessWithArray:dataArray WithLastSectionArr:lastSectionArr WithLastSectionSumArr:lastSectionSumArr WithPage:page];
        } failed:^(id model){
            kStrongSelf(self);
    //        [self requestHomeListSuccessWithArray:model WithPage:page];
            [self requestHomeListFailed];
        }];
    
    
}

- (void)inputFilmData{
    self.playerView.isLockScreen = NO;
    HomeItem* item = self.item;
    if (item.hls_url||item.preview_hls_url) {
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL         = [NSString stringWithFormat:@"%@",item.limit> 0? item.preview_hls_url:item.hls_url];
    
    if (self.playerView&&self.item.limit == 0){
        CGFloat ctime = GetUserFloatWithKey(item.hls_url);
//            [self.playerView seekToTime:seekTime];
        self.playerView.startTime = ctime;
    }
        
    [self.playerView playWithModel:playerModel];
        
//    [self.playerView.controlView setTitle:[NSString stringWithFormat:@"%@",item.name]];
    }
    [self.playerView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.cover_img]]];
    
    [self.levBut addTarget:self action:@selector(levPush) forControlEvents:UIControlEventTouchUpInside];
    if (item.limit > 0) {
        self.playerView.controlView.lockBtn.hidden = true;
        
        [self.levBut setBackgroundColor:YBGeneralColor.themeColor];
        [self.levBut setTitle:[item getLevLimitTitle] forState:0];
        self.levBut.userInteractionEnabled = YES;
        
    //有倒计时 不能横屏
//        [self.timeBtn setTitle:[NSString stringWithFormat:@"%i s",kCountSecs] forState:0];
//        [self.timeBtn setTitleColor:HEXCOLOR(0xffffff) forState:0];
//        [self countClick];
        
//        self.playerView.controlView.fullScreenBtn.hidden = YES;
//        self.playerView.controlView.videoSlider.hidden = YES;
//        self.playerView.controlView.startBtn.hidden = YES;
//        self.playerView.controlView.totalTimeLabel.hidden = YES;
//    self.playerView.controlView.currentTimeLabel.hidden = YES;
//        self.playerView.isLockScreen = YES;
////    self.playerView.controlView.currentTimeLabel.text = @"0 s";
////        self.playerView.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"%i s",kCountSecs];
        

    }else{
        self.playerView.controlView.lockBtn.hidden = NO;
    
        [self.levBut setBackgroundColor:kClearColor];
        [self.levBut setTitle:@"" forState:0];
        self.levBut.userInteractionEnabled = NO;
        
        //无倒计时 能横屏
//        [self.timeBtn setTitle:@"" forState:0];
//        [self.timeBtn setTitleColor:kClearColor forState:0];
        

//        self.playerView.controlView.fullScreenBtn.hidden = NO;
//        self.playerView.controlView.videoSlider.hidden = NO;
//        self.playerView.controlView.startBtn.hidden = NO;
//        self.playerView.controlView.totalTimeLabel.hidden = NO;
//        self.playerView.controlView.currentTimeLabel.hidden = NO;
//        self.playerView.isLockScreen = NO;
    }
    
}

- (void)levPush{
    if (self.item.limit>0) {
        self.playerView.isFullScreen = NO;
        self.playerView.isLockScreen = YES;
        [LevelVC pushFromVC:self
               requestParams:@(self.item.limit-1)
                     success:^(id data) {
//                        [self requestFilmData:self.requestParams];
            self.isPaid = YES;
        }];
    }
}
- (void)playerEndShowPopUpView{
    NSArray* arr = @[
        @[
            [NSString stringWithFormat:@"%@",[self.item getNLevLimitTitle]]
        ]
    ];
    
//        if ([self.videoView viewWithTag:99]!=nil) {
//            UIView* v = [self.videoView viewWithTag:99];
//            [v removeFromSuperview];
//        }
    PreviewPopUpView* popupView = [[PreviewPopUpView alloc]init];
    popupView.tag = 99;
    self.popupView = popupView;
    [popupView showInView:self.videoView];
    
    [popupView richElementsInViewWithModel:arr withItem:self.item];
    
    [popupView actionBlock:^(NSNumber* data) {
        if ([data integerValue] == 0) {
            [self inputFilmData];
//                [self requestFilmData:self.requestParams];

        }else{
            [self levPush];
        }
        
    }];
}
//自然预播结束
-(void)superPlayerDidEnd:(SuperPlayerView *)player{
    if (self.item.limit > 0) {
        self.playerView.isFullScreen = NO;
        self.playerView.isLockScreen = YES;
        [self playerEndShowPopUpView];
    }
}

-(void)superPlayerDidStart:(SuperPlayerView *)player{
//    CGFloat pct =    [self.playerView playCurrentTime];
//    NSLog(@"%l",pct);
    if (self.popupView) {
        [self.popupView disMissView];
    }
    if (self.item.limit > 0) {
//        [self countClick];
    }
}

//倒计时结束
-(void)countClick{
    
    NSInteger second = kCountSecs;
    [self startTimeCount:[NSString stringWithFormat:@"%ld s",(long)second]];
}

- (void)timeActionBlock:(TwoDataBlock)timeBlock{

    self.timeBlock = timeBlock;
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
//    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    
//    [self.playerView.controlView.currentTimeLabel setText:[NSString stringWithFormat:@"%ld s",(long)self.timeCount]];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%ld s",(long)self.timeCount] forState:0];
    if(self.timeCount < 0){
        
        [self distoryTimer];
//        [self.playerView resetPlayer];
        [self.playerView pause];
//        self.playerView.startTime = 5;
//        self.playerView.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"%i s",kCountSecs];
//        self.playerView.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"00:%i",kCountSecs];
        [self.timeBtn setTitle:[NSString stringWithFormat:@"%i s",0] forState:0];
        [self.playerView pause];
        
        self.playerView.isFullScreen = NO;
        [self playerEndShowPopUpView];
        
        if (self.timeBlock) {
            self.timeBlock(@(0), @(0));
        }
        
    }
}

//- (void) removeFromSuperview
//{
////    [super removeFromSuperview];
//    [self distoryTimer];
//}

#pragma mark - public processData
- (void)requestHomeListSuccessWithArray:(NSArray *)sections WithLastSectionArr:(NSArray *)lastSectionArr WithLastSectionSumArr:(NSArray *)lastSectionSumArr WithPage:(NSInteger)page{
    
    self.currentPage = page;
    if (self.currentPage == 1) {
        self.tableView.tableFooterView = [UIView new];
        [self.sections removeAllObjects];
        [self.tableView reloadData];
    }
    if (sections.count > 0) {
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
        [self.sections removeAllObjects];
        [self.sections addObjectsFromArray:sections];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        //如果接口不分页，每次请求都有数据，永远 可以加载底部
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
    }
    
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
//    [self.sections removeAllObjects];
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
//        case IndexSectionMinusOne:
//        case IndexSectionZero:
//            {
//                NSDictionary* model = (NSDictionary*)(_sections[section]);
//                return 20.1f;//[HomeSectionHeaderView viewHeight:model];
//            }
//                break;
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            return [HomeSectionHeaderView viewHeight:model];
        }
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
//        case IndexSectionMinusOne:
//        case IndexSectionZero:
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            return  sectionHeaderView;
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
    
    switch (type) {
        case IndexSectionZero:
            return 0.1f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
            case IndexSectionMinusOne:
            {
                ShowFilmInfoCell *cell = [ShowFilmInfoCell cellWith:tableView];
//                __block HomeItem* item = itemData;
                [cell actionBlock:^(id data) {
                    if ([data isKindOfClass:[HomeItem class]]) {
                        self.item = data;
                    }
                }];
                [cell richElementsInCellWithModel:self.item];
                return cell;
                
            }
                break;
            case IndexSectionZero:
            {/*+
              +*/
                ShowFilmBannerCell *cell = [ShowFilmBannerCell cellWith:tableView];
                [cell richElementsInCellWithModel:itemData];
                [cell actionBlock:^(id data, id data2) {
                    HomeItem* item = data2;
                    switch ([data integerValue]) {
                        case BannerTypeVideo:
                        {
                            self.requestParams = item;
                            [self requestFilmData:self.requestParams];
                            
                        }
                            break;
                        case BannerTypeH5:
                        {
                            if (item.url.length > 0) {
                                NSURL *url = [NSURL URLWithString:item.url];
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }
                            break;
                        case BannerTypeJumpPW:
                        {
                            [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                                [self levSuccessMethod];
                            }];
                        }
                            break;
                        case BannerTypeForV:
                        {
                            [LevelVC pushFromVC:self
                                   requestParams:@0
                                         success:^(id data) {
                                
                                [self levSuccessMethod];
                            }];
                        }
                            break;
                        case BannerTypeForB:
                        {
                            [LevelVC pushFromVC:self
                                   requestParams:@1
                                         success:^(id data) {
                                [self levSuccessMethod];
                            }];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                return cell;
                
            }
                break;
        case IndexSectionOne:
        {
            StyleCell5 *cell = [StyleCell5 cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(id data) {
                self.requestParams = data;
                [self requestFilmData:self.requestParams];
                
            }];
            return cell;
            
        }
            break;
        default:{
//            BaseCell *cell = [BaseCell cellWith:tableView];
//            cell.hideSeparatorLine = YES;
//            cell.frame = CGRectZero;
//            return cell;
       static NSString *name=@"defaultCell";
                               
       UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:name];
           
       if (cell==nil) {
           cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
       }
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
        case IndexSectionMinusOne:
            return [ShowFilmInfoCell cellHeightWithModel:itemData];
            break;
        case IndexSectionZero:
            return [ShowFilmBannerCell cellHeightWithModel];
            break;
        case IndexSectionOne:
            return [StyleCell5 cellHeightWithModel:itemData];
            break;
            
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        
        case IndexSectionTwo:
        {
//            [self clickEvent:@(EnumActionTag4) withData:itemData];
        }
            break;
        default:
            
            break;
    }
}
#pragma mark - clickEvent
- (void)clickEvent:(id) data withData:(id)data2{
//    EnumActionTag type = [data integerValue];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
        
//       kWeakSelf(self);
//       [_tableView addMJHeaderWithBlock:^{
//                    kStrongSelf(self);
//
//           self.currentPage = 1;
//           if (self.item) {
//               [self requestHomeListWithPage:self.currentPage WithHomeItem:self.item];
//           }
//
//        }];
        
//       [_tableView addMJFooterWithBlock:^{
//                    kStrongSelf(self);
//                    ++self.currentPage;
//           if (self.item) {
//               [self requestHomeListWithPage:self.currentPage WithHomeItem:self.item];
//           }
//        }];
    }
    return _tableView;
}

- (UIView *)hv {
    if (!_hv) {
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.statusBarHeight)];
        
        _hv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_hv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(YBFrameTool.statusBarHeight);
            make.centerX.mas_equalTo(self.hv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.statusBarHeight;
        self.hHV = [[HomeHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:-topMar];
        
    }
    return _hv;
}

- (UIView *)fv {
    if (!_fv) {
        _fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.iphoneBottomHeight)];
        
        _fv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_fv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-YBFrameTool.iphoneBottomHeight);
            make.centerX.mas_equalTo(self.fv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.iphoneBottomHeight;
        self.hFV = [[HomeFV alloc]initWithFrame:CGRectZero InSuperView:_fv withTopMargin:-topMar];
        
    }
    return _fv;
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


- (void)dealloc {
    
    [_playerView resetPlayer];
    [self distoryTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
