//
//  NSDictionary+STProperty.h
//  WorthWhile
//
//  Created by Mac on 2018/9/15.
//  Copyright © 2018年 stoneobs.icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/************将字典 转换成 oc 模型打印 （只到第二级）******************/
@interface NSDictionary (STProperty)
- (void)st_showProperty;
@end
