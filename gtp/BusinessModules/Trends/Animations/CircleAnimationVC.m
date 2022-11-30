//
//  Master4ViewController.m
//  SegmentController
//
//  Created by WIQ on 14-6-13.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "CircleAnimationVC.h"
#import "SXWaveView.h"

#import "Radar.h"
#define R           80
#define Rr_MARIGIN  10
static SystemSoundID soundID;
@interface CircleAnimationVC ()<RNExpandingButtonBarDelegate,AwesomeMenuDelegate>

@property (nonatomic, strong) RNExpandingButtonBar *bar;
@property(nonatomic,strong)SXWaveView *animateView;
@end

@implementation CircleAnimationVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    CircleAnimationVC *vc = [[CircleAnimationVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
   
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : HEXCOLOR(0xffffff)
    }];
    
    
    self.navigationItem.title = @"CircleAnimationVC";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self createCircleImageView];
    
    [self createScaleLayerRadar];
    
    [self createRadarAnimation];
    
    [self createAwesomeMenu];
    
    [self expandingButtonBar];
    
    [self createDragButton];
}
#pragma mark- Create CircleImageView
- (void)createCircleImageView{
    UIImage *customImage =  [UIImage imageNamed:@"SQUARE_PLACEDHOLDER_IMG"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - customImage.size.width/2)/2, 10, customImage.size.width/2, customImage.size.height/2)];
    imageView.image = customImage;
    [imageView bezierCircle];
    [self.view addSubview:imageView];
    
    
    UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, customImage.size.width/2, customImage.size.height/2)];
    imageView2.image = customImage;
    [imageView2 drawCircle];
    [self.view addSubview:imageView2];
}

#pragma mark- Create ScaleRadarAnimation
- (void)createScaleLayerRadar{
    CALayer *scaleLayer = [[CALayer alloc] init];
    scaleLayer.backgroundColor = RGBCOLOR(255, 234, 243).CGColor;
    scaleLayer.frame = CGRectMake(30, 120 , R, R);
    scaleLayer.cornerRadius = scaleLayer.frame.size.height/2;
    [self.view.layer addSublayer:scaleLayer];
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.8;
    
    //开演
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    //演员初始化
    CALayer *scaleLayer2 = [[CALayer alloc] init];
    scaleLayer2.backgroundColor = RGBCOLOR(255, 179, 209).CGColor;
    scaleLayer2.frame = CGRectMake(scaleLayer.frame.origin.x + Rr_MARIGIN/2, scaleLayer.frame.origin.y + Rr_MARIGIN/2 , R-Rr_MARIGIN, R-Rr_MARIGIN);
    scaleLayer2.cornerRadius = scaleLayer2.frame.size.height/2;
    [self.view.layer addSublayer:scaleLayer2];
    
    //设定剧本
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation2.autoreverses = YES;
    scaleAnimation2.fillMode = kCAFillModeForwards;
    scaleAnimation2.repeatCount = MAXFLOAT;
    scaleAnimation2.duration = 0.8;
    
    //开演
    [scaleLayer2 addAnimation:scaleAnimation2 forKey:@"scaleAnimation"];
    
    //    UIImageView* centreImage = [[UIImageView alloc]initWithFrame:CGRectMake(scaleLayer.frame.origin.x + 2*Rr_MARIGIN/2, scaleLayer.frame.origin.y + 2*Rr_MARIGIN/2, R-2*Rr_MARIGIN, R-2*Rr_MARIGIN)];
    UIImageView* centreImage = [[UIImageView alloc]init];
    centreImage.frame = scaleLayer2.frame;
    centreImage.frame = CGRectMake(scaleLayer.frame.origin.x + 2*Rr_MARIGIN/2, scaleLayer.frame.origin.y + 2*Rr_MARIGIN/2, R-2*Rr_MARIGIN, R-2*Rr_MARIGIN);
    centreImage.backgroundColor = [UIColor redColor];
    centreImage.layer.cornerRadius = centreImage.size.height/2;
    [self.view addSubview:centreImage];
}

#pragma mark- Create RadarAnimation
- (void)createRadarAnimation{
    Radar* radarView = [[Radar alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH -R)/2, 120 , R, R)];
    [self.view addSubview:radarView];
    
    UIImageView* centreImage = [[UIImageView alloc]init];
    //    centreImage.image = [UIImage imageNamed:@"identitiMaMa_nor"];
    centreImage.frame = radarView.frame;
    centreImage.layer.cornerRadius = R/2;
    centreImage.backgroundColor = RGBCOLOR(255, 179, 209);
    [self.view addSubview:centreImage];
}
#pragma mark-Create ExpandingButtonBar
-(void)expandingButtonBar{
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    
    CGPoint center = CGPointMake(MAINSCREEN_WIDTH-60, 90);
    CGRect expandingButtonFrame = CGRectMake(0, 0, 95.0f, 55.0f);
    NSArray* expandingButtonInfos = @[
                      @{@"next":@"mmdefe"},
                      @{@"lightbulb":@"bbdbdddd"},
                      @{@"check":@"ccccddfef"}
                      ];
    
    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage expandingButtonInfos:expandingButtonInfos
                                                       expandingButtonFrame:expandingButtonFrame center:center];
    
    [bar setDelegate:self];
    [bar actionBlock:^(id data) {
        [self expandingButtonAction:[data integerValue]];
        [self closeExpandingBtn];
    }];
    [bar setSpin:YES];
    [self setBar:bar];
