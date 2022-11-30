//
//  STError.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STError.h"

@implementation STError
- (id)initWithCode:(NSInteger)code andDesc:(NSString *)desc{
    if (self == [super init]) {
        self.code = code;
        self.desc = desc;
    }
    return self;
}
- (id)initWithCode:(NSInteger)code{
    if (self == [super init]) {
        self.code = code;
    }
    return self;
}
@end
