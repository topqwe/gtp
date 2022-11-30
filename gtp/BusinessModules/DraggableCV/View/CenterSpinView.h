//
//  CenterSpinView.h
//  PLLL
//
//  Created by TNM on 7/06/2020.
//  Copyright © 2020 PLLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterSpinView : UIView

- (void)actionBlock:(ActionBlock)block;
+ (CGFloat)cellHeightWithModel;
- (void)richElementsInCellWithModel:(NSDictionary*)model;
@end
