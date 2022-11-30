//
//  collectionAndQuiltModel.h
//  TestDemo
//
//  Created by WIQChen on 15/10/31.
//  Copyright © 2015年 WIQChen. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface CollectionAndQuiltCellData : NSObject
@property(assign,nonatomic)NSInteger ID;
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* icon;
+(NSDictionary*)replacedKeyFromPropertyName;
@end
@interface CollectionAndQuiltData : NSObject
@property(strong,nonatomic)NSMutableArray* list;
+(NSDictionary*)objectClassInArray;
@end
@interface CollectionAndQuiltModel : NSObject
@property(strong,nonatomic)CollectionAndQuiltData* data;
@property(assign,nonatomic)NSInteger status;
@end
