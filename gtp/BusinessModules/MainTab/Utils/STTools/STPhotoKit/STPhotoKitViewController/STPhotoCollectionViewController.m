//
//  STPhotoCollectionViewController.m
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STPhotoCollectionViewController.h"
#import "STPhotoCollectionViewCell.h"
#import "STPhotoModel.h"
#import "STPhotoSystemBrowserController.h"
#import "UIButton+STPhotoKitSelectedAnimation.h"
#import "UIView+STPhotoKitTool.h"
#import "STImagePickerController.h"
#import "NSObject+STPhotoKitToolBar.h"
@interface STPhotoCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,STPhotoSystemBrowserControllerDlegate>

@property(nonatomic,strong)NSMutableArray<STPhotoModel*>  *dataSouce;
@property(nonatomic,strong)UIView               *bootView;//底部bottom
@property(nonatomic,strong)UIButton             *finshButton;//完成按钮
@property(nonatomic,strong)UIButton             *numButton;//数量按钮
@property(nonatomic,strong)STPhotoSystemBrowserController            *STPhotoSystemBrowserVC;
@end

@implementation STPhotoCollectionViewController
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"chosedArray"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --Geter And Seter
- (void)setCurentAlbum:(PHFetchResult *)curentAlbum
{
    if (curentAlbum) {
        self.dataSouce = [NSMutableArray new];
        for (PHAsset * asset  in curentAlbum) {
            STPhotoModel * model = [STPhotoModel new];
            model.asset = asset;
            [self.dataSouce addObject:model];
        }
        _curentAlbum = curentAlbum;
    }
}
#pragma mark --vc生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chosedArray = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭collectionview自动inset
    [self configNav];
    [self initCollectionView];
    [self initGradualLayer];
    [self initBottomView];
    //观察选中数组，需要实现几个方法
    [self  addObserver:self forKeyPath:@"chosedArray" options:NSKeyValueObservingOptionNew context:nil];
    //滑动到最后一个位置
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSouce.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.numButton.hidden = NO;
    [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
    if (self.chosedArray.count==0) {
        self.numButton.hidden = YES;
    }
 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark --SubView
- (void)configNav{
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    right.tintColor = item_COLOR;
    STImagePickerController * nav = (STImagePickerController*)self.navigationController;
    if (nav.themeColor) {
        right.tintColor = nav.themeColor;
    }
    self.navigationItem.rightBarButtonItem = right;
    
}
//渐变颜色
- (void)initGradualLayer{

    STImagePickerController * nav = (STImagePickerController*)self.navigationController;
    if (!nav.showGradual) {
        //选择不展示渐变layer
        return;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.01];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.3);
    gradientLayer.frame = CGRectMake(0, 0, 115, SCREEN_HEIGHT );
    [self.view.layer addSublayer:gradientLayer];
    
    
    CAGradientLayer *gradientLayerright = [CAGradientLayer layer];
    gradientLayerright.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayerright.locations = @[@0.01];
    gradientLayerright.startPoint = CGPointMake(1, 0);
    gradientLayerright.endPoint = CGPointMake(0, 0.3);
    gradientLayerright.frame = CGRectMake(SCREEN_WIDTH - 100 , 0, 100, SCREEN_HEIGHT );
    [self.view.layer addSublayer:gradientLayerright];
}
- (void)initCollectionView{
    
    UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-50.5 - 64) collectionViewLayout:flow];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[STPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}
