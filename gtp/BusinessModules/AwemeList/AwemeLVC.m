//
//  AwemeLVC.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <AVKit/AVKit.h>

#import "AwemeLVC.h"
#import "Aweme.h"
#import "AwemeListCell.h"
#import "AVPlayerView.h"
#import "LoadMoreControl.h"
#import "AVPlayerManager.h"

NSString * const kAwemeListCell   = @"AwemeListCell";

@interface AwemeLVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL                              isCurPlayerPause;
@property (nonatomic, assign) NSInteger                         currentPage;

@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, strong) NSString*  cid;

@property (nonatomic, copy) NSString                            *uid;

@property (nonatomic, strong) NSMutableArray          *data;
@property (nonatomic, strong) NSMutableArray  *awemes;
@property (nonatomic, strong) LoadMoreControl                      *loadMore;
@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation AwemeLVC
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
-(instancetype)initWithVideoData:(NSMutableArray  *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid {
    self = [super init];
    if(self) {
        _isCurPlayerPause = NO;
        _currentIndex = currentIndex;
        _currentPage = pageIndex;
        _pageSize = pageSize;
        _awemeType = type;
        _cid = uid;
        
        _awemes = [data mutableCopy];
        _data = [[NSMutableArray alloc] initWithObjects:[_awemes objectAtIndex:_currentIndex], nil];
        _start = CFAbsoluteTimeGetCurrent();
        
    }
    return self;
}
- (void)setUpNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}
-(void)levSuccessMethod{
    [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
        
        self.myModel = model;
        if (self.awemeType == AwemeLiviPush&&
            !self.myModel.data.member_card.is_vip){
            [self setUpCountBtn];
        }
        [self requestHomeListWithPage:1 WithCid:self.cid];
    } failed:^(id data) {
            
    }];
    
}

- (void)requestUserInfoWithPage:(NSInteger)page{
    [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
        
        self.myModel = model;
        if (self.awemeType == AwemeLiviPush&&
            !self.myModel.data.member_card.is_vip){
            [self setUpCountBtn];
        }
    } failed:^(id data) {
            
    }];
}

- (void)setUpCountBtn{
    return;//imodel
    UIButton *levBut = [[UIButton alloc]init];
    self.levBut = levBut;
//    levBut.userInteractionEnabled = NO;
    levBut.tag = 8002;
    [self.view addSubview:levBut];
    levBut.layer.cornerRadius = 58/2;
    levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    levBut.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    levBut.titleLabel.font = kFontSize(13);
    [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
    levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    levBut.layer.masksToBounds = true;
    [self.levBut setBackgroundColor:YBGeneralColor.themeColor];
    [self.levBut setTitle:@"13秒" forState:0];
    self.levBut.titleLabel.numberOfLines = 0;
    self.levBut.hidden = NO;
    [self.levBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YBFrameTool.statusBarHeight+ 8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(58);
        make.width.mas_equalTo(180);
    }];
    [self.levBut addTarget:self action:@selector(levPush) forControlEvents:UIControlEventTouchUpInside];
    
    _timeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_timeBtn];
    _timeBtn.hidden = NO;
    _timeBtn.userInteractionEnabled = NO;
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YBFrameTool.statusBarHeight+ 8+40);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(180);
    }];
    [self countFunc];
}
- (void)countFunc{
//    _countDownCode.frame = CGRectMake(81, 200, 108, 32);
//    [_countDownCode setTitle:@"开始" forState:UIControlStateNormal];
    NSInteger second = 0;
    NSInteger countTime = GetUserIntegerWithKey(kLivOutSecs);
    BOOL isOut = GetUserDefaultBoolWithKey(kIsLivOutTime);
    if (countTime>0) {//播过
//        second = countTime;
        
        if (isOut) {//播完
//            second = 0;
            NSDate* outTime = GetUserDefaultWithKey(kLivOutTime);
            if (outTime) {
                if (![outTime isToday]) {//第二天重新开始
                    second = kLivTotalSecs  - round(CFAbsoluteTimeGetCurrent()-_start);
                    [self startTimeCount:[NSString stringWithFormat:@"%ld",(long)second]];
                    SetUserBoolKeyWithObject(kIsLivOutTime, NO);//dp
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    [self playerEndShowPopUpView];
                }
            }
            else{
//            [self.navigationController popViewControllerAnimated:YES];
//            [self playerEndShowPopUpView];
            }
        }
        else{//没播完
            second = countTime;
            [self startTimeCount:[NSString stringWithFormat:@"%ld",(long)second]];
        }
    }
    else if (countTime==0 && isOut){//dp
        [self.navigationController popViewControllerAnimated:YES];
        [self playerEndShowPopUpView];
    }
    else{//没播过
        second = kLivTotalSecs  - round(CFAbsoluteTimeGetCurrent()-_start);
        [self startTimeCount:[NSString stringWithFormat:@"%ld",(long)second]];
    }
//    [self timingTask];
}

