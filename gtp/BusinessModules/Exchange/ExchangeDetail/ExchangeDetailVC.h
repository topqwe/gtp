//
//  OrderDetailVC.h


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeDetailVC : UIViewController
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
