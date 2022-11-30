//
//  PieStatedView.h

#import <UIKit/UIKit.h>
#import "PieView.h"

@interface PieStatedView : UIView
- (void)richEleInView:(id)model;
- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <PieModel*>*)ary;


@end
