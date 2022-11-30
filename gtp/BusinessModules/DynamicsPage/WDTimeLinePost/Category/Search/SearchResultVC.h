//
//  MineVC.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwemeSearchCell.h"
#import "AwemeLVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchResultVC : BaseVC
@property (nonatomic, assign) AwemeType                         awemeType;
@property(nonatomic,assign)BOOL isFromSF;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams isFromSF:(BOOL)isFromSF success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