- (void)timingTask {
    //首先获取一个时间
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    //设置一个时间点. 比如 16:16:16
    NSString *newDateStr = [NSString stringWithFormat:@"%@ 10:17:00", dateStr];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *newDate = [dateFormatter dateFromString:newDateStr];


    //然后初始化一个NSTimer.
    //一天的秒数是86400.然后设置重复repeats:YES.指定执行哪个方法.
    //最后添加到runloop就行了.从你运行代码的当天起,就开始执行了.
    self.eveyTimer  = [[NSTimer alloc] initWithFireDate:newDate interval:10 target:self selector:@selector(timeTrigger) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.eveyTimer forMode:NSDefaultRunLoopMode];

}

- (void)timeTrigger {
    NSLog(@"触发了");
    NSInteger second = kLivTotalSecs  - round(CFAbsoluteTimeGetCurrent()-_start);
 
    [self startTimeCount:[NSString stringWithFormat:@"%ld",(long)second]];
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
//    if (sec) {
        self.timeCount = [sec integerValue];
//    } else {
//        self.timeCount = 60;
//    }
    
    [self distoryTimer];
    self.timeBtn.enabled = false;
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
- (void)destroyEveryTimer
{
    if (self.eveyTimer != nil)
    {
        [self.eveyTimer invalidate];
        self.eveyTimer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    [self.timeBtn setAttributedTitle:
     
      [NSString attributedStringWithString:[NSString stringWithFormat:@"剩余时间 %@",[NSString transToHMSSeparatedByColonFormatSecond:self.timeCount]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:13] subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(8) paragraphStyle:NSTextAlignmentCenter]
      
                    forState:UIControlStateNormal];
    
    SetUserIntegerKeyWithObject(kLivOutSecs, self.timeCount);
    
    if(self.timeCount < 0||self.timeCount == 0){
        [self distoryTimer];
//        [self destroyEveryTimer];
        self.timeBtn.enabled = false;
        self.timeBtn.hidden = NO;
        
        if (self.awemeType == AwemeLiviPush&&
            !self.myModel.data.member_card.is_vip) {
            SetUserBoolKeyWithObject(kIsLivOutTime, YES);
            SetUserDefaultKeyWithObject(kLivOutTime, [NSDate date]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        [self playerEndShowPopUpView];
        
        
    }
    
}

//- (void) removeFromSuperview
//{
//    [super removeFromSuperview];
//
//    [self distoryTimer];
//}

- (void)playerEndShowPopUpView{
    HomeItem* aweme  = [HomeItem new];
    if (self.awemeType == AwemeLiviPush&&
        !self.myModel.data.member_card.is_vip) {
        aweme.limit = 1;
//        BOOL isOut = GetUserDefaultBoolWithKey(kIsLivOutTime);
//        if (isOut) {
//            return;
//        }else{
//
//        }
    }
    
    if (self.popupView) {
        [self.popupView disMissView];
    }
    NSArray* arr = @[
        @[
            [NSString stringWithFormat:@"%@",@"已结束继续"]
        ]
    ];
    
//        if ([self.videoView viewWithTag:99]!=nil) {
//            UIView* v = [self.videoView viewWithTag:99];
//            [v removeFromSuperview];
//        }
    PreviewPopUpView* popupView = [[PreviewPopUpView alloc]init];
    popupView.tag = 99;
    self.popupView = popupView;
    [popupView showInApplicationKeyWindow];
    
    [popupView richElementsInViewWithModel:arr withItem:aweme];
    
    [popupView actionBlock:^(NSNumber* data) {
        if ([data integerValue] == 0) {
//            [self inputFilmData];
//                [self requestFilmData:self.requestParams];
//            [self play];
        }else{
//            [self levPush];
            if (self.block) {
                self.block(@(self.awemeType), data);
            }
        }
        [popupView disMissView];
    }];
//    if (self.awemeType == AwemeLiviPush&&
//        !self.myModel.data.member_card.is_vip) {
//        SetUserBoolKeyWithObject(kIsLivOutTime, YES);
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNoti];
    self.myModel = [HomeModel new];
    if (self.awemeType == AwemeLiviPush) {
        [self requestUserInfoWithPage:1];
    }
//    [self setBackgroundImage:@"img_video_loading"];
    self.view.backgroundColor = HEXCOLOR(0x929292);
    [self setUpView];
}

- (void)handlePlayer{
    
        /// playerManager
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];

        /// player,tag值必须在cell里设置
        self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:kPlayerViewTag];
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    if (self.awemeType == AwemeLiviPush) {
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch|
        ZFPlayerDisableGestureTypesSingleTap|
        ZFPlayerDisableGestureTypesDoubleTap
        ;
    }
    self.player.controlView = self.controlView;
        self.player.allowOrentitaionRotation = NO;
        self.player.WWANAutoPlay = YES;
    //    /// 1.0是完全消失时候
    //    self.player.playerDisapperaPercent = 1.0;
        /// 0.4是消失40%时候
        self.player.playerDisapperaPercent = 0.4;
        /// 0.6是出现60%时候
        self.player.playerApperaPercent = 1.0;
        /// 续播
    //    self.player.resumePlayRecord = YES;
    //    self.player.controlView.hidden = NO;
    
        @zf_weakify(self)
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            @zf_strongify(self)
            [self.player.currentPlayerManager replay];
        };

        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//            kAPPDelegate.allowOrentitaionRotation = isFullScreen;
            @zf_strongify(self)
            self.player.controlView.hidden = YES;
        };
        
        self.player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @zf_strongify(self)
            self.player.controlView.hidden = NO;
            if (isFullScreen) {
                self.player.controlView = self.fullControlView;
            } else {
                self.player.controlView = self.controlView;
            }
        };
    
        /// 更新另一个控制层的时间
        self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
            @zf_strongify(self)
            
            if (self.awemeType == AwemeLiviPush) {//asc seekto play
                [self.player.currentPlayerManager play];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.player.controlView isEqual:self.fullControlView]) {
                        [self.controlView videoPlayer:self.player currentTime:currentTime totalTime:duration];
                    } else if ([self.player.controlView isEqual:self.controlView]) {
                        [self.fullControlView videoPlayer:self.player currentTime:currentTime totalTime:duration];
                    }
                });
            }
            else{
                if ([self.player.controlView isEqual:self.fullControlView]) {
                    [self.controlView videoPlayer:self.player currentTime:currentTime totalTime:duration];
                } else if ([self.player.controlView isEqual:self.controlView]) {
                    [self.fullControlView videoPlayer:self.player currentTime:currentTime totalTime:duration];
                }
            }
            if (self.selectedData&&
                self.awemeType != AwemeLiviPush) {
                if (self.selectedData.limit>0&&
                    currentTime > kPalyEndLimSecs) {
//                    [self.player stopCurrentPlayingCell];
//                    [self.controlView videoPlayer:self.player currentTime:0.0 totalTime:duration];

//                    [self.player.currentPlayerManager replay];
//                    [self.player.currentPlayerManager pause];
//                    self.controlView.bottomPgrogress.value = 0.0;
//                    [self.controlView resetControlView];
//                    [self.controlView.portraitControlView resetControlView];
//                    [self.player stopCurrentPlayingCell];
//                    [self.controlView.portraitControlView resetControlView];
//                    [self.player seekToTime:0.0 completionHandler:^(BOOL finished) {
                        [self.player.currentPlayerManager pause];
//                    }];
                    
                    [self handlePlayerEndShowPopUpView];
                }
//                currentTime = 0.0;
            }
        };
        
        /// 更新另一个控制层的缓冲时间
        self.player.playerBufferTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
            @zf_strongify(self)
            if ([self.player.controlView isEqual:self.fullControlView]) {
                [self.controlView videoPlayer:self.player bufferTime:bufferTime];
            } else if ([self.player.controlView isEqual:self.controlView]) {
                [self.fullControlView videoPlayer:self.player bufferTime:bufferTime];
            }
        };
        
        /// 停止的时候找出最合适的播放
        self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @zf_strongify(self)
            if (self.player.playingIndexPath) return;
