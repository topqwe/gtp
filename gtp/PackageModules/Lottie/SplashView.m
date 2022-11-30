//
//  SplashView.m
//  LottieExample
//
//  Created by York on 2017/8/12.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "SplashView.h"

@interface SplashView()

@property (nonatomic,strong) LOTAnimationView *animationView;


@property (nonatomic,strong) LOTAnimationView *editButton;
@property (nonatomic,assign) BOOL isEditing;
@end

@implementation SplashView
- (instancetype)initWithFrame:(CGRect)frame withAnimationNamed:(NSString*)animationNamed{
    self = [super initWithFrame:frame];
//
    self.animationView = [LOTAnimationView animationNamed:animationNamed];
    self.animationView.contentMode = UIViewContentModeScaleAspectFill;
    self.animationView.frame = self.bounds;
    [self addSubview:self.animationView];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.animationView = [LOTAnimationView animationNamed:@"LottieLogo"];
    self.animationView.contentMode = UIViewContentModeScaleAspectFill;
    self.animationView.frame = self.bounds;
    [self addSubview:self.animationView];

    return self;
}

- (void)showOnView:(UIView *)containerView withAnimationCompleter:(void(^)(void))completer {
    if (!containerView) {
        return;
    }

    [containerView addSubview:self];
    [self.animationView playWithCompletion:^(BOOL animationFinished) {
        if (completer) {
            completer();
        }
    }];
}

- (void)aeEditButton{
    self.editButton = [LOTAnimationView animationNamed:@"Edit"];
    self.editButton.contentMode = UIViewContentModeScaleAspectFit;
    //editButton的width和height从AE文件中获得
    self.editButton.frame = CGRectMake(150, 100, 62/2, 62/2);//124
    UITapGestureRecognizer *editButtonTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editButtonClicked)];
    [self.editButton addGestureRecognizer:editButtonTapGR];
    [self addSubview:self.editButton];
    [self.editButton setProgressWithFrame:@(54)];
}


- (void)editButtonClicked {
    if (self.isEditing) {
        //Lottie总是从上一次位置开始播放动画，
        //上一次位置停留的帧可能不是startFrmae，在播放前，需要设置其停留到startFrmae
        [self.editButton setProgressWithFrame:@(166)];
        [self.editButton playFromFrame:@(166) toFrame:@(218) withCompletion:nil];

        NSLog(@"结束编辑...");
    } else {
        [self.editButton setProgressWithFrame:@(54)];
        [self.editButton playFromFrame:@(54) toFrame:@(105) withCompletion:nil];

        NSLog(@"开始编辑...");
    }

    self.isEditing = !self.isEditing;
}

@end
