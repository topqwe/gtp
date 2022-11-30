//
//  NSString+SHA.h
//  OC-SHA
//
//  Created by 王亮 on 16/12/14.
//  Copyright © 2016年 com.reaal.Dichtbij. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (SHA)
- (NSString *)hmacSHA256WithKey:(NSData *)key;
@end