//            if (indexPath.row == self.data.count-1) {
//                /// 加载下一页数据
////                [self requestData];
//
//                    [self requestHomeListWithPage:++self.currentPage WithCid:self.cid];
//                [self.tableView reloadData];
//            }
            [self playTheVideoAtIndexPath:indexPath];
        };
}

- (void)setUpView {
    self.view.layer.masksToBounds = YES;
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight * 3)];
//    _tableView.contentInset = UIEdgeInsetsMake(ScreenHeight, 0, ScreenHeight * 1, 0);
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.pagingEnabled = YES;
    _tableView.scrollsToTop = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerClass:AwemeListCell.class forCellReuseIdentifier:kAwemeListCell];
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.scrollsToTop = NO;
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    _tableView.estimatedRowHeight = 0;
    _tableView.frame = self.view.bounds;
    if (self.awemeType == AwemeMain) {
        [_tableView setHeight:self.view.bounds.size.height-YBFrameTool.safeAdjustTabBarHeight];
    }
    _tableView.rowHeight = _tableView.frame.size.height;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
////        make.bottom.left.equalTo(self.view).offset(0);
////        make.top.equalTo(self.view.mas_top).offset(kHeaderHeight);
////        make.center.equalTo(self.view);
//    }];
    
//    self.currentPage = 1;
//    self.uid = @"97795069353";
    
    [self handlePlayer];
    if (self.awemeType == AwemeMain) {
        self.currentIndex = 0;
        self.isCurPlayerPause = NO;
        _data = [[NSMutableArray alloc]init];
    }
    
