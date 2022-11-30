//
//  STPhotoBrowserController.m
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STPhotoUrlImageBrowerController.h"
#import <Photos/Photos.h>
#import "STPhotoCollectionViewController.h"
#import "STImagePickerController.h"
#import "UIButton+STPhotoKitSelectedAnimation.h"
#import "STUrlBrowserCollectionViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "NSObject+STPhotoKitToolBar.h"
//#warning 导入SDWebImage方可使用
//#import "WebImage.h"
@interface STPhotoUrlImageBrowerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,STUrlBrowserCollectionViewCellDelegate>

@property(nonatomic,strong)NSMutableArray<STUrlPhotoModel*>     *dataSouce;
@property(nonatomic,assign)NSInteger                            curentIndex;//传入进来的照片位置
@property(nonatomic,strong)NSIndexPath                          *curentIndexpath;//当前被浏览的照片位置

//top
@property(nonatomic,strong)UIView                               *topView;//顶部view
@property(nonatomic,strong)UIButton                             *titleButton;
@property(nonatomic,strong)UIButton                             *rightButton;
//底部
@property(nonatomic,strong)UIView                               *bootView;//顶部view
@property(nonatomic,strong)UIButton                             *originButton;//查看原图

//模态这个vc的控制器
@property(nonatomic,strong)UIView                               *currentView;//当前被放大的view（上一个控制器中的）
@property(nonatomic,strong)UIView                               *whiteView;//动画view,将当前图片变成白色区域
@property(nonatomic,assign)CGPoint                              lastCenter;//上次移动的位置
@property(nonatomic,assign)CGFloat                              scale;//缩放比例
//展示开始动画的时候在collectionview上蒙上一层黑色的view，因为网络太快，或者原图存在的时候，那么在viewDidAppear中会先显示cell中的图片，在进行动画，造成一闪而过，体验不佳,所以添加这个view
@property(nonatomic,strong)UIView                               *beginView;

@property(nonatomic,assign)BOOL                                  didShowBeginAnimation;//是否展示过了入场动画，展示过就不展示了，当此vc不是最后一个时，应该不显示动画

@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@end

@implementation STPhotoUrlImageBrowerController
- (instancetype)initWithArray:(NSArray<STUrlPhotoModel*>*)dataSouce curentIndex:(NSInteger)curentIndex
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (dataSouce.count == 0) {
            NSAssert(NO, @"STPhotoBrowserController数组不能为空");
        }
        if (![dataSouce.firstObject isKindOfClass:[STUrlPhotoModel class]]) {
            NSAssert(NO, @"dataSouce数组中的类型必须是STPhotoModel");
        }
        self.dataSouce = [NSMutableArray arrayWithArray:dataSouce];
        self.curentIndex = curentIndex;
        self.lastCenter = self.view.center;//初始化中心点
        
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    CGRect shadowFrame = self.topView.layer.bounds;
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
    self.titleButton.bottom = self.topView.height;
    self.titleButton.centerX = SCREEN_WIDTH/2;
    self.titleButton.backgroundColor = [UIColor clearColor];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.topView addSubview:self.titleButton];
    
    //更多按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44-10, 0, 44, 44)];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    self.rightButton.bottom = self.topView.height;
    self.rightButton.backgroundColor = [UIColor clearColor];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIImage * normalImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STPhotoKit.bundle/img_white_more@2x"] ofType:@"png"]];
    UIImage * selectedImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STPhotoKit.bundle/img_white_more@2x"] ofType:@"png"]];
    [self.rightButton setImage:normalImage forState:UIControlStateNormal];
    [self.rightButton setImage:selectedImage forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.rightButton];
    
    
    [self.view addSubview:self.topView];
    
}

