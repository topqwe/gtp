

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface RewResultPopUpView : UIView
@property (nonatomic, strong) DynamicsModel* configModel;
@property (nonatomic, strong) NSString * text0;
@property (nonatomic, strong) NSString * text1;
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)richElementsInViewWithModel:(id)model WithConfig:(id)configModel WithTModel:(NSInteger)tModel;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
