//
//  STProgressHudManger.m
//  ZuoBiao
//
//  Created by stoneobs on 17/3/17.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "STProgressHudTool.h"
#import <UIKit/UIKit.h>
#import "NSString+STFormatter.h"
#import "UIView+STDirection.h"
#import "STBezierView.h"
#define DEFULT_TAG  98989898989898
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)
@interface STProgressHudTool()

@end

@implementation STProgressHudTool

+ (void)showDefultHud{

    [STProgressHudTool showProgressHudWithStyle:STProgressHudStyleActivityIndicator];
}
+ (void)showProgressHudWithStyle:(STProgressHudStyle)style {


    switch (style) {
        case STProgressHudStyleActivityIndicator:
        {
        
            [STProgressHudTool initActivityIndicatorView];
        
        }
            break;
        case STProgressHudStyleRonateIndicator:
        {
            
            [STProgressHudTool initRonateIndicatorView];
        }
            break;
        default:
            break;
    }

 
    
}

+ (void)showProgressHudWithTitle:(NSString *)title delay:(NSInteger)deleay{

    [STProgressHudTool initTitleIndicatorView:title delay:deleay];

}
+ (void)hideCureentProgressHud
{
    UIWindow *  window = [UIApplication sharedApplication].keyWindow;
    UIView * backView = [window viewWithTag:DEFULT_TAG];
    [backView removeFromSuperview];
    
}
#pragma mark --Private Method
//初始菊花view
+ (void)initActivityIndicatorView{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
//    window = [(ZBAppDelegate*)[UIApplication sharedApplication].delegate window];
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }

    UIView  * loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingView.layer.cornerRadius = 15;
    loadingView.center = window.center;
    loadingView.backgroundColor = [UIColor grayColor];
    loadingView.clipsToBounds = YES;

    
    //菊花
    UIActivityIndicatorView * juhuaView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [juhuaView startAnimating];
    juhuaView.center = CGPointMake(50, 50);
    [loadingView addSubview:juhuaView];
    [backView addSubview:loadingView];
    


}
//初始化旋转view
+ (void)initRonateIndicatorView{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
   // window = [(ZBAppDelegate*)[UIApplication sharedApplication].delegate window];
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }
    
    STBezierView  * loadingView = [[STBezierView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    loadingView.layer.cornerRadius = 10;
    loadingView.clipsToBounds = YES;
    loadingView.center = window.center;
    loadingView.backgroundColor = [UIColor grayColor];

    
  
      
    [backView addSubview:loadingView];
    [window addSubview:backView];
    
}
//一闪而过的提示
+ (void)initTitleIndicatorView:(NSString*)title delay:(NSInteger)delay{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
    //window = [(ZBAppDelegate*)[UIApplication sharedApplication].delegate window];
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }
    
    UILabel  * loadingLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    loadingLable.layer.cornerRadius = 3;
    loadingLable.center = window.center;
    loadingLable.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1];
    loadingLable.textColor = UIColorFromRGB(0x333333);
    loadingLable.font = [UIFont systemFontOfSize:16];
    loadingLable.text = title;
    loadingLable.numberOfLines = 0;
    loadingLable.textAlignment = NSTextAlignmentCenter;
    loadingLable.clipsToBounds = YES;
    CGFloat maxWitdh = UIScreenWidth - 100;
    if ([title st_widthWithheight:16 font:16] > maxWitdh) {
        
        loadingLable.st_width = maxWitdh + 20;
        loadingLable.st_height = [title st_heigthWithwidth:maxWitdh font:16] + 3;
        loadingLable.center = window.center;
        
    }
    else
    {
        loadingLable.st_width = [title st_widthWithheight:16 font:16] + 5;
        loadingLable.center = window.center;
    }
    [backView addSubview:loadingLable];
    [window addSubview:backView];
    
 

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [backView removeFromSuperview];
    });
}
@end
