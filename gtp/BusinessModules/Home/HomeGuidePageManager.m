//
//  ABGuidePageManager.m
//  OTC
//
//  Created by David on 2018/12/5.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "HomeGuidePageManager.h"

@interface HomeGuidePageManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) HWGuidePageType guidePageType;

@end

@implementation HomeGuidePageManager

+ (instancetype)shareManager
{
    static HomeGuidePageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)showGuidePageWithType:(HWGuidePageType)type
{
    [self creatControlWithType:type completion:NULL];
}

- (void)showGuidePageWithType:(HWGuidePageType)type completion:(FinishBlock)completion
{
    [self creatControlWithType:type completion:completion];
//    if (self.lastSectionArr.count>0) {
//        TurntableView* popupView = [[TurntableView alloc]init];
//        [popupView richElementsInViewWithModel:self.lastSectionArr];
//        [popupView showInView:self.view];
//        [popupView actionBlock:^(id data) {
//            if ([data isKindOfClass:[WItem class]]) {
//                WItem* item = data;
//                self.resultItem = item;
////                NSLog(@"%@",item.title);
//                [self setupAnimateView];
//                [self setAnimate];
//            }
//            
//        }];
//    }
}

- (void)creatControlWithType:(HWGuidePageType)type completion:(FinishBlock)completion
{
    _finish = completion;
//    NSString * dangqianshebei=[NSString stringWithFormat:@"%@",[[UIScreen mainScreen]preferredMode]];
//    NSRange this=[dangqianshebei rangeOfString:@"2048"];
//    if (this.location!=NSNotFound) {
//        NSLog(@"ipad3");
//    }else{
//        this = [dangqianshebei rangeOfString:@"1024"];
//        if (this.location != NSNotFound) {
//            NSLog(@"ipad2");
//        }
//        else{
//            this=[dangqianshebei rangeOfString:@"960"];
//            if (this.location != NSNotFound) {
//                NSLog(@"iphone高清");
//            }else {
//                this=[dangqianshebei rangeOfString:@"750"];
//                if (this.location != NSNotFound) {
//                    NSLog(@"iphone小屏");
//                }else{
//                    NSLog(@"其他");//iphx
//                }
//            }
//        }
//    }
    
    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    // 信息提示视图
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    UIImageView *imgView2 = [[UIImageView alloc] init];
    [bgView addSubview:imgView2];
    UIImageView *imgView3 = [[UIImageView alloc] init];
    [bgView addSubview:imgView3];

    
    float screenWidth =   [UIScreen mainScreen].bounds.size.width;
    float screenHeight =   [UIScreen mainScreen].bounds.size.height;

    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];

    switch (type) {
        case ABGuidePageTypeScan:
            // 下一个路径，圆形
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth/6.0, 382) radius:(58) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth - 36, 44) radius:(34) startAngle:0 endAngle:2 * M_PI clockwise:NO]];

            imgView.image = [UIImage imageNamed:@"img_star1"];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(116));
                make.top.mas_equalTo(406);
            }];
            imgView2.image = [UIImage imageNamed:@"msg_saoma"];
            [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(20));
                make.top.mas_equalTo(451);
            }];
            imgView3.image = [UIImage imageNamed:@"btn_next"];
            [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(116));
                make.top.mas_equalTo(572);
            }];
            _guidePageKey = @"FIRSTSCAN";
            break;
            
        case ABGuidePageTypeBuy:
            // 下一个路径，矩形
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth/2.0, 385) radius:(58) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth/8.0*3.0, screenHeight - 38) radius:(36) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            
            imgView.image = [UIImage imageNamed:@"img_star2"];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(115));
                make.top.mas_equalTo(408);
            }];
            imgView2.image = [UIImage imageNamed:@"msg_buy"];
            [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(28));
                make.top.mas_equalTo(440);
            }];
            imgView3.image = [UIImage imageNamed:@"btn_next"];
            [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(116));
                make.top.mas_equalTo(528);
            }];
            _guidePageKey = @"TWOBUY";
            break;
            
        case ABGuidePageTypeSale:
            // 下一个路径，矩形
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth/2.0, 338+88+60) radius:(58) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            imgView.image = [UIImage imageNamed:@"img_star2"];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(95));
                make.top.mas_equalTo(378);
            }];
            imgView2.image = [UIImage imageNamed:@"msg_sell"];
            [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(54));
                make.top.mas_equalTo(301);
            }];
            imgView3.image = [UIImage imageNamed:@"btn_next"];
            [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(116));
                make.top.mas_equalTo(556);
            }];
            _guidePageKey = @"THREESALE";
            break;
            
        case ABGuidePageTypeOrder:
            // 下一个路径，矩形
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screenWidth/8.0*7.0-20, 338+44) radius:(55) startAngle:0 endAngle:2 * M_PI clockwise:NO]];//7.0-10
            imgView.image = [UIImage imageNamed:@"img_star1"];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(213));
                make.top.mas_equalTo(398);
            }];
            imgView2.image = [UIImage imageNamed:@"msg_order"];
            [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(36));
                make.top.mas_equalTo(438);
            }];
            imgView3.image = [UIImage imageNamed:@"btn_know"];
            [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealValue(116));
                make.top.mas_equalTo(540);
            }];
            _guidePageKey = @"FOURORDER";
            break;

        default:
            break;
    }
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:_guidePageKey];
    
    if (_finish) _finish();
}



@end
