//
//  AwemeLVC.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "BaseVC.h"
#import "MineVM.h"
#import "PreviewPopUpView.h"
#import "JKCountDownButton.h"

#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFPlayerConst.h>
#import "ZFCustomControlView.h"
#define kPalyEndLimSecs 13.0
#define kLivTotalSecs 120
#define kLivOutSecs @"kLivOutSecs"
#define kLivOutTime @"kLivOutTime"
#define kIsLivOutTime @"kIsLivOutTime"

@class Aweme;
@interface AwemeLVC : BaseVC
@property (nonatomic, strong)PreviewPopUpView* prepopupView;
@property (nonatomic, strong) ZFPlayerController *player;
//@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFCustomControlView *fullControlView;

@property (nonatomic, strong) NSTimer *eveyTimer;
@property (nonatomic, strong) UIButton *levBut;
//@property (nonatomic, strong)JKCountDownButton * timeBtn;
@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong)PreviewPopUpView* popupView; //刷新数据时的时间

@property (nonatomic, strong) HomeModel* myModel;
@property(nonatomic, weak) ZFPlayerView                     *lastplayerView;/**< <##> */
- (void)actionBlock:(TwoDataBlock)block;
@property (nonatomic, strong) UIButton              *backBtn;
@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, assign) NSInteger                         currentIndex;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, strong) HomeItem            *selectedData;
- (void)levPush;
-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid;
- (void)requestHomeListWithPage:(NSInteger)page WithCid:(NSString*)cid;
- (void)applicationBecomeActive;
@end
