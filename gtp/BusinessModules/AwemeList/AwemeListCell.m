//
//  AwemeListCell.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "AwemeListCell.h"
#import "Aweme.h"
#import "AVPlayerView.h"
#import "HoverTextView.h"
#import "CircleTextView.h"
#import "FocusView.h"
#import "MusicAlbumView.h"
#import "FavoriteView.h"
#import "CommentsPopView.h"
#import "SharePopView.h"
#import "SelVideoSlider.h"
#import "ZFPlayer.h"

#define  kContainBottomMargin (49.5f)
// + YBFrameTool.iphoneBottomHeight
static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;
static const NSInteger kAwemeListLikeCollectTag   = 0x03;
static const NSInteger kAwemeListLikeInviteTag   = 0x04;
@interface AwemeListCell()<SendTextDelegate, HoverTextViewDelegate, AVPlayerUpdateDelegate>
//ZFPlayerDelegate,ZFPlayerControlViewDelagate

@property(nonatomic, strong) UIImageView                     *fatherView;/**<  */

/** 底部控制栏 */
@property (nonatomic, strong)UIView *bottomControlsBar;
/** 进度滑杆 */
@property (nonatomic, strong) SelVideoSlider *videoSlider;
/** 播放时间 */
@property (nonatomic, strong) UILabel *playTimeLabel;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic ,strong) UIImageView              *musicIcon;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) NSMutableArray *topBtns;
@end

@implementation AwemeListCell
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.01);
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //init player view;
    
//    _playerView = [AVPlayerView new];
//    _playerView.delegate = self;
//    [self.contentView addSubview:_playerView];
    
//    _playerView.hidden = YES;
//    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
//    _videoPlayView = [UIImageView new];
//    [self.contentView addSubview:_videoPlayView];
//    [_videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self configSubView];
    //init hover on player view container
//    self.contentView = [UIView new];
//    [self.contentView addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(self);
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self).inset(kContainBottomMargin);
//        make.left.top.equalTo(self);
////        make.width.mas_equalTo(ScreenWidth);
////        make.height.equalTo(@30);
//    }];
    
//    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.contentView addGestureRecognizer:_singleTapGesture];
    
//    _gradientLayer = [CAGradientLayer layer];
//    _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)RGBA(0.0, 0.0, 0.0, 0.2).CGColor, (__bridge id)RGBA(0.0, 0.0, 0.0, 0.4).CGColor];
//    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
//    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
//    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
//    [self.contentView.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = kIMG(@"M_pauseBtnIcon");
//    [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [self.contentView addSubview:_pauseIcon];
    
    //init hoverTextView
    _hoverTextView = [HoverTextView new];
    _hoverTextView.delegate = self;
    _hoverTextView.hoverDelegate = self;
    [self addSubview:_hoverTextView];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = [UIColor whiteColor];
    [_playerStatusBar setHidden:YES];
    [self.contentView addSubview:_playerStatusBar];
    
    [self.contentView addSubview:self.bottomControlsBar];
    [_bottomControlsBar addSubview:self.playTimeLabel];
    [_bottomControlsBar addSubview:self.totalTimeLabel];
    [_bottomControlsBar addSubview:self.progress];
    [_bottomControlsBar addSubview:self.videoSlider];
    
    //init aweme message
    _musicIcon = [[UIImageView alloc]init];
    _musicIcon.contentMode = UIViewContentModeCenter;
    _musicIcon.image = [UIImage imageNamed:@"icon_home_musicnote3"];
    [self.contentView addSubview:_musicIcon];
    
    _musicName = [[CircleTextView alloc]init];
    _musicName.textColor = [UIColor whiteColor];
    _musicName.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_musicName];
    
    
    _desc = [[UILabel alloc]init];
    _desc.numberOfLines = 0;
    _desc.textColor = [UIColor whiteColor];
    _desc.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_desc];
    
    
    _nickName = [[UILabel alloc]init];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font =  [UIFont boldSystemFontOfSize:16.0];
    [self.contentView addSubview:_nickName];
    
    
    //init music alum view
    _musicAlum = [MusicAlbumView new];
    [self.contentView addSubview:_musicAlum];
    
    _invite = [[UIImageView alloc]init];
    _invite.contentMode = UIViewContentModeCenter;
    _invite.image = [UIImage imageNamed:@"icon_home_share"];
    _invite.userInteractionEnabled = YES;
    _invite.tag = kAwemeListLikeInviteTag;
    [_invite addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.contentView addSubview:_invite];
    
    
    //init share、comment、like action view
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"icon_home_share"];
    _share.userInteractionEnabled = YES;
    _share.tag = kAwemeListLikeShareTag;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.contentView addSubview:_share];
    
    _shareNum = [[UILabel alloc]init];
    _shareNum.text = @"0";
    _shareNum.textColor = [UIColor whiteColor];
    _shareNum.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_shareNum];
    
    _collect = [[UIImageView alloc]init];
    _collect.contentMode = UIViewContentModeCenter;
    _collect.image = [UIImage imageNamed:@"icon_home_allshare_copylink"];
    _collect.userInteractionEnabled = YES;
    _collect.tag = kAwemeListLikeCollectTag;
    [_collect addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.contentView addSubview:_collect];
    
    _collectNum = [[UILabel alloc]init];
    _collectNum.text = @"0";
    _collectNum.textColor = [UIColor whiteColor];
    _collectNum.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_collectNum];
    
    _comment = [[UIImageView alloc]init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"icon_home_comment"];
    _comment.userInteractionEnabled = YES;
    _comment.tag = kAwemeListLikeCommentTag;
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.contentView addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    _commentNum.text = @"0";
    _commentNum.textColor = [UIColor whiteColor];
    _commentNum.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_commentNum];
    
    _favorite = [FavoriteView new];
    [self.contentView addSubview:_favorite];
    
    _favoriteNum = [[UILabel alloc]init];
    _favoriteNum.text = @"0";
    _favoriteNum.textColor = [UIColor whiteColor];
    _favoriteNum.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_favoriteNum];
    
    //init avatar
    CGFloat avatarRadius = 25;
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"img_find_default"];
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.borderWidth = 1;
    [self.contentView addSubview:_avatar];
    
    //init focus action
    _focus = [FocusView new];
    [self.contentView addSubview:_focus];
    
    
    
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];

    //make constraintes
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(kContainBottomMargin);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_bottomControlsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(kContainBottomMargin);
        make.left.equalTo(self);
