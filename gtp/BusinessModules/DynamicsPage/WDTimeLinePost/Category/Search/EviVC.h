//
//  HomeVC.h
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwemeLVC.h"
#import "MineVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface EviVC : BaseVC
@property (nonatomic, strong) HomeModel* myModel;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
