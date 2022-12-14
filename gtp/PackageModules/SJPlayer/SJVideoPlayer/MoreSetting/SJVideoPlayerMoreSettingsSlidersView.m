//
//  SJVideoPlayerMoreSettingsSlidersView.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2018/2/5.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerMoreSettingsSlidersView.h"
#import "SJButtonSlider.h"
#import <Masonry/Masonry.h>
#import "SJUIFactory.h"
#import "UIView+SJVideoPlayerSetting.h"

@interface SJVideoPlayerMoreSettingsSlidersView ()<SJSliderDelegate>

@property (nonatomic, strong, readonly) SJButtonSlider *rateSlider;
@property (nonatomic, strong, readonly) SJButtonSlider *volumeSlider;
@property (nonatomic, strong, readonly) SJButtonSlider *brightnessSlider;

@end

@implementation SJVideoPlayerMoreSettingsSlidersView

@synthesize volumeSlider = _volumeSlider;
@synthesize brightnessSlider = _brightnessSlider;
@synthesize rateSlider = _rateSlider;

+ (CGFloat)itemHeight {
    return 60;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(ceil(SJScreen_Max() * 0.382), [[self class] itemHeight] * 3);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _footerSetupViews];
    [self _footerSettings];
    return self;
}

- (void)setModel:(SJMoreSettingsSlidersViewModel *)model {
    _model = model;
    __weak typeof(self) _self = self;
    
    if ( model.initialBrightnessValue ) self.brightnessSlider.slider.value = model.initialBrightnessValue();
    if ( model.initialVolumeValue ) self.volumeSlider.slider.value = model.initialVolumeValue();
    if ( model.initialPlayerRateValue ) self.rateSlider.slider.value = model.initialPlayerRateValue();
    
    model.volumeChanged = ^(float volume) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.volumeSlider.slider.isDragging ) return;
        self.volumeSlider.slider.value = volume;
    };
    
    model.brightnessChanged = ^(float brightness) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.brightnessSlider.slider.isDragging ) return;
        self.brightnessSlider.slider.value = brightness;
    };
    
    model.playerRateChanged = ^(float rate) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.rateSlider.slider.isDragging ) return;
        self.rateSlider.slider.value = rate;
    };
}

- (void)_footerSetupViews {
    
    [self addSubview:self.volumeSlider];
    [self addSubview:self.brightnessSlider];
    [self addSubview:self.rateSlider];
    
    
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.brightnessSlider.mas_top);
        make.size.equalTo(self.brightnessSlider);
        make.centerX.equalTo(self.brightnessSlider);
    }];
    
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.equalTo(self);
        make.height.offset([[self class] itemHeight]);
    }];
    
    [self.rateSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.brightnessSlider);
        make.top.equalTo(self.brightnessSlider.mas_bottom);
        make.centerX.equalTo(self.brightnessSlider);
    }];
    
    self.volumeSlider.slider.delegate = self;
    self.brightnessSlider.slider.delegate = self;
    self.rateSlider.slider.delegate = self;
}

- (SJButtonSlider *)volumeSlider {
    if ( _volumeSlider ) return _volumeSlider;
    _volumeSlider = [self slider];
    return _volumeSlider;
}

- (SJButtonSlider *)brightnessSlider {
    if ( _brightnessSlider ) return _brightnessSlider;
    _brightnessSlider = [self slider];
    _brightnessSlider.slider.minValue = 0.1;
    return _brightnessSlider;
}

- (SJButtonSlider *)rateSlider {
    if ( _rateSlider ) return _rateSlider;
    _rateSlider = [self slider];
    _rateSlider.slider.minValue = 0.5;
    _rateSlider.slider.maxValue = 1.5;
    _rateSlider.slider.value = 1.0;
    return _rateSlider;
}

- (SJButtonSlider *)slider {
    SJButtonSlider *slider = [SJButtonSlider new];
    slider.spacing = 4;
    return slider;
}

#pragma mark

- (void)sliderWillBeginDragging:(SJSlider *)slider {
    if ( slider == _rateSlider.slider ) {
        if ( _model.needChangePlayerRate ) _model.needChangePlayerRate(slider.value);
    }
    else if ( slider == _volumeSlider.slider ) {
        if ( _model.needChangeVolume ) _model.needChangeVolume(slider.value);
    }
    else {
        if ( _model.needChangeBrightness ) _model.needChangeBrightness(slider.value);
    }
}

- (void)sliderDidDrag:(SJSlider *)slider {
    if ( slider == _rateSlider.slider ) {
        if ( _model.needChangePlayerRate ) _model.needChangePlayerRate(slider.value);
    }
    else if ( slider == _volumeSlider.slider ) {
        if ( _model.needChangeVolume ) _model.needChangeVolume(slider.value);
    }
    else {
        if ( _model.needChangeBrightness ) _model.needChangeBrightness(slider.value);
    }
}

- (void)sliderDidEndDragging:(SJSlider *)slider {
    if ( slider == _rateSlider.slider ) {
        if ( _model.needChangePlayerRate ) _model.needChangePlayerRate(slider.value);
    }
    else if ( slider == _volumeSlider.slider ) {
        if ( _model.needChangeVolume ) _model.needChangeVolume(slider.value);
    }
    else {
        if ( _model.needChangeBrightness ) _model.needChangeBrightness(slider.value);
    }
}

- (void)_footerSettings {
    __weak typeof(self) _self = self;
    self.settingRecroder = [[SJVideoPlayerControlSettingRecorder alloc] initWithSettings:^(SJVideoPlayerSettings * _Nonnull setting) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.volumeSlider.slider.trackHeight = self.brightnessSlider.slider.trackHeight = self.rateSlider.slider.trackHeight = setting.more_trackHeight;
        self.volumeSlider.slider.trackImageView.backgroundColor = self.brightnessSlider.slider.trackImageView.backgroundColor = self.rateSlider.slider.trackImageView.backgroundColor = setting.more_trackColor;
        self.volumeSlider.slider.traceImageView.backgroundColor = self.brightnessSlider.slider.traceImageView.backgroundColor = self.rateSlider.slider.traceImageView.backgroundColor = setting.more_traceColor;
        
        [self.rateSlider.leftBtn setBackgroundImage:setting.more_minRateImage forState:UIControlStateNormal];
        [self.rateSlider.rightBtn setBackgroundImage:setting.more_maxRateImage forState:UIControlStateNormal];
        [self.volumeSlider.leftBtn setBackgroundImage:setting.more_minVolumeImage forState:UIControlStateNormal];
        [self.volumeSlider.rightBtn setBackgroundImage:setting.more_maxVolumeImage forState:UIControlStateNormal];
        [self.brightnessSlider.leftBtn setBackgroundImage:setting.more_minBrightnessImage forState:UIControlStateNormal];
        [self.brightnessSlider.rightBtn setBackgroundImage:setting.more_maxBrightnessImage forState:UIControlStateNormal];
    }];
}
@end
