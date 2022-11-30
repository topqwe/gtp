//
//  YBGeneralColor.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBGeneralColor.h"

@implementation YBGeneralColor

+ (UIColor *)themeColor {
    return RGBCOLOR(29,113,217);

}

+ (UIColor *)navigationBarColor {
//    return RGBCOLOR(29,113,217);
    return kWhiteColor;
}

+ (UIColor *)navigationBarTitleColor {
//    return [UIColor whiteColor];
    return [UIColor darkTextColor];
}

+ (UIColor *)tabBarTitleNormalColor {
//    return [UIColor darkGrayColor];
    return HEXCOLOR(0x8FAEB7);
}

+ (UIColor *)tabBarTitleSelectedColor {
//    return COLOR_RGB(86,129,247,1);
    return HEXCOLOR(0xff4598);
}

+ (UIColor *)seperaterColor {
    return [UIColor groupTableViewBackgroundColor];
}

@end
