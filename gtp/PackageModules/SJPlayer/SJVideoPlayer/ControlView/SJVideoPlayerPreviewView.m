//
//  SJVideoPlayerPreviewView.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/12/4.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerPreviewView.h"
#import "SJUIFactory.h"
#import <Masonry/Masonry.h>

static NSString *SJVideoPlayerPreviewCollectionViewCellID = @"SJVideoPlayerPreviewCollectionViewCell";

@interface SJVideoPlayerPreviewView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

@implementation SJVideoPlayerPreviewView
@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _previewSetupView];
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = ceil(SJScreen_Min() * 0.25);
    if ( _fullscreen ) return CGSizeMake(SJScreen_Max(), height);
    else return CGSizeMake(SJScreen_Min(), height);
}

- (void)setPreviewImages:(NSArray<id<SJVideoPlayerPreviewInfo>> *)previewImages {
    _previewImages = previewImages;
    [_collectionView reloadData];
}

- (void)setFullscreen:(BOOL)fullscreen {
    _fullscreen = fullscreen;
    [self invalidateIntrinsicContentSize];
}

#pragma mark

- (void)_previewSetupView {
    [self addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}

- (UICollectionView *)collectionView {
    if ( _collectionView ) return _collectionView;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(SJVideoPlayerPreviewCollectionViewCellID) forCellWithReuseIdentifier:SJVideoPlayerPreviewCollectionViewCellID];
    _collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _previewImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJVideoPlayerPreviewCollectionViewCellID forIndexPath:indexPath];
    [cell setValue:_previewImages[indexPath.item] forKey:@"model"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize imageSize = _previewImages.firstObject.image.size;
    CGFloat rate = imageSize.width / imageSize.height;
    CGFloat height = floor(self.intrinsicContentSize.height - (collectionView.contentInset.top + collectionView.contentInset.bottom));
    CGFloat width = floor(rate * height);
    return CGSizeMake( width, height );
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( ![self.delegate respondsToSelector:@selector(previewView:didSelectItem:)] ) return;
    [self.delegate previewView:self didSelectItem:_previewImages[indexPath.item]];
}

@end
