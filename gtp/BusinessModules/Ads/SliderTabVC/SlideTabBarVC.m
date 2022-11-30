//
//  ViewController.m
//  SlideTabBar
//


#import "SlideTabBarVC.h"
#import "SlideTabBarView.h"

@interface SlideTabBarVC ()

@property (strong, nonatomic) SlideTabBarView *slideTabBarView;
@property (assign) NSInteger tabCount;

@end

@implementation SlideTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _tabCount = 4;
//    [self initSlideWithCount:_tabCount];
    NSArray* tabs = @[@"",@""];
    [self initSlideWithTabs:tabs];
}

- (void)reduce:(id)sender {
    [_slideTabBarView removeFromSuperview];
    if (_tabCount > 1) {
        [self initSlideWithCount:--_tabCount];
    }
}


- (IBAction)add:(id)sender {
    [_slideTabBarView removeFromSuperview];
    [self initSlideWithCount:++_tabCount];
}

-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 94;
    
    _slideTabBarView = [[SlideTabBarView alloc] initWithFrame:screenBound WithCount:_tabCount];
    [self.view addSubview:_slideTabBarView];
}

-(void) initSlideWithTabs: (NSArray*) tabs{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _slideTabBarView = [[SlideTabBarView alloc] initWithFrame:screenBound WithTabs:tabs];
    [self.view addSubview:_slideTabBarView];
}

@end
