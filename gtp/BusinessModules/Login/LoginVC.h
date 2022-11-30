//
//  LoginVC.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
- (void)actionBlock:(ActionBlock)block;
@end

@interface VertifyVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
- (void)actionBlock:(ActionBlock)block;
@end
NS_ASSUME_NONNULL_END
