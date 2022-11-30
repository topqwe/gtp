//
//  HomeLVC.h


#import <UIKit/UIKit.h>

#import "StyleCell1.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeLVC : BaseVC
- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid;
/** 缓存cell高度的数组 */
@property (nonatomic,strong) NSMutableArray *heightArray;
@end

NS_ASSUME_NONNULL_END
