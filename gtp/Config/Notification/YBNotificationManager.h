//
//  YBNotificationManager.h
//  Created by WIQ on 2018/12/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXTERN NSString * const kNotify_NetWorkingStatusRefresh;

FOUNDATION_EXTERN NSString * const kNotify_IsLoginRefresh;
FOUNDATION_EXTERN NSString * const kNotify_LevRefresh;
FOUNDATION_EXTERN NSString * const kNotify_DesMovieTimer;
extern NSString* const kIsLogin;
extern NSString* const kUserName;
extern NSString* const kUserPW;
extern NSString* const kUserInfo;

extern NSString* const kPayMethodesInPostAds;
extern NSString* const kFixedAccountsInPostAds;

extern NSString* const kIndexSection;
extern NSString* const kIndexInfo;
extern NSString* const kIndexRow;
extern NSString* const kIndexHeight;

extern NSString* const kType ;
extern NSString* const kIsOn ;
extern NSString* const kImg;
extern NSString* const kTit;
extern NSString* const kSubTit;
extern NSString* const kAmount;
extern NSString* const kDate;
extern NSString* const kTotal;
extern NSString* const kColor;
extern NSString* const kUrl;
extern NSString* const kArr;
extern NSString* const kData;

typedef NS_ENUM(NSUInteger,BannerType){
    BannerTypeZero = 0 ,
    BannerTypeVideo  ,
    BannerTypeH5,
    BannerTypeJumpPW  ,
    BannerTypeForV,
    BannerTypeForB
};
typedef NS_ENUM(NSUInteger,SearchRecordSource){
    SearchRecordSourceWords = 0 ,
    SearchRecordSourceTags
};

typedef NS_ENUM(NSUInteger,EditRecordSource){
    EditRecordSourceAvatar = 0 ,
    EditRecordSourceNickName,
    EditRecordSourceGender,
    EditRecordSourcePhoneNumber,
    EditRecordSourceEmail,
    EditRecordSourcViewHistory,
    EditRecordSourcMyCollect
};

typedef NS_ENUM(NSUInteger,IndexSectionUIStyle){
    IndexSectionUIStyleZero = 0 ,
    IndexSectionUIStyleOne ,
    IndexSectionUIStyleTwo ,
    IndexSectionUIStyleThree ,
    IndexSectionUIStyleFour ,
    IndexSectionUIStyleFive ,
    IndexSectionUIStyleSix ,
    IndexSectionUIStyleSeven ,
    IndexSectionUIStyleEight ,
    IndexSectionUIStyleNine ,
    IndexSectionUIStyleTen ,
};
typedef NS_ENUM(NSUInteger,IndexSectionType){
    IndexSectionMinusOne = 0 ,
    IndexSectionZero  ,
    IndexSectionOne ,
    IndexSectionTwo ,
    IndexSectionThree ,
    IndexSectionFour ,
    IndexSectionFive ,
};
typedef NS_ENUM(NSUInteger,EnumActionTag){
    EnumActionTag0 = 0 ,
    EnumActionTag1  ,
    EnumActionTag2  ,
    EnumActionTag3  ,
    EnumActionTag4  ,
    EnumActionTag5  ,
    EnumActionTag6  ,
};

typedef NS_ENUM(NSUInteger,AccountPurseType){
    AccountPurseTypeCash = 0 ,
    AccountPurseTypeCredit ,
    AccountPurseTypeZFB,
    AccountPurseTypeWX ,
    AccountPurseTypeDeposit,
};

typedef NS_ENUM(NSUInteger,AccountingSelectedType){
    AccountingSelectedTypeIncome = 0 ,
    AccountingSelectedTypeOutcome  ,
    AccountingSelectedTypeAllStated  ,
    
    AccountingSelectedTypeAllBalanceTotalStated  ,
    
    AccountingSelectedTypeDayAllStated  ,
    AccountingSelectedTypeDayBalanceTotalStated  ,
    
    AccountingSelectedTypeAllSameSourceBalanceStated ,
    AccountingSelectedTypeMonthSameSourceBalanceStated,
    AccountingSelectedTypeMonthSameDaySameSourceBalanceStated
};

typedef NS_ENUM(NSUInteger,AccountingDistinctionType){
    AccountingDistinctionTypeNone = 0 ,
    AccountingDistinctionTypeDayAllStated  ,
    AccountingDistinctionTypeMonthPie   ,
    
    AccountingDistinctionTypeAllBalanceFromSameSource,
    AccountingDistinctionTypeMonthBalanceFromSameSource
    
};

typedef NS_ENUM(NSUInteger,AccountingType){
    AccountingTypeIncome = 0 ,
    AccountingTypeDiet ,
    AccountingTypeShopping,
    AccountingTypeTrip ,
    AccountingTypeEducation,
    AccountingTypeRecreation,
    AccountingTypeOtherOutcome,
};

typedef NS_ENUM(NSUInteger,AccountingIncomeType){
    AccountingIncomeTypeSalary = 0 ,
    AccountingIncomeTypeInvest ,
    AccountingIncomeTypePartTime,
    AccountingIncomeTypeLivingCost ,
    AccountingIncomeTypeRedPacket,
    AccountingIncomeTypeSecondhand,
    AccountingIncomeTypeDebit,
    AccountingIncomeTypeReimburse,
    AccountingIncomeTypeOther,
};

typedef NS_ENUM(NSUInteger,PostAdsType){
    PostAdsTypeCreate = 0 ,
    PostAdsTypeEdit,
};

typedef NS_ENUM(NSUInteger,PostAdsDetailType){
    PostAdsDetailTypeSuccess = 0 ,
    
};

typedef NS_ENUM(NSUInteger,OrderType){
    OrderTypeWaitDistribute = 0 ,
    OrderTypeAppeal ,
    
    OrderTypeCancel,
    OrderTypeTimeOut,
    
    OrderTypeWaitPay ,
    
    OrderTypeFinished ,
};

typedef NS_ENUM(NSUInteger,ExchangeType){
    ExchangeTypeAll = 0,
    
    ExchangeTypeHandling,
    
    ExchangeTypePayed,
    ExchangeTypeBack,
};

typedef NS_ENUM(NSUInteger, AwemeType) {
    AwemeWork        = 0,
    AwemeFavorite    = 1,
    
    AwemeMain = 2,
    AwemeTargetPush = 3,
    AwemeKeywordPush = 4,
    
    AwemeLivi = 5,
    AwemeLiviPush = 6,
    AwemeCollectPush = 7,
};
NS_ASSUME_NONNULL_BEGIN

@interface YBNotificationManager : NSObject
@end

NS_ASSUME_NONNULL_END