//    [self requestHomeListWithPage:self.currentPage WithCid:0];
//    //warming
    if (self.awemeType == AwemeMain){
//    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:3];
//    __weak __typeof(self) wself = self;
//
//    [_loadMore setOnLoad:^{
//        [wself requestHomeListWithPage:++wself.currentPage WithCid:wself.cid];
//    }];
//    [_tableView addSubview:_loadMore];
        [self reloadTableV];
    }
//    kWeakSelf(self);
//    [_tableView addMJHeaderWithBlock:^{
//                 kStrongSelf(self);
//
//        NSInteger cin = self.currentPage;
//        if (cin > 1) {
//            --self.currentPage;
//        }
//        else  {
//            self.currentPage = 1;
//        }
//        [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
//     }];
     
//    [_tableView addMJFooterWithBlock:^{
//                 kStrongSelf(self);
//                 ++self.currentPage;
//        [self requestHomeListWithPage:self.currentPage WithCid:self.cid];
//     }];
//
    
    
    if (self.awemeType != AwemeMain) {
        [self reloadTableV];
        [self.view addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15.0f);
            make.top.equalTo(self.view).offset(YBFrameTool.statusBarHeight );//+ 20.0f
            make.width.height.mas_equalTo(44.0f);
        }];
    }
    //[self reloadTableV];//from favior
