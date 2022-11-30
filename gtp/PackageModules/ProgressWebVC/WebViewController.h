//
//  WebViewController.h
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKProgressLayer.h"

@interface WebViewController : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC req:(NSDictionary* )req withProgressStyle:(DKProgressStyle)style success:(DataBlock)block;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestUrl:(NSString* )requestUrl withProgressStyle:(DKProgressStyle)style success:(DataBlock)block;
@end
