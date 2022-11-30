//
//  TTVideoPlayViewController.m
//  togetherPlay
//
//  Created by Mac on 2018/12/21.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import "TTVideoPlayViewController.h"

@interface TTVideoPlayViewController ()<ZFPlayerDelegate>
@property(nonatomic, strong) ZFPlayerView                     *playerView;/**< <##> */
@property(nonatomic, strong) ZFPlayerModel                     *playerModel;/**< <##> */
@property(nonatomic, strong) UIView                     *fatherView;/**< <##> */
@end

@implementation TTVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self vhl_setNavBarBackgroundAlpha:0];
    [self configSubView];
    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{
    self.view.backgroundColor = UIColor.blackColor;
    self.tableView.backgroundColor = UIColor.blackColor;
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    // 初始化
    self.fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, TMUtils.tabBarTop+49)];
    self.fatherView.backgroundColor = UIColor.blackColor                                                                                                                                                                               ;
    [header addSubview:self.fatherView];
    _playerView = ZFPlayerView.alloc.init;
    _playerView.contentMode = UIViewContentModeScaleAspectFit ;
    _playerView.delegate = self;
    // 当cell播放视频由全屏变为小屏时候，不回到中间位置
    _playerView.cellPlayerOnCenter = NO;
    _playerView.forcePortrait = YES;
    // 初始化播放数据
    _playerModel = [[ZFPlayerModel alloc] init];
    _playerModel.fatherView = self.fatherView;
    _playerModel.placeholderImageURLString = self.img_url;
    _playerModel.videoURL = [NSURL URLWithString:self.url];
    
    [self.playerView playerModel:_playerModel];
    [_playerView autoPlayTheVideo];
    [self.view addSubview:header];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.playerView.controlView.backBtn.hidden = YES;
}

@end