//    __weak __typeof(self) wself = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [wself.tableView reloadData];
////        [self.view addSubview:self.tableView];
//        //warming
//        wself.loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:3];
//
//        [wself.loadMore setOnLoad:^{
//            [wself requestHomeListWithPage:++wself.currentPage WithCid:wself.cid];
//        }];
//        [wself.tableView addSubview:wself.loadMore];
//
//    });
    
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma load data
- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSString*)cid{
    self.cid = cid;
//    AwemeListRequest *request = [AwemeListRequest new];
//    request.page = pageIndex;
//    request.size = pageSize;
//    request.uid = _uid;
    
//        __block NSArray* arr = @[];
    [[HomeVM new]network_getSVListWithPage:page WithCid:self.cid WithSource:self.awemeType success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr) {
//                [wself reloadData:arr];
//                NSDictionary* dicc = [NSString readJson2DicWithFileName:@"awemes"];
//                NSArray* arr = [Aweme mj_objectArrayWithKeyValuesArray:dicc[@"data"]];
         [self requestHomeListSuccessWithArray:lastSectionArr WithPage:page];
//            success(weakSelf.listData,arr,self.lastSectionSumArr);
        } failed:^(id data) {
            [self.loadMore loadingFailed];
        }];
        
        
//        [NetworkHelper getWithUrlPath:_awemeType == AwemeWork?FindAwemePostByPagePath:FindAwemeFavoriteByPagePath request:request success:^(id data) {
//            AwemeListResponse *response = [[AwemeListResponse alloc] initWithDictionary:data error:nil];
//            NSArray<Aweme *> *array = response.data;
//            [wself reloadData:array];
//        } failure:^(NSError *error) {
//            [wself.loadMore loadingFailed];
//        }];
}
#pragma mark - public processData
- (void)requestHomeListSuccessWithArray:(NSArray *)arr  WithPage:(NSInteger)page{
    self.currentPage = page;
    NSArray *array = arr;
    if(array.count > 0) {
        
        [self.tableView beginUpdates];
        [self.data addObjectsFromArray:array];
        [self.data removeAllObjects];//imodel
        NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
        for(NSInteger row = self.data.count - array.count; row<self.data.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:NO];
        [self.tableView endUpdates];
        
        [self.loadMore endLoading];
//        [self reloadTableV];
//        [self playTheIndex:self.currentIndex];
        
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self scrollViewDidEndDecelerating:self.tableView];
//        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        
        [self.tableView reloadData];
        
//        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionBottom
//                                      animated:NO];
//        [self scrollViewDidEndDecelerating:self.tableView];
        
        _start = CFAbsoluteTimeGetCurrent();
        
        
    }else {
        [self.loadMore loadingAll];
    }
}
- (void)reloadTableV{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view addSubview:self.tableView];
        if (self.awemeType != AwemeMain) {
            self.data = self.awemes;
        }
        if (self.awemeType != AwemeLiviPush&&
            self.awemeType != AwemeCollectPush) {
            /// 如果是最后一行，去请求新数据
        //    if (index == self.data.count-1) {
        //        /// 加载下一页数据
        //        [self requestHomeListWithPage:++self.currentPage WithCid:self.cid];
        //        [self.tableView reloadData];
        //    }
            self.loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:3];
            __weak __typeof(self) wself = self;

            [self.loadMore setOnLoad:^{
                [wself requestHomeListWithPage:++wself.currentPage WithCid:wself.cid];
            }];
            [self.tableView addSubview:self.loadMore];
        }
        [self.tableView reloadData];
        if(!self.data||self.data.count==0)return;
        [self playTheIndex:self.currentIndex];
