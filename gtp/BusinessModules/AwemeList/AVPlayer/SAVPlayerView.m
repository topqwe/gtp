//
//  AVPlayerView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "SAVPlayerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WebCacheHelpler.h"
#import "AVPlayerManager.h"
#import "SelPlayerConfiguration.h"
#import "SelPlaybackControls.h"
@interface SAVPlayerView () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate,  AVAssetResourceLoaderDelegate,SelPlaybackControlsDelegate>
/** 视频播放控制面板 */
@property (nonatomic, strong) SelPlaybackControls *playbackControls;
/** 是否结束播放 */
@property (nonatomic, assign) BOOL playDidEnd;
@property (nonatomic ,strong) NSURL                *sourceURL;              //视频路径
@property (nonatomic ,strong) NSString             *sourceScheme;           //路径Scheme
@property (nonatomic ,strong) AVURLAsset           *urlAsset;               //视频资源
@property (nonatomic ,strong) AVPlayerItem         *playerItem;             //视频资源载体
@property (nonatomic ,strong) AVPlayer             *player;                 //视频播放器
@property (nonatomic ,strong) AVPlayerLayer        *playerLayer;            //视频播放器图形化载体
@property (nonatomic ,strong) id                   timeObserver;            //视频播放器周期性调用的观察者

@property (nonatomic, strong) NSMutableData        *data;                   //视频缓冲数据
@property (nonatomic, copy) NSString               *mimeType;               //资源格式
@property (nonatomic, assign) long long            expectedContentLength;   //资源大小
@property (nonatomic, strong) NSMutableArray       *pendingRequests;        //存储AVAssetResourceLoadingRequest的数组

@property (nonatomic, copy) NSString               *cacheFileKey;           //缓存文件key值
@property (nonatomic, strong) NSOperation          *queryCacheOperation;    //查找本地视频缓存数据的NSOperation
@property (nonatomic, strong) dispatch_queue_t     cancelLoadingQueue;

@property (nonatomic, strong) WebCombineOperation  *combineOperation;

@property (nonatomic, assign) BOOL                 retried;
@end

@implementation SAVPlayerView

//重写initWithFrame
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        //初始化存储AVAssetResourceLoadingRequest的数组
        _pendingRequests = [NSMutableArray array];
        
        //初始化播放器
        _player = [AVPlayer new];
        //添加视频播放器图形化载体AVPlayerLayer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:_playerLayer];
        [self _setupPlayControls];
        //初始化取消视频加载的队列
        _cancelLoadingQueue = dispatch_queue_create("com.start.cancelloadingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
/** 添加播放器控制面板 */
- (void)_setupPlayControls
{
    [self addSubview:self.playbackControls];
}
/** 播放器控制面板 */
- (SelPlaybackControls *)playbackControls
{
    if (!_playbackControls) {
        _playbackControls = [[SelPlaybackControls alloc]init];
        _playbackControls.delegate = self;
        _playbackControls.hideInterval = 38;
        [_playbackControls _activityIndicatorViewShow:NO];
        _playbackControls.statusBarHideState = 1;
        _playbackControls.userInteractionEnabled = YES;
    }
    return _playbackControls;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    //禁止隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    self.playbackControls.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height-(49.5f + YBFrameTool.iphoneBottomHeight));
    
    self.playbackControls.backgroundColor = UIColor.greenColor;
    [CATransaction commit];
}

//设置播放路径
-(void)setPlayerWithUrl:(NSString *)url {
    //播放路径
    self.sourceURL = [NSURL URLWithString:url];
    
    //获取路径schema
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.sourceURL resolvingAgainstBaseURL:NO];
    self.sourceScheme = components.scheme;
    
    //路径作为视频缓存key
    _cacheFileKey = self.sourceURL.absoluteString;
    
    __weak __typeof(self) wself = self;
    //查找本地视频缓存数据
    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //hasCache是否有缓存，data为本地缓存路径
            if(!hasCache) {
                //当前路径无缓存，则将视频的网络路径的scheme改为其他自定义的scheme类型，http、https这类预留的scheme类型不能使AVAssetResourceLoaderDelegate中的方法回调
                wself.sourceURL = [wself.sourceURL.absoluteString urlScheme:@"streaming"];
            }else {
                //当前路径有缓存，则使用本地路径作为播放源
                wself.sourceURL = [NSURL fileURLWithPath:data];
            }
            //初始化AVURLAsset
            wself.urlAsset = [AVURLAsset URLAssetWithURL:wself.sourceURL options:nil];
            //设置AVAssetResourceLoaderDelegate代理
            [wself.urlAsset.resourceLoader setDelegate:wself queue:dispatch_get_main_queue()];
            //初始化AVPlayerItem
            wself.playerItem = [AVPlayerItem playerItemWithAsset:wself.urlAsset];
            //观察playerItem.status属性
            [wself.playerItem addObserver:wself forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
            //切换当前AVPlayer播放器的视频源
            wself.player = [[AVPlayer alloc] initWithPlayerItem:wself.playerItem];
            wself.playerLayer.player = wself.player;
            //给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
            [wself addProgressObserver];
        });
    } extension:@"mp4"];
}

