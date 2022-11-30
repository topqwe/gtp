//
//  STCollectionViewCell.m
//  STTools
//
//  Created by stoneobs on 16/10/13.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STUrlBrowserCollectionViewCell.h"
#import "UIView+STPhotoKitTool.h"
#import <SDWebImage/SDImageCache.h>
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)
@interface STUrlBrowserCollectionViewCell()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic)CGFloat                 lastScale;

@property(nonatomic)CGFloat                 Scale;

@property(nonatomic)CGFloat                 lastRotation;

@property(nonatomic)CGFloat                 firstY;

@property(nonatomic)CGFloat                 firstX;

@property(nonatomic)CGAffineTransform       origin;


@end
@implementation STUrlBrowserCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.imageView.center = [UIApplication sharedApplication].keyWindow.center;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.transform = CGAffineTransformIdentity;
        _origin = self.imageView.transform ;
        [_scrollView addSubview:self.imageView];
        [self addSubview:_scrollView];
        
        
    }
    return self;
}

-(void)setModel:(STUrlPhotoModel *)model
{
    
    if (model) {
        _model = model;
        //缩放
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    
        _pinchRecognizer.delegate = self;
        
        [self.imageView addGestureRecognizer:_pinchRecognizer];
        //旋转
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        
        _rotationGestureRecognizer.delegate = self;
        
        [self.imageView  addGestureRecognizer:_rotationGestureRecognizer];
        //平移
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        //  [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:_panGes];
        _panGes.delegate = self;
        
        _panGes.enabled = YES;
        
        _panGes.minimumNumberOfTouches = 2;
        
        [self.imageView addGestureRecognizer:_panGes];
        //点击
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _tapGes.delegate = self;
        _tapGes.enabled = YES;
        [self.imageView addGestureRecognizer:_tapGes];
    
        if (model.originImage) {
            self.imageView.image = model.originImage;
            return;
        }
        if (model.thumbImage) {
            self.imageView.image = model.thumbImage;
            return;
        }
        if (model.thumbImageUrl) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbImageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"--------下载-%ld------总%ld",receivedSize,expectedSize);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                model.thumbImage = image;
                if (self.finshBlock) {
                    self.finshBlock(image);
                }
                //[_act removeFromSuperview];
            }];
            return;
        }
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbImageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"--------下载-%ld------总%ld",receivedSize,expectedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            model.originImage = image;
            if (self.finshBlock) {
                self.finshBlock(image);
            }
            
        }];
        
        
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.view == self.imageView) {
        return YES;
    }
    
    return NO;
    
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    return YES;
}
-(void)scale:(UIPinchGestureRecognizer*)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = _imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [_imageView setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinchRecognizerdisScale:)]) {
        
        [self.delegate pinchRecognizerdisScale:_lastScale];
    }
    
    
    _scrollView.contentSize = CGSizeMake(self.imageView.size.width-ABS(self.imageView.frame.origin.x), self.imageView.size.height-ABS(self.imageView.frame.origin.y));
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"缩放手势开始  ");
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureRecognizerisRuning:)]) {
            [self.delegate gestureRecognizerisRuning:sender];
        }
        
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"缩放手势结束  ssssssss");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
        NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
        if (pinch&&ronate&&pingtyi) {
            [self.delegate gestureRecognizerdidEnd:self.pinchRecognizer];
        }
    }
}
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged ) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"旋转手势开始");
    }
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"旋转手势结束");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
        NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
        if (pinch&&ronate&&pingtyi) {
            [self.delegate gestureRecognizerdidEnd:self.pinchRecognizer];
        }
    }
}
-(void)panGesture:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                     sender.view.center.y + translation.y);
    if (self.delegate && [self.delegate respondsToSelector:@selector(panRecognizerPoint:)]) {
        [self.delegate panRecognizerPoint:[sender locationInView:self.window]];
    }
    [sender setTranslation:CGPointZero inView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"平移手势结束  ssssssss");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
        NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
        if (pinch&&ronate&&pingtyi) {
            [self.delegate gestureRecognizerdidEnd:self.pinchRecognizer];
        }
        
        
    }
    
}
- (void)tapGesture:(UITapGestureRecognizer*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClicTheImageView)]) {
        [self.delegate didClicTheImageView];
    }
}
//将要remove 的时候将所有还原
-(void)backToOrigin
{
    self.imageView.transform = _origin;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

@end
