//
//  PhotoView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "PhotoView.h"
#import "CircleProgressView.h"

@implementation PhotoView

- (instancetype)initWithUrl:(NSString *)urlPath {
    self = [super init];
    if (self) {
        self.frame = MAINSCREENFRAME;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:MAINSCREENFRAME];
        _container.backgroundColor = [UIColor blackColor];
        self.container.alpha = 0.0f;
        [self addSubview:_container];
        
        
        _imageView = [[UIImageView alloc] initWithFrame:MAINSCREENFRAME];
        __weak typeof(self) wself = self;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSString *percentStr = [NSString stringWithFormat:@"%.1fw",(CGFloat)receivedSize/(CGFloat)expectedSize];
            CGFloat percent = [percentStr floatValue];
            [wself.progressView setProgress:percent];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(!error) {
                [wself.imageView setImage:image];
                [wself.progressView setHidden:YES];
            }else {
                [wself.progressView setTipHidden:NO];
            }
        }];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _progressView = [CircleProgressView new];
        _progressView.center = self.center;
        [_imageView addSubview:_progressView];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image urlPath:(NSString *)urlPath {
    self = [super init];
    if (self) {
        self.frame = MAINSCREENFRAME;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:MAINSCREENFRAME];
        _container.backgroundColor = [UIColor blackColor];
        self.container.alpha = 0.0f;
        [self addSubview:_container];
        
        _imageView = [[UIImageView alloc] initWithFrame:MAINSCREENFRAME];
        _imageView.image = image;
        __weak typeof(self) wself = self;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSString *percentStr = [NSString stringWithFormat:@"%.1fw",(CGFloat)receivedSize/(CGFloat)expectedSize];
            CGFloat percent = [percentStr floatValue];
            [wself.progressView setProgress:percent];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(!error) {
                [wself.imageView setImage:image];
                [wself.progressView setHidden:YES];
            }else {
                [wself.progressView setTipHidden:NO];
            }
        }];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _progressView = [CircleProgressView new];
        _progressView.center = self.center;
        [_imageView addSubview:_progressView];
        [_progressView setHidden:YES];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.frame = MAINSCREENFRAME;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:MAINSCREENFRAME];
        _container.backgroundColor = [UIColor blackColor];
        self.container.alpha = 0.0f;
        [self addSubview:_container];
        
        _imageView = [[UIImageView alloc] initWithFrame:MAINSCREENFRAME];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.alpha = 0.0f;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.windowLevel = UIWindowLevelStatusBar;
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.imageView.alpha = 1.0f;
                         self.container.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.windowLevel = UIWindowLevelNormal;
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.imageView.alpha = 0.0f;
                         self.container.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
