//
//  FSPageView.m
//  DJMusic
//
//  Created by Mac on 2018/8/13.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import "STPageView.h"
#define pageControlNormalHeight 30
@interface STPageView()<FSPagerViewDataSource,FSPagerViewDelegate>

@end
@implementation STPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    return self;
}
- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray{
    _imageUrlArray = imageUrlArray;
    [self.pagerView reloadData];
    self.pageControl.numberOfPages = self.imageArray.count;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
     [self.pagerView reloadData];
    self.pageControl.numberOfPages = self.imageArray.count;
}
- (void)setUrlPlaceHolderImage:(UIImage *)urlPlaceHolderImage{
    _urlPlaceHolderImage = urlPlaceHolderImage;
     [self.pagerView reloadData];
}
- (void)setAnimationType:(FSPagerViewTransformerType)animationType{
    _animationType = animationType;
    self.pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:animationType];
    switch (animationType) {
        case FSPagerViewTransformerTypeCrossFading:
        case FSPagerViewTransformerTypeZoomOut:
        case FSPagerViewTransformerTypeDepth: {
            self.pagerView.itemSize = CGSizeZero; // 'Zero' means fill the size of parent
            break;
        }
        case FSPagerViewTransformerTypeLinear:
        case FSPagerViewTransformerTypeOverlap: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            break;
        }
        case FSPagerViewTransformerTypeFerrisWheel:
        case FSPagerViewTransformerTypeInvertedFerrisWheel: {
            self.pagerView.itemSize = CGSizeMake(180, 140);
            break;
        }
        case FSPagerViewTransformerTypeCoverFlow: {
            self.pagerView.itemSize = CGSizeMake(220, 170);
            break;
        }
        case FSPagerViewTransformerTypeCubic: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            break;
        }
        default:
            break;
    }
    [self.pagerView reloadData];
}
- (void)setAutoMoveDuring:(CGFloat)autoMoveDuring{
    _autoMoveDuring = autoMoveDuring;
    self.pagerView.automaticSlidingInterval = autoMoveDuring;
}
- (void)setStyleIndex:(NSInteger)styleIndex
{
    _styleIndex = styleIndex;
    // Clean up
    [self.pageControl setStrokeColor:nil forState:UIControlStateNormal];
    [self.pageControl setStrokeColor:nil forState:UIControlStateSelected];
    [self.pageControl setFillColor:nil forState:UIControlStateNormal];
    [self.pageControl setFillColor:nil forState:UIControlStateSelected];
    [self.pageControl setImage:nil forState:UIControlStateNormal];
    [self.pageControl setImage:nil forState:UIControlStateSelected];
    [self.pageControl setPath:nil forState:UIControlStateNormal];
    [self.pageControl setPath:nil forState:UIControlStateSelected];
    switch (styleIndex) {
        case 0: {
            // Default
            break;
        }
        case 1: {
            // Ring
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor greenColor] forState:UIControlStateSelected];
            break;
        }
        case 2: {
            // UIImage
            [self.pageControl setImage:[UIImage imageNamed:@"adver_seelcted"] forState:UIControlStateNormal];
            [self.pageControl setImage:[UIImage imageNamed:@"adver_unseelcted"] forState:UIControlStateSelected];
            break;
        }
        case 3: {
            // UIBezierPath - Star
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setPath:self.starPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.starPath forState:UIControlStateSelected];
            break;
        }
        case 4: {
            // UIBezierPath - Heart
            UIColor *color = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:255/255.0 alpha:1.0];
            [self.pageControl setStrokeColor:color forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:color forState:UIControlStateSelected];
            [self.pageControl setFillColor:color forState:UIControlStateSelected];
            [self.pageControl setPath:self.heartPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.heartPath forState:UIControlStateSelected];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark --subView
- (void)configSubView{
    self.backgroundColor = UIColor.whiteColor;
    _pagerView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - pageControlNormalHeight)];
    _pagerView.delegate = self;
    _pagerView.dataSource = self;
    self.animationType =  FSPagerViewTransformerTypeLinear;
     self.pagerView.isInfinite = YES;
    [self addSubview:self.pagerView];
    _pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, self.height - pageControlNormalHeight, self.width, pageControlNormalHeight)];
    self.pageControl.numberOfPages = self.imageArray.count;
    self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.pageControl.itemSpacing = 25;
    self.styleIndex = FSPageViewPageControlTypeImage;

    [self addSubview:self.pageControl];
    [self.pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView
{
    if (self.imageUrlArray.count) {
        return self.imageUrlArray.count;
    }
    return self.imageArray.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    if (self.imageUrlArray.count) {
        NSURL * url = [NSURL URLWithString:self.imageUrlArray[index]];
        [cell.imageView sd_setImageWithURL:url placeholderImage:self.urlPlaceHolderImage];
    }else{
        cell.imageView.image = self.imageArray[index];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
    }

    return cell;
}
// ⭐️
- (UIBezierPath *)starPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *starPath = [[UIBezierPath alloc] init];
    [starPath moveToPoint:CGPointMake(width*0.5, 0)];
    [starPath addLineToPoint:CGPointMake(width*0.677, height*0.257)];
    [starPath addLineToPoint:CGPointMake(width*0.975, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.785, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.794, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.5, height*0.8)];
    [starPath addLineToPoint:CGPointMake(width*0.206, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.215, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.025, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.323, height*0.257)];
    [starPath closePath];
    return starPath;
}

// ❤️
- (UIBezierPath *)heartPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *heartPath = [[UIBezierPath alloc] init];
    [heartPath moveToPoint:CGPointMake(width*0.5, height)];
    [heartPath addCurveToPoint:CGPointMake(0, height*0.25)
                 controlPoint1:CGPointMake(width*0.5, height*0.75)
                 controlPoint2:CGPointMake(0, height*0.5)];
    [heartPath addArcWithCenter:CGPointMake(width*0.25, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addArcWithCenter:CGPointMake(width*0.75, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addCurveToPoint:CGPointMake(width*0.5, height)
                 controlPoint1:CGPointMake(width, height*0.5)
                 controlPoint2:CGPointMake(width*0.5, height*0.75)];
    [heartPath closePath];
    return heartPath;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
    if (_onSelectedBannerHandle) {
        _onSelectedBannerHandle(index);
    }
}
- (void)pagerViewDidScroll:(FSPagerView *)pagerView
{
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
        if (self.scrollDidScroll) {
            self.scrollDidScroll(pagerView.currentIndex);
        }
    }
}

- (void)forceReloadData{
    [self.pagerView reloadData];
}


@end