//        make.width.mas_equalTo(ScreenWidth);
        make.height.equalTo(@30);
    }];
    
    [_playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomControlsBar).offset(5);
        make.width.equalTo(@45);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomControlsBar.mas_right).offset(-5);
        make.width.equalTo(@45);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playTimeLabel.mas_right).offset(5);
        make.right.equalTo(_totalTimeLabel.mas_left).offset(-5);
        make.height.equalTo(@2);
        make.centerY.equalTo(_bottomControlsBar.mas_centerY);
    }];

    [_videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_progress);
    }];
    
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).inset(60 + YBFrameTool.iphoneBottomHeight);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicIcon.mas_right);
        make.centerY.equalTo(self.musicIcon);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(24);
    }];
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).inset(kContainBottomMargin);
        make.left.equalTo(self).offset(10);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
    }];
//    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.bottom.equalTo(self.musicIcon.mas_top).offset(-20);
//        make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
//    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.desc.mas_top).inset(5);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/4*3 + 30);
    }];
    
    [_musicAlum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicName);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    
    
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];
    
    [_invite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicAlum.mas_top).offset(-20);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_collectNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collect.mas_bottom);
        make.centerX.equalTo(self.collect);
    }];
    
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favorite.mas_top).inset(35);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.centerY.equalTo(self.avatar.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];
    
    _nickName.hidden = YES;
    _musicIcon.hidden = YES;
    _musicName.hidden = YES;
    _musicAlum.hidden = YES;
    _share.hidden = YES;
    _shareNum.hidden = YES;
    _avatar.hidden = YES;
    _focus.hidden = YES;
    _hoverTextView.hidden = YES;

    _favorite.hidden = YES;
    _comment.hidden = YES;
    
    _collectNum.hidden = YES;
    _favoriteNum.hidden = YES;
    _commentNum.hidden = YES;
    
    _invite.hidden = YES;
    _collect.hidden = YES;
    _collectNum.hidden = YES;
    
    _bottomControlsBar.hidden = YES;
    _playerStatusBar.hidden = YES;
    
    [self setupDanmakuData];
    
    [self setLeftBtns];
    
    UIButton *levBut = [[UIButton alloc]init];
    self.levBut = levBut;
//    levBut.userInteractionEnabled = NO;
    levBut.tag = 8002;
    [self.contentView addSubview:levBut];
    [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(8);
//        make.right.mas_equalTo(-8);
//        make.height.mas_equalTo(36);
//        make.width.mas_equalTo(180);
        
        make.bottom.equalTo(self).inset(kContainBottomMargin);
        make.left.equalTo(self).offset(10);
        make.width.mas_equalTo(180);
        make.height.equalTo(@36);
    }];
    levBut.layer.cornerRadius = 36/2;
    levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    levBut.titleLabel.font = kFontSize(15);
    [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
    levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    levBut.layer.masksToBounds = true;
    levBut.hidden = YES;
    
    [self.contentView addSubview:self.introBtn];
    [self.introBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(8);
//        make.right.mas_equalTo(-8);
//        make.height.mas_equalTo(36);
//        make.width.mas_equalTo(180);
        
        make.bottom.equalTo(self).inset(kContainBottomMargin);
        make.left.equalTo(self).offset(10);
        make.width.mas_equalTo(130);
        make.height.equalTo(@36);
    }];
    self.introBtn.layer.cornerRadius = 36/2;
    self.introBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    self.introBtn.titleLabel.font = kFontSize(13);
//    [self.introBtn setTitleColor:HEXCOLOR(0xffffff) forState:0];
    self.introBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.introBtn.titleLabel.numberOfLines = 2;
    self.introBtn.layer.masksToBounds = true;
    self.introBtn.backgroundColor = HEXCOLOR(0x000000);
    self.introBtn.hidden = YES;
    
    _danmakuBtn.backgroundColor = HEXCOLOR(0x000000);
    [self.contentView addSubview:self.danmakuBtn];
    self.danmakuBtn.hidden = YES;
    [_danmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(kContainBottomMargin);
//            make.left.equalTo(self);
        make.width.mas_equalTo(90);
        make.height.equalTo(@30);
    }];
    _danmakuBtn.backgroundColor = HEXCOLOR(0x000000);
    _danmakuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _danmakuBtn.layer.masksToBounds = YES;
    _danmakuBtn.layer.cornerRadius = 30/2;
    
    [self setUpCountBtn];
//    if (self.awemeType == AwemeLiviPush&&
//        self.aweme.style==0) {
        SetUserBoolKeyWithObject(@"isOutTime2", NO);