- (void)initBottomView
{

    self.bootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tabBarTop] + 49)];
    self.bootView.layer.shadowOffset = CGSizeMake(0, -0.8);
    self.bootView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bootView.layer.shadowRadius = 1;
    self.bootView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.bootView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.bootView.layer.shadowPath = shadowPath;
    
    [self.bootView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    

    //原图按钮
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 200, 20)];
    self.originButton.centerY = 25;
    self.originButton.centerX = self.bootView.width/2;
    [self.originButton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [self.originButton setTitle:@"原图" forState:UIControlStateNormal];
    [self.originButton addTarget:self action:@selector(didClicTheOriginButton) forControlEvents:UIControlEventTouchUpInside];
    self.originButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.originButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
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
    [self.collectionView registerClass:[STUrlBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    //改在collectionview上面
    [self initSubviews];
    [self initBottomView];
    
    if (self.curentIndex > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    



    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.didShowBeginAnimation) {
        return ;
    }
    //原图
    if (self.themeColor) {
        [self.originButton setTitleColor:self.themeColor forState:UIControlStateNormal];
        [self.originButton setTitle:@"原图" forState:UIControlStateNormal];
    }
    
    
    
    self.beginView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    self.beginView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.beginView];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:self.collectionView];
    [self scrollViewDidEndDecelerating:self.collectionView];
    [self showBeginAnimation];
    
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
    
    STUrlBrowserCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    for (UIGestureRecognizer * ges in item.imageView.gestureRecognizers) {
        [item.imageView removeGestureRecognizer:ges];
    }
//    STUrlPhotoModel *model = self.dataSouce[indexPath.item];
    item.model = self.dataSouce[indexPath.item];
    item.delegate = self;
    //解决手势冲突
    [item.panGes requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    item.scrollView.delegate = self;
    
    UILongPressGestureRecognizer * longpressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressAction:)];
    longpressGes.minimumPressDuration = 0.5;
    [item.tapGes requireGestureRecognizerToFail:longpressGes];
    [item.imageView addGestureRecognizer:longpressGes];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //video
        STUrlPhotoModel *model = self.dataSouce[indexPath.item];
        if (model.type == 1) {
            AVPlayerItem *playItem;
            if (model.filePath) {
                 playItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:model.filePath]];
            } else {
                 playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.originImageUrl]];
            }
            // 3.创建AVPlayer
            self.player = [AVPlayer playerWithPlayerItem:playItem];
            // 4.添加AVPlayerLayer
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
            [cell.layer addSublayer:self.playerLayer];
             self.playerLayer.hidden = NO;
            [self addNotification];
             [self.player play];
        }
    
        if (model.type == 1) {
            self.bootView.hidden = YES;
            self.playerLayer.hidden = NO;
        } else {
            self.bootView.hidden = NO;
            self.playerLayer.hidden = YES;
        }
}


-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    STUrlBrowserCollectionViewCell * mycell = (STUrlBrowserCollectionViewCell*)cell;
    //经过旋转，放大等之后回到初始
    [mycell backToOrigin];
    
    
    //cell 将要消失的时候把上一个含有player的 暂停掉
    NSArray *array = [cell.layer sublayers];
    for (CALayer *lay in array) {
        if ([lay isKindOfClass:[AVPlayerLayer class]]) {
            AVPlayerLayer *layer = (AVPlayerLayer *)lay;
            [layer.player pause];
        }
    }
    
}
#pragma --mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //点击手势和cell中的scroleview的手势冲突，所以点击事件用的imageview的手势
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}
#pragma mark --STCollectionViewCellDelegate

