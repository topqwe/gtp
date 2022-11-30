//
//  collectionAndQuiltModel.m
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//

#import "CollectionAndQuiltModel.h"

@implementation CollectionAndQuiltCellData
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID":@"id",
             };
}
@end

@implementation CollectionAndQuiltData
+(NSDictionary *)objectClassInArray{
    return @{
             @"list":[CollectionAndQuiltCellData class],
             };
}
@end

@implementation CollectionAndQuiltModel

@end