//    }
}


-(void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
//    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];
    
    [_hoverTextView.textView setText:@""];
    [_avatar setImage:[UIImage imageNamed:@"img_find_default"]];
    
    [_musicAlum resetView];
    [_favorite resetView];
    [_focus resetView];
    _focus.hidden = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.fatherView.frame = self.contentView.bounds;
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
//    [CATransaction commit];
//    ZFPlayerControlView * controlView =  (id)_playerView.controlView;
//    controlView.backBtn.hidden = YES;
//    controlView.st_typeButton.hidden = YES;
//    controlView.fullScreenBtn.hidden = YES;
//    controlView.st_frontButton.hidden = YES;
//    controlView.st_backButton.hidden = YES;
//    controlView.startBtn.hidden = YES;
//
//    [controlView.repeatBtn removeFromSuperview];
//    /** 缓冲进度条 */
//    [controlView.progressView removeFromSuperview];
//    /** 控制层消失时候在底部显示的播放进度progress */
//    [controlView.bottomProgressView removeFromSuperview];
    
}
- (void)configSubView{
//    self.fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, [SVFindTableViewCell cellHeight])];
    self.fatherView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.fatherView];
//    self.fatherView.frame = self.contentView.bounds;
//    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView);
//    }];
//    self.fatherView.contentMode = UIViewContentModeScaleAspectFill;
//    self.fatherView.clipsToBounds = YES;
    self.fatherView.tag = kPlayerViewTag;
    self.fatherView.userInteractionEnabled = YES;
    self.fatherView.contentMode = UIViewContentModeScaleAspectFit;
//
//    _playerView = ZFPlayerView.alloc.init;
//    _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
//    // 当cell播放视频由全屏变为小屏时候，不回到中间位置
//    _playerView.cellPlayerOnCenter = NO;
//
//    // 初始化播放数据
////    UIImage * image = [TMRandImageTool bundleImageWithImageName:TMRandImageTool.randOneGoodBanner];
//    _playerModel = [[ZFPlayerModel alloc] init];
//    _playerModel.fatherView = self.fatherView;
//    _playerModel.videoURL = [NSURL URLWithString:@""];
//    _playerModel.placeholderImage =  [UIImage new];
//
////    [self.playerView playerModel:_playerModel];
//
//    ZFPlayerControlView * controlView =  (id)_playerView.controlView;
////    controlView.foreverShow = true;
////    controlView.bottom = YBFrameTool.safeAdjustTabBarHeight;
//    self.playerView.disablePanGesture = YES;
////    self.playerView.forcePortrait = YES;
//    self.playerView.isLocked = YES;
////    self.playerView.isFullScreen = YES;
//    ZFPlayerShared.isLockScreen = YES;
//    ZFPlayerShared.isAllowLandscape = NO;
//
}
//- (void)initZFData:(HomeItem *)aweme{
//    [self.playerView resetPlayer];
//    if (self.awemeType == AwemeLiviPush) {
//        self.playerView.foreverShow = NO;
//    }else{
//        self.playerView.foreverShow = YES;
//    }//imodel
////    ZFPlayerControlView * controlView =  (id)_playerView.controlView;
////    controlView.foreverShow = true;
//    self.playerModel.placeholderImageURLString = aweme.cover_img;
//    _playerModel.videoURL = [NSURL URLWithString:self.awemeType == AwemeLiviPush?aweme.hls_url:aweme.url];
//    if (self.awemeType == AwemeLiviPush) {
////        [_playerView startPlayOneTime:[self.aweme.start_second floatValue]];
//        _playerModel.seekTime = [self.aweme.start_second floatValue];
////        [_playerView seekToTime:[self.aweme.start_second floatValue] completionHandler:nil];
//        ZFPlayerControlView * controlView =  (id)_playerView.controlView;
//        [controlView removeAllSubviews];
//        /** 当前播放时长label */
//        [controlView.currentTimeLabel removeFromSuperview];
//        /** 视频总时长label */
//        [controlView.totalTimeLabel removeFromSuperview];
//        /** 滑杆 */
//        [controlView.videoSlider removeFromSuperview];
//
//        [self.pauseIcon removeFromSuperview];
//        controlView.userInteractionEnabled = NO;
////        _playerView.userInteractionEnabled = NO;
//    }else{
//        _playerModel.seekTime = 0.0;
//        [_playerView seekToTime:_playerModel.seekTime completionHandler:nil];
//    }
//    _playerView.pauseTime = self.aweme.limit > 0?kZFPlayerPasueTime:0;
//    [self.playerView playerModel:_playerModel];
////    [self.playerView resetToPlayNewVideo:_playerModel];
//    [self.playerView autoPlayTheVideo];
//    self.playerView.isAutoRepeatPlay = YES;
////    self.playerView.repeatToPlay = YES;
//    [self.playerView actionBlock:^(id data, id data2) {
//
//        if ([data integerValue] == ZFPlayerEventCotrolPasueIcon) {
////            [self singleTapAction];
//            [self.pauseIcon setHidden:YES];
//            return;
//        }
//        if ([data integerValue] == ZFPlayerEventCotrolRepeatPlay) {
////            [self singleTapAction];
//            [self.playerView repeatPlay];
////            return;
//        }
//        if ([data integerValue]==ZFPlayerEventCotrolPasueTime) {
//            [self.pauseIcon setHidden:YES];
//            if (self.aweme.limit > 0) {
//                self.playerView.isAutoRepeatPlay = NO;
////                [self.playerView pause];
//                [self playerEndShowPopUpView];
//            }else{
//                self.playerView.isAutoRepeatPlay = YES;
//            }
//        }
//
//    }];
//}
- (void)playerEndShowPopUpView{
//    if (self.awemeType == AwemeLiviPush&&
//        self.aweme.style == 0) {
//        BOOL isOut = GetUserDefaultBoolWithKey(@"isOutTime2");
//        if (isOut) {
//            self.aweme.limit = 1;
//                        return;
//        }else{
//            self.aweme.limit = 1;
//        }
//    }
    
    if (self.prepopupView) {
        for (UIView* v  in self.prepopupView.subviews) {
            [v removeFromSuperview];
        }
        [self.prepopupView disMissView];
    }
    NSArray* arr = @[
        @[
            [NSString stringWithFormat:@"%@",[self.aweme getNLevLimitTitle]]
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
    
    [popupView richElementsInViewWithModel:arr withItem:self.aweme];
    
    [popupView actionBlock:^(NSNumber* data) {
        if ([data integerValue] == 0) {
//            [self inputFilmData];
//                [self requestFilmData:self.requestParams];
            [self play];
        }else{
            [self levPush];
        }
        [popupView disMissView];
        if ([[UIApplication sharedApplication].keyWindow viewWithTag:99]!=nil) {
            UIView* v = [[UIApplication sharedApplication].keyWindow viewWithTag:99];
            [v removeFromSuperview];
        }
    }];
//    if (self.awemeType == AwemeLiviPush&&
//        self.aweme.style==0) {
//        SetUserBoolKeyWithObject(@"isOutTime2", YES);
//    }
//    [self.timeBtn stopCountDown];
}
//SendTextDelegate delegate
- (void)onSendText:(NSString *)text {
    [[HomeVM new] network_postTextWithRequestParams:[NSString stringWithFormat:@"%@",text] WithHomeItem:[HomeItem new] WithSource:0 success:^(id data) {
//        if (self.block) {
//            self.block(@"1");
//        }
//        [self requestHomeListWithPage:1 WithCid:0];
    
    } failed:^(id data) {
//        [self requestHomeListWithPage:1 WithCid:0];
    }];
    
//    __weak __typeof(self) wself = self;
//    PostCommentRequest *request = [PostCommentRequest new];
//    request.aweme_id = _aweme.aweme_id;
//    request.udid = UDID;
//    request.text = text;
//    [NetworkHelper postWithUrlPath:PostComentPath request:request success:^(id data) {
//        [UIWindow showTips:@"评论成功"];
//    } failure:^(NSError *error) {
//        wself.hoverTextView.textView.text = text;
//        [UIWindow showTips:@"评论失败"];
//    }];
}

//HoverTextViewDelegate delegate
-(void)hoverTextViewStateChange:(BOOL)isHover {
    self.contentView.alpha = isHover ? 0.0f : 1.0f;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
            CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:[NSString stringWithFormat:@"%ld",(long)_aweme.ID]];
            [popView show];
            break;
        }
        case kAwemeListLikeCollectTag: {
//            CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:_aweme.aweme_id];
//            [popView show];
            NSLog(@"collect");
            break;
        }
        case kAwemeListLikeInviteTag: {
            id object = [self nextResponder];
            while (![object isKindOfClass:[UIViewController class]] && object != nil) {
                object = [object nextResponder];
            }
            UIViewController *superController = (UIViewController*)object;
            [superController.navigationController  showViewController:[ShareVC new] sender:nil];
            break;
        }
        case kAwemeListLikeShareTag: {
            SharePopView *popView = [[SharePopView alloc] init];
            [popView show];
            break;
        }
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:self.contentView];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time - _lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            }else {
                //取消执行单击方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
//                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
            }
            //更新上一次点击位置
            _lastTapPoint = point;
            //更新上一次点击时间
            _lastTapTime =  time;
            break;
        }
    }
    
}

