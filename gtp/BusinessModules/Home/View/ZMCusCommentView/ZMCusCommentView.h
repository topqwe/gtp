//
//  ZMCusCommentView.h
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCusCommentView : UIView
- (instancetype)initWithFrame:(CGRect)frame withData:(id)item;
- (void)actionBlock:(ActionBlock)block;
@end

@interface ZMCusCommentManager : NSObject
+ (instancetype)shareManager;
- (void)showCommentWithSourceId:(id)sourceId success:(DataBlock)block;
@end
