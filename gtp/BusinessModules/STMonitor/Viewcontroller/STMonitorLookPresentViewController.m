//
//  LBMediaPresentViewController.m
//  LangBa
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STMonitorLookPresentViewController.h"
#import "STMonitorCrashManger.h"
#define labelWith 200
@interface STMonitorLookPresentViewController ()
@property(nonatomic, strong) UIButton                     *clearButton;
@property(nonatomic, strong) UIView                       *customView;
@property(nonatomic, strong) UITextView                 *textView;
@end

@implementation STMonitorLookPresentViewController

- (instancetype)init
{
    if (self == [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}
- (void)setLogs:(NSString *)logs{
    _logs = logs;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * dealLog = logs.length?logs:@"暂无日志哟";
        self.textView.text = dealLog;
    });

}
#pragma mark --vc 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    [self configSubView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self show];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark --subView
- (void)configSubView{
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton = clearButton;
    clearButton.frame = [UIScreen mainScreen].bounds;
    clearButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [clearButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearButton];

    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width - 30, 342)];
    self.customView.stmc_centerX = STMC_UIScrenWitdh / 2;
    self.customView.stmc_top = STMC_UIScrenHeight;
    self.customView.backgroundColor = [UIColor whiteColor];
    self.customView.layer.cornerRadius = 10;
    self.customView.clipsToBounds = YES;
    self.customView.stmc_top = STMC_UIScrenHeight;
    [self.view addSubview:self.customView];
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.customView.stmc_width, 44)];
    titleLable.text = @"日志";
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = STMC_UIColorFromRGBA(0x666666);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.customView addSubview:titleLable];

    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, titleLable.stmc_bottom, self.customView.stmc_width, 500)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = self.logs;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = STMC_UIColorFromRGBA(0x666666);
    [self.customView addSubview:self.textView];

    
    UIButton * saveButton = [[UIButton alloc] initWithFrame:CGRectMake(30,self.textView.stmc_bottom  +10, 90, 30)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setTitle:@"复制" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    saveButton.layer.cornerRadius = 4;
    saveButton.backgroundColor = STMC_ThemeBackGroundColor;
    saveButton.stmc_right = self.customView.stmc_width/2 - 10;
    self.customView.stmc_height = saveButton.stmc_bottom + 30;
    [saveButton addTarget:self action:@selector(onSlectedSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:saveButton];
    


    UIButton * cacleButton = [[UIButton alloc] initWithFrame:CGRectMake(30,self.textView.stmc_bottom  +10, 90, 30)];
    [cacleButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cacleButton setTitle:@"取消" forState:UIControlStateNormal];
    cacleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cacleButton.layer.cornerRadius = 4;
    cacleButton.backgroundColor = STMC_ThemeBackGroundColor;
    cacleButton.stmc_right = self.customView.stmc_width/2 - 10;
    cacleButton.stmc_left = self.customView.stmc_width/2 + 10;
    self.customView.stmc_height = saveButton.stmc_bottom + 30;
    [cacleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:cacleButton];
    
}
#pragma mark --Private Method
- (void)show{
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.customView.stmc_centerY = STMC_UIScrenHeight / 2;
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void)dismiss{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.customView.stmc_top = STMC_UIScrenHeight;
        self.clearButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
- (void)dismissWithHandle:(void(^)(void))handle{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.customView.stmc_top = STMC_UIScrenHeight;
        self.clearButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (handle) {
                handle();
            }
        }];
    }];
}
#pragma mark --Action Method

- (void)onSelectedCancleButton{
    [self dismiss];
}
- (void)onSelectedWhiteView{
    [self.view endEditing:YES];
}
- (void)onSlectedSaveButton{
    UIPasteboard * bord = [UIPasteboard generalPasteboard];
    [bord setString:self.textView.text];
    //[SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

@end





