//
//  STError.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STError : NSObject
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDictionary *resp;
- (id)initWithCode:(NSInteger )code;

- (id)initWithCode:(NSInteger )code andDesc:(NSString *)desc;

- (NSString *)description;
@end
