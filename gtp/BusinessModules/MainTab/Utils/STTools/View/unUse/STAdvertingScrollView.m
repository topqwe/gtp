//
//  STAdvertingScrollView.m
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.


#import "STAdvertingScrollView.h"
#import "UIButton+WebCache.h"
/************会在最后插入一个imageVIew 造成无限轮播的假象******************/
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface STAdvertingScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong)NSTimer                          *timer;
@property(nonatomic,strong)NSMutableArray<UIImageView*>     *imageViwArray;
@property(nonatomic,copy)  STAdvertingScrollViewHandle      action;
@property(nonatomic,strong)UIScrollView                     *scrollView;
@end
@implementation STAdvertingScrollView
- (instancetype)initWithFrame:(CGRect)frame andWithArray:(NSArray<NSString *> *)array handle:(STAdvertingScrollViewHandle)handle
{
    if (self = [super initWithFrame:frame]) {
        self.time = 2;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = YES;
        self.canAutoScroll = NO;
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.imageViwArray = [NSMutableArray new];
        self.action = handle;
        self.dataSouce = array;
       
        
        __weak typeof(self) weakSelf =self;
        self.pageControll = [[STPageControl alloc] initWithPages:array.count handle:^(NSInteger tag) {
            [weakSelf scrollViewDidEndDragging:weakSelf.scrollView willDecelerate:YES];
            [weakSelf.scrollView setContentOffset:CGPointMake(tag * weakSelf.scrollView.frame.size.width, 0) animated:YES];
        }];
        [self addSubview:self.pageControll];
        
    }
    return self;
}
- (void)removeFromSuperview
{
    [self invideTimer];
    [super removeFromSuperview];
}
#pragma mark --Geter And Setter
- (void)setHidden:(BOOL)hidden
{
    
    if (hidden) {
          [self invideTimer];
    }else{
        self.time = self.time;
    }
   
    [super setHidden: hidden];
}
- (void)setTime:(NSTimeInterval)time
{
    if (time) {
        _time = time;
         [self invideTimer];
        self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
}
- (void)setCanAutoScroll:(BOOL)canAutoScroll
{
    if (canAutoScroll) {
         [self invideTimer];
        _canAutoScroll = canAutoScroll;
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else{
        [self invideTimer];
    }
}
- (void)setDataSouce:(NSArray *)dataSouce
{
    _dataSouce = dataSouce;
    self.time = self.time;
    self.pageControll.numberOfPages = dataSouce.count;
    self.pageControll.currentPage = 0 ;
    if (self.canInfiniteScroll) {
        NSString * imageName = dataSouce.firstObject;
        NSMutableArray * nowDataSouce = [dataSouce mutableCopy];
        [nowDataSouce addObject:imageName];
        _dataSouce = nowDataSouce;
    }
    [self configSubView];
    
    
}
- (void)setImageUrlsArray:(NSArray *)imageUrlsArray
{
    _imageUrlsArray = imageUrlsArray;
    self.pageControll.numberOfPages = imageUrlsArray.count;
    self.pageControll.currentPage = 0 ;
    self.dataSouce = imageUrlsArray;
    for (int i = 0; i < self.dataSouce.count; i ++) {
        [self.imageViwArray[i] sd_setImageWithURL:[NSURL URLWithString:_dataSouce[i]] placeholderImage:_placeholderImage];
    }
    
}
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    for (int i = 0; i< self.dataSouce.count; i++) {
        [self.imageViwArray[i] sd_setImageWithURL:[NSURL URLWithString:_dataSouce[i]] placeholderImage:_placeholderImage];
    }
    
}
#pragma mark --subView
- (void)configSubView{
    self.imageViwArray = [NSMutableArray new];
    //移除之前的
    for (UIView * view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.dataSouce.count, 0) ;
    if (@available(iOS 11.0, *)) {
        [self.scrollView setContentInsetAdjustmentBehavior:@(2)];
    } else {
        // Fallback on earlier versions
    }
    //NSLog(@"%f",self.scrollView.contentSize.width);
    for (int i=0; i< self.dataSouce.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10000 + i;
        imageView.image = [UIImage imageNamed:self.dataSouce[i]];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelctedImageView:)];
        [imageView addGestureRecognizer:tapGes];
        [self.scrollView addSubview:imageView];
        [self.imageViwArray addObject:imageView];
        
    }
}



