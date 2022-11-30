//
//  PlayerViewController.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/11/29.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJPlayerVC.h"
#import "SJVideoPlayer.h"
#import "SJUIFactory.h"
#import "SJSharedVideoPlayerHelper.h"

@interface SJPlayerVC ()<SJSharedVideoPlayerHelperUseProtocol>

@property (nonatomic, strong, readonly) UIView *playerBackgroundView;
@property (nonatomic, strong, readonly) UIButton *nextVCBtn;
@property (nonatomic, strong, readonly) UIButton *otherVideoBtn;
@property (nonatomic, strong) SJVideoPlayerURLAsset *asset; // 由于这个`VC`使用的是播放器单例, 所以需要记录`asset`, 以便再次进入该控制器时, 继续播放该资源.
//@property (nonatomic, strong) HomeItem* item;
@end

@implementation SJPlayerVC

@synthesize playerBackgroundView = _playerBackgroundView;
@synthesize otherVideoBtn = _otherVideoBtn;

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    SJPlayerVC *vc = [[SJPlayerVC alloc] init];
    //    vc.block = block;
//    vc.item = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _playerVCAccessNetwork];
    [self _playerVCSetupViews];
//
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    
    [SJSharedVideoPlayerHelper sharedHelper].vc_deallocExeBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [SJSharedVideoPlayerHelper sharedHelper].vc_viewWillAppearExeBlock(self, self.asset);   // 这些代码都是固定的, 所以就抽成了一个block, 传入必要参数即可.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [SJSharedVideoPlayerHelper sharedHelper].vc_viewWillDisappearExeBlock();                // 这些代码都是固定的, 所以就抽成了一个block, 传入必要参数即可.
}

- (BOOL)prefersStatusBarHidden {
    return [SJSharedVideoPlayerHelper sharedHelper].vc_prefersStatusBarHiddenExeBlock();    // 这些代码都是固定的, 所以就抽成了一个block, 传入必要参数即可.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [SJSharedVideoPlayerHelper sharedHelper].vc_preferredStatusBarStyleExeBlock();   // 这些代码都是固定的, 所以就抽成了一个block, 传入必要参数即可.
}


#pragma mark - 网路请求

- (void)_playerVCAccessNetwork {
    self.asset = /* 记录资源, 以便返回该界面时, 继续播放他 */
    [[SJVideoPlayerURLAsset alloc] initWithTitle:[NSString stringWithFormat:@"%@",@""]
                                 alwaysShowTitle:YES
                                        assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://.m3u8"]]];
    [SJVideoPlayer sharedPlayer].URLAsset = self.asset;
}


#pragma mark - UI布局

- (void)_playerVCSetupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.playerBackgroundView];
    [_playerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset([YBFrameTool statusBarHeight]);//34 : 20
        make.leading.trailing.offset(0);
        make.height.equalTo(_playerBackgroundView.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    
    
    [self.view addSubview:self.otherVideoBtn];
    [_otherVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}

- (UIView *)playerBackgroundView {
    if ( _playerBackgroundView ) return _playerBackgroundView;
    _playerBackgroundView = [SJUIViewFactory viewWithBackgroundColor:[UIColor blackColor]];
    return _playerBackgroundView;
}

- (UIButton *)otherVideoBtn {
    if ( _otherVideoBtn ) return _otherVideoBtn;
    _otherVideoBtn = [SJUIButtonFactory buttonWithTitle:@"Other"
                                             titleColor:[UIColor blueColor]
                                                   font:[UIFont boldSystemFontOfSize:17]
                                                 target:self sel:@selector(playOtherVideo)];
    return _otherVideoBtn;
}

- (void)playOtherVideo {
    
    self.asset = /* 记录资源, 以便返回该界面时, 继续播放他 */
    [[SJVideoPlayerURLAsset alloc] initWithTitle:[NSString stringWithFormat:@"%@",@""]
                                 alwaysShowTitle:YES
                                        assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://.m3u8"]]];
    [SJVideoPlayer sharedPlayer].URLAsset = self.asset;
}
@end
