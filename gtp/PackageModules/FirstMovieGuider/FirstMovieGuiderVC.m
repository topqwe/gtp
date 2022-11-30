//
//  WSMovieController.m
//  StartMovie
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "FirstMovieGuiderVC.h"

@interface FirstMovieGuiderVC ()

@property (nonatomic, copy) ActionBlock block;

@property (nonatomic, strong) SelVideoPlayer *player;
@end

@implementation FirstMovieGuiderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupBgVideoPlayer];
    [self setupLoginView];
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)setupBgVideoPlayer
{
    
    
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
//    configuration.supportedDoubleTap = YES;
//    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.assetSource =
    [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"qidong" ofType:@"mp4"]];
    
    configuration.videoGravity = SelVideoGravityResizeAspect;
    
    _player = [[SelVideoPlayer alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
    [self.view addSubview:_player];
    
}

- (void)setupLoginView
{
    //进入按钮
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    enterMainButton.alpha = 0;
    [self.view addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIView animateWithDuration:3.0 animations:^{
        enterMainButton.alpha = 1.0;
    }];
}


- (void)enterMainAction:(UIButton *)btn {
    
    if (self.block) {
        self.block(btn);
    }
}


@end
