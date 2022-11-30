//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface HomeVM : NSObject

//这里也可以用代理回调网络请求
- (void)network_getHomeListWithPage:(NSInteger)page success:(void(^)(NSArray *dataArray, NSArray * _Nonnull lastSectionArr, NSArray * _Nonnull lastSectionSumArr))success failed:(DataBlock)failed;

- (void)network_getTrendsListWithPage:(NSInteger)page success:(void(^)(NSArray *dataArray))success failed:(void(^)(void))failed;
@end

NS_ASSUME_NONNULL_END
