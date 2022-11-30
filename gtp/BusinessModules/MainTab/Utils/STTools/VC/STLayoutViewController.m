//
//  ETSideViewController.m
//  EasyTool
//
//  Created by supertext on 14-10-15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import "STLayoutViewController.h"
#import "STNavigationController.h"
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)

@interface STLayoutViewController ()
@property (nonatomic,weak)              UIView                  *rootView ;
@property (nonatomic,strong)            UIControl               *coverView ;
@property (nonatomic,weak)              UIView                  *animationView ;
@property (nonatomic,strong,readwrite)  UIViewController        *rootViewController ;
@property (nonatomic,strong,readwrite)  UIPanGestureRecognizer  *panGestureRecognizer;
@property (nonatomic)                   CGPoint                 startPanPoint;
@property (nonatomic)                   BOOL                    movingRightOrLeft;
@property (nonatomic,readwrite)         STLayoutViewStatus      status;
@end

@implementation STLayoutViewController
#pragma mark --- initlize
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}
+(STLayoutViewController*)defaultLayout
{
    static STLayoutViewController * defaultLayout;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLayout=[[STLayoutViewController alloc]initWithRootViewController:[[STNavigationController alloc] initWithRootViewController:[UIViewController new]] ];
    });
    return defaultLayout;

}

-(instancetype)init
{
   // [self doesNotRecognizeSelector:_cmd];
     NSAssert(NO, @"STLayoutViewController only allowed one instance");
    return nil;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        NSParameterAssert(rootViewController);
        self.leftDisplayVector = CGVectorMake(240, 64);
        self.rightDisplayVector = CGVectorMake(80, 64);
        self.animationDuration = 0.35;
        self.displayShadow = YES;
        self.rootViewController=rootViewController;
        self.leftDisplayMode = STLayoutViewDisplayModeDefault;
        self.rightDisplayMode = STLayoutViewDisplayModeDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rootView =self.rootViewController.view;
    self.view.backgroundColor=[UIColor whiteColor];
    self.rootView.frame=self.view.bounds;
    [self.view addSubview:self.rootView];
    [self setPanGestureEnable:YES];
}
#pragma mark -- getters and setters
-(UIControl *)coverView
{
    if (!_coverView) {
        UIControl *coverView = [[UIControl alloc] initWithFrame:self.rootView.bounds];
        coverView.backgroundColor=[UIColor clearColor];
        [coverView addTarget:self action:@selector(coverViewTaped:) forControlEvents:UIControlEventTouchUpInside];
        self.coverView = coverView;
    }
    return _coverView;
}
-(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        self.panGestureRecognizer =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        self.panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}
-(void)setStatus:(STLayoutViewStatus)status
{
    if (_status!=status) {
        [self willChangeValueForKey:@"status"];
        _status =status;
        if (status == STLayoutViewStatusNormal) {
            [self setShadowHidden:YES];
            [self.coverView removeFromSuperview];
            [self.leftViewController.view removeFromSuperview];
            [self.rightViewController.view removeFromSuperview];
            self.animationView=nil;
        }
        else
        {
            [self setShadowHidden:NO];
            if (status ==STLayoutViewStatusLeftshowed||status == STLayoutViewStatusRightshowed) {
                [self.rootView addSubview:self.coverView];
            }
        }
        [self didChangeValueForKey:@"status"];
    }
}
- (void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController!=rootViewController) {
        if (_rootViewController) {
            [_rootViewController removeFromParentViewController];
        }
        _rootViewController=rootViewController;
        if (_rootViewController) {
            [self addChildViewController:_rootViewController];
        }
    }
}
-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController!=leftViewController) {
        if (_leftViewController) {
            [_leftViewController removeFromParentViewController];
        }
        _leftViewController=leftViewController;
        if (leftViewController) {
            [self addChildViewController:_leftViewController];
        }
    }
}
-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController!=rightViewController) {
        if (_rightViewController) {
            [_rightViewController removeFromParentViewController];
        }
        _rightViewController=rightViewController;
        if (_rightViewController) {
            [self addChildViewController:_rightViewController];
        }
    }
}
#pragma mark -- interface methods