- (void)singleTapAction {
    if([_hoverTextView isFirstResponder]) {
        [_hoverTextView resignFirstResponder];
    }else {
        if (self.awemeType == AwemeLiviPush) {
            return;
        }
//        [self showPauseViewAnim:[_playerView rate]];
//        [_playerView updatePlayerState];
    }
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [self.contentView addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = [UIColor whiteColor];
        [_playerStatusBar setHidden:YES];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
        
        [_bottomControlsBar setHidden:YES];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
        
        [_bottomControlsBar setHidden:NO];
    }
    if (self.awemeType == AwemeLiviPush) {
        _bottomControlsBar.hidden = YES;
    }
    
    
}
- (void)setLeftBtns{
    _funcBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"点赞":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"收藏":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"评论":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"分享":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+100;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        [button setBackgroundImage:kIMG(@"m_sfleftBtns") forState:0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //[button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    CGFloat funcBtnWH = 40.0f;
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:funcBtnWH leadSpacing:MAINSCREEN_HEIGHT/3+50 tailSpacing:MAINSCREEN_HEIGHT/6-20];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.mas_equalTo(funcBtnWH);
    }];
    
    UIButton* fuBtn0 = _funcBtns[0];
    _topBtns = [NSMutableArray array];
    NSArray* subtitleArray2 =@[
    @{@"12330":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"0":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"0":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"0":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray2.count; i++) {
        NSDictionary* dic = subtitleArray2[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+200;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//        [button setBackgroundImage:kIMG(@"m_sfleftBtns") forState:0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //[button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_topBtns addObject:button];
        
    }
    UIButton* toBtn2 = _topBtns[2];
    toBtn2.hidden = YES;
    UIButton* toBtn3 = _topBtns[3];
    toBtn3.hidden = YES;
    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:20 leadSpacing:MAINSCREEN_HEIGHT/3+50+funcBtnWH tailSpacing:MAINSCREEN_HEIGHT/6-20-20];
    
    [_topBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fuBtn0);
        make.width.equalTo(@140);
    }];
}

