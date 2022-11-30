//
//  AwemeListCell.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareVC.h"
#import "ZMCusCommentView.h"
#import "CFDanmakuView.h"
#import "PreviewPopUpView.h"
#import "JKCountDownButton.h"
/// 播放器view的tag，列表中UI控件唯一tag值
#define kPlayerViewTag 80000
typedef void (^OnPlayerReady)(void);

@class Aweme;
@class AVPlayerView;
@class HoverTextView;
@class CircleTextView;
@class FocusView;
@class MusicAlbumView;
@class FavoriteView;

@interface AwemeListCell : UITableViewCell<CFDanmakuDelegate>
@property (nonatomic, strong)JKCountDownButton * timeBtn;
@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间
@property (nonatomic, assign) NSInteger timeCount;
//@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong)PreviewPopUpView* prepopupView;
- (void)actionBlock:(TwoDataBlock)block;
@property (nonatomic, assign) CGFloat dmstarTime;
@property CFDanmakuView *danmakuView;
@property(nonatomic, strong) UIButton *danmakuBtn;

@property (nonatomic, strong) UIButton *levBut;
@property(nonatomic, strong) UIButton *introBtn;

@property (nonatomic, strong) HomeItem            *aweme;
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, assign) NSInteger likes;
//@property(nonatomic, strong) ZFPlayerView                     *playerView;/**< <##> */
//@property(nonatomic, strong) ZFPlayerModel                     *playerModel;/**< <##> */
//@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, strong) HoverTextView    *hoverTextView;

@property (nonatomic, strong) CircleTextView   *musicName;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;

@property (nonatomic, strong) UIImageView      *avatar;
@property (nonatomic, strong) FocusView        *focus;
@property (nonatomic, strong) MusicAlbumView   *musicAlum;
@property (nonatomic, strong) UIImageView      *collect;
@property (nonatomic, strong) UILabel          *collectNum;
@property (nonatomic, strong) UIImageView      *invite;
@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;

@property (nonatomic, strong) FavoriteView     *favorite;

@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;

@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

- (void)initData:(HomeItem *)aweme;
- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;
@property (strong, nonatomic) UIImageView *videoPlayView;
@property(nonatomic, assign)AwemeType awemeType;
@end
