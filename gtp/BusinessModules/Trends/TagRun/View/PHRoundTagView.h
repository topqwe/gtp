//
//  PHRoundTagView.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "PHLockClick.h"
#import "UIControl+ClickControl.h"
#define ROUND_ADD_TAG  999999
#define LINE_ADD_TAG  888888
#define LABEL_ADD_TAG  777777


@interface PHRoundTagView : UIView
@property (nonatomic,strong) PHLockClick *aLockList;
-(instancetype)initWithFrame:(CGRect)frame withRoundWidthHeight:(CGFloat)roundWH withContentLabelHeight:(CGFloat)contentLabelHeight withRoundHorizonRangeToContent:(CGFloat)horizonRange withContenLabelSpace:(CGFloat)contentLabelSpace withTitleArray:(NSArray*)titleArray  isHidePerforativeLineView:(BOOL)isHidenLine;

+(UIView *)creatRoundTagViewWithFrame:(CGRect)frame withRoundWidthHeight:(CGFloat)roundWH withContentLabelHeight:(CGFloat)contentLabelHeight withRoundHorizonRangeToContent:(CGFloat)horizonRange withContenLabelSpace:(CGFloat)contentLabelSpace withTitleArray:(NSArray*)titleArray isHidePerforativeLineView:(BOOL)isHidenLine;
@end
