//
//  YBNaviagtionViewController.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBNaviagtionViewController : UINavigationController<UINavigationControllerDelegate>
+(UINavigationController *)rootNavigationController;
-(void)setNavBg:(UIColor *)bgColor;
@end

NS_ASSUME_NONNULL_END