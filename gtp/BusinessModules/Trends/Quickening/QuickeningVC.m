//
//  ViewController.m
//  TagUtilViews
//
//  Created by WIQ on 16/6/11.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "QuickeningVC.h"

#import "PHOvalView.h"
#import "PHNormalMembrane.h"
#import "AnimatiomView.h"

@interface QuickeningVC ()
@property (nonatomic, strong) AnimatiomView *animationView;
@property (strong, nonatomic) PHNormalMembrane* nor;
@property (strong, nonatomic) UIImageView* babyV;
@end

@implementation QuickeningVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    QuickeningVC *vc = [[QuickeningVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)initlizeAnimationView {
    
    _animationView = [[AnimatiomView alloc] initWithFrame:CGRectMake(100, 100, 190, 237)];
    _animationView.backgroundColor = [UIColor clearColor];

    [_animationView setNeedsDisplay];
    [_animationView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_animationView];
    
}

#pragma mark AnimatiomViewDelegate
- (void)click{
    [_animationView wobbleCircleLayer];
}

-(void)creatMembraneView2{
    _nor = [[PHNormalMembrane alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH-200)/2, 30, 200, 260)];
    //_nor.backgroundColor = [UIColor blueColor];
    [_nor addTarget:self action:@selector(scale) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nor];
    
    _babyV = [[UIImageView alloc]init];
    [self centre];
    //[self transY];
    [_nor addSubview:_babyV];
    //[self scale];
}

- (void)trans{
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.fromValue = @(_babyV.center.y);
    positionAnima.toValue = @(_babyV.center.y-30);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    CABasicAnimation *transformAnima =[CABasicAnimation animationWithKeyPath:@"position.x"];
    transformAnima.fromValue = @(_babyV.center.x);
    transformAnima.toValue = @(_babyV.center.x+20);
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 4.0f;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.autoreverses=YES;
    animaGroup.removedOnCompletion = NO;
    animaGroup.animations = @[positionAnima,transformAnima];
    
    [_babyV.layer addAnimation:animaGroup forKey:@"Animation"];
}
- (void)transY{
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = 1.8;
    positionAnima.fromValue = @(_babyV.center.y);
    positionAnima.toValue = @(_babyV.center.y-30);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    positionAnima.repeatCount = HUGE_VALF;
    positionAnima.repeatDuration = 1;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    [_babyV.layer addAnimation:positionAnima forKey:@"AnimationMoveY"];
}
- (void)random{
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
- (void)centre{
    UIImage* babyIcon = [UIImage imageNamed: @"baby_40"];
    _babyV.image = babyIcon ;
    
    _babyV.frame  = CGRectMake((_nor.frame.size.width-babyIcon.size.width)/2, (_nor.frame.size.height-babyIcon.size.height)/2, babyIcon.size.width, babyIcon.size.height);
    
    
}
- (void)timerFired{
    UIImage* babyIcon = [UIImage imageNamed: @"baby_40"];
    _babyV.image = babyIcon ;
    
    [UIView animateWithDuration:10 animations:^{
        self.babyV.frame  = CGRectMake((arc4random() % (int)((self.nor.frame.size.width-babyIcon.size.width)/2))+30, (arc4random() % (int)((self.nor.frame.size.height-babyIcon.size.height)/2))+30, babyIcon.size.width, babyIcon.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}
-(void)scale{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:.92];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 3;
    
    
    //开演
    [_nor.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
-(void)creatMembraneView{
    _nor = [[PHNormalMembrane alloc]initWithFrame:CGRectMake(100, 100, 190, 237)];
    [self.view addSubview:_nor];
    
    _nor.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:3
                     animations:^{
                         self.nor.transform = CGAffineTransformMakeScale(.8, .8);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:3
                                          animations:^{
                                              self.nor.transform = CGAffineTransformMakeScale(1, 1);
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:3
                                                               animations:^{
                                                                   self.nor.transform = CGAffineTransformMakeScale(.8, .8);
                                                               }completion:^(BOOL finish){
                                                                   self.nor.transform = CGAffineTransformMakeScale(1, 1);
                                                               }];
                                          }];
                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self creatMembraneView2];
//    [self initlizeAnimationView];
    //http://blog.csdn.net/zsk_zane/article/details/47360717
    //http://blog.csdn.net/xiongbaoxr/article/details/50890565
    //http://blog.csdn.net/xiongbaoxr/article/details/51818265
    //http://blog.csdn.net/a454431208/article/details/49494723
    //http://code.cocoachina.com/view/128877
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scale];
    [self random];
}

@end