//        [self scrollViewDidEndDecelerating:self.tableView];
        
        
//        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });
}
- (void)playTheIndex:(NSInteger)index {
    
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        
        [self playTheVideoAtIndexPath:indexPath];
    }];
    
}
- (void)applicationBecomeActive {
//    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    if(!_isCurPlayerPause) {
//        [cell.playerView play];
//        [cell play];
//    cell.playerView.mute = NO;
//    }
    [self.player stopCurrentPlayingCell];
//    [self requestData];
//    [self.tableView reloadData];
    /// 找到可以播放的视频并播放
    [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        [self playTheVideoAtIndexPath:indexPath];
    }];
}

- (void)applicationEnterBackground {
    [self.player stopCurrentPlayingCell];
//    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//    _isCurPlayerPause = ![cell.playerView rate];
//    [cell.playerView pause];
//    [cell pause];
    
//    [self.lastplayerView pause];
//    self.lastplayerView.mute = YES;
//    NSArray * array = [self.tableView visibleCells];
//    for (AwemeListCell * ecell in array) {
//        [ecell pause];
////        ecell.playerView.isAutoRepeatPlay = NO;
//        ecell.playerView.mute = YES;
////        [ecell.playerView resetPlayer];
//        if (ecell.popupView) {
//            [ecell.popupView disMissView];
//        }
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.fd_interactivePopDisabled = YES;
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    if (self.awemeType != AwemeMain){
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self applicationBecomeActive];
    }
    if (self.awemeType == AwemeLiviPush&&
        !self.myModel.data.member_card.is_vip){
//        [self.timeBtn stopCountDown];
        if(self.timer)[self.timer setFireDate:[NSDate date]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    if (self.awemeType != AwemeMain){
    [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self applicationEnterBackground];
        
//        [_tableView.layer removeAllAnimations];
//        NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
//        for(AwemeListCell *cell in cells) {
//            [cell.playerView cancelLoading];
//        }
//        [[AVPlayerManager shareManager] removeAllPlayers];
//
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self removeObserver:self forKeyPath:@"currentIndex"];
//
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    if (self.awemeType == AwemeLiviPush&&
        !self.myModel.data.member_card.is_vip){
//        [self.timeBtn stopCountDown];
        if(self.timer)[self.timer setFireDate:[NSDate distantFuture]];
        
        
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self applicationBecomeActive];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[AVPlayerManager shareManager] pauseAll];
//    [self applicationEnterBackground];
    
    //from Mine Info Enter
//    [_tableView.layer removeAllAnimations];
//    NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
//    for(AwemeListCell *cell in cells) {
//        [cell.playerView cancelLoading];
//    }
//    [[AVPlayerManager shareManager] removeAllPlayers];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"currentIndex"];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.tableView.size.height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAwemeListCell forIndexPath:indexPath];
    cell.awemeType = self.awemeType;
    if (self.awemeType == AwemeLiviPush)cell.start = self.start;
    HomeItem* it = _data[indexPath.row];
    if (self.awemeType == AwemeLiviPush)it.style = self.myModel.data.member_card.is_vip?1:0;
    
    [cell initData:it];
    [cell startDownloadBackgroundTask];
    [cell actionBlock:^(id data, id data2) {//8002
        self.selectedData = data2;
        UIButton* sender = data;
        if (sender.tag == 8002) {
            switch (self.awemeType) {
                case AwemeMain:
                {
                    if (self.block) {
                        self.block(@(self.awemeType), data2);
                    }
                }
                    break;
                    
                default:
                {
                    [self levPush];
                }
                    break;
            }
        }
    }];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    AwemeListCell * fcell  = (id)cell;
//    [fcell pause];
//    fcell.playerView.mute = YES;
//    if (fcell.popupView) {
//        [fcell.popupView disMissView];
//    }
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
////    NSInteger page = self.tableView.contentOffset.y / (MAINSCREEN_HEIGHT-0.01);
//    AwemeListCell * fcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//
//    [self.lastplayerView pause];
//    self.lastplayerView.mute = YES;
//    NSArray * array = [self.tableView visibleCells];
//    for (AwemeListCell * ecell in array) {
//        [ecell pause];
//        ecell.playerView.mute = YES;
//        if (ecell.popupView) {
//            [ecell.popupView disMissView];
//        }
//    }
//
//    self.lastplayerView = fcell.playerView;
//    fcell.playerView.delegate = self;
//
//    [fcell play];
//    fcell.playerView.mute = NO;
//    if (fcell.popupView) {
//        [fcell.popupView disMissView];
//    }
//    if ([[UIApplication sharedApplication].keyWindow viewWithTag:99]!=nil) {
//        UIView* v = [[UIApplication sharedApplication].keyWindow viewWithTag:99];
//        [v removeFromSuperview];
//    }
//
//}
- (void)levPush{//@(self.aweme.limit-1)
    [LevelVC pushFromVC:self
           requestParams:0
                 success:^(id data) {
//                        [self requestFilmData:self.requestParams];
//        self.isPaid = YES;
        [self levSuccessMethod];
    }];
}

//#pragma ScrollView delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (!self.data||self.data.count<1) {
//        return;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
//        //UITableView禁止响应其他滑动手势
//        scrollView.panGestureRecognizer.enabled = NO;
//
//        if(translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
//            self.currentIndex ++;   //向下滑动索引递增
//        }
//        if(translatedPoint.y > 50 && self.currentIndex > 0) {
//            self.currentIndex --;   //向上滑动索引递减
//        }
//        [UIView animateWithDuration:0.15
//                              delay:0.0
//                            options:UIViewAnimationOptionCurveEaseOut animations:^{
//                                //UITableView滑动到指定cell
//                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                            } completion:^(BOOL finished) {
//                                //UITableView可以响应其他滑动手势
//                                scrollView.panGestureRecognizer.enabled = YES;
//                            }];
//
//    });
//}

#pragma KVO
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    //观察currentIndex变化
//    if ([keyPath isEqualToString:@"currentIndex"]) {
////        NSString* cs = [NSString stringWithFormat:@"%ld",(long)self.cid];
////        SetUserIntegerKeyWithObject(cs,self.currentIndex);
//        //设置用于标记当前视频是否播放的BOOL值为NO
//        _isCurPlayerPause = NO;
//        //获取当前显示的cell
//        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//        [cell startDownloadHighPriorityTask];
//        __weak typeof (cell) wcell = cell;
//        __weak typeof (self) wself = self;
//        //判断当前cell的视频源是否已经准备播放
//        if(cell.isPlayerReady) {
//            //播放视频
//            [cell replay];
//
//        }else {
//            [[AVPlayerManager shareManager] pauseAll];
//            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
//            cell.onPlayerReady = ^{
//                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
//                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
//                    [wcell play];
//                }
//            };
//        }
//    } else {
//        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

- (void)statusBarTouchBegin {
    _currentIndex = 0;
}



- (NSInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
//    if (!self.data||self.data.count<1) {
//        return;
//    }
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;

        if(translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];

    });
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - ZFDouYinCellDelegate

