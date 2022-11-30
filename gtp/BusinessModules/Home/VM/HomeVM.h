//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface HomeVM : NSObject
- (void)network_postCRListWithPage:(NSInteger)page WithHomeItem:(HomeItem*)item WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_postCRWithRequestParams:(id)requestParams WithHomeItem:(HomeItem*)item WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed;

- (void)network_getConfigWithPage:(NSInteger)page success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_getSCTagsWithPage:(NSInteger)page didAdd0Data:(BOOL)didAdd0Data didAddLastData:(BOOL)didAddLastData  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getSCPageResultWithPage:(NSInteger)page WithCid:(id)cid withPageClick:(BOOL)isPageClick WithSearchSource:(SearchRecordSource)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getSearchResultWithPage:(NSInteger)page WithCid:(id)cid  WithSearchSource:(SearchRecordSource)s isFromSF:(BOOL)isFromSF success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getHotTagsWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_postClearMyLevelWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_postMyLevelWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_getMyShareWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_postShowFilmWithPage:(NSInteger)page WithFid:(NSInteger)fid success:(void(^)(HomeItem * data))success failed:(TwoDataBlock)failed;
- (void)network_postRecommendWithPage:(NSInteger)page WithHomeItem:(HomeItem*)item success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_postHomeMoreWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getMyMsgHomeListWithPage:(NSInteger)page  success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_postDynamicsDetailWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_postTextWithRequestParams:(id)requestParams WithHomeItem:(HomeItem*)item WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_postMessageWithRequestParams:(id)requestParams WithID:(NSInteger)item WithSource:(NSInteger)s success:(DataBlock)success failed:(DataBlock)failed;
- (void)network_postDynamicsListWithPage:(NSInteger)page WithCid:(id)cid withSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;
- (void)network_getSVListWithPage:(NSInteger)page WithCid:(id)item WithSource:(NSInteger)s success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;


- (void)network_postHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getCategoryWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(DataBlock)failed;

- (void)network_getTrendsListWithPage:(NSInteger)page success:(void(^)(NSArray *dataArray))success failed:(void(^)(void))failed;
- (void)network_getHomeListWithPage:(NSInteger)page WithParams:(id)param success:(void (^)(NSArray * _Nonnull,NSArray * _Nonnull,NSArray * _Nonnull))success failed:(DataBlock)failed;
@end

NS_ASSUME_NONNULL_END