//    [[self view] addSubview:[self bar]];
    
    CGRect frame = CGRectZero;
    UIView* view = [[UIView alloc]initWithFrame:frame];
    view.tag = 300000;
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
//    [view addSubview:[self bar]];
    [self.view addSubview:view];
    [[self view] addSubview:[self bar]];
//    [[UIApplication sharedApplication].keyWindow addSubview:[self bar]];
}
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF BAR ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
- (void)expandingButtonAction:(NSInteger)tag{
    switch (tag) {
        case 0:
            [self onNext];
            break;
        case 1:
            [self onAlert];
            break;
        case 2:
            [self onModal];
            break;
        default:
            break;
    }
}
- (void) onNext{
    [[self bar] hideButtonsAnimated:YES];
    
    RichTextAdjustVC *vc = [[RichTextAdjustVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onAlert{
    [[self bar] hideButtonsAnimated:NO];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This is an alert message." preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void) onModal
{
    [[self bar] hideButtonsAnimated:YES];
    RichTextAdjustTableVC *vc = [[RichTextAdjustTableVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Delegate methods of ExpandingButtonBarDelegate
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    NSLog(@"did appear");
    for (UIView* view in self.view.subviews) {
        if (view.tag == 300000) {
            CGRect frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
            [view setFrame:frame];
            
            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            view.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeExpandingBtn)];
            //        tap.delegate = self;
            [view addGestureRecognizer:tap];
        }
    }
    
    
}

- (void)closeExpandingBtn{
    [self removeMaskView];
    [[self bar] hideButtonsAnimated:YES];
}
- (void)removeMaskView{
    for (UIView* view in self.view.subviews) {
        if (view.tag == 300000) {
            [view setFrame:CGRectZero];
            view.backgroundColor = [UIColor clearColor];
        }
    }
}
- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    NSLog(@"will appear");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"泡泡声音" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    NSLog(@"will disappear");
    [self removeMaskView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"新浪微博刷新声音" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark- Create AwesomeMenu
-(void)createAwesomeMenu{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    //UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    UIImage *starImage0 = [UIImage imageNamed:@"icon0"];
    UIImage *starImage1 = [UIImage imageNamed:@"icon1"];
    UIImage *starImage2 = [UIImage imageNamed:@"icon2"];
    UIImage *starImage3 = [UIImage imageNamed:@"icon3"];
    // Default Menu
    /*
     AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
     highlightedImage:storyMenuItemImagePressed
     ContentImage:starImage
     highlightedContentImage:nil];
     
     NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,starMenuItem9, nil];
     
     AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
     highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
     ContentImage:[UIImage imageNamed:@"icon-plus.png"]
     highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
     
     AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.window.bounds startItem:startItem optionMenus:menus];
     menu.delegate = self;
     */
    
    
    //* Path-like customization
    
    AwesomeMenuItem *starMenuItem0 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage0
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage1
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage2
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage3
                                                    highlightedContentImage:nil];
    //    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
    //                                                           highlightedImage:storyMenuItemImagePressed
    //                                                               ContentImage:starImage
    //                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem0, starMenuItem1, starMenuItem2, starMenuItem3, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem optionMenus:menus];
    menu.delegate = self;
    
	menu.menuWholeAngle =- M_PI_2;
	menu.farRadius = 110.0f;
	menu.endRadius = 100.0f;
	menu.nearRadius = 90.0f;
    menu.animationDuration = 0.3f;
    menu.startPoint = CGPointMake(MAINSCREEN_WIDTH - 60 - storyMenuItemImage.size.width, MAINSCREEN_HEIGHT-158);
    
    [self.view addSubview:menu];
    
}

#pragma mark- GET RESPONSE OF AwesomeMENU
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %ld",(long)idx);
    [self waterWaveAnimation:(int)idx];
    switch (idx) {
        case 0:{
            
            
        }
            break;
        case 1:{

        }
            break;
        case 2:{

        }
            break;
        case 3:{

        }
            break;
        default:
            break;
    }
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

#pragma mark- Create DragButton
-(void)createDragButton{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10,100,60,60)];
    btn.backgroundColor = [UIColor orangeColor];
    btn.tag = 0;
    btn.layer.cornerRadius = 8;
    [btn setDragEnable:YES];
    [btn setAdsorbEnable:YES];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)showTag:(UIButton *)sender
{
    NSLog(@"button.tag >> %@",@(sender.tag));
}

#pragma mark- Create WaterWaveAnimation
- (void)waterWaveAnimation:(int)precent{
    self.animateView = [[SXWaveView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH -100)/2, 220,100, 100)];
    [self.view addSubview:self.animateView];
    
    
    [self.animateView setPrecent:precent+1 description:@"" textColor:[UIColor greenColor] bgColor:RGBCOLOR(253, 112, 112) alpha:1 clips:YES];
    self.animateView.endless = YES;
    
    [self.animateView addAnimateWithType:0];
    //    [_animateView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:5.0f];
//    [UIView animateWithDuration:5.0f animations:^ {
//        _animateView.alpha=0;
//    }];

}

@end
