//
//  NSString+HMACSHA1.h
//  GoldChampion
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/************HMACSHA1加密******************/
@interface NSString (HMACSHA1)
- (NSString *)hmacsha1Withkey:(NSString *)secret;
@end