-(void)setPanGestureEnable:(BOOL)enable
{
    if (enable) {
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }else{
        [self.view removeGestureRecognizer:self.panGestureRecognizer];
    }
}
-(void)showLeftViewController:(BOOL)animated
{
    if (self.status == STLayoutViewStatusNormal&&_leftViewController) {
        [self willShowLeftViewController];
        [self showLeftControler:animated?self.animationDuration:0];
    }
}
-(void)showRightViewController:(BOOL)animated
{
    if (self.status == STLayoutViewStatusNormal&&_rightViewController) {
        [self willShowRightViewController];
        [self showRightControler:animated?self.animationDuration:0];
    }
}
-(void)dismissCurrentController:(BOOL)animated
{
    switch (self.status) {
        case STLayoutViewStatusLeftshowed:
            self.status = STLayoutViewStatusLefthiding;
            [self hideViewController:animated?self.animationDuration:0];
            break;
        case STLayoutViewStatusRightshowed:
            self.status = STLayoutViewStatusRighthiding;
            [self hideViewController:animated?self.animationDuration:0];
            break;
        default:
            break;
    }
}
#pragma mark  private methods
- (void)coverViewTaped:(id)sender
{
    [self dismissCurrentController:YES];
}
-(CGFloat)leftMaxOffset
{
    return self.leftDisplayVector.dx;
}
-(CGFloat)rightMaxOffset
{
    return self.rightDisplayVector.dx;
}
- (void)setShadowHidden:(BOOL)hidden
{
    if (!hidden&&self.canDisplayShadow) {
        self.animationView.layer.shadowOffset = CGSizeZero;
        self.animationView.layer.shadowRadius = 4.0f;
        self.animationView.layer.shadowPath   = [UIBezierPath bezierPathWithRect:self.animationView.bounds].CGPath;
        self.animationView.layer.shadowOpacity    = 0.8f;
    }
    else
    {
        self.animationView.layer.shadowOpacity =0;
    }
}
- (void)willShowLeftViewController
{
    if (self.status ==STLayoutViewStatusNormal) {
        self.leftViewController.view.frame=self.view.bounds;
        if (self.leftDisplayMode == STLayoutViewDisplayModeBackground)
        {
            [self.view insertSubview:self.leftViewController.view belowSubview:self.rootView];
            self.animationView = self.rootView;
        }
        else
        {
            CGRect frame = self.leftViewController.view.frame;
            frame.origin.x = 0;
            self.leftViewController.view.frame = frame;
 
            [self.view addSubview:self.leftViewController.view];
            self.animationView = self.leftViewController.view;
        }
        self.status = STLayoutViewStatusLeftshowing;
    }
}
- (void)willShowRightViewController
{
    if (self.status == STLayoutViewStatusNormal) {
        self.rightViewController.view.frame=self.view.bounds;
        if (self.rightDisplayMode == STLayoutViewDisplayModeBackground)
        {
            [self.view insertSubview:self.rightViewController.view belowSubview:self.rootView];
            self.animationView = self.rootView;
        }
        else
        {
            CGRect frame = self.rightViewController.view.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.rightViewController.view.frame = frame;

            [self.view addSubview:self.rightViewController.view];
            self.animationView = self.rightViewController.view;
        }
        self.status = STLayoutViewStatusRightshowing;
    }
}

- (void)showLeftControler:(CGFloat)aniduration
{
    CGFloat maxoffset =[self leftMaxOffset];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:aniduration animations:^{
        [self layoutSubviewWithOffset:maxoffset];
    }completion:^(BOOL finished) {
        self.status= STLayoutViewStatusLeftshowed;
    }];
}

