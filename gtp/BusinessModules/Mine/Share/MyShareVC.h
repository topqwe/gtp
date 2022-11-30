//
//  MineVC.h

#import <UIKit/UIKit.h>
#import "ChatListController.h"
#import "MineVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyShareVC : BaseVC
@property (nonatomic, strong) HomeModel* myModel;
@property (nonatomic, assign) NSInteger requestParams;
- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid;
- (void)actionBlock:(ActionBlock)ablock;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(NSInteger)requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