//取消播放
-(void)cancelLoading {
    //暂停视频播放
    [self pause];
    
    //隐藏playerLayer
    [_playerLayer setHidden:YES];
    
    //取消下载任务
    if(_combineOperation) {
        [_combineOperation cancel];
        _combineOperation = nil;
    }
    
    //取消查找本地视频缓存数据的NSOperation任务
    [_queryCacheOperation cancel];
    
    _player = nil;
    [_playerItem removeObserver:self forKeyPath:@"status"];
    _playerItem = nil;
    _playerLayer.player = nil;
    
    __weak __typeof(self) wself = self;
    dispatch_async(self.cancelLoadingQueue, ^{
        //取消AVURLAsset加载，这一步很重要，及时取消到AVAssetResourceLoaderDelegate视频源的加载，避免AVPlayer视频源切换时发生的错位现象
        [wself.urlAsset cancelLoading];
        wself.data = nil;
        //结束所有视频数据加载请求
        [wself.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
            if(![loadingRequest isFinished]) {
                [loadingRequest finishLoading];
            }
        }];
        [wself.pendingRequests removeAllObjects];
    });
    
    _retried = NO;
    
}

//开始视频资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground {
    __weak __typeof(self) wself = self;
    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hasCache) {
                return;
            }
            
            if(wself.combineOperation != nil) {
                [wself.combineOperation cancel];
            }
            
            wself.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL responseBlock:^(NSHTTPURLResponse *response) {
                wself.data = [NSMutableData data];
                wself.mimeType = response.MIMEType;
                wself.expectedContentLength = response.expectedContentLength;
                [wself processPendingRequests];
            } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
                [wself.data appendData:data];
                //处理视频数据加载请求
                [wself processPendingRequests];
            } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if(!error && finished) {
                    //下载完毕，将缓存数据保存到本地
                    [[WebCacheHelpler sharedWebCache] storeDataToDiskCache:wself.data key:wself.cacheFileKey extension:@"mp4"];
                }
            } cancelBlock:^{
            } isBackground:isBackground];
        });
    }];
}

//更新AVPlayer状态，当前播放则暂停，当前暂停则播放
-(void)updatePlayerState {
    if(_player.rate == 0) {
        [self play];
//        [_playbackControls _activityIndicatorViewShow:NO];
    }else {
        [self pause];
//        [_playbackControls _activityIndicatorViewShow:YES];
    }
}

//播放
-(void)play {
    if (self.playDidEnd && self.playbackControls.videoSlider.value == 1.0) {
        //若播放已结束重新播放
        [self replay];
    }else
    {
    [[AVPlayerManager shareManager] play:_player];
    [self.playbackControls _setPlayButtonSelect:YES];
    }
}

//暂停
-(void)pause {
    [self.playbackControls _setPlayButtonSelect:NO];
    [self.playbackControls _playerShowOrHidePlaybackControls];
    [[AVPlayerManager shareManager] pause:_player];
}

//重新播放
-(void)replay {
    self.playDidEnd = NO;
    [[AVPlayerManager shareManager] replay:_player];
}

//播放速度
-(CGFloat)rate {
    return [_player rate];
}

//重新请求
-(void)retry {
    [_playbackControls _retryButtonShow:NO];
//    [_playbackControls _activityIndicatorViewShow:YES];
    [self cancelLoading];
    _sourceURL = [_sourceURL.absoluteString urlScheme:_sourceScheme];
    [self setPlayerWithUrl:_sourceURL.absoluteString];
    _retried = YES;
}
#pragma mark 播放器控制面板代理
/** 控制面板单击事件 */
- (void)tapGesture
{
    [_playbackControls _playerShowOrHidePlaybackControls];
}
#pragma mark 滑杆拖动代理
/** 开始拖动 */
-(void)videoSliderTouchBegan:(SelVideoSlider *)slider{
    [self pause];
    [_playbackControls _playerCancelAutoHidePlaybackControls];
}
/** 结束拖动 */
-(void)videoSliderTouchEnded:(SelVideoSlider *)slider{

    if (slider.value != 1) {
        self.playDidEnd = NO;
    }
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
//        [self bufferingSomeSecond];
    }else{
        //继续播放
        [self play];
    }
    [_playbackControls _playerAutoHidePlaybackControls];
}

