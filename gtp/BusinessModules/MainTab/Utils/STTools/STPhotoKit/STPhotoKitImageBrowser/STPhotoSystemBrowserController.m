//
//  STPhotoBrowserController.m
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STPhotoSystemBrowserController.h"
#import "STPhotoModel.h"
#import "STBrowserCollectionViewCell.h"
#import <Photos/Photos.h>
#import "UIButton+STPhotoKitSelectedAnimation.h"
#import "STPhotoCollectionViewController.h"
#import "STImagePickerController.h"
#import "UIButton+STPhotoKitSelectedAnimation.h"
#import "NSObject+STPhotoKitToolBar.h"
@interface STPhotoSystemBrowserController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,STBrowserCollectionViewCellDelegate>
@property(nonatomic,strong)UICollectionView                     *collectionView;
@property(nonatomic,strong)NSMutableArray<STPhotoModel*>        *dataSouce;
@property(nonatomic,assign)NSInteger                            curentIndex;//传入进来的照片位置
@property(nonatomic,strong)NSIndexPath                          *curentIndexpath;//当前被浏览的照片位置

//top
@property(nonatomic,strong)UIView                               *topView;
@property(nonatomic,strong)UIButton                             *titleButton;
@property(nonatomic,strong)UIButton                             *chosedButton;

//底部
@property(nonatomic,strong)UIView                               *bootView;//底部bottom
@property(nonatomic,strong)UIButton                             *finshButton;
@property(nonatomic,strong)UIButton                             *numButton;
@property(nonatomic,strong)UIButton                             *originButton;//查看原图

//模态这个vc的控制器
@property(nonatomic,strong)UIView                               *currentView;//当前被放大的view（上一个控制器中的）
@property(nonatomic,strong)UIView                               *whiteView;//动画view,将当前图片变成白色区域
@property(nonatomic,assign)CGPoint                              lastCenter;//上次移动的位置
@property(nonatomic,assign)CGFloat                              scale;//缩放比例
//展示开始动画的时候在collectionview上蒙上一层黑色的view，因为网络太快，或者原图存在的时候，那么在viewDidAppear中会先显示cell中的图片，在进行动画，造成一闪而过，体验不佳,所以添加这个view
@property(nonatomic,strong)UIView                               *beginView;
@end

@implementation STPhotoSystemBrowserController
- (instancetype)initWithArray:(NSArray<STPhotoModel*>*)dataSouce curentIndex:(NSInteger)curentIndex
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (dataSouce.count == 0) {
            NSAssert(NO, @"STPhotoBrowserController数组不能为空");
        }
        if (![dataSouce.firstObject isKindOfClass:[STPhotoModel class]]) {
            NSAssert(NO, @"dataSouce数组中的类型必须是STPhotoModel");
        }
        self.showBottomView = YES;
        self.dataSouce = [NSMutableArray arrayWithArray:dataSouce];
        self.curentIndex = curentIndex;
        self.lastCenter = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);//初始化中心点
        
        
    }
    return self;
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"chosedArray"];
}
#pragma mark --SubView
- (void)initSubviews
{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self navgationBarBootom])];
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.topView.layer.shadowOffset = CGSizeMake(0, 0.8);
    self.topView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.topView.layer.shadowRadius = 1;
    self.topView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.topView .layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.topView.layer.shadowPath = shadowPath;
    
    //返回按钮 -之后点击哪个view就返回到哪个view
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.bottom = self.topView.height;
    [cancelButton setImage:[UIImage imageNamed:@"STPhotoKit.bundle/img_white_back@2x"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didClicReturnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelButton];
    
    //title
    self.titleButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleButton setTitle:@"" forState:UIControlStateNormal];
     self.titleButton.centerY = cancelButton.centerY;
    self.titleButton.centerX = SCREEN_WIDTH/2;
    self.titleButton.backgroundColor = [UIColor clearColor];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.topView addSubview:self.titleButton];
    
    //钩钩按钮
    self.chosedButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-22-20, 0, 22, 22)];
    self.chosedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.chosedButton setTitle:@"" forState:UIControlStateNormal];
     self.chosedButton.centerY = cancelButton.centerY;
    self.chosedButton.backgroundColor = [UIColor clearColor];
    self.chosedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIImage * normalImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STPhotoKit.bundle/STPhotoKitImageSelectedOff"] ofType:@"png"]];
    UIImage * selectedImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STPhotoKit.bundle/STPhotoKitImageSelectedOn"] ofType:@"png"]];
    [self.chosedButton setImage:normalImage forState:UIControlStateNormal];
    [self.chosedButton setImage:selectedImage forState:UIControlStateSelected];
    [self.topView addSubview:self.chosedButton];
    
    
    [self.view addSubview:self.topView];
    
}