- (void)showRightControler:(CGFloat)aniduration
{
    CGFloat maxoffset =[self rightMaxOffset];
    [UIView animateWithDuration:aniduration animations:^{
        [self layoutSubviewWithOffset:maxoffset];
    }completion:^(BOOL finished) {
        self.status = STLayoutViewStatusRightshowed;
    }];
}

- (void)hideViewController:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self layoutSubviewWithOffset:0];
    } completion:^(BOOL finished) {
        self.status = STLayoutViewStatusNormal;
    }];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && ABS(translation.x)/ABS(translation.y)>1.1) {
            if (_leftViewController||_rightViewController) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginGesture:pan];
        }break;
        case UIGestureRecognizerStateEnded:
        {
            [self endedGesture:pan];
        }break;
        default:
        {
            [self duringGesture:pan];
        }break;
    }
}
-(void)beginGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint velocity=[pan velocityInView:self.view];
    if(velocity.x>0)
    {
        if (self.status == STLayoutViewStatusNormal && _leftViewController)
        {
            [self willShowLeftViewController];
             self.startPanPoint = [self leftStartPoint];
        }
        else if (self.status == STLayoutViewStatusRightshowed)
        {
            self.startPanPoint = [self rightStartPoint];
            self.status = STLayoutViewStatusRighthiding;
        }
    }
    else if (velocity.x<0)
    {
        if (self.status == STLayoutViewStatusNormal && _rightViewController) {
            [self willShowRightViewController];
            self.startPanPoint=[self rightStartPoint];
        }
        else if (self.status == STLayoutViewStatusLeftshowed)
        {
            self.startPanPoint=[self leftStartPoint];
            self.status = STLayoutViewStatusLefthiding;
        }
    }
}
-(CGPoint)leftStartPoint
{
    if (self.leftDisplayMode == STLayoutViewDisplayModeBackground)
    {
        return  self.rootView.frame.origin;
    }
    else
    {
       
        return CGPointMake(self.leftViewController.view.frame.origin.x + self.leftViewController.view.frame.size.width, self.leftViewController.view.frame.origin.y );
    }
}
-(CGPoint)rightStartPoint
{
    if (self.rightDisplayMode == STLayoutViewDisplayModeBackground)
    {
      
        return  CGPointMake(self.rootView.frame.origin.x + self.rootView.frame.size.width,self.rootView.frame.origin.y);
    }
    else
    {
        return self.rightViewController.view.frame.origin;
    }
}