/** 拖拽中 */
-(void)videoSliderValueChanged:(SelVideoSlider *)slider{
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    CGFloat dragedSeconds = totalTime * slider.value;
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [_player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger currentTime = (NSInteger)CMTimeGetSeconds(dragedCMTime);
    [_playbackControls _setPlaybackControlsWithPlayTime:currentTime totalTime:totalTime sliderValue:slider.value];
}

#pragma AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    //创建用于下载视频源的NSURLSessionDataTask，当前方法会多次调用，所以需判断self.task == nil
    if(_combineOperation == nil) {
        //将当前的请求路径的scheme换成https，进行普通的网络请求
        NSURL *URL = [[loadingRequest.request URL].absoluteString urlScheme:_sourceScheme];
        [self startDownloadTask:URL isBackground:YES];
    }
    //将视频加载请求依此存储到pendingRequests中，因为当前方法会多次调用，所以需用数组缓存
    [_pendingRequests addObject:loadingRequest];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //AVAssetResourceLoadingRequest请求被取消，移除视频加载请求
    [_pendingRequests removeObject:loadingRequest];
}

- (void)processPendingRequests {
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    //获取所有已完成AVAssetResourceLoadingRequest
    [_pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * stop) {
        //判断AVAssetResourceLoadingRequest是否完成
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest];
        //结束AVAssetResourceLoadingRequest
        if (didRespondCompletely){
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }];
    //移除所有已完成AVAssetResourceLoadingRequest
    [self.pendingRequests removeObjectsInArray:requestsCompleted];
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //设置AVAssetResourceLoadingRequest的类型、支持断点下载、内容大小
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(_mimeType), NULL);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.contentLength = _expectedContentLength;
    
    //AVAssetResourceLoadingRequest请求偏移量
    long long startOffset = loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        startOffset = loadingRequest.dataRequest.currentOffset;
    }
    //判断当前缓存数据量是否大于请求偏移量
    if (_data.length < startOffset) {
        return NO;
    }
    //计算还未装载到缓存数据
    NSUInteger unreadBytes = _data.length - (NSUInteger)startOffset;
    //判断当前请求到的数据大小
    NSUInteger numberOfBytesToRespondWidth = MIN((NSUInteger)loadingRequest.dataRequest.requestedLength, unreadBytes);
    //将缓存数据的指定片段装载到视频加载请求中
    [loadingRequest.dataRequest respondWithData:[_data subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWidth)]];
    //计算装载完毕后的数据偏移量
    long long endOffset = startOffset + loadingRequest.dataRequest.requestedLength;
    //判断请求是否完成
    BOOL didRespondFully = _data.length >= endOffset;
    
    return didRespondFully;
}

#pragma kvo

// 给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
-(void)addProgressObserver{
    __weak __typeof(self) weakSelf = self;
    //AVPlayer添加周期性回调观察者，一秒调用一次block，用于更新视频播放进度
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            //获取当前播放时间
            float current = CMTimeGetSeconds(time);
            //获取视频播放总时间
            float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
            //重新播放视频
            if(total == current) {
                [weakSelf replay];
            }
            CGFloat value = current  / total;
            [weakSelf.playbackControls _setPlaybackControlsWithPlayTime:current  totalTime:total  sliderValue:value];
            //更新视频播放进度方法回调
            if(weakSelf.delegate) {
                [weakSelf.delegate onProgressUpdate:current total:total];
            }
        }
    }];
}

// 响应KVO值变化的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //AVPlayerItem.status
    if([keyPath isEqualToString:@"status"]) {
        if(_playerItem.status == AVPlayerItemStatusFailed) {
            if(!_retried) {
                [self retry];
            }
        }
        //视频源装备完毕，则显示playerLayer
        if(_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playerLayer setHidden:NO];
        }
        //视频播放状体更新方法回调
        if(_delegate) {
            [_delegate onPlayItemStatusUpdate:_playerItem.status];
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_player removeTimeObserver:_timeObserver];
    [self.playbackControls _playerCancelAutoHidePlaybackControls];
}

@end
