//
//  SJVideoPlayerTopControlView.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/11/29.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerTopControlView.h"
#import "SJUIFactory.h"
#import "SJVideoPlayerControlMaskView.h"
#import "UIView+SJVideoPlayerSetting.h"
#import "SJAttributeWorker.h"

@interface SJVideoPlayerTopControlView ()

@property (nonatomic, strong, readonly) SJVideoPlayerControlMaskView *controlMaskView;
@property (nonatomic, strong, readonly) UIButton *backBtn;
@property (nonatomic, strong, readonly) UIButton *previewBtn;
@property (nonatomic, strong, readonly) UIButton *moreBtn;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, copy, readwrite) NSString *title;

@end

@implementation SJVideoPlayerTopControlView
@synthesize controlMaskView = _controlMaskView;
@synthesize backBtn = _backBtn;
@synthesize previewBtn = _previewBtn;
@synthesize moreBtn = _moreBtn;
@synthesize titleLabel = _titleLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _topSetupViews];
    [self _topSettingHelper];
    _model = [SJVideoPlayerTopControlModel new];
    return self;
}

- (CGSize)intrinsicContentSize {
    if ( _model.fullscreen ) {
        return CGSizeMake(SJScreen_Max(), 72);
    }
    else {
        return CGSizeMake(SJScreen_Min(), 55);
    }
}

- (void)setModel:(SJVideoPlayerTopControlModel *)model {
    _model = model;
    [self update];
}

- (void)update {
    [self invalidateIntrinsicContentSize];
    if ( self.model.fullscreen ) [self _fullscreenState];
    else [self _smallscreenState];
}

- (void)_fullscreenState {
    // back btn
    self.backBtn.hidden = NO;

    // title label layout
    self.title = self.model.title;
    if ( self.model.playOnCell && self.model.alwaysShowTitle ) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_backBtn.mas_trailing);
            make.centerY.equalTo(_backBtn);
            make.trailing.equalTo(_previewBtn.mas_leading);
        }];
    }
    
    // preview btn
    if ( [self.delegate hasBeenGeneratedPreviewImages] ) self.previewBtn.hidden = NO;
    
    // more btn
    self.moreBtn.hidden = NO;
}

- (void)_smallscreenState {
    self.title = self.model.title;
    if ( self.model.playOnCell && self.model.alwaysShowTitle ) {
        // back btn
        _backBtn.hidden = YES;
        
        // title label layout
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_backBtn.mas_centerX).offset(-8);
            make.centerY.equalTo(_backBtn);
            make.trailing.equalTo(_moreBtn.mas_centerX).offset(8);
        }];
    }
    else {
        _backBtn.hidden = NO;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_backBtn.mas_trailing);
            make.centerY.equalTo(_backBtn);
            make.trailing.equalTo(_previewBtn.mas_leading);
        }];
    }
    
    // preview btn
    self.previewBtn.hidden = YES;
    
    // more btn
    self.moreBtn.hidden = YES;
}

- (void)setTitle:(NSString *)title {
    if ( [title isEqualToString:_title]  ) return;
    _title = title;
    NSAttributedString *attrStr = nil;
    if ( 0 != title.length ) {
        attrStr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
            make.font(self.titleLabel.font).textColor(self.titleLabel.textColor);
            make.insert(title, 0);
            make.shadow(CGSizeMake(0.5, 0.5), 1, [UIColor blackColor]);
        });
    }
    _titleLabel.attributedText = attrStr;
}

- (void)clickedBtn:(UIButton *)btn {
    if ( ![_delegate respondsToSelector:@selector(topControlView:clickedBtnTag:)] ) return;
    [_delegate topControlView:self clickedBtnTag:btn.tag];
}

- (void)_topSetupViews {
    [self addSubview:self.controlMaskView];
    [self addSubview:self.backBtn];
    [self addSubview:self.previewBtn];
    [self addSubview:self.moreBtn];
    [self addSubview:self.titleLabel];
    
    [_controlMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_controlMaskView.superview);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(49);
        make.leading.bottom.offset(0);
    }];
    
    [_previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.bottom.equalTo(_backBtn);
        make.trailing.equalTo(_moreBtn.mas_leading).offset(-8);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.bottom.equalTo(_backBtn);
        make.trailing.offset(-8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_backBtn.mas_trailing);
        make.centerY.equalTo(_backBtn);
        make.trailing.equalTo(_previewBtn.mas_leading);
    }];
    
    self.moreBtn.hidden = self.previewBtn.hidden = YES;
}

- (UIButton *)backBtn {
    if ( _backBtn ) return _backBtn;
    _backBtn = [SJUIButtonFactory buttonWithImageName:nil target:self sel:@selector(clickedBtn:) tag:SJVideoPlayerTopViewTag_Back];
    return _backBtn;
}

- (UIButton *)previewBtn {
    if ( _previewBtn ) return _previewBtn;
    _previewBtn = [SJUIButtonFactory buttonWithTitle:nil titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] backgroundColor:nil target:self sel:@selector(clickedBtn:) tag:SJVideoPlayerTopViewTag_Preview];
    return _previewBtn;
}

- (UIButton *)moreBtn {
    if ( _moreBtn ) return _moreBtn;
    _moreBtn = [SJUIButtonFactory buttonWithImageName:nil target:self sel:@selector(clickedBtn:) tag:SJVideoPlayerTopViewTag_More];
    return _moreBtn;
}

- (UILabel *)titleLabel {
    if ( _titleLabel ) return _titleLabel;
    _titleLabel = [UILabel new];
    return _titleLabel;
}

- (SJVideoPlayerControlMaskView *)controlMaskView {
    if ( _controlMaskView ) return _controlMaskView;
    _controlMaskView = [[SJVideoPlayerControlMaskView alloc] initWithStyle:SJMaskStyle_top];
    return _controlMaskView;
}

#pragma mark -
- (void)_topSettingHelper {
    __weak typeof(self) _self = self;
    self.settingRecroder = [[SJVideoPlayerControlSettingRecorder alloc] initWithSettings:^(SJVideoPlayerSettings * _Nonnull setting) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.backBtn setImage:setting.backBtnImage forState:UIControlStateNormal];
        [self.moreBtn setImage:setting.moreBtnImage forState:UIControlStateNormal];
        if ( setting.previewBtnImage ) {
            [self.previewBtn setImage:setting.previewBtnImage forState:UIControlStateNormal];
        }
        else {
            [self.previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        }
        self.titleLabel.font = setting.titleFont;
        self.titleLabel.textColor = setting.titleColor;
        if ( 0 != self.title.length ) self.title = self.title;
    }];
}
@end


@implementation SJVideoPlayerTopControlModel
@end
