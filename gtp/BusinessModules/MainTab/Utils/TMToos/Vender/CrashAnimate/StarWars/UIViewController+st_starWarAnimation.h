//
//  UIViewController+st_starWarAnimation.h
//  blanket
//
//  Created by Mac on 2018/11/20.
//  Copyright © 2018 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarWarAnimationViewController.h"
#import "BannerVideo-Swift.h"
@interface UIViewController (st_starWarAnimation)
//更换rootViewControler
- (void)st_rootViewControllerChangeAnimationToViewController:(UIViewController*)toViewController completion:(void(^)(void))completion;
//pop
- (void)st_showNavgationControllerpopAnimationToRoot:(BOOL)toroot completion:(void(^)(void))completion;
//dismis
- (void)st_showDismissAnimationCompletion:(void(^)(void))completion;
@end
