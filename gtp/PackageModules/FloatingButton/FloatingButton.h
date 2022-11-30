

#import <UIKit/UIKit.h>

@interface FloatingButton : UIButton

@property(nonatomic,weak) UIView *parentView;

/**安全边距，主要是针对有navbar 以及 tabbar的*/
@property(nonatomic,assign)UIEdgeInsets safeInsets;

@end
