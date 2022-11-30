//
//  ZBActionSheet.m
//  ZuoBiao
//
//  Created by stoneobs on 2017/3/29.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "STActionSheet.h"
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define ST_BUTTON_HEIGHT 55.f
@interface STActionSheet(){
    
    NSArray *_buttonTitles;
    UIView *_backgroundView;
    UIView *_bottomView;
    __weak  id <STActionSheetDelegate> _delegate;
    
}
@property (nonatomic, strong) UIWindow *backgroundWindow;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *buttonTitlesArray;



@end

@implementation STActionSheet
+ (instancetype)actionSheetWithTitle:(NSString *)title
                        buttonTitles:(NSArray *)buttonTitles
                         cancelTitle:(NSString *)cancelTitle
                            delegate:(id <STActionSheetDelegate>)delegate{
    
    return [[self alloc] initWithTitle:title
                          buttonTitles:buttonTitles
                           cancelTitle:cancelTitle
                              delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                  cancelTitle:(NSString *)cancelTitle
                     delegate:(id <STActionSheetDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        
        CGFloat leftPadding = 0.f;//按钮左间距
        CGFloat seperateLineLeftPadding = 0.f;//分割线的左间距
        
        //背景视图
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onTapBackgroundView:)];
        [backgroundView addGestureRecognizer:tapGestureRecognizer];
        
        // 所有按钮的底部view
        UIView *bottomView = [[UIView alloc] init];
        [bottomView setBackgroundColor:UIColorFromRGBA(0xf1f2f7)];
        [self addSubview:bottomView];
        _bottomView = bottomView;
        
        if (title.length) {
            // 标题
            UILabel *label = [[UILabel alloc] init];
            [label setText:title];
            [label setTextColor:UIColorFromRGBA(0x333333)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
            [label setTextColor:UIColorFromRGBA(0x999999)];
            //1.5 优化，title font 14 ，颜色999999
            [label setFont:[UIFont systemFontOfSize:14.0f]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setFrame:CGRectMake(0, 0, UIScreenWidth - 2*leftPadding, ST_BUTTON_HEIGHT)];
            label.numberOfLines = 0;
            [bottomView addSubview:label];
            self.titleLabel = label;
        }
        if (buttonTitles.count) {
            _buttonTitles = buttonTitles;
            self.buttonTitlesArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < buttonTitles.count; i++) {
                // 所有按钮
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTag:i];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:buttonTitles[i] forState:UIControlStateNormal];
                [[btn titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
                
                [btn setTitleColor:UIColorFromRGBA(0x333333) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnY = ST_BUTTON_HEIGHT * (i + (title ? 1 : 0));
                [btn setFrame:CGRectMake(0, btnY, UIScreenWidth-2*leftPadding, ST_BUTTON_HEIGHT)];
                [bottomView addSubview:btn];
                [self.buttonTitlesArray addObject:btn];
            }
            for (int i = 0; i < buttonTitles.count; i++) {
                // 所有线条
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                //坐标1.5 优化，颜色e0e4e5
                line.backgroundColor = UIColorFromRGBA(0xE0E4E5);
                [line setContentMode:UIViewContentModeCenter];
                CGFloat lineY = (i + (title ? 1 : 0)) * ST_BUTTON_HEIGHT;
                [line setFrame:CGRectMake(seperateLineLeftPadding, lineY, UIScreenWidth - 2 * seperateLineLeftPadding, 0.5f)];
                [bottomView addSubview:line];
            }
        }
        // 取消按钮
        CGFloat topPadding = 10.f;
        NSString *cancelBtnTitle = @"取消";
        if (cancelTitle) {
            cancelBtnTitle = cancelTitle;
        }
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTag:buttonTitles.count];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        [[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
        [cancelBtn setTitleColor:UIColorFromRGBA(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnY = ST_BUTTON_HEIGHT * (buttonTitles.count + (title ? 1 : 0)) + topPadding;
        [cancelBtn setFrame:CGRectMake(0, btnY, UIScreenWidth-2*leftPadding, ST_BUTTON_HEIGHT)];
        [bottomView addSubview:cancelBtn];
        CGFloat bottomH = (title ? ST_BUTTON_HEIGHT : 0) + ST_BUTTON_HEIGHT * buttonTitles.count + ST_BUTTON_HEIGHT + topPadding;
        [bottomView setFrame:CGRectMake(leftPadding, UIScreenHeight, UIScreenWidth-2*leftPadding, bottomH)];
        [self setFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.backgroundWindow addSubview:self];
        self.cancleButton = cancelBtn;
        
    }
    return self;
}

#pragma mark - Getters
- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar;
        _backgroundWindow.backgroundColor = [UIColor clearColor];
        _backgroundWindow.hidden = NO;
    }
    return _backgroundWindow;
}

#pragma mark - Action Methods
- (void)onTapBackgroundView:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _backgroundView.alpha = 0.0f;
        _backgroundView.userInteractionEnabled = NO;
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        self.backgroundWindow.hidden = YES;
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(actionSheetdidClickedBackGroundAction:)]) {
            [_delegate actionSheetdidClickedBackGroundAction:self];
        }
    }];
}

- (void)onClickButton:(UIButton *)sender{
    [self onTapBackgroundView:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:sender.tag];
    }
}

- (void)onClickCancelButton:(UIButton *)sender{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _backgroundView.alpha = 0.0f;
        _backgroundView.userInteractionEnabled = NO;
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        self.backgroundWindow.hidden = YES;
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            [_delegate actionSheet:self didClickedButtonAtIndex:_buttonTitles.count];
        }
    }];
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    self.titleLabel.textColor = titleColor;
}

- (void)setButtonColor:(UIColor *)color index:(NSInteger)index{
    if (self.buttonTitlesArray.count
        && index <= self.buttonTitlesArray.count) {
        
        UIButton *btn = (UIButton *)self.buttonTitlesArray[index];
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
}

- (void)show{
    self.backgroundWindow.hidden = NO;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        // _backgroundView.alpha = 0.6f;
        _backgroundView.userInteractionEnabled = YES;
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:nil];
}

@end