- (void)updateData:(HomeItem*)aweme{
//    [_favoriteNum setText:[NSString formatCount:aweme.statistics.digg_count]];
//    [_commentNum setText:[NSString formatCount:aweme.statistics.comment_count]];
//    [_shareNum setText:[NSString formatCount:aweme.statistics.share_count]];
//
//    [_collectNum setText:[NSString formatCount:aweme.statistics.share_count]];
}
-(NSMutableArray*)getRandomArrFrome:(NSArray*)arr
{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
//        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
//        }
    }
    return newArr;
}

-(void)getDanmuData{
    UIFont* dfo = [UIFont systemFontOfSize:15];
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
    NSArray *danmakusDicts = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSArray * randomDanmaKu = [self getRandomArrFrome:danmakusDicts];
    
    NSMutableArray* tits = [NSMutableArray array];
    for (int i=0; i<randomDanmaKu.count/5; i++) {
        NSString* tit = @"0";
        NSString* tit2 = @"1";
        NSString* tit3 = @"2";
        NSString* tit4 = @"3";
        NSString* tit5 = @"4";
        
        [tits addObject:tit];
        [tits addObject:tit2];
        [tits addObject:tit3];
        [tits addObject:tit4];
        [tits addObject:tit5];
        
    }
    tits = [self getRandomArrFrome:tits];
    
    NSMutableArray* times = [NSMutableArray array];
    for (int i=0; i<180; i++) {
        NSTimeInterval timeInterval = i;
        NSString* timeStr = [NSString stringWithFormat:@"%0.1f", timeInterval];
        timeInterval = timeStr.floatValue;
        [times addObject:@(timeInterval)];
    }
    NSMutableArray* danmakus = [NSMutableArray array];
//    for (NSDictionary* dict in [self getRandomArrFrome:danmakusDicts]) {
//    for (int i=0; i<tits.count; i++) {
    for (int i=0; i<randomDanmaKu.count; i++) {
        NSDictionary* dict  = randomDanmaKu[i];
        CFDanmaku* danmaku = [[CFDanmaku alloc] init];
//        NSString* str = tits[i];
        [dict setValue:tits[i] forKey:@"m"];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:dict[@"m"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]}];
        //dict[@"m"]
        NSString* emotionName = [NSString stringWithFormat:@"smile_%u", arc4random_uniform(90)];
        UIImage* emotion = [UIImage imageNamed:emotionName];
        if (nil != emotion) {
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = emotion;
            attachment.bounds = CGRectMake(0, -dfo.lineHeight*0.3, dfo.lineHeight*1.5, dfo.lineHeight*1.5);
            NSAttributedString *emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
            [contentStr appendAttributedString:emotionAttr];
        }
        
        danmaku.contentStr = contentStr;
        
        NSString* attributesStr = dict[@"p"];
        NSArray* attarsArray = [attributesStr componentsSeparatedByString:@","];
        danmaku.timePoint = [[attarsArray firstObject] doubleValue] / 1000;
        danmaku.position = [attarsArray[1] integerValue];
//        danmaku.timePoint = [times[i] floatValue];
//        danmaku.position = 1;
        [danmakus addObject:danmaku];
    }
    [_danmakuView prepareDanmakus:danmakus];
}
- (void)setupDanmakuData
{
    _danmakuView = [[CFDanmakuView alloc] initWithFrame:CGRectZero];
    _danmakuView.duration = 10.5;
    _danmakuView.centerDuration = 2.5;
    _danmakuView.lineHeight = 25;
    _danmakuView.lineMargin = 5;
    _danmakuView.maxShowLineCount = 1;
//    _danmakuView.maxCenterLineCount = 0;
//    [self getDanmuData];
    
    _danmakuView.delegate = self;
    [self.contentView addSubview:_danmakuView];
    
    [_danmakuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YBFrameTool.statusBarHeight+10);
//        make.bottom.equalTo(self.container);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    
//    SPDefaultControlView *dv = (SPDefaultControlView *)self.playerView.controlView;
//    [dv.danmakuBtn addTarget:self action:@selector(danmakuShow:) forControlEvents:UIControlEventTouchUpInside];
}
- (UIButton *)introBtn {
    if (!_introBtn) {
        _introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_introBtn setTitle:@"" forState:UIControlStateNormal];
        _introBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_introBtn setTitleColor:kWhiteColor forState:0];
        _introBtn.userInteractionEnabled = NO;
//        [_introBtn addTarget:self action:@selector(danmakuShow:) forControlEvents:UIControlEventTouchUpInside];
//        _introBtn.selected = YES;
        
        _introBtn.backgroundColor = YBGeneralColor.themeColor;
        _introBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        _danmakuBtn.layer.masksToBounds = YES;
//        _danmakuBtn.layer.cornerRadius = 30/2;
    }
    return _introBtn;
}
- (UIButton *)danmakuBtn {
    if (!_danmakuBtn) {
        _danmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danmakuBtn setTitle:@"关闭弹幕" forState:UIControlStateNormal];
        [_danmakuBtn addTarget:self action:@selector(danmakuShow:) forControlEvents:UIControlEventTouchUpInside];
        _danmakuBtn.selected = YES;
    }
    return _danmakuBtn;
}
#pragma mark - 弹幕

