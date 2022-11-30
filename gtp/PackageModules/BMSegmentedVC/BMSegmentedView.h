//
//  BMSegmentedView.h
//  bigmama
//
//  Created by ganguo on 13-1-29.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMSegmentedView : UIView


/*
 Current selected Index (Either 0 or 1)
 */
@property (nonatomic, assign) NSInteger currentIndex;

/*
 Block that is called everytime index changes
 */
@property (nonatomic, copy) void (^block) (NSInteger currentIndex);

/*
 Text for both Indices
 */
@property (nonatomic, strong) NSString *leftText;
@property (nonatomic, strong) NSString *rightText;

/*
 Label Font
 */
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *titleColor;

//- (void)setLeftText:(NSString *)leftText;
//- (void)setRightText:(NSString *)rightText;
//- (void)setFont:(UIFont *)font;
//- (void)setCurrentIndex:(NSInteger)currentIndex;
- (id)initWithImage:(CGRect)frame leftBgImg:(NSString *)leftBgImg leftSetImg:(NSString *)leftSetImg rightBgImg:(NSString *)rightBgImg rightSetImg:(NSString *)rightSetImg;
- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state;

- (void)setLeftBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setRightBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (void)setLeftImage:(UIImage *)image forState:(UIControlState)state;
- (void)setRightImage:(UIImage *)image forState:(UIControlState)state;
//选择不加时间处理
-(void)setLeftBtnSelected:(BOOL)isLeft;
@end
