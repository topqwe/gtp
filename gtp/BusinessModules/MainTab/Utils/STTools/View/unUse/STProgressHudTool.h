//
//  STProgressHudManger.h
//  ZuoBiao
//
//  Created by stoneobs on 17/3/17.
//  Copyright © 2017年 shixinyun. All rights reserved.
//  自定义Hud

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, STProgressHudStyle) {
    STProgressHudStyleActivityIndicator = 0,//菊花指示器
    STProgressHudStyleRonateIndicator,//无限旋转指示器
    
};
@interface STProgressHudTool : NSObject

+ (void)showDefultHud;

+ (void)showProgressHudWithStyle:(STProgressHudStyle)style;

+ (void)hideCureentProgressHud;

+ (void)showProgressHudWithTitle:(NSString*)title delay:(NSInteger)deleay;
@end