-(void)initBottomView
{
    self.bootView = [[UIView alloc] initWithFrame:CGRectMake(0, [self tabBarTop], SCREEN_WIDTH, 49)];
    //上方阴影
    self.bootView.layer.shadowOffset = CGSizeMake(0, - 0.3);
    self.bootView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bootView.layer.shadowRadius = 1;
    self.bootView.layer.shadowOpacity = .5f;
    CGRect shadowFrame = self.bootView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath
                            bezierPathWithRect:shadowFrame].CGPath;
    self.bootView.layer.shadowPath = shadowPath;
    
    [self.bootView setBackgroundColor:[UIColor whiteColor]];
    
    self.finshButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 - 12, 0, 44, 44)];
    [self.finshButton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    self.finshButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.finshButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.finshButton addTarget:self action:@selector(sendDidChosedArrayNotifcation:) forControlEvents:UIControlEventTouchUpInside];
    self.finshButton.centerY = 25;
    self.finshButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.bootView addSubview:self.finshButton];
    
    
    self.numButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 56 - 24, 0, 26, 26)];
    self.numButton.selected = YES;
    self.numButton.layer.cornerRadius = 13;
    self.numButton.clipsToBounds = YES;
    [self.numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.numButton.backgroundColor = BLUE_COLOR;
    self.numButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.numButton setTitle:@"0" forState:UIControlStateSelected];
    self.numButton.centerY = 25;
    [self.view addSubview:self.numButton];
     self.numButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.bootView addSubview:self.numButton];

    [self.view addSubview:self.bootView];
    //底部数字
    self.numButton.hidden = NO;
    [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
    if (self.chosedArray.count == 0) {
        self.numButton.hidden = YES;
    }
    
    STImagePickerController * nav = (STImagePickerController*)self.navigationController;
    if (nav.themeColor) {
        [self.finshButton setTitleColor:nav.themeColor forState:UIControlStateNormal];
        self.numButton.backgroundColor = nav.themeColor;
    }
    if (nav.showOriginImageButton) {
        //展示原图
    }
    
}



#pragma mark --kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"chosedArray"]) {
        [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
        if (self.chosedArray.count == 0) {
            self.numButton.hidden = YES;
            return;
        }
        self.numButton.hidden = NO;
        [self.numButton showSlectedAnimation];

    }
}
//要实现对容器类的监听，就必须实现insert和remove这两个方法
#pragma mark --override Method
- (void)insertObject:(STPhotoModel *)object inChosedArrayAtIndex:(NSUInteger)index
{
    [self.chosedArray insertObject:object atIndex:index];
 
}
- (void)removeObjectFromChosedArrayAtIndex:(NSUInteger)index
{
    [self.chosedArray removeObjectAtIndex:index];
    
}
- (void)addChosedArrayObject:(STPhotoModel *)object
{
    [self.chosedArray addObject:object];
  
}
- (void)removeChosedArrayObject:(STPhotoModel *)object
{
    [self removeChosedArrayObject:object];
  
}
#pragma mark --Private Method
-(void)showAnimation:(NSIndexPath*)indexpath
{
    
    NSIndexPath * path = indexpath;
    NSLog(@"收到的位置%ld",path.item);
    if (path.item <= self.dataSouce.count-1) {
        STPhotoCollectionViewCell * mycell = (STPhotoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:path];
        
        CGSize  imageSize = self.dataSouce[path.item].thumbImage.size;
        CGFloat bili = SCREEN_WIDTH/imageSize.width;
        
        UIImageView * animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bili*imageSize.height)];
        animationImageView.transform= CGAffineTransformMakeScale(0.8, 0.8);
        animationImageView.center = self.view.center;
        animationImageView.image = mycell.imageView.image;
        [[UIApplication sharedApplication].keyWindow addSubview:animationImageView];
        CGFloat duration = 0.3;
        [UIView animateWithDuration:duration animations:^{
            
            CGRect frame = [mycell convertRect:mycell.bounds toView:self.view.window];
            animationImageView.frame = frame;
            
        } completion:^(BOOL finished) {
            [animationImageView removeFromSuperview];
        }];
        
        
        
    }
    
    
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
    
    return CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STPhotoCollectionViewCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    item.model = self.dataSouce[indexPath.item];
    __weak typeof(item) weakItme = item;
    __weak typeof(self) weakSelf =self;
    //图片点击回调
    [item imageViewClicHandle:^(UIImageView *imageView) {
        [weakSelf didClicTheImageView:imageView indexPath:indexPath item:weakItme];
    }];
    
    //点击选择按钮回调
    [item chosedButtonClicHandle:^(UIButton *button) {
     
        [weakSelf didClicTheChosedButtonButton:button indexPath:indexPath item:weakItme];


    }];

    return item;
}
#pragma --mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
//将要消失的时候，取消请求
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].requsetID];

    
}
//确保取消成功，已经消失的时候，取消请求
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

    [[PHImageManager defaultManager] cancelImageRequest:self.dataSouce[indexPath.item].requsetID];
}
#pragma mark --STPhotoSystemBrowserControllerDlegate
- (UIImageView *)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath *)indexPath model:(STPhotoModel *)model
{
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    STPhotoCollectionViewCell * cell = (STPhotoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView;

}
- (void)didClicTheChosedButtonAtIndexPath:(NSIndexPath *)indexPath currentModel:(STPhotoModel *)currentModel
{
    [self.dataSouce replaceObjectAtIndex:indexPath.item withObject:currentModel];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.numButton setTitle:[NSString stringWithFormat:@"%ld",self.chosedArray.count] forState:UIControlStateSelected];
}
- (void)didClicTheConfimButtonCurrentIndexPath:(NSIndexPath *)currentIndexPath currentModel:(STPhotoModel *)currentModel
{
    [self sendDidChosedArrayNotifcation:nil];

}