- (void)gestureRecognizerisRuning:(UIGestureRecognizer *)gestureRecognizer
{
    self.topView.hidden = YES;
    self.bootView.hidden = YES;
    UIView * nowView = self.currentView;
    UIPinchGestureRecognizer * sender = (UIPinchGestureRecognizer*)gestureRecognizer;
    CGFloat scale = sender.scale;
    self.collectionView.scrollEnabled = NO;
    
    //NSLog(@"begin%f",scale);
    
    [self.whiteView removeFromSuperview];
    self.whiteView = [[UIView alloc] initWithFrame:nowView.bounds];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.hidden = NO;
    [nowView addSubview:self.whiteView];
    
    [self makeTheCollectionViewUserInterfceCloesed];
    
}
//cell 上手势结束
- (void)gestureRecognizerdidEnd:(UIGestureRecognizer *)gestureRecognizer
{
    self.collectionView.scrollEnabled = YES;
    UIPinchGestureRecognizer * sender = (UIPinchGestureRecognizer*)gestureRecognizer;
    CGFloat scale = sender.scale;
    STUrlBrowserCollectionViewCell *cell = (STUrlBrowserCollectionViewCell*)gestureRecognizer.view.superview.superview;
    cell.imageView.userInteractionEnabled = YES;
    [self makeTheCollectionViewUserInterfceOpened];//开启手势
    
    
   // NSLog(@"-最后缩放程度-----%f",scale);
    self.scale = scale;
    if (scale >= 1) {
        self.topView.hidden = NO;
        self.bootView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        cell.imageView.center = self.view.center;
    }];
    
    
    
    if (scale < 0.9) {
        [self showDismisAnimation];
    }
    
    
}
//正在缩放时候的程度
-(void)pinchRecognizerdisScale:(CGFloat)scale
{
    
    //NSLog(@"缩放------%f",scale);
    if (scale  <  0.9) {
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
    //NSLog(@"center 最后%@", NSStringFromCGPoint(self.lastCenter));
    
    
}
//点击事件
- (void)didClicTheImageView
{
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
        if (self.STPhotoUrlImageBrowerControllerdelegate && [self.STPhotoUrlImageBrowerControllerdelegate respondsToSelector:@selector(STPhotoSystemBrowserControllerDidScrollToIndexpath:model:)]) {
            self.currentView =  [self.STPhotoUrlImageBrowerControllerdelegate STPhotoSystemBrowserControllerDidScrollToIndexpath:self.curentIndexpath model:self.dataSouce[_curentIndexpath.item]];
            
        }

        [self.titleButton setTitle:[NSString stringWithFormat:@"%ld/%ld",num+1,self.dataSouce.count] forState:UIControlStateNormal];
 
        //--之前这段代码在didscroll中
        
        STUrlPhotoModel * model = self.dataSouce[_curentIndexpath.item];
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

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    
    
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}


#pragma mark --Action Method
//点击右上角
- (void)rightBarAction{

    if (self.STPhotoUrlImageBrowerControllerdelegate && [self.STPhotoUrlImageBrowerControllerdelegate respondsToSelector:@selector(rightBarActionFromController:currentIndexPath:)]) {
        [self.STPhotoUrlImageBrowerControllerdelegate rightBarActionFromController:self currentIndexPath:self.curentIndexpath];
    }
}
//点击导航返回键
- (void)didClicReturnBack{
    
    [self backToLastVC];
    
}

//点击原图按钮
- (void)didClicTheOriginButton{
    
    self.originButton.selected = !self.originButton.selected;
    if (self.originButton.selected) {
        //请求大图
        
        STUrlPhotoModel * model = self.dataSouce[_curentIndexpath.item];
        if (model.originImage.size.width > 10) {
            return;
        }
        else{
            
          //  STUrlBrowserCollectionViewCell * cell = (STUrlBrowserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.curentIndexpath];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.originImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                model.originImage = image;
                [self.originButton setTitle:[NSString stringWithFormat:@"原图(%@)",[self sizeFromImage:model.originImage]] forState:UIControlStateNormal];
                
                [self.collectionView reloadItemsAtIndexPaths:@[self.curentIndexpath]];
            }];


        
            
            
        }
    }
    
    
    
}
//长按
- (void)didLongPressAction:(UILongPressGestureRecognizer*)ges{

    if (ges.state != UIGestureRecognizerStateBegan) return ;
    STUrlBrowserCollectionViewCell * cell = (STUrlBrowserCollectionViewCell*)ges.view.superview.superview;
    NSIndexPath * indexPath = self.curentIndexpath;
    STUrlPhotoModel * currentModel = self.dataSouce[indexPath.row];
    
    if (self.STPhotoUrlImageBrowerControllerdelegate && [self.STPhotoUrlImageBrowerControllerdelegate respondsToSelector:@selector(didLongPressTheCell:fromVC:currentIndexPath:currentModel:)]) {
        [self.STPhotoUrlImageBrowerControllerdelegate didLongPressTheCell:cell fromVC:self currentIndexPath:indexPath currentModel:currentModel];
    }

}
#pragma mark --Public Method
- (void)reloadData{
    [self.collectionView reloadData];
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
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
    
}
- (void)bottomAndTopViewAnimation{
    
    [UIView animateWithDuration:0.4 animations:^{
        if (!_shouldHideTopView) {
             self.topView.top = 0;
        }
        if (!_shouldHideBottomView) {
             self.bootView.top = [self tabBarTop];
        }
       
       
    }];
    
}
//开始动画
- (void)showBeginAnimation{
    
    if (self.didShowBeginAnimation) {
        return;
    }
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    
    
    UIImage    * nowImage;
    if ([self.currentView isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView*)self.currentView;
        nowImage = imageView.image;
        
    }
    if ([self.currentView isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton*)self.currentView;
        nowImage = button.currentBackgroundImage;
        if (!nowImage) {
            nowImage = button.currentImage;
        }
    }
    //      CGSize  imageSize = mycell.imageView.image.size;
    //    CGFloat kuangaobi = imageSize.width/imageSize.height;
    //    double height = SCREEN_WIDTH  / (kuangaobi);
    //    CGSize size = CGSizeMake(SCREEN_WIDTH, height);
    
    CGRect originframe = [self.currentView convertRect:_currentView.bounds toView:self.view.window];
    UIImageView *  animationImageView = [[UIImageView alloc] initWithFrame:originframe];
    animationImageView.image = nowImage;
    animationImageView.clipsToBounds = YES;
    animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:animationImageView];
    
    //动画展示0.4
    CGFloat duration = 0.4;
    
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
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
        animationImageView.frame = SCREEN_FRAME;
        animationImageView.center = self.view.center;
        
    } completion:^(BOOL finished) {
        //         mycell.imageView.hidden = NO;
        [animationImageView removeFromSuperview];
        self.didShowBeginAnimation = YES;
        [self.beginView removeFromSuperview];
        [self bottomAndTopViewAnimation];
    }];
    
    
    
    
    
}
//退出动画
-(void)showDismisAnimation
{
    if (self.STPhotoUrlImageBrowerControllerdelegate && [self.STPhotoUrlImageBrowerControllerdelegate respondsToSelector:@selector(willDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:currentModel:)]) {
        [self.STPhotoUrlImageBrowerControllerdelegate willDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:self.curentIndexpath currentModel:self.dataSouce[_curentIndexpath.item]];
    }
    self.topView.hidden = YES;
    self.bootView.hidden = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    STUrlBrowserCollectionViewCell * mycell = (STUrlBrowserCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:_curentIndexpath];
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
    animationImageView.image = mycell.imageView.image;
    animationImageView.clipsToBounds = YES;
    //animationImageView.backgroundColor = [UIColor redColor];
    animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    [[UIApplication sharedApplication].keyWindow addSubview:animationImageView];
    
    //动画展示
    CGFloat duration = 0.25;
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
            if (self.STPhotoUrlImageBrowerControllerdelegate && [self.STPhotoUrlImageBrowerControllerdelegate respondsToSelector:@selector(didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:currentModel:)]) {
                [self.STPhotoUrlImageBrowerControllerdelegate didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:self.curentIndexpath currentModel:self.dataSouce[_curentIndexpath.item]];
            }
        }];
    }];
    
    
}

//获取图片大小
- (NSString *)sizeFromImage:(UIImage*)image{
    NSData * data = UIImageJPEGRepresentation(image,1);
    CGFloat  lengthKB = [data length]/1000;//1000最接近
    
    if (lengthKB < 1024) {
        return [NSString stringWithFormat:@"%0.02fk",lengthKB];
    }
    else
    {
        CGFloat lengthMb = lengthKB/1000;
        return [NSString stringWithFormat:@"%0.02fM",lengthMb];
        
        
    }
    
}
//开启手势交互
- (void)makeTheCollectionViewUserInterfceOpened{
    
    NSArray<STUrlBrowserCollectionViewCell*> *cells = [self.collectionView visibleCells];
    for (STUrlBrowserCollectionViewCell * cell in cells) {
        cell.imageView.userInteractionEnabled = YES;
    }
}
//关闭手机交互
- (void)makeTheCollectionViewUserInterfceCloesed{
    
    NSArray<STUrlBrowserCollectionViewCell*> *cells = [self.collectionView visibleCells];
    for (STUrlBrowserCollectionViewCell * cell in cells) {
        cell.imageView.userInteractionEnabled = NO;
    }
}

@end