static NSTimeInterval danmaku_start_time; // 测试用的，因为demo里的直播时间可能非常大，本地的测试弹幕时间很短

- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    if (self.awemeType == AwemeLiviPush) {
        CGFloat l = self.dmstarTime;
//        if (sender.selected) {
//            l +=  1;
//        }else{
            if (l > 0) {
                l -=  .5;
            }
//        }
        self.dmstarTime = l;
        return self.dmstarTime;
    }
//    if (self.awemeType == AwemeLiviPush) {
//        return 120;
//    }
    return 180;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
//    return self.playerView.st != StatePlaying;
    return NO;
}
- (void)danmakuShow:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_danmakuBtn setTitle:@"关闭弹幕" forState:UIControlStateNormal];
        [_danmakuView start];
        _danmakuView.hidden = NO;
        _desc.hidden = NO;
//        self.dmstarTime = self.playerView.playTotalTime - self.playerView.playCurrentTime;
    } else {
        [_danmakuBtn setTitle:@"打开弹幕" forState:UIControlStateNormal];
        [_danmakuView pause];
        _danmakuView.hidden = YES;
        _desc.hidden = YES;
    }
}
- (void)levPush{
    if (self.block) {
        self.block(self.levBut, self.aweme);
    }
}

// update method
- (void)initData:(HomeItem *)aweme {
    _aweme = aweme;
//    if (self.aweme.ID == 5952||self.aweme.ID == 5949) {
//        self.aweme.limit = 1;
//    }else{
//        self.aweme.limit = 0;
//    }
//    [self initZFData:_aweme];
//    [self.fatherView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_aweme.cover_img]]];
//    if (self.awemeType == AwemeLiviPush) {
//        self.fatherView.userInteractionEnabled = NO;
//    }//imodel
//    [_nickName setText:[NSString stringWithFormat:@"@%@", aweme.name]];
//    [_desc setText:aweme.name];//imodel
    [self.levBut addTarget:self action:@selector(levPush) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.aweme.limit > 0) {
//        self.playerView.controlView.lockBtn.hidden = true;
        [self.levBut setBackgroundColor:YBGeneralColor.themeColor];
        [self.levBut setTitle:[self.aweme getLevLimitTitle] forState:0];
        self.levBut.hidden = NO;
        
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(kContainBottomMargin+36+15);
            make.left.equalTo(self).offset(10);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
        }];
    }else{
//        self.playerView.controlView.lockBtn.hidden = NO;
        [self.levBut setBackgroundColor:kClearColor];
        [self.levBut setTitle:@"" forState:0];
        self.levBut.hidden = YES;
        
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(kContainBottomMargin);
            make.left.equalTo(self).offset(10);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
        }];
    }
    [self updateData:_aweme];
    //    [self alterButton:_aweme];//imodel
        for (UIButton* btn in self.funcBtns) {
            btn.hidden = YES;
        }
        for (UIButton* btn in self.topBtns) {
            btn.hidden = YES;
        }
    
    if (self.awemeType == AwemeLiviPush) {
        for (UIButton* btn in self.funcBtns) {
            btn.hidden = YES;
        }
        for (UIButton* btn in self.topBtns) {
            btn.hidden = YES;
        }
        _desc.backgroundColor = HEXCOLOR(0x4A4A4A);
        _desc.text = @"\n";
        _desc.font = [UIFont systemFontOfSize:13];
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(kContainBottomMargin+36+15);
            make.left.equalTo(self).offset(10);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
        }];
        _desc.layer.masksToBounds = YES;
        _desc.layer.cornerRadius = 8;
        _bottomControlsBar.hidden = YES;
        
        _danmakuBtn.hidden = NO;
//        [self setupDanmakuData];
        _danmakuView.hidden = NO;
        NSArray* dmtarr = @[@(180),@(170),@(160),@(150)];
        int r = arc4random() % [dmtarr count];
        
        NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
        NSArray *danmakusDicts = [NSArray arrayWithContentsOfFile:danmakufile];
        
        NSArray * randomDanmaKu = [self getRandomArrFrome:danmakusDicts];
        
        //randomDanmaKu.count;//[dmtarr[r] floatValue];
        [self getDanmuData];
        
        self.dmstarTime = 250;
//        self.playerView.playTotalTime - self.playerView.playCurrentTime;
        [_danmakuView start];
        if (_danmakuBtn.selected) {
            _danmakuView.hidden = NO;
        }else{
            _danmakuView.hidden = YES;
        }
        if (self.aweme.style == 0) {
            [self.levBut setBackgroundColor:YBGeneralColor.themeColor];
            [self.levBut setTitle:@"完整" forState:0];
            self.levBut.hidden = NO;
            [self.levBut mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(YBFrameTool.statusBarHeight+ 8);
                make.right.mas_equalTo(-8);
                make.height.mas_equalTo(36);
                make.width.mas_equalTo(180);
            }];
            
            
            _timeBtn.hidden = NO;
            
//            [self countFunc];
            _timeBtn.hidden = YES;
            _levBut.hidden = YES;
        }else{
            [self.levBut setBackgroundColor:kClearColor];
            [self.levBut setTitle:@"" forState:0];
            self.levBut.hidden = YES;
            
            _timeBtn.hidden = YES;
        }
        
        self.introBtn.hidden = NO;
        [self.introBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",self.aweme.name.length>8?[self.aweme.name substringToIndex:8]:self.aweme.] stringColor:HEXCOLOR(0xffffff) stringFont:kFontSize(13) subString:[NSString stringWithFormat:@"%@",self.aweme.name] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentCenter] forState:0];//intro
    }