- (void)didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:(NSIndexPath *)currentIndexPath currentModel:(STPhotoModel *)currentModel
{
    [self.dataSouce replaceObjectAtIndex:currentIndexPath.item withObject:currentModel];
    [self.collectionView reloadItemsAtIndexPaths:@[currentIndexPath]];
   
    
} 
#pragma mark --Action Method
//发送点击了确定的通知
- (void)sendDidChosedArrayNotifcation:(UIButton*)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:STPHOTOKIT_FINSH_CHOSED_NOTIFICATION object:self.chosedArray];

}
- (void)rightBarAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击了选择按钮
- (void)didClicTheChosedButtonButton:(UIButton*)button indexPath:(NSIndexPath*)indexPath item:(STPhotoCollectionViewCell*)item {
    
    STImagePickerController * nav = (STImagePickerController*)self.navigationController;
    if (nav.maxImageChosed == self.chosedArray.count && !item.chosedButton.isSelected) {
        //判断最大选取张数
        if (nav.didChosedMaxImages) {
            nav.didChosedMaxImages(nav.maxImageChosed);
        }
        return;
    }
    self.dataSouce[indexPath.item].isChosed =  !self.dataSouce[indexPath.item].isChosed;
    item.chosedButton.selected = self.dataSouce[indexPath.item].isChosed;
    STPhotoModel * model = self.dataSouce[indexPath.item];
    
    if (self.dataSouce[indexPath.item].isChosed) {
        [item.chosedButton showSlectedAnimation];
        //如此获取才会进入监听方法
        [[self mutableArrayValueForKey:@"chosedArray"] addObject:model];
    }
    else
    {
        [[self mutableArrayValueForKey:@"chosedArray"] removeObject:model];
        
    }

}
//点击了图片
- (void)didClicTheImageView:(UIImageView*)imageView indexPath:(NSIndexPath*)indexPath item:(STPhotoCollectionViewCell*)item {
    
    if (self.dataSouce[indexPath.item].asset.mediaType == PHAssetMediaTypeVideo) {
        //NSLog(@"将来跳转到视屏播放");
    }
    else
    {
        //跳转到图片浏览器，你可以在此处跳转到 你所自定义的控制器
        _STPhotoSystemBrowserVC = [[STPhotoSystemBrowserController alloc] initWithArray:self.dataSouce curentIndex:indexPath.item];
        _STPhotoSystemBrowserVC.chosedArray = self.chosedArray;
        _STPhotoSystemBrowserVC.STPhotoSystemBrowserControllerdlegate = self;
        STImagePickerController * nav = (STImagePickerController*)self.navigationController;
        if (nav.themeColor) {
            _STPhotoSystemBrowserVC.themeColor = nav.themeColor;
        }
        _STPhotoSystemBrowserVC.weakNav = nav;
        [self presentViewController:_STPhotoSystemBrowserVC animated:NO completion:nil];
    }
}

@end