- (void)initBottomView
{
    if (!self.showBottomView) {
        return;
    }
    self.bootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  49)];
    self.bootView.layer.shadowOffset = CGSizeMake(0, -0.8);
    self.bootView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bootView.layer.shadowRadius = 1;
    self.bootView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.bootView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.bootView.layer.shadowPath = shadowPath;
    
    [self.bootView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    self.finshButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 - 12, 0, 44, 44)];
    [self.finshButton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    self.finshButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.finshButton setTitle:@"确认" forState:UIControlStateNormal];
    self.finshButton.centerY = 25;
    [self.finshButton addTarget:self action:@selector(didClicTheFinshButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bootView addSubview:self.finshButton];
    
    self.numButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 56 - 24, 0, 26, 26)];
    self.numButton.selected = YES;
    [self.numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.numButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.numButton setTitle:@"0" forState:UIControlStateSelected];
    self.numButton.centerY = 25;
    self.numButton.layer.cornerRadius = 13;
    self.numButton.clipsToBounds = YES;
    [self.numButton setBackgroundColor:BLUE_COLOR];
    self.numButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.bootView addSubview:self.numButton];
    
    //原图按钮
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 200, 44)];
    self.originButton.userInteractionEnabled = YES;
    [self.originButton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [self.originButton setTitle:@"原图" forState:UIControlStateNormal];
    [self.originButton addTarget:self action:@selector(didClicTheOriginButton) forControlEvents:UIControlEventTouchUpInside];
    self.originButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.originButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bootView addSubview:self.originButton];
    
    [self.view addSubview:self.bootView];
    
    self.topView.bottom = 0;
    self.bootView.top = SCREEN_HEIGHT;
    
    
}
#pragma mark --vc生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.chosedButton.selected = self.dataSouce[_curentIndex].isChosed;
    
    UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flow];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor= [UIColor blackColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[STBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    //改在collectionview上面
    [self initSubviews];
    [self initBottomView];
    
    if (self.curentIndex > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [self  addObserver:self forKeyPath:@"chosedArray" options:NSKeyValueObservingOptionNew context:nil];
    //避免第一次进来点击无效
    [self scrollViewDidScroll:self.collectionView];
    [self scrollViewDidEndDecelerating:self.collectionView];

    
    [self.beginView removeFromSuperview];
    self.beginView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    self.beginView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.beginView];
    
  
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //主题色
    if (self.themeColor) {
        [self.finshButton setTitleColor:self.themeColor forState:UIControlStateNormal];
        [self.numButton setBackgroundColor:self.themeColor];
    }
    //底部数字
    self.numButton.hidden = NO;
    [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
    if (self.chosedArray.count == 0) {
        self.numButton.hidden = YES;
    }
    //原图
    if (self.themeColor) {
        [self.originButton setTitleColor:self.themeColor forState:UIControlStateNormal];
       // [self.originButton setTitle:@"原图" forState:UIControlStateNormal];
    }
    


    
    
  
   
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showBeginAnimation];
}

#pragma mark --kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object==self&&[keyPath isEqualToString:@"chosedArray"]) {
        [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
        if (self.chosedArray.count==0) {
            self.numButton.hidden = YES;
            return;
        }
        self.numButton.hidden = NO;
        [self.numButton showSlectedAnimation];
    }
}
//要实现对容器类的监听，就必须实现insert和remove这两个方法
- (void)insertObject:(STPhotoModel *)object inChosedArrayAtIndex:(NSUInteger)index
{
    [self.chosedArray insertObject:object atIndex:index];
    NSLog(@"数组增加了");
}
- (void)removeObjectFromChosedArrayAtIndex:(NSUInteger)index
{
    [self.chosedArray removeObjectAtIndex:index];
    
}
- (void)addChosedArrayObject:(STPhotoModel *)object
{
    [self.chosedArray addObject:object];
    NSLog(@"数组增加了");
}
- (void)removeChosedArrayObject:(STPhotoModel *)object
{
    [self removeChosedArrayObject:object];
    NSLog(@"数组减少了");
}

