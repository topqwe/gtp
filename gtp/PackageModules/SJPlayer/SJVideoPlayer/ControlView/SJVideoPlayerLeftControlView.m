//
//  SJVideoPlayerLeftControlView.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2018/2/3.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerLeftControlView.h"
#import "UIView+SJVideoPlayerSetting.h"
#import <Masonry/Masonry.h>
#import "SJUIFactory.h"

@interface SJVideoPlayerLeftControlView ()

@property (nonatomic, strong, readonly) UIButton *lockBtn;
@property (nonatomic, strong, readonly) UIButton *unlockBtn;

@end

@implementation SJVideoPlayerLeftControlView

@synthesize lockBtn = _lockBtn;
@synthesize unlockBtn = _unlockBtn;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _leftSetupView];
    [self _leftSettingHelper];
    self.lockState = NO;
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(49, 49);
}

- (void)clickedBtn:(UIButton *)btn {
    if ( ![_delegate respondsToSelector:@selector(leftControlView:clickedBtnTag:)] ) return;
    [_delegate leftControlView:self clickedBtnTag:btn.tag];
}

- (void)setLockState:(BOOL)lockState {
    _lockState = lockState;
    [UIView animateWithDuration:0.25 animations:^{
        if ( lockState ) {
            self.lockBtn.alpha = 1;
            self.unlockBtn.alpha = 0.001;
        }
        else {
            self.lockBtn.alpha = 0.001;
            self.unlockBtn.alpha = 1;
        }
    }];
}

- (void)_leftSetupView {
    [self addSubview:self.lockBtn];
    [self addSubview:self.unlockBtn];
    
    [_lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_lockBtn.superview);
    }];
    
    [_unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_unlockBtn.superview);
    }];
}

- (UIButton *)lockBtn {
    if ( _lockBtn ) return _lockBtn;
    _lockBtn = [SJUIButtonFactory buttonWithImageName:nil target:self sel:@selector(clickedBtn:) tag:SJVideoPlayerLeftViewTag_Lock];
    return _lockBtn;
}

- (UIButton *)unlockBtn {
    if ( _unlockBtn ) return _unlockBtn;
    _unlockBtn = [SJUIButtonFactory buttonWithImageName:nil target:self sel:@selector(clickedBtn:) tag:SJVideoPlayerLeftViewTag_Unlock];
    return _unlockBtn;
}

#pragma mark -
- (void)_leftSettingHelper {
    __weak typeof(self) _self = self;
    self.settingRecroder = [[SJVideoPlayerControlSettingRecorder alloc] initWithSettings:^(SJVideoPlayerSettings * _Nonnull setting) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.lockBtn setImage:setting.lockBtnImage forState:UIControlStateNormal];
        [self.unlockBtn setImage:setting.unlockBtnImage forState:UIControlStateNormal];
    }];
}
@end
