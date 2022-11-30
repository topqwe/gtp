//
//  SlideTabBarView.h
//  SlideTabBar
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSSlideView : UIView

@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;
-(instancetype)initWithFrame:(CGRect)frame WithTabs: (NSArray*) tabTitles;
-(instancetype)initWithFrame:(CGRect)frame WithTabs: (NSArray*) tabTitles withModel:(id)model topSliderBarCentreXLeadSpacing:(CGFloat)leadspacing
topSliderBarHeight:(CGFloat)topSliderBarHeight
sliderLineHeight:(CGFloat)sliderLineHeight
isHiddenTopSliderBarSeparatorLine:(BOOL)isHiddenSLine;

-(void)scrollToIndex:(NSInteger)index;
-(void)fixedScrollToIndex:(NSInteger)index;
@end