- (void)zf_douyinRotation {
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    if (self.player.isFullScreen) {
        orientation = UIInterfaceOrientationPortrait;
    } else {
        orientation = UIInterfaceOrientationLandscapeRight;
    }
    [self.player rotateToOrientation:orientation animated:YES completion:nil];
}
#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath];
}
- (void)handlePlayerEndShowPopUpView{
    
    if (self.prepopupView) {
        for (UIView* v  in self.prepopupView.subviews) {
            [v removeFromSuperview];
        }
        [self.prepopupView disMissView];
    }
    NSArray* arr = @[
        @[
            [NSString stringWithFormat:@"%@",[self.selectedData getNLevLimitTitle]]
        ]
    ];
    
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:99]!=nil) {
        UIView* v = [[UIApplication sharedApplication].keyWindow viewWithTag:99];
        [v removeFromSuperview];
    }
    PreviewPopUpView* popupView = [[PreviewPopUpView alloc]init];
    popupView.tag = 99;
    self.prepopupView = popupView;
    [popupView showInApplicationKeyWindow];
    
    [popupView richElementsInViewWithModel:arr withItem:self.selectedData];
    
    [popupView actionBlock:^(NSNumber* data) {
        if ([data integerValue] == 0) {
//            [self inputFilmData];
//                [self requestFilmData:self.requestParams];
//            [self.player seekToTime:0.0 completionHandler:^(BOOL finished) {
//
//            }];
            [self.player.currentPlayerManager replay];
//            [self.player stopCurrentPlayingCell];
//            [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
//                [self playTheVideoAtIndexPath:indexPath];
//            }];
        }else{
            [self levPush];
        }
        [popupView disMissView];
        if ([[UIApplication sharedApplication].keyWindow viewWithTag:99]!=nil) {
            UIView* v = [[UIApplication sharedApplication].keyWindow viewWithTag:99];
            [v removeFromSuperview];
        }
    }];
}
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeItem* it = _data[indexPath.row];
    self.selectedData = it;
    NSString *playUrl =
