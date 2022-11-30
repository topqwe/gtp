//
//  YBFrameTool.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBFrameTool.h"
#import "YBSystemTool.h"

@implementation YBFrameTool

+ (CGFloat)iphoneBottomHeight {
    return IS_iPhoneX ? 34.0 : 0.0;
}

+ (CGFloat)tabBarHeight {
    return [self iphoneBottomHeight] + 49.0;
}

+ (CGFloat)safeAdjustTabBarHeight {
    return [self iphoneBottomHeight] + 49.0;
}


+ (CGFloat)statusBarHeight {
    return IS_iPhoneX ? 44.0 : 20.0;
}

+ (CGFloat)navigationBarHeight {
    return 44.0;
}

+ (CGFloat)safeAdjustNavigationBarHeight {
    return [self statusBarHeight] + [self navigationBarHeight];
}
@end
