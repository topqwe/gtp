//
//  ViewController.m
//  TagUtilViews
//
//  Created by WIQ on 16/6/11.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "TagRunVC.h"

#import "PHRoundTagView.h"
#import "PHRectTagView.h"

#import "PHHorizontalAnimationLabel.h"
#import "PHVerticalAnimationLabel.h"

typedef void(^addRemindBlock)(void);
@interface TagRunVC ()
@property (nonatomic, copy) addRemindBlock addRemindBlock;
@property (nonatomic,copy) NSString *string;

@end

@implementation TagRunVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    TagRunVC *vc = [[TagRunVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"=================1");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"=================2");
        });
        NSLog(@"=================3");
    });
    
    TagRunVC* vc = [[TagRunVC alloc]init];
    vc.string = @"welcome to our company";
    
    //弱引用
    kWeakSelf(vc);
    vc.addRemindBlock = ^{
        //弱引用
        NSLog(@"弱引用%@",weakvc.string);
        //强引用
        kStrongSelf(vc);
        NSLog(@"强引用%@",vc.string);
        //强引用,3s后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"强引用,3s后执行%@",vc.string);
        });
    };
    vc.addRemindBlock();
    NSLog(@"%@",LRToast(温馨提示));
    [self initlizeTagView];
}


- (void)initlizeTagView {
    NSArray* transArr = @[@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",@"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",@"Duis aute irure dolor in reprehenderit ", @"Excepteur sint occaecat cupidatat non proident."];
    
    UIView* roundTagView0 = [[PHRoundTagView alloc]initWithFrame:CGRectMake( 4, 0, MAINSCREEN_WIDTH, 0) withRoundWidthHeight:5 withContentLabelHeight:15 withRoundHorizonRangeToContent:12 withContenLabelSpace:5 withTitleArray:transArr isHidePerforativeLineView:NO];
    [self.view addSubview:roundTagView0];
    
    UIView* roundTagView  = [PHRoundTagView creatRoundTagViewWithFrame:CGRectMake( 4, CGRectGetMaxY(roundTagView0.frame)+20, MAINSCREEN_WIDTH, 0) withRoundWidthHeight:5 withContentLabelHeight:15 withRoundHorizonRangeToContent:12 withContenLabelSpace:5 withTitleArray:transArr isHidePerforativeLineView:NO];
    [self.view addSubview:roundTagView];
    
    NSArray* transArr2 = @[@"Lorem ipsum",@"dolor sit amet",@"consectetur adipisicing elit", @"sed do"];
    
    UIView* tagView0 = [PHRectTagView creatBtnWithFrame:CGRectMake(0, CGRectGetMaxY(roundTagView.frame)+20, MAINSCREEN_WIDTH, 0) isFixedBtnWidth:YES withTitleArray:transArr2];
//    tagView0.clickSectionBlock = ^(NSInteger sec, NSString *btnTit) {
//        NSLog(@"%ld,.....%@(long)",sec,btnTit);
//    };
    [self.view addSubview:tagView0];
    
    PHRectTagView* tagView = [[PHRectTagView alloc ]initBtnWithFrame:CGRectMake(0, CGRectGetMaxY(tagView0.frame)+20, MAINSCREEN_WIDTH, 0) isFixedBtnWidth:NO withTitleArray:transArr2];
    tagView.clickSectionBlock = ^(NSInteger sec, NSString *btnTit) {
        NSLog(@"%ld,.......+%@",(long)sec,btnTit);
        [YKToastView showToastText:[NSString stringWithFormat:@"%ld, %@",sec,btnTit]];
    };
    [self.view addSubview:tagView];
    
    
    PHVerticalAnimationLabel* verticalAnimationLabel = [[PHVerticalAnimationLabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tagView.frame)+20, MAINSCREEN_WIDTH,13) withTextFont:13 withTextColor:RGBSAMECOLOR(153)];
    [self.view addSubview:verticalAnimationLabel];
    [verticalAnimationLabel setArrayText:[transArr mutableCopy]];
    [verticalAnimationLabel stopTimer];
    [verticalAnimationLabel startTimer];
    
    
    PHHorizontalAnimationLabel* horizontalAnimationLabel = [[PHHorizontalAnimationLabel alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(verticalAnimationLabel.frame)+20,120, 13.0f)];
    horizontalAnimationLabel.leastInnerGap = 150.f;
    horizontalAnimationLabel.speed = BBFlashCtntSpeedSlow;
    horizontalAnimationLabel.textColor = RGBCOLOR(100,83,79);
    horizontalAnimationLabel.font = kFontSize(13);
    [self.view addSubview:horizontalAnimationLabel];
    horizontalAnimationLabel.text = transArr[1];
    
}

@end