//    [_nickName setText:[NSString stringWithFormat:@"@%@", aweme.author.nickname]];
//    [_desc setText:aweme.desc];
//    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", aweme.music.title, aweme.music.author]];
//
//    [self updateData:_aweme];
//
//    __weak __typeof(self) wself = self;
//    [_musicAlum.album sd_setImageWithURL:[NSURL URLWithString:aweme.music.cover_thumb.url_list.firstObject] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if(!error) {
//            wself.musicAlum.album.image = [image drawCircleImage];
//        }
//    }];
//    [_avatar sd_setImageWithURL:[NSURL URLWithString:aweme.author.avatar_thumb.url_list.firstObject] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if(!error) {
//            wself.avatar.image = [image drawCircleImage];
//        }
//    }];
}
- (void)setUpCountBtn{
    _timeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_timeBtn];
    _timeBtn.hidden = YES;
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YBFrameTool.statusBarHeight+ 8+36+10);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(180);
    }];
}
- (void)countFunc{
    
//    _countDownCode.frame = CGRectMake(81, 200, 108, 32);
//    [_countDownCode setTitle:@"开始" forState:UIControlStateNormal];
    self.timeCount = 6  - round(CFAbsoluteTimeGetCurrent()-_start);
    [_timeBtn setTitle:[NSString stringWithFormat:@"时间 %ld秒",(long)self.timeCount] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _timeBtn.backgroundColor = [UIColor clearColor];
    

//     [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
    _timeBtn.enabled = NO;

        [_timeBtn startCountDownWithSecond:self.timeCount];

        [_timeBtn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"时间 %zd秒",second];
            
            return title;
        }];
        [_timeBtn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            
            
            [self playerEndShowPopUpView];
//            countDownButton.enabled = YES;
            return @"剩余时间 0秒";//点击重新获取
        }];

//    }];
}
- (void)alterButton:(HomeItem*)model{
    
   [self.contentView layoutIfNeeded];
   self.likes = model.likes;
    self.comments = model.comments;
   NSArray* subtitleArray =@[
    @{[NSString stringWithFormat:@"%ld",(long)model.likes]:[[NSNumber numberWithInteger:model.is_love]boolValue]? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"]},
    @{[NSString stringWithFormat:@"%ld",(long)model.comments]:[UIImage imageNamed:@"detail_comment"]},
    @{@"收藏":[[NSNumber numberWithInteger:model.is_collect]boolValue]? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] },
     
    @{@"分享":[UIImage imageNamed:@"detail_share"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton* button = _topBtns[i];
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
//        button.tag = model.ID;
    }
    
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton* button = _funcBtns[i];
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
//        button.tag = model.ID;
    }
    
    UIButton* btn0 = _funcBtns[0];
    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
    [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn1 = _funcBtns[1];
    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _funcBtns[2];
    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
    [btn2 addTarget:self action:@selector(delayCollectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn3 = _funcBtns[3];
    [btn3 addTarget:self action:@selector(pushShareVCClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView jp_playVideoMuteWithURL:[NSURL URLWithString:_aweme.url] bufferingIndicator:nil progressView:nil configuration:nil];
    
}

- (void)pushCRClick:(UIButton*)sender{
    self.aweme.style = 1;
    [[ZMCusCommentManager shareManager] showCommentWithSourceId:self.aweme  success:^(id data) {
        NSInteger fID = self.aweme.ID;
        
        NSInteger l = self.comments;
        l +=  1;
        self.comments = l;
        UIButton* toBtn1 = self.topBtns[1];
        [toBtn1 setTitle:[NSString stringWithFormat:@"%ld",(long)self.comments] forState:0];
        self.aweme.comments = self.comments;
        if (self.block) {
            self.block(sender,self.aweme);
        }
        return;
//    if (self.block) {
//        self.block(@(sender.tag));
//    }
}

- (void)pushShareVCClick:(UIButton*)sender{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    [superController.navigationController  showViewController:[ShareVC new] sender:nil];
}
- (void)likeClick:(UIButton*)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayLikeClick:) object:sender];
    [self performSelector:@selector(delayLikeClick:) withObject:sender afterDelay:1];
}

- (void)delayLikeClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, (sender.bounds.size.height-25)/2,  25, 25) withAnimationNamed:sender.isSelected ?@"likeAni":@"likeAni"];
    __weak SplashView *weakSplashView = splashView;
    [splashView showOnView:sender withAnimationCompleter:^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSplashView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSplashView removeFromSuperview];
            [self likeEvent:sender];
        }];
    }];
    
    
}
- (void)likeEvent:(UIButton*)sender{
    
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"] forState:UIControlStateNormal];
    NSInteger l = self.likes;
    if (sender.selected) {
        l +=  1;
    }else{
        if (l > 0) {
            l -=  1;
        }
    }
    self.likes = l;
    UIButton* toBtn0 = _topBtns[0];
    [toBtn0 setTitle:[NSString stringWithFormat:@"%ld",(long)self.likes] forState:0];
//    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.likes] forState:UIControlStateNormal];
    
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType51] andType:All andWith:@{@"like":str,@"id":@(self.aweme.ID)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.aweme.is_love =sender.selected ? 1 :0;
                self.aweme.likes = self.likes;
                if (self.block) {
                    self.block(sender,self.aweme);
                }
            }
            else{
               
            }
        } error:^(NSError *error) {
            
        }];
}
- (void)collectClick:(UIButton*)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCollectClick:) object:sender];
    [self performSelector:@selector(delayCollectClick:) withObject:sender afterDelay:1];
   
}

