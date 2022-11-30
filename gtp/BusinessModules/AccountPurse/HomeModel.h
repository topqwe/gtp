//
//  HomeModel.h
//  LiNiuYang
//
//  Created by WIQ on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WItem : NSObject
@property (nonatomic, copy) NSString * argValue;
@property (nonatomic, copy) NSString * rankingType;
@property (nonatomic, copy) NSString * argName;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;
@end

@interface WData : NSObject
@property (nonatomic, copy) NSArray * rankinglist;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
+(NSDictionary *)objectClassInArray;
@end

@interface HomeItem : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ID;
@end

@interface HomeData : NSObject
@property (nonatomic, copy) NSArray * itemBaseInfoList;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) WData * returnData;
+(NSDictionary *)objectClassInArray;
@end



@interface HomeResult : NSObject
@property (nonatomic, strong) HomeData * data;
@property (nonatomic, copy) NSString*  code;
@property (nonatomic, copy) NSString*  info;
@end


@interface HomeModel : NSObject
@property (nonatomic, copy) NSString * info;
@property (nonatomic, strong) HomeResult * result;

@end
