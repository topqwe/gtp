//
//  ChangeURLEnvironment.h
//  gt
//
//  Created by GT on 2019/3/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeURLEnvironment : NSObject
MACRO_SHARED_INSTANCE_INTERFACE
@property (nonatomic, copy) ActionBlock block;
//切换环境
- (void)changeEnvironment:(ActionBlock)block;

//获得当前环境
- (NSString *)currentEnvironment;


@end

NS_ASSUME_NONNULL_END