#pragma --mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouce.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    STBrowserCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    for (UIGestureRecognizer * ges in item.imageView.gestureRecognizers) {
        [item.imageView removeGestureRecognizer:ges];
    }
    item.model = self.dataSouce[indexPath.item];
    item.delegate = self;
    //解决手势冲突
    [item.panGes requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    item.scrollView.delegate = self;
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].requsetID];
    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].originRequsetID];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //试图被移除， 那么删除这个请求，避免多次查看，所有全部进入下载状态
    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].requsetID];
    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].originRequsetID];
    STBrowserCollectionViewCell * mycell = (STBrowserCollectionViewCell*)cell;
    //经过旋转，放大等之后回到初始
    [mycell backToOrigin];
    
}
#pragma --mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //点击手势和cell中的scroleview的手势冲突，所以点击事件用的imageview的手势
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}
#pragma mark --STBrowserCollectionViewCellDelegate

- (void)gestureRecognizerisRuning:(UIGestureRecognizer *)gestureRecognizer
{
    self.topView.hidden = YES;
    self.bootView.hidden = YES;
    UIView * nowView = self.currentView;
    UIPinchGestureRecognizer * sender = (UIPinchGestureRecognizer*)gestureRecognizer;
    CGFloat scale = sender.scale;
    self.collectionView.scrollEnabled = NO;
    
    NSLog(@"begin%f",scale);
    
    if (scale<1) {
        [self.whiteView removeFromSuperview];
        self.whiteView = [[UIView alloc] initWithFrame:nowView.bounds];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.hidden = NO;
        [nowView addSubview:self.whiteView];
    }

    
    [self makeTheCollectionViewUserInterfceCloesed];
    
}
//cell 上手势结束
- (void)gestureRecognizerdidEnd:(UIGestureRecognizer *)gestureRecognizer
{
    self.collectionView.scrollEnabled = YES;
    UIPinchGestureRecognizer * sender = (UIPinchGestureRecognizer*)gestureRecognizer;
    CGFloat scale = sender.scale;
    STBrowserCollectionViewCell *cell = (STBrowserCollectionViewCell*)gestureRecognizer.view.superview.superview;
    cell.imageView.userInteractionEnabled = YES;
    [self makeTheCollectionViewUserInterfceOpened];//开启手势
    
    
    NSLog(@"-最后缩放程度-----%f",scale);
    self.scale = scale;
    if (scale >= 1) {
        self.topView.hidden = NO;
        self.bootView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        cell.imageView.center = self.view.center;
    }];
    
    
    
    if (scale < 1) {
        [self showDismisAnimation];
    }
    
    
}
//正在缩放时候的程度
-(void)pinchRecognizerdisScale:(CGFloat)scale
{
    
    NSLog(@"缩放------%f",scale);
    if (scale  <  1) {
        self.collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scale];
    }
    else
    {
        
        self.collectionView.backgroundColor = [UIColor blackColor];
    }
    
    
    
    
}
//移动时候点；
-(void)panRecognizerPoint:(CGPoint)center
{
    
    
    self.lastCenter = center;
    NSLog(@"center 最后%@", NSStringFromCGPoint(self.lastCenter));
    
    
}
//点击事件
- (void)didClicTheImageView
{
    [self.whiteView removeFromSuperview];
    self.whiteView = [[UIView alloc] initWithFrame:self.currentView.bounds];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.hidden = NO;
    [self.currentView addSubview:self.whiteView];                                            
    [self showDismisAnimation];
}
#pragma mark --UIScrollViewDeleagte
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //滑动时关闭手势交互,造成位置错乱
    if (scrollView == self.collectionView) {
        [self makeTheCollectionViewUserInterfceCloesed];
    }
    else
    {
        [self makeTheCollectionViewUserInterfceOpened];
        
    }
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        //每次减速完成都 remove一下 蒙层
        [self.whiteView removeFromSuperview];
        //减速完成打开手势交互
        [self makeTheCollectionViewUserInterfceOpened];
        //--之前这段代码在didscroll中
        CGFloat width = scrollView.contentOffset.x;
        NSInteger num = (width + 10) /SCREEN_WIDTH;
        self.curentIndexpath = [NSIndexPath indexPathForRow:num inSection:0];
        if (self.STPhotoSystemBrowserControllerdlegate && [self.STPhotoSystemBrowserControllerdlegate respondsToSelector:@selector(STPhotoSystemBrowserControllerDidScrollToIndexpath:model:)]) {
            self.currentView =  [self.STPhotoSystemBrowserControllerdlegate STPhotoSystemBrowserControllerDidScrollToIndexpath:self.curentIndexpath model:self.dataSouce[_curentIndexpath.item]];
            
        }
        self.chosedButton.selected = self.dataSouce[num].isChosed;
        [self.titleButton setTitle:[NSString stringWithFormat:@"%ld/%ld",num+1,self.dataSouce.count] forState:UIControlStateNormal];
        [self.chosedButton addTarget:self action:@selector(didClicTheChosedButton:) forControlEvents:UIControlEventTouchUpInside];
        //--之前这段代码在didscroll中
        
        STPhotoModel * model = self.dataSouce[_curentIndexpath.item];
        if (model.originImage.size.width > 10) {
            self.originButton.selected = YES;
            [self.originButton setTitle:[NSString stringWithFormat:@"原图(%@)",[self sizeFromImage:model.originImage]] forState:UIControlStateNormal];
        }
        else
        {
            [self.originButton setTitle:@"原图" forState:UIControlStateNormal];
        }
    }
}
#pragma mark --Action Method
//点击确认
- (void)didClicTheFinshButton{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.STPhotoSystemBrowserControllerdlegate && [self.STPhotoSystemBrowserControllerdlegate respondsToSelector:@selector(didClicTheConfimButtonCurrentIndexPath:currentModel:)]) {
            [self.STPhotoSystemBrowserControllerdlegate didClicTheConfimButtonCurrentIndexPath:_curentIndexpath currentModel:self.dataSouce[_curentIndexpath.item]];
        }
    }];
}
//点击导航返回键
- (void)didClicReturnBack{
    
    [self backToLastVC];
    
}
//点击选择按钮
- (void)didClicTheChosedButton:(UIButton * )sender {
    
    if (self.weakNav.maxImageChosed == self.chosedArray.count && !sender.isSelected) {
        //判断最大选取张数
        if (self.weakNav.didChosedMaxImages) {
            self.weakNav.didChosedMaxImages(self.weakNav.maxImageChosed);
        }
        return;
    }
    NSInteger index = self.curentIndexpath.item;
    self.dataSouce[index].isChosed = !self.dataSouce[index].isChosed;
    self.chosedButton.selected = self.dataSouce[index].isChosed;
    STPhotoModel * model = self.dataSouce[index];
    if (self.chosedButton.selected) {
        [self.chosedButton showSlectedAnimation];
        [[self mutableArrayValueForKey:@"chosedArray"] addObject:model];
    }
    else
    {
        NSLog(@"删除钱的数组%ld",self.chosedArray.count);
        [[self mutableArrayValueForKey:@"chosedArray"]removeObject:model];
        NSLog(@"删除后的数组%ld",self.chosedArray.count);
    }
    if (self.STPhotoSystemBrowserControllerdlegate && [self.STPhotoSystemBrowserControllerdlegate respondsToSelector:@selector(didClicTheChosedButtonAtIndexPath:currentModel:)]) {
        [self.STPhotoSystemBrowserControllerdlegate didClicTheChosedButtonAtIndexPath:_curentIndexpath currentModel:self.dataSouce[_curentIndexpath.item]];
    }
    
    
}
//点击原图按钮
- (void)didClicTheOriginButton{
    
    self.originButton.selected = !self.originButton.selected;
    if (self.originButton.selected) {
        //请求大图
        
        STPhotoModel * model = self.dataSouce[_curentIndexpath.item];
        if (model.originImage.size.width > 10) {
            return;
        }
        else{
            
            PHAsset * aset = model.asset;
            PHImageRequestOptions *originRequestOptions = [[PHImageRequestOptions alloc] init];
            originRequestOptions.networkAccessAllowed = YES;
            
            originRequestOptions.progressHandler =  ^(double progress, NSError * error, BOOL *stop, NSDictionary * info){
                NSLog(@"正在被请求%f",progress);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * title = [NSString stringWithFormat:@"正在请求%0.2f%%",progress];
                    [self.originButton setTitle:title forState:UIControlStateNormal];
                });

            };
            model.originRequsetID = [[PHImageManager defaultManager] requestImageForAsset:aset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:originRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                if (downloadFinined) {
                    model.originImage = result;
                    [self.collectionView reloadItemsAtIndexPaths:@[_curentIndexpath]];
                    [self.originButton setTitle:[NSString stringWithFormat:@"原图(%@)",[self sizeFromImage:model.originImage]] forState:UIControlStateNormal];
                    
                }
                
            }];
            
            
        }
    }
    
    
    
}
#pragma mark --Private Method
//退出控制器，之后添加动画
-(void)backToLastVC
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        [self showDismisAnimation];
        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissedFormSTPhotoSystemBrowserController" object:self.curentIndexpath];
    }];
    
}
//电池
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)bottomAndTopViewAnimation{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.topView.top = 0;
         self.bootView.top = [self tabBarTop] ;
    }];
    
}
//开始动画
- (void)showBeginAnimation{
    
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    
    
    UIImage    * nowImage;
    if ([self.currentView isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView*)self.currentView;
        nowImage = imageView.image;
        
    }
    if ([self.currentView isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton*)self.currentView;
        nowImage = button.currentBackgroundImage;
    }
    //      CGSize  imageSize = mycell.imageView.image.size;
    //    CGFloat kuangaobi = imageSize.width/imageSize.height;
    //    double height = SCREEN_WIDTH  / (kuangaobi);
    //    CGSize size = CGSizeMake(SCREEN_WIDTH, height);
    
    CGRect originframe = [_currentView convertRect:_currentView.bounds toView:self.view.window];
    UIImageView *  animationImageView = [[UIImageView alloc] initWithFrame:originframe];
    animationImageView.image = nowImage;//如果这里直接获取大图来进行动画，大图3兆左右会造成动画延迟,原因是计算大小时间太长
    animationImageView.clipsToBounds = YES;
    animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.beginView addSubview:animationImageView];
    
    //动画展示0.4
    CGFloat duration = 0.6;
    
    //        [UIView animateWithDuration:duration animations:^{
    //
    //
    //            animationImageView.frame = SCREEN_FRAME;
    //            animationImageView.center = self.view.center;
    //            self.collectionView.alpha = 1;
    //
    //
    //
    //
    //        }  completion:^(BOOL finished) {
    //            mycell.imageView.hidden = NO;
    //
    //            [animationImageView removeFromSuperview];
    //            [self bottomAndTopViewAnimation];
    //        }];
    
    //use spring
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
        animationImageView.frame = SCREEN_FRAME;
        animationImageView.center = self.view.center;
        
    } completion:^(BOOL finished) {
        //         mycell.imageView.hidden = NO;
        [animationImageView removeFromSuperview];
        [self.beginView removeFromSuperview];
        [self bottomAndTopViewAnimation];
    }];
    
    
    
    
    
}
//退出动画
-(void)showDismisAnimation
{
    
    self.topView.hidden = YES;
    self.bootView.hidden = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    STBrowserCollectionViewCell * mycell = (STBrowserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:_curentIndexpath];
    mycell.imageView.hidden = YES;
    CGSize  imageSize = mycell.imageView.image.size;
    
    NSLog(@"imagesize %@",NSStringFromCGSize(imageSize));
    //    NSLog(@"imageviewsize %@",NSStringFromCGSize(mycell.imageView.size));
    [mycell backToOrigin];
    
    CGRect frame ;
    if (imageSize.width > SCREEN_WIDTH) {
        CGFloat kuangaobi = imageSize.width/imageSize.height;
        frame = CGRectMake(0, 0, SCREEN_WIDTH*self.scale, SCREEN_WIDTH * self.scale / kuangaobi);
    }
    else
    {
        frame = CGRectMake(0, 0, imageSize.width*self.scale, imageSize.height*self.scale);
        
    }
    //改变frame 成 cell 的放大比例
    CGFloat heightScal = frame.size.width / (SCREEN_WIDTH/4);
    frame.size = CGSizeMake(SCREEN_WIDTH/4  * heightScal, frame.size.height);
    if (frame.size.width == 0 || frame.size.height == 0) {
        frame = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2);//没有进行过缩放等手势直接点击退出
    }
    UIImageView *  animationImageView = [[UIImageView alloc] initWithFrame:frame];
    animationImageView.center = self.lastCenter;
    animationImageView.image = self.dataSouce[self.curentIndexpath.row].thumbImage;;
    animationImageView.clipsToBounds = YES;
    //animationImageView.backgroundColor = [UIColor redColor];
    animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    [[UIApplication sharedApplication].keyWindow addSubview:animationImageView];
    
    //动画展示
    CGFloat duration = 0.3;
    UIView * nowView = self.currentView;
    [UIView animateWithDuration:duration animations:^{
        if (nowView) {
            
            CGRect frame = [nowView convertRect:nowView.bounds toView:self.view.window];
            animationImageView.frame = frame;
            
            
        }
        else
        {
            animationImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
            animationImageView.alpha = 0.1;
            animationImageView.center = self.view.center;
            
            
        }
        
    } completion:^(BOOL finished) {
        [animationImageView removeFromSuperview];
        [self.whiteView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.STPhotoSystemBrowserControllerdlegate && [self.STPhotoSystemBrowserControllerdlegate respondsToSelector:@selector(didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:currentModel:)]) {
                [self.STPhotoSystemBrowserControllerdlegate didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:self.curentIndexpath currentModel:self.dataSouce[_curentIndexpath.item]];
            }
        }];
    }];
    
    
}

