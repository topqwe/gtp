//
//  STBrowserCollectionViewCell.m
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//
//**********************说明：这个cell手势冲突，在放大的时候会出现，后续移除平移手势，缩放手势可以实现点的平移***************************
#import "STBrowserCollectionViewCell.h"
#import "UIView+STPhotoKitTool.h"
@interface STBrowserCollectionViewCell()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic)CGFloat             lastScale;
@property(nonatomic)CGFloat             Scale;
@property(nonatomic)CGFloat             lastRotation;
@property(nonatomic)CGFloat             firstY;
@property(nonatomic)CGFloat             firstX;
@property(nonatomic)CGAffineTransform   origin;


@end
@implementation STBrowserCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
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

- (void)setModel:(STPhotoModel *)model
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
        _panGes.delegate = self;
        _panGes.enabled = YES;
        _panGes.minimumNumberOfTouches = 2;//捏合2指 移动有效
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

        //NSLog(@"%@",NSStringFromCGRect(self.imageView.frame));
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [self.imageView addGestureRecognizer:pinchRecognizer];
        
        if (model.thumbImage) {
            self.imageView.image = model.thumbImage;
            
        }
        else{
            [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                model.thumbImage = result;
                self.imageView.image = model.thumbImage;

            }];
        }

        
     
    }
}
#pragma mark --<#say#>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.view == self.imageView) {
        return YES;
    }
    
    return NO;
    
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    return YES;
}
#pragma mark --Action Method
- (void)scale:(UIPinchGestureRecognizer*)sender {
    
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
    
    CGFloat witdh = self.imageView.size.width-ABS(self.imageView.frame.origin.x);
    CGFloat height = self.imageView.size.height-ABS(self.imageView.frame.origin.y);
    _scrollView.contentSize = CGSizeMake(witdh, height);
   // _scrollView.contentInset = UIEdgeInsetsMake(height/2, witdh/2, 0, 0);

    
    if (sender.state == UIGestureRecognizerStateBegan) {
       // NSLog(@"缩放手势开始  ");
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureRecognizerisRuning:)]) {
            [self.delegate gestureRecognizerisRuning:sender];
        }
        
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
       // NSLog(@"缩放手势结束  ssssssss");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
       // NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
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
        //NSLog(@"旋转手势开始");
    }
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"旋转手势结束");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
        //NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
        if (pinch&&ronate&&pingtyi) {
            [self.delegate gestureRecognizerdidEnd:self.pinchRecognizer];
        }
    }
}
- (void)panGesture:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                     sender.view.center.y + translation.y);
    if (self.delegate && [self.delegate respondsToSelector:@selector(panRecognizerPoint:)]) {
        [self.delegate panRecognizerPoint:[sender locationInView:self.window]];
    }
    [sender setTranslation:CGPointZero inView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
       // NSLog(@"平移手势结束  ssssssss");
        BOOL pinch = (self.pinchRecognizer.state == UIGestureRecognizerStatePossible || self.pinchRecognizer.state == UIGestureRecognizerStateEnded|| self.pinchRecognizer.state == UIGestureRecognizerStateFailed);
        BOOL ronate = (self.rotationGestureRecognizer.state == UIGestureRecognizerStateFailed || self.rotationGestureRecognizer.state == UIGestureRecognizerStateEnded|| self.rotationGestureRecognizer.state == UIGestureRecognizerStatePossible);
        BOOL pingtyi = (self.panGes.state == UIGestureRecognizerStateFailed || self.panGes.state == UIGestureRecognizerStateEnded|| self.panGes.state == UIGestureRecognizerStatePossible);
       // NSLog(@"平移%ld旋转%ld缩放%ld",self.panGes.state,self.rotationGestureRecognizer.state,(long)self.pinchRecognizer.state);
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
- (void)backToOrigin
{
    self.imageView.transform = _origin;
   // _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
}
- (void)backToVertical
{
    

}
@end
