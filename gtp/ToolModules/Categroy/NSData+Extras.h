//
//  NSData+MM.h
//  PregnancyHelper
//
//  Created by Chen Yaoqiang on 14-3-19.
//  Copyright (c) 2014年 ShengCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extras)
- (NSString *)newStringInBase64FromData;
- (NSString *)toString;
- (id)jsonValue;
- (NSString *)utf8String;

@end
