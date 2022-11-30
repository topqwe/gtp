//
//  UIView+STPhotoKitTool.h
//  STNewTools
//
//  Created by stoneobs on 17/3/1.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define FirstTextColor RGB(0x333333)
#define SecendTextColor RGB(0x666666)
#define ThirdTextColor RGB(0x999999)
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)
#define BLUE_COLOR       STRGB(0x7a8fdf)
#define item_COLOR       STRGB(0x8a8fa4)
@interface UIView (STPhotoKitTool)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@end