//获取图片大小
- (NSString *)sizeFromImage:(UIImage*)image{
    //如果一个7兆左右的原比例转换，这个方法会消耗0.5秒的时间，所以0.1比例， 最后* 10
    NSData * data = UIImageJPEGRepresentation(image,0.1);
    CGFloat  lengthKB = [data length]/1024 * 7 ;//看似0.1倍，7最合适
    
    if (lengthKB < 1024) {
        return [NSString stringWithFormat:@"%0.02fk",lengthKB];
    }
    else
    {
        CGFloat lengthMb = lengthKB/1024;
        return [NSString stringWithFormat:@"%0.02fM",lengthMb];
        
        
    }
    
}
//开启手势交互
- (void)makeTheCollectionViewUserInterfceOpened{
    
    NSArray<STBrowserCollectionViewCell*> *cells = [self.collectionView visibleCells];
    for (STBrowserCollectionViewCell * cell in cells) {
        cell.imageView.userInteractionEnabled = YES;
    }
}
//关闭手机交互
- (void)makeTheCollectionViewUserInterfceCloesed{
    
    NSArray<STBrowserCollectionViewCell*> *cells = [self.collectionView visibleCells];
    for (STBrowserCollectionViewCell * cell in cells) {
        cell.imageView.userInteractionEnabled = NO;
    }
}
@end
