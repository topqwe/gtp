//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineVM : NSObject
- (void)network_postPWCode:(id)res WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray))success failed:(DataBlock)failed;
- (void)network_postPW:(NSArray*)arr WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_postQueryLevelWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_postFinalLevelMethodSureWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed;

- (void)network_postLevelMethodSureWithRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_getLevelMethodWithRequestParams:(id)requestParams  success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed;
- (void)network_getLevelInfoWithRequestParams:(id)requestParams  success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed;
- (void)network_getLevelInfoWithRequestParams:(id)requestParams  success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed;
-(void)network_getUserExtendInfoWithRequestParams:(id)requestParams  success:(void(^)(HomeModel *model))success failed:(DataBlock)failed;
-(void)network_postBindInviteCodeWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                             failed:(DataBlock)failed;
- (void)network_postShareWithRequestParams:(id)requestParams  success:(void(^)(HomeModel *model))success failed:(DataBlock)failed;

-(void)network_postEditUserInfosWithRequestParams:(id)requestParams WithSource:(EditRecordSource)s
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed;

- (void)network_getDeteleEditRecord:(NSArray*)arr WithSource:(EditRecordSource)s success:(void(^)(NSArray *dataArray))success failed:(DataBlock)failed;

- (void)network_getEditRecordPage:(NSInteger)page WithSource:(EditRecordSource)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;


@end

NS_ASSUME_NONNULL_END
