//
//  STNavigationController.h
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import <UIKit/UIKit.h>
/************解决rootViewController出发滑动手势卡死，必须重新出发才生效******************/
@interface STNavigationController : UINavigationController

@end
/************解决透明模式设置颜色有色差******************/
@interface UINavigationBar (STColor)
- (void)st_setBackgroundColor:(UIColor *)backgroundColor;
- (void)st_hideShadowImageOrNot:(BOOL)bHidden;
@end

