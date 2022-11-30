
NS_ASSUME_NONNULL_BEGIN

@interface PNVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(NSInteger )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