- (void)delayCollectClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, (sender.bounds.size.height-25)/2,  25, 25) withAnimationNamed:sender.isSelected ?@"colAni":@"colAni"];
    __weak SplashView *weakSplashView = splashView;
    [splashView showOnView:sender withAnimationCompleter:^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSplashView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSplashView removeFromSuperview];
            [self collectEvent:sender];
        }];
    }];
}
- (void)collectEvent:(UIButton*)sender{
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType52] andType:All andWith:@{@"collect":str,@"id":@(self.aweme.ID)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.aweme.is_collect =sender.selected ? 1 :0;
                if (self.block) {
                    self.block(sender,self.aweme);
                }
            }
            else{
                if (bdic&&
                    [bdic.allKeys containsObject:@"msg"]) {
                    NSString* str = [NSString stringWithFormat:@"%@",bdic[@"msg"]];
                    [YKToastView showToastText:str];
                }
                [sender setImage:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
            }
        } error:^(NSError *error) {
            
        }];
}
- (void)play {
    if (self.awemeType == AwemeLiviPush) {
//        [_playerView startPlayOneTime:[self.aweme.start_second floatValue]];
//        _playerModel.seekTime = [self.aweme.start_second floatValue];
    }else{
//        _playerModel.seekTime = 0.0;
    }
//    [_playerView seekToTime:_playerModel.seekTime completionHandler:nil];
//    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
//    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    if (self.awemeType == AwemeLiviPush) {
        [self pause];
        [_pauseIcon setHidden:YES];
        return;
    }
//    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    NSString *playUrl = [NSString stringWithFormat:@"%@",self.awemeType==AwemeLiviPush?_aweme.hls_url: _aweme.url];
    //https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200f180000bcv3d0o9lr7ddj9npmcg&line=0&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0
    
//    NSString *playUrl = [YTSharednetManager isWifiStatus] ? _aweme.video.play_addr.url_list.firstObject : _aweme.video.play_addr_lowbr.url_list.firstObject;
//    [_playerView setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = [NSString stringWithFormat:@"%@",self.awemeType==AwemeLiviPush?_aweme.hls_url:_aweme.url];
//    NSString *playUrl = [YTSharednetManager isWifiStatus] ? _aweme.video.play_addr.url_list.firstObject : _aweme.video.play_addr_lowbr.url_list.firstObject;
//    [_playerView startDownloadTask:[NSURL URLWithString:playUrl] isBackground:NO];
}

/** 底部控制栏 */
- (UIView *)bottomControlsBar
{
    if (!_bottomControlsBar) {
        _bottomControlsBar = [[UIView alloc]init];
        _bottomControlsBar.userInteractionEnabled = YES;
    }
    return _bottomControlsBar;
}
/** 当前播放时间 */
- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc]init];
        _playTimeLabel.font = [UIFont systemFontOfSize:14];
        _playTimeLabel.text = @"00:00";
        _playTimeLabel.adjustsFontSizeToFitWidth = YES;
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor whiteColor];
    }
    return _playTimeLabel;
}

/** 视频总时间 */
- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}
/** 播放进度条 */
- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]init];
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _progress;
}

/** 滑杆 */
- (SelVideoSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[SelVideoSlider alloc]init];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        _videoSlider.tintColor = YBGeneralColor.themeColor;
        //开始拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        //拖动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //结束拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}

#pragma mark - 滑杆
/** 开始拖动事件 */
- (void)progressSliderTouchBegan:(SelVideoSlider *)slider{
//    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchBegan:)]) {
//        [_delegate videoSliderTouchBegan:slider];
//    }
    
//    [self.playerView videoSliderTouchBegan:slider];
}
/** 拖动中事件 */
- (void)progressSliderValueChanged:(SelVideoSlider *)slider{
//    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderValueChanged:)]) {
//        [_delegate videoSliderValueChanged:slider];
//    }
    NSArray* arr = @[@(120),@(20)];
//    [self.playerView videoSliderValueChanged:slider];
    [self _setPlaybackControlsWithPlayTime:[arr.firstObject integerValue] totalTime:[arr.lastObject integerValue] sliderValue:slider.value];
}
/** 结束拖动事件 */
- (void)progressSliderTouchEnded:(SelVideoSlider *)slider{
//    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchEnded:)]) {
//        [_delegate videoSliderTouchEnded:slider];
//    }
//    if (slider.value != 1) {
//        self.playDidEnd = NO;
//    }
//    [self.playerView videoSliderTouchEnded:slider];
}
/**
 设置视频时间显示以及滑杆状态
 @param playTime 当前播放时间
 @param totalTime 视频总时间
 @param sliderValue 滑杆滑动值
 */
- (void)_setPlaybackControlsWithPlayTime:(NSInteger)playTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue
{
    //当前时长进度progress
    NSInteger proMin = playTime / 60;//当前秒
    NSInteger proSec = playTime % 60;//当前分钟
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    //更新当前播放时间
    self.videoSlider.value = sliderValue;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    //更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}
// AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
    [self _setPlaybackControlsWithPlayTime:current  totalTime:total sliderValue:current/total];
    if (current/total > 0.99) {
        [self replay];
//        self.playDidEnd = NO;
    }
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
//            [_musicAlum startAnimation:_aweme.rate];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
//            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}
@end
