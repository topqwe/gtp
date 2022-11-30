#import <UIKit/UIKit.h>
#import "TXLaunchMoviePlayProtocol.h"
//#import "AABlock.h"
typedef void (^DataBlock)(id data);
@interface MoviePlayerVC : UIViewController<TXLaunchMoviePlayProtocol>
/** 视频URL */
@property (nonatomic, strong) NSString *videoURL;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block;
- (void)startPlayVideoFromLaunchInfo:(NSDictionary *)launchInfo complete:(void (^)(BOOL succ))complete;


@end
