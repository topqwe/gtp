//
//  TabContentView.m
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/29.
//  Copyright © 2018年 张小明. All rights reserved.
//

#import "TabContentView.h"

@interface TabContentView()
@property (nonatomic,strong)UIScrollView *sv;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) NSInteger index;
@end
@implementation TabContentView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}


-(void)initView{
    _pageController=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageController.delegate = self;
    _pageController.dataSource = self;
    _pageController.view.frame=self.bounds;
    __block UIScrollView *scrollView = nil;
    [_pageController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]])
        {
            scrollView = (UIScrollView *)obj;
        }
        
    }];
    if (scrollView ) {
        
        scrollView.delegate = self;
        _sv = scrollView;
    }
    [self addSubview:_pageController.view];
}

#pragma mark -- UIGestureRecognizerDelegate

-(void)configParam:(NSMutableArray<UIViewController *> *)controllers Index:(NSInteger)index block:(TabSwitchBlcok)tabSwitch{
    
    _tabSwitch=tabSwitch;
    _controllers=controllers;
    _tabSwitch=tabSwitch;
    //默认展示的第一个页面
    [_pageController setViewControllers:[NSArray arrayWithObject:[self pageControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)updateTab:(NSInteger)index{
    NSLog(@"updateTab---%lu",index);
    //默认展示的第一个页面
    [_pageController setViewControllers:[NSArray arrayWithObject:[self pageControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _index = index;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    _pageController.view.frame=self.bounds;
}

//返回下一个页面
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index= [_controllers indexOfObject:viewController];
    if(index==(_controllers.count-1)){
        return nil;
    }
    index++;
    return [self pageControllerAtIndex:index];
}
//返回前一个页面
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //判断当前这个页面是第几个页面
    NSInteger index=[_controllers indexOfObject:viewController];
    //如果是第一个页面
    if(index==0){
        
        return nil;
    }
    index--;
    return [self pageControllerAtIndex:index];
    
}

//根据tag值创建内容页面
-(UIViewController*)pageControllerAtIndex:(NSInteger)index{
    
    return [_controllers objectAtIndex:index];
    
}
//结束滑动的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    NSLog(@"didFinishAnimating firstIndexFinalScroll");
    NSInteger index=[_controllers indexOfObject:pageViewController.viewControllers[0]];
    _tabSwitch(index);
    _index = index;
    
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
//拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ([scrollView isEqual:_sv]) {
//        if(_sv.contentOffset.x< MAINSCREEN_WIDTH){
//            self.block(@(_sv.contentOffset.x));
//        }
//
//        return;
//    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_sv]) {
        
        if(_sv.contentOffset.x< MAINSCREEN_WIDTH&&_index ==0){//375
            if (self.block) {
                self.block(@(_sv.contentOffset.x));
            }
            
        }
        return;
        
    }
    
}
//开始滑动的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSLog(@"pageViewController");

    
}




@end