-(void)duringGesture:(UIPanGestureRecognizer *)pan
{
    
    switch (self.status) {
        case STLayoutViewStatusLeftshowing:
        case STLayoutViewStatusLefthiding:
        {
            [self layoutInGesture:pan leftOrRight:YES];
        }break;
        case STLayoutViewStatusRightshowing:
        case STLayoutViewStatusRighthiding:
        {
            [self layoutInGesture:pan leftOrRight:NO];
        }break;
        default:
            break;
    }
}
-(void)layoutInGesture:(UIPanGestureRecognizer *)pan leftOrRight:(BOOL)leftOrRight
{
    CGPoint currentPostion = [pan translationInView:self.view];
    CGFloat xoffset = _startPanPoint.x + currentPostion.x;
    xoffset = [self xoffsetWithOffset:xoffset leftOrRight:leftOrRight];
    CGPoint velocity = [pan velocityInView:self.view];
    if (velocity.x>0)
    {
        self.movingRightOrLeft = YES;
    }
    else if (velocity.x < 0)
    {
        self.movingRightOrLeft = NO;
    }
    [self layoutSubviewWithOffset:xoffset];
}
-(CGFloat)xoffsetWithOffset:(CGFloat)offset leftOrRight:(BOOL)leftOrRight
{
    CGFloat resultOffset =offset;
    CGFloat maxtOffset;
    if (leftOrRight) {
        maxtOffset = [self leftMaxOffset];
    }
    else
    {
        maxtOffset = [self rightMaxOffset];
        resultOffset = SCREEN_WIDTH -resultOffset;
    }
    if (resultOffset>maxtOffset) {
        resultOffset = maxtOffset;
    }
    else if (resultOffset<0)
    {
        resultOffset = 0;
    }
    return resultOffset;
}
-(void)endedGesture:(UIPanGestureRecognizer *)pan
{
    switch (self.status) {
        case STLayoutViewStatusLeftshowing:
        case STLayoutViewStatusLefthiding:
        {
            CGPoint currentPostion = [pan translationInView:self.view];
            CGFloat xoffset = _startPanPoint.x + currentPostion.x;
            xoffset = [self xoffsetWithOffset:xoffset leftOrRight:YES];
            CGFloat maxOffset =[self leftMaxOffset];
            if (self.movingRightOrLeft) {
                [self showLeftControler:self.animationDuration*(maxOffset -xoffset)/maxOffset];
            }
            else
            {
                [self hideViewController:self.animationDuration*xoffset/maxOffset];
            }
        }break;
        case STLayoutViewStatusRightshowing:
        case STLayoutViewStatusRighthiding:
        {
            CGPoint currentPostion = [pan translationInView:self.view];
            CGFloat xoffset = _startPanPoint.x + currentPostion.x;
            CGFloat maxOffset =[self rightMaxOffset];
            xoffset = [self xoffsetWithOffset:xoffset leftOrRight:NO];
            if (self.movingRightOrLeft) {
                [self hideViewController:self.animationDuration*xoffset/maxOffset];
            }
            else
            {
                [self showRightControler:self.animationDuration*(maxOffset-xoffset)/maxOffset];
            }
        }break;
        default:
            break;
    }
}
- (void)layoutSubviewWithOffset:(CGFloat)offset
{
    
    switch (self.status) {
        case STLayoutViewStatusLeftshowing:
        case STLayoutViewStatusLefthiding:
        {
            CGFloat viewHeight = SCREEN_HEIGHT;
            CGFloat maxoffset = [self leftMaxOffset];
            if (self.leftDisplayMode == STLayoutViewDisplayModeBackground)
            {
                CGFloat minscale = (viewHeight - self.leftDisplayVector.dy*2)/viewHeight;
                CGFloat scale =1- (1-minscale)*offset/maxoffset;
                self.animationView.transform = CGAffineTransformMakeScale(scale, scale);
               
                CGRect frame = self.animationView.frame;
                frame.origin.x = offset;
                self.animationView.frame = frame;
              
            }
            else
            {
                CGRect frame = self.animationView.frame;
                frame.origin.x = offset - frame.size.width;
                self.animationView.frame = frame;
               
            }
            [self layoutSubviewWithOffset:offset maxOfsset:maxoffset atView:self.animationView status:self.status];
        }break;
        case STLayoutViewStatusRightshowing:
        case STLayoutViewStatusRighthiding:
        {
            CGFloat viewWidth = SCREEN_WIDTH;
            CGFloat viewHeight = SCREEN_HEIGHT;
            CGFloat maxoffset = [self rightMaxOffset];
            if (self.rightDisplayMode == STLayoutViewDisplayModeBackground)
            {
                CGFloat minscale = (viewHeight - self.rightDisplayVector.dy*2)/viewHeight;
                CGFloat scale =1- (1-minscale)*offset/maxoffset;
                self.animationView.transform = CGAffineTransformMakeScale(scale, scale);
                
                CGRect frame = self.animationView.frame;
                frame.origin.x = viewWidth-offset - frame.size.width;
                self.animationView.frame = frame;
              
            }
            else
            {
                CGRect frame = self.animationView.frame;
                frame.origin.x = viewWidth -offset;
                self.animationView.frame = frame;
             
            }
            [self layoutSubviewWithOffset:offset maxOfsset:maxoffset atView:self.animationView status:self.status];
        } break;
        default:
            break;
    }
}
#pragma mark customAnimationSuport method
- (void)layoutSubviewWithOffset:(CGFloat)offset maxOfsset:(CGFloat)maxofsset atView:(UIView *)animationView status:(STLayoutViewStatus)status;
{
    
}
@end
