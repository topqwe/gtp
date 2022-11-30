//
//  SaoleiView.h
//  text
//
//  Created by hanlu on 16/8/1.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaoleiChessView.h"
@class MineClearVC;

@interface SaoleiView : UIView

@property (nonatomic,assign) NSInteger numberOfChessInLine;

@property (nonatomic,assign) NSInteger numberOfChessInList;

@property (nonatomic,weak) MineClearVC *vc;

- (instancetype)initWithFrame:(CGRect)frame NumberOfChessInLine:(NSInteger)numberOfChessInLine NumberOfChessInList:(NSInteger)numberOfChessInList ViewController:(MineClearVC *)vc;

- (SaoleiChessView *)viewWithPostion:(Position *)position;

- (void)getRestarted;

- (void)showAll;

- (void)resetView;

@end
