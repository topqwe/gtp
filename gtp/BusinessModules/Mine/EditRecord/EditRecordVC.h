//
//  ViewController.h
//  pod_test
//
//  Created by YY_ZYQ on 2017/5/17.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRecordVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(EditRecordSource )requestParams success:(DataBlock)block;

@end

