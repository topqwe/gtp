//
//  ZMCusCommentListView.h
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMCusCommentToolView.h"
#define ZMCusCommentViewTopMargin (MAINSCREEN_WIDTH*9)/16
//(MAINSCREEN_HEIGHT - ((MAINSCREEN_WIDTH*9)/16))
//101
#define ZMCusComentBottomViewHeight YBFrameTool.safeAdjustTabBarHeight
//55

@interface ZMCusCommentListView : UIView
@property (nonatomic, assign) NSInteger s;
@property (nonatomic, strong) HomeItem* item;
- (void)richHeaderText:(NSInteger)s withData:(id)item;
@property (nonatomic, strong) ZMCusCommentToolView *toolView;
@property (nonatomic, copy) void(^sendBtnBlock)(NSString *text);
@property (nonatomic, copy) void(^closeBtnBlock)(void);
@property (nonatomic, copy) void(^titleBtnBlock)(void);
@property (nonatomic, copy) void(^replyBtnBlock)(id data);

@property (nonatomic, copy) void(^scrollBlock)(void);
@end

