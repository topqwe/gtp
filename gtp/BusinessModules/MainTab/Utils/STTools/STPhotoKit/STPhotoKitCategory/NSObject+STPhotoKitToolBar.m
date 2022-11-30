//
//  NSObject+STPhotoKitToolBar.m
//  blanket
//
//  Created by Mac on 2018/1/11.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "NSObject+STPhotoKitToolBar.h"
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define KIsiPhoneX (TMUtils.isIphoneX)
@implementation NSObject (STPhotoKitToolBar)
- (CGFloat)navgationBarBootom{
    if (KIsiPhoneX) {
        return 88;
    }
    
    return 64;
}
- (CGFloat)tabBarTop{
    if (KIsiPhoneX) {
        return (UIScreenHeight - 83);
    }
    return (UIScreenHeight - 49);
}
@end
