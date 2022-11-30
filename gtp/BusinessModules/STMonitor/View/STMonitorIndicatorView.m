//
//  STMonitorIndicatorView.m
//  GoldChampion
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorIndicatorView.h"
#import "STMonitorFileLogger.h"
#import "STMonitorLogFormatter.h"
#import "STMonitorHeader.h"
#import "AppDelegate.h"
#import <mach/mach.h>
#define consoleViewFrame  CGRectMake(0, 0, 200, 220)
#define normalViewFrame  CGRectMake(0, 0, 60, 60)
@interface STMonitorIndicatorView()
@property(nonatomic, strong) UIButton                     *consoleButton;
@property(nonatomic, assign) CGPoint                        originPoint;
@property(nonatomic, strong) UIView                     *consoleView;
@property(nonatomic, strong) UITextView                     *textView;
@property(nonatomic, strong) STMonitorFileLogger                     *logger;
@property(nonatomic, strong) UILabel                     *displayLable;/**< 屏幕刷新率 */
@property(nonatomic, strong) CADisplayLink                    *displayLink;/**< <##> */
@property(nonatomic, assign) NSTimeInterval                     lastTimestamp;

@property(nonatomic, assign) NSInteger                          performTimes;
@end
@implementation STMonitorIndicatorView

+ (STMonitorIndicatorView *)deflult{
    static STMonitorIndicatorView * deflut = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deflut = [[STMonitorIndicatorView alloc] initWithFrame:normalViewFrame];
    });
    return deflut;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf =  self;
        self.logger = (id)[DDLog sharedInstance].allLoggers.firstObject;
        [self.logger setDidLogHandle:^(DDLogMessage *message) {
            [weakSelf didLogMessage:message];
        }];
        [self configSubView];
        [self configConsoleView];
        //避免重新 设置 window的rootViewController 被覆盖
        [self addObseveToKeyWindowChange];
        //获取实时FPS
        [self configDisPlay];
    }
    return self;
}
#pragma mark --KVO
- (void)addObseveToKeyWindowChange{
    UIWindow * window = (id)[UIApplication sharedApplication].delegate.window;
    
    [window addObserver:self forKeyPath:@"rootViewController" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    UIWindow * window = (id)[UIApplication sharedApplication].delegate.window;
    [window bringSubviewToFront:self];
}
- (void)dealloc{
    UIWindow * window = (id)[UIApplication sharedApplication].delegate.window;
    [window removeObserver:self forKeyPath:@"rootViewController"];
}
#pragma mark --subView
- (void)configSubView{
    self.backgroundColor = [UIColor clearColor];
    self.stmc_right = STMC_UIScrenWitdh - 15;
    self.stmc_top = 20;
    self.hidden = YES;
    
    
    self.consoleButton = [[UIButton alloc] initWithFrame:self.bounds];
    self.consoleButton.layer.cornerRadius = self.consoleButton.stmc_width / 2;
    self.consoleButton.clipsToBounds = YES;
    self.consoleButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.consoleButton setTitle:@"Console" forState:UIControlStateNormal];
    [self.consoleButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.consoleButton.backgroundColor = STMC_ThemeBackGroundColor;
    [self.consoleButton addTarget:self action:@selector(onSelctedConsoleButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.consoleButton];
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pangesHandle:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDebugViewer)];
    tap.numberOfTapsRequired =  5;
    [self addGestureRecognizer:tap];
    
    
    self.originPoint = self.center;
}
- (void)configConsoleView{
    
    UIView * view = [[UIView alloc] initWithFrame:consoleViewFrame];
    view.backgroundColor = [STMC_ThemeBackGroundColor colorWithAlphaComponent:0.5];
    self.consoleView = view;
    [self addSubview:view];
    CGFloat buttonWith = view.stmc_width / 3;
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, buttonWith, 30);
    [backButton setTitle:@"收起" forState:UIControlStateNormal];
    [backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton addTarget:self action:@selector(onSelctedBackButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backButton];
    
    
    
    UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(buttonWith, 0, buttonWith, 30);
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyButton addTarget:self action:@selector(onSelcteCopyButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:copyButton];
    
    
    
    
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(2 * buttonWith, 0, buttonWith, 30);
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [clearButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearButton addTarget:self action:@selector(onSelcteClearButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clearButton];
    
    
    self.displayLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, self.textView.size.width - 10, 34)];
    self.displayLable.textColor = UIColor.whiteColor;
    self.displayLable.text = @"FPS:";
    self.displayLable.font = [UIFont systemFontOfSize:9];
    self.displayLable.numberOfLines = 0;
    [view addSubview:self.displayLable];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 65, view.stmc_width, 0.5)];
    line.backgroundColor = UIColor.whiteColor;
    [view addSubview:line];
    [view stmc_setBorderWith:1 borderColor:STMC_ThemeBackGroundColor cornerRadius:5];
    
    
    [view addSubview:self.textView];
    
    self.consoleView.hidden = YES;
    [self addSubview:self.consoleView];
    [self configDisPlay];
}
- (void)configDisPlay{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTicks:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)displayLinkTicks:(CADisplayLink *)link{
    if (self.hidden) {
        return;
    }
    if (_lastTimestamp == 0) {
        _lastTimestamp = link.timestamp;
        return;
    }
    _performTimes ++;
    NSTimeInterval interval = link.timestamp - _lastTimestamp;
    if (interval < 1) { return; }
    _lastTimestamp = link.timestamp;
    //刷新率
    float fps = _performTimes / interval;
    _performTimes = 0;
    //cpu
    float cpu = [self getCpuValue];
    //内存memory
    float memory = [self getMemoryValue];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString* phoneModel = [[STMonitorCrashManger defult] iphoneType];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    batteryLevel = batteryLevel * 100;
    NSString * deviceStatus = [NSString stringWithFormat:@"系统:%@  手机:%@ 电量:%0.2f%@",phoneVersion,phoneModel,batteryLevel,@"%"];
    
    self.displayLable.text = [NSString stringWithFormat:@"%@\nFPS:%0.2f  CPU:%0.2f%@   内存:%0.2fM",deviceStatus,
                              fps,cpu,@"%",memory];
}


