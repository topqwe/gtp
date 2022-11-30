//
//  GHGlobalMacro.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#ifndef KLGlobalMacro_h
#define KLGlobalMacro_h

#define UIColorFromRGBA(v)  [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
//无广告模式 1 无 0 有
#define NOLIMITMODE  0
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define ios11  ([UIDevice currentDevice].systemVersion.floatValue > 11.0)

#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenFrame  [UIScreen mainScreen].bounds
#define UINavigationBarHeight 64


#define TM_firstTextColor       UIColorFromRGBA(0x333333)
#define TM_secendTextColor      UIColorFromRGBA(0x666666)
#define TM_thirdTextColor       UIColorFromRGBA(0x999999)
#define TM_lineColor            UIColorFromRGBA(0xd9d9d9)
#define TM_backgroundColor      UIColorFromRGBA(0xf1f2f7)

#define TM_redColor             UIColorFromRGBA(0xf03611)
#define TM_grayBackGroundColor  UIColorFromRGBA(0xB3B3B3)
#define TM_BlueBackGroundColor   UIColorFromRGBA(0x2a92ea)
#define TM_BlackBackGroundColor UIColorFromRGBA(0x1a1a1a)
#define TM_placeHoderImage      [UIImage new]
//主题色
#define TM_ThemeBackGroundColor  UIColorFromRGBA(0xA36AD8)
#define TM_YellowBackGroundColor  UIColorFromRGBA(0xF56187)
#define TM_YellowTitleGroundColor  UIColorFromRGBA(0xF6A520)

#define TM_scrollViewBackGroundColor  UIColorFromRGBA(0x24282B)
#define TM_HomeTableViewCollor  [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]

#define TM_PAGE_DIC     \
[paramDic setObject:@(self.page) forKey:@"page"];\
[paramDic setObject:@"100" forKey:@"page_size"];\

#define pageNum  10

#endif /* KLGlobalMacro_h */

