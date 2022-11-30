//
//  WDTimeLineImageSelectCell.m
//  TimeLine
//
//  Created by Unique on 2019/10/30.
//  Copyright © 2019 Unique. All rights reserved.
//

#import "WDTimeLineImageSelectCell.h"
#import <Masonry.h>
#import "IntroPopUpView.h"
@interface WDTimeLineImageSelectCell ()<HXPhotoViewDelegate>
@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) HXPhotoManager *manager;
@property(nonatomic, strong) UIButton *introBtn;
@end

@implementation WDTimeLineImageSelectCell
- (void)danmakuShow:(UIButton*)sender{
    NSArray* arr = @[
        @[
            @"说明："
        ]
    ];
    IntroPopUpView* popupView = [[IntroPopUpView alloc]init];
    [popupView richElementsInViewWithModel:arr WithConfig:nil];
    [popupView showInApplicationKeyWindow];
    [popupView actionBlock:^(NSNumber* data) {
//        if ([data integerValue] == 0) {
//            [self activityAdView];
//
//        }else{
//        }
    }];
}
- (UIButton *)introBtn {
    if (!_introBtn) {
        _introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_introBtn setTitle:@"说明" forState:UIControlStateNormal];
        _introBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_introBtn setTitleColor:YBGeneralColor.themeColor forState:0];
        [_introBtn addTarget:self action:@selector(danmakuShow:) forControlEvents:UIControlEventTouchUpInside];
        _introBtn.selected = YES;
        _introBtn.hidden = YES;
        
//        _danmakuBtn.backgroundColor = YBGeneralColor.themeColor;
        _introBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        _danmakuBtn.layer.masksToBounds = YES;
//        _danmakuBtn.layer.cornerRadius = 30/2;
    }
    return _introBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.introBtn];
        [_introBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.trailing.mas_equalTo(self.contentView).inset(25);
    //            make.left.equalTo(self);
            make.width.mas_equalTo(90);
            make.height.equalTo(@30);
        }];
        
        self.photoView = [HXPhotoView photoManager:self.manager];
        self.photoView.lineCount = 3;
        self.photoView.delegate = self;
        self.photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
        [self.photoView goPhotoViewController];
        [self.contentView addSubview:self.photoView];
        
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.leading.trailing.mas_equalTo(self.contentView).inset(25);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

//- (void)photoViewChangeComplete:(HXPhotoView *)photoView allAssetList:(NSArray<PHAsset *> *)allAssetList photoAssets:(NSArray<PHAsset *> *)photoAssets videoAssets:(NSArray<PHAsset *> *)videoAssets original:(BOOL)isOriginal {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSelectCell:didChangePhotoAssets:didChangeVideoAssets:)]) {
//        [self.delegate imageSelectCell:self didChangePhotoAssets:photoAssets didChangeVideoAssets:videoAssets];
//    }
//}
- (void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSelectCell:didChangePhotos:didChangeVideos:)]) {
        [self.delegate imageSelectCell:self didChangePhotos:photos didChangeVideos:videos];
    }
}
#pragma mark - Lazy
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.photoMaxNum = 9;
//        _manager.configuration.type = HXConfigurationTypeWXChat;
//        _manager.configuration.videoMaximumDuration = 300;
        _manager.configuration.videoMaximumDuration = 10;
//        60* 355;
        _manager.configuration.videoMaximumSelectDuration = 10;
//        60* 355;
        _manager.configuration.maxVideoClippingTime = _manager.configuration.videoMaximumSelectDuration;
        _manager.configuration.selectVideoBeyondTheLimitTimeAutoEdit = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _manager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
