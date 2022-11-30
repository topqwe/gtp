
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SlotAnimateView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *diamondImg;

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLab;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLab;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, copy) NSMutableArray *iconUrlArray;
@property (nonatomic, assign) NSInteger selectedIndex;

+ (SlotAnimateView *)customView;

- (void)setupOneAnimationView;

@end

NS_ASSUME_NONNULL_END