- (UITextView*)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 65, self.consoleView.stmc_width, self.consoleView.stmc_height - 50)];
        _textView.text = @"";
        _textView.font = [UIFont systemFontOfSize:10];
        _textView.textColor = STMC_UIColorFromRGBA(0x333333);
    }
    return _textView;
}
#pragma mark --Public
- (void)updateConsoleState{
    bool open = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenDeBugWindowKey];
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = !open;
    }completion:^(BOOL finished) {
        [self judgeEndPointAndDeal];
    }];
    
}
#pragma mark --Action Method
- (void)onSelctedConsoleButton{
    [UIView animateWithDuration:0.3 animations:^{
        self.consoleView.hidden = NO;
        self.consoleButton.hidden = YES;
        self.frame  = consoleViewFrame;
        self.center = self.originPoint;
    }completion:^(BOOL finished) {
        [self judgeEndPointAndDeal];
    }];
    
}
- (void)onSelctedBackButton{
    [UIView animateWithDuration:0.3 animations:^{
        self.consoleView.hidden = YES;
        self.consoleButton.hidden = NO;
        self.frame  = normalViewFrame;
        self.center = self.originPoint;
    }completion:^(BOOL finished) {
        [self judgeEndPointAndDeal];
    }];
    
}
- (void)onSelcteCopyButton{
    UIPasteboard *bord = [UIPasteboard generalPasteboard];
    [bord setString:self.textView.text];
    DDLogInfo(@"复制成功");
}
- (void)onSelcteClearButton{
    self.textView.text = @"";
}
- (void)pangesHandle:(UIPanGestureRecognizer*)pan{
    
    CGPoint point = [pan translationInView:self];
    //    self.centerX   = self.originPoint.x + point.x;
    //    self.centerY = self.originPoint.y + point.y;
    CGAffineTransform trance = self.transform;
    pan.view.transform =  CGAffineTransformTranslate(trance, point.x, point.y);
    [pan setTranslation:CGPointZero inView:pan.view];
    //DDLogDebug(@"手势拖动%@",NSStringFromCGPoint(point));
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        [self judgeEndPointAndDeal];
    }
}
- (void)gotoDebugViewer{
    
    UIViewController  *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[STMonitorHomeViewController new]];
    [rootViewController presentViewController:nav animated:YES completion:nil];
}
#pragma mark --Private Method
//获取cpu占比
- (float)getCpuValue {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}
//内存
- (float)getMemoryValue{
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernReturn != KERN_SUCCESS) { return NSNotFound; }
    memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    return memoryUsageInByte/1024.0/1024.0;
}
- (void)judgeEndPointAndDeal{
    CGFloat top = self.stmc_top - 0;
    CGFloat bootom = STMC_UIScrenHeight- self.stmc_bottom;
    CGFloat left = self.stmc_left - 0;
    CGFloat right = STMC_UIScrenWitdh- self.stmc_right;
    CGFloat miny = MIN(top, bootom);
    CGFloat minx = MIN(left, right);
    CGFloat min = MIN(minx, miny);
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (STMC_IOS11) {
        safeAreaInsets =  window.safeAreaInsets;
    }
    
    CGFloat insetValue = 15;//上下左右边距
    
    if (min == top ) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.6
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.stmc_top = insetValue  + safeAreaInsets.top;
                             if (self.stmc_left < insetValue) {
                                 self.stmc_left = insetValue;
                             }
                             if (self.stmc_right > STMC_UIScrenWitdh  - insetValue) {
                                 self.stmc_right = STMC_UIScrenWitdh - insetValue;
                             }
                         } completion:^(BOOL finished) {
                             [self panGesEnd];
                         }];
    }
    
    if (min == left ) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.6
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.stmc_left = insetValue;
                             if (self.stmc_top < 0 + safeAreaInsets.top) {
                                 self.stmc_top = insetValue + safeAreaInsets.top;
                             }
                             if (self.stmc_bottom > STMC_UIScrenHeight - insetValue - safeAreaInsets.bottom) {
                                 self.stmc_bottom = STMC_UIScrenHeight - insetValue - safeAreaInsets.bottom;
                             }
                         } completion:^(BOOL finished) {
                             [self panGesEnd];
                         }];
    }
    
    if (min == right ) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.6
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.stmc_right = STMC_UIScrenWitdh - insetValue;
                             if (self.stmc_top < 0 + safeAreaInsets.top) {
                                 self.stmc_top = insetValue + safeAreaInsets.top;
                             }
                             if (self.stmc_bottom > STMC_UIScrenHeight - safeAreaInsets.bottom - insetValue) {
                                 self.stmc_bottom = STMC_UIScrenHeight - safeAreaInsets.bottom - insetValue;
                             }
                         } completion:^(BOOL finished) {
                             [self panGesEnd];
                         }];
    }
    
    if (min == bootom ) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.6
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.stmc_bottom = STMC_UIScrenHeight - insetValue - safeAreaInsets.bottom;
                             if (self.stmc_left < insetValue) {
                                 self.stmc_left = insetValue;
                             }
                             if (self.stmc_right > STMC_UIScrenWitdh - insetValue) {
                                 self.stmc_right = STMC_UIScrenWitdh - insetValue;
                             }
                         } completion:^(BOOL finished) {
                             [self panGesEnd];
                         }];
    }
}
- (void)panGesEnd{
    self.originPoint = self.center;
}
#pragma mark --logMessageChangeHandle
- (void)didLogMessage:(DDLogMessage*)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.hidden) {
            NSString * orginString = self.textView.text;
            NSString * delMessgae = [[STMonitorLogFormatter new] formatLogMessage:message];
            NSString * finsh = [NSString stringWithFormat:@"%@\n%@",orginString,delMessgae];
            self.textView.text = finsh;
        }
        
    });
    
    
    
}
@end