//    @"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4";
    [NSString stringWithFormat:@"%@",self.awemeType==AwemeLiviPush?it.hls_url: it.url];
    if (self.awemeType==AwemeLiviPush) {
        if ([it.start_second floatValue] > [it.duration_seconds floatValue]) {
            [self.player seekToTime:0.0 completionHandler:^(BOOL finished) {
                
            }];
        }else{
            NSTimeInterval tim = [it.start_second integerValue];
            [self.player seekToTime:tim completionHandler:^(BOOL finished) {
//                [self.player.currentPlayerManager play];
            }];
//            [self.player.currentPlayerManager play];
            
        }
    }else{
//        [self.player seekToTime:15.0 completionHandler:^(BOOL finished) {
//
//        }];
    }
    [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:playUrl]];
    [self.controlView resetControlView];
    if (self.selectedData) {
        if (self.selectedData.limit>0){
//            self.controlView.bottomPgrogress.value = 0.0;
            self.controlView.landScapeControlView.slider.userInteractionEnabled = NO;
            self.controlView.portraitControlView.slider.userInteractionEnabled = NO;

        }else{
            self.controlView.landScapeControlView.slider.userInteractionEnabled = YES;
            self.controlView.portraitControlView.slider.userInteractionEnabled = YES;
        }
    }
//    self.controlView.landScapeControlView.fullScreenBtn.hidden = YES;
    self.controlView.portraitControlView.fullScreenBtn.hidden = YES;
    self.controlView.portraitControlView.slider.minimumTrackTintColor = YBGeneralColor.themeColor;
//    [self.controlView showCoverViewWithUrl:data.thumbnail_url];
    [self.controlView showTitle:@""
                 coverURLString:it.cover_img
                 fullScreenMode:ZFFullScreenModePortrait];//it.title
    [self.fullControlView showTitle:@"custom landscape controlView" coverURLString:it.cover_img fullScreenMode:ZFFullScreenModeLandscape];
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.horizontalPanShowControlView = NO;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}

- (ZFCustomControlView *)fullControlView {
    if (!_fullControlView) {
        _fullControlView = [[ZFCustomControlView alloc] init];
    }
    return _fullControlView;
}

- (void)dealloc {
    NSLog(@"======== dealloc =======");
}

@end