#pragma mark --Action Method
- (void)timerAction{
    CGPoint offSet = self.scrollView.contentOffset;
    CGFloat imageViewWith = self.scrollView.frame.size.width;
    offSet = CGPointMake(offSet.x + imageViewWith, 0);
    [self.scrollView setContentOffset:offSet animated:YES];
}
- (void)onSelctedImageView:(UITapGestureRecognizer*)ges
{
    if (self.dataSouce.count == 0) {
        return;
    }
    UIImageView * imageView = (id)ges.view;
    NSLog(@"%lu",imageView.tag);
    if (self.action) {
        self.action(imageView.tag);
    }
}
#pragma mark --Private Method
- (void)invideTimer{
    [self.timer invalidate];
    self.timer = nil;
}
//给与合适的offset
- (void)adjustOffset{
    NSInteger num = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    if (num == (self.dataSouce.count -1)  && self.canInfiniteScroll){
        CGPoint  offSet = CGPointMake(0 , 0);
        [self.scrollView setContentOffset:offSet animated:NO];
        self.pageControll.currentPage = 0;
    }
}
#pragma mark -----UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        [self invideTimer];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.scrollView) {
        if (self.timer) {
            [self invideTimer];
        }
        if (self.canAutoScroll) {
            self.timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        }

        [self adjustOffset];
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self adjustOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        NSInteger num = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageControll.currentPage = num;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self adjustOffset];
    }
}
@end


//---pageControl  ----------------
@interface STPageControl()
@property(nonatomic,copy)STPageControlHandle           handle;
@end
@implementation STPageControl

-(instancetype)initWithPages:(NSInteger)numberOfPages handle:(STPageControlHandle)handle
{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 10*numberOfPages + 5 * (numberOfPages-1), 10);
        self.numberOfPages = numberOfPages;
        self.currentPage = 0;
        self.backgroundColor = [UIColor clearColor];
        if (handle) {
            self.handle = handle;
        }
    }
    return self;
}
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.superview) {
        self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height - 25);
    }
    for (NSInteger i =0; i<numberOfPages; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i*4 + 10* i, 3, 4, 4)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i+1;
        view.layer.cornerRadius = 2;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSlectedPageControl:)];
        [view addGestureRecognizer:tap];
        
        [self addSubview:view];
    }
    _numberOfPages = numberOfPages;
}
-(void)didSlectedPageControl:(UITapGestureRecognizer*)sender
{
    if (self.handle) {
        self.handle(sender.view.tag - 1);
    }
    
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    for (UIView * view in self.subviews) {
        if (view.tag!=self.currentPage+1) {
            //未选中状态
            
            view.backgroundColor = pageIndicatorTintColor;
        }
        else
        {
            //选中状态
            if (_currentPageIndicatorTintColor) {
                view.backgroundColor = _currentPageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor orangeColor];
            }
            
        }
    }
    _pageIndicatorTintColor = pageIndicatorTintColor;
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    
    for (UIView * view in self.subviews) {
        if (view.tag   == self.currentPage+1) {
            view.backgroundColor = currentPageIndicatorTintColor;
        }
        else
        {
            //未选中状态
            if (_pageIndicatorTintColor) {
                view.backgroundColor = _pageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor whiteColor];
            }
            
        }
    }
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(void)setCurrentPage:(NSInteger)currentPage
{
    for (UIView * view in self.subviews) {
        if (view.tag == (currentPage  + 1) ) {
            //选中状态
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 7, 7);
            view.layer.cornerRadius = 3.5;
            view.center = CGPointMake(view.center.x, self.frame.size.height/2);
            if (_currentPageIndicatorTintColor) {
                view.backgroundColor = _currentPageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor orangeColor];
            }
        }
        else
        {
            //未选中状态
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 4, 4);
            view.layer.cornerRadius = 2;
            view.center = CGPointMake(view.center.x, self.frame.size.height/2);
            if (_pageIndicatorTintColor) {
                view.backgroundColor = _pageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor whiteColor];
            }
            
        }
    }
    
    _currentPage = currentPage;
}

@end

