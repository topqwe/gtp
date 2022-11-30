//
//  TMImageAutoChoseView.m
//  Marriage
//
//  Created by Mac on 2018/4/25.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#define TMImageminimumLineSpacing  1
//每行最多多少数量 包括加号
#define TMImageMaxRowNum  4
//父视图 宽度
#define TMImageAutoChoseViewWitdh (UIScreenWidth - 44)
#define TMImageWitdh  ( (TMImageAutoChoseViewWitdh - (TMImageMaxRowNum - 1)*TMImageminimumLineSpacing)/TMImageMaxRowNum)
#import "TZImagePickerController.h"
#import "NSBundle+STSystemTool.h"
@interface  TMImageAutoChoseViewCollectionCell:UICollectionViewCell
@property(nonatomic, strong) STButton                     *imageButton;/**< button */

@end
@implementation TMImageAutoChoseViewCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    self.imageButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, TMImageWitdh, TMImageWitdh)
                                                 title:nil
                                            titleColor:nil
                                             titleFont:0
                                          cornerRadius:0
                                       backgroundColor:nil
                                       backgroundImage:nil
                                                 image:nil];
    self.imageButton.showCloseButton = YES;
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageButton];
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self);
    }];

    
    
}
@end
#import "TMImageAutoChoseView.h"
#import "STPhotoUrlImageBrowerController.h"

@interface TMImageAutoChoseView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
STPhotoUrlImageBrowerControllerDelegate>
@property(nonatomic, strong) NSMutableArray <STPhotoModel*>                    *dataSouce;/**< 数据 */
@property(nonatomic, strong) UICollectionView                     *collectionView;/**< collectionView */
@property(nonatomic, strong) STButton                             *addButton;/**< 添加按钮 */
@end
@implementation TMImageAutoChoseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCount = 9;
        self.height = TMImageWitdh + 2 * TMImageminimumLineSpacing;
        self.backgroundColor = [UIColor clearColor];
        STPhotoModel * model = STPhotoModel.new;
        model.originImage = [UIImage imageNamed:@"mutiple_image_add"];
        model.thumbImage = [UIImage imageNamed:@"mutiple_image_add"];
        [self.dataSouce addObject:model];
        [self configSubView];
    }
    return self;
}
- (NSMutableArray<STPhotoModel *> *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray new];
    }
    return _dataSouce;
}
- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount + 1;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flow = [UICollectionViewFlowLayout new];
        flow.minimumLineSpacing = TMImageminimumLineSpacing;
        flow.minimumInteritemSpacing = TMImageminimumLineSpacing;
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TMImageminimumLineSpacing, self.width, self.height - 2 * TMImageminimumLineSpacing) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TMImageAutoChoseViewCollectionCell class] forCellWithReuseIdentifier:@"item"];
    }
    return _collectionView;
}
- (void)setAddImage:(UIImage *)addImage{
    _addImage = addImage;
    if (!addImage) {
        addImage = [UIImage imageNamed:@"mutiple_image_add"];
    }
    STPhotoModel * model = self.dataSouce.firstObject;
    model.originImage = addImage;
    model.thumbImage = addImage;
    [self.collectionView reloadData];
}
#pragma mark --subView
- (void)configSubView{
    [self insertSubview:self.collectionView atIndex:0];
}
#pragma --mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouce.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(TMImageWitdh, TMImageWitdh);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMImageAutoChoseViewCollectionCell * item =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    STPhotoModel * model = self.dataSouce[indexPath.row];
    UIImage * image = model.originImage?model.originImage:model.thumbImage;
    [item.imageButton setImage:image forState:UIControlStateNormal];
    item.imageButton.closeButton.right = item.width;
    __weak typeof(self) weakSelf =  self;
    if (indexPath.row == 0) {
        [item.imageButton setShowCloseButton:NO];
        [item.imageButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedAddButton];
        }];
    }else{
        [item.imageButton setShowCloseButton:YES];
        [item.imageButton setCloseAction:^(UIButton *sender) {
            [weakSelf onSelectedDelButtonWithIndexPath:indexPath];
        }];
        [item.imageButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedButtonWithIndexPath:indexPath];
        }];
    }

    return item;
}
#pragma --mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
#pragma mark --public Method
- (void)addImageModels:(NSArray<STPhotoModel *> *)imageModels{
    [self.dataSouce addObjectsFromArray:imageModels];
}
- (void)addImageModel:(STPhotoModel *)imageModel{
    [self.dataSouce addObject:imageModel];
}
- (NSArray<UIImage *> *)allImages{
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 1; i<self.dataSouce.count;i ++ ) {
        STPhotoModel * model = self.dataSouce[i];
        if (model.originImage) {
           [array addObject:model.originImage];
        }else{
            [array addObject:model.thumbImage];
        }
    }
    return [array copy];
}
- (NSArray<STPhotoModel *> *)allImageModels{
    return [self.dataSouce subarrayWithRange:NSMakeRange(1, self.dataSouce.count - 1)];
}
- (void)cancleImageModel:(STPhotoModel *)imageModel{
    if ([self.dataSouce containsObject:imageModel]) {
        [self.dataSouce removeObject:imageModel];
    }
}
- (void)cancleImageModels:(NSArray<STPhotoModel *> *)imageModels{
    for (STPhotoModel * model in imageModels) {
        if (![self.dataSouce containsObject:model]) {
            NSLog(@"数组中含有 不存在的模型");
            return;
        }
    }
    [self.dataSouce removeObjectsInArray:imageModels];
}
- (void)removeImageModelFormIndex:(NSInteger)index{
    [self.dataSouce removeObjectAtIndex:index];
}
- (void)updateCollectonViewFrame{
    CGFloat num = ((self.dataSouce.count) / 4.0);
    if (num - @(num).integerValue > 0.01) {
        num = @(num+1).integerValue;   
    }
    self.collectionView.height = TMImageWitdh * num ;
    self.collectionView.scrollEnabled = NO;
    self.height = self.collectionView.bottom;
    if (self.frameDidChangedHandle) {
        self.frameDidChangedHandle(self);
    }
}
#pragma mark --Action Method
- (void)onSelctedAddButton{
    UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    TZImagePickerController * controller =  [[TZImagePickerController alloc] init];
    controller.maxImagesCount = self.maxCount - self.dataSouce.count  ;
    controller.allowPickingGif = NO;
    controller.allowTakeVideo = YES;
    controller.allowPickingVideo = NO;
    controller.barItemTextColor = TM_ThemeBackGroundColor;
    [controller setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        for (UIImage * image in photos) {
            STPhotoModel * model = STPhotoModel.new;
            model.thumbImage = image;
            model.originImage = image;
            [self.dataSouce addObject:model];
        }
        [self updateCollectonViewFrame];
        [self.collectionView reloadData];
    }];
    if (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    [vc presentViewController:controller animated:YES completion:nil];
    
}
- (void)onSelectedDelButtonWithIndexPath:(NSIndexPath*)indexPath{
    [self removeImageModelFormIndex:indexPath.row];
   // [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self updateCollectonViewFrame];
    [self.collectionView reloadData];
    [self.collectionView st_showAnimationWithType:STAnimationTypekCATransitionFade];
}
- (void)onSelctedButtonWithIndexPath:(NSIndexPath*)indexPath{
    //点击了某个图片
    NSMutableArray * models = [NSMutableArray new];
    NSArray * modeArray = self.allImageModels;
    for (STPhotoModel * originModel in modeArray) {
        STUrlPhotoModel * model = [STUrlPhotoModel  new];
        model.originImage = originModel.originImage?originModel.originImage:originModel.thumbImage;
        [models addObject:model];
    }
    STPhotoUrlImageBrowerController * vc = [[STPhotoUrlImageBrowerController alloc] initWithArray:models curentIndex:indexPath.row-1];
    vc.shouldHideBottomView = YES;
    vc.STPhotoUrlImageBrowerControllerdelegate = self;
    UIViewController * rootVC = UIViewController.new.st_currentNavgationController;
    [rootVC presentViewController:vc animated:NO completion:nil];
}
#pragma mark --STPhotoUrlImageBrowerControllerDelegate
- (UIView*)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath*)indexPath model:(STUrlPhotoModel*)model{
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    NSIndexPath * delIndexpath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    TMImageAutoChoseViewCollectionCell * item  =(id)[self.collectionView cellForItemAtIndexPath:delIndexpath];
    return   item.imageButton;
}
- (void)rightBarActionFromController:(STPhotoUrlImageBrowerController*)controller currentIndexPath:(NSIndexPath *)curentIndexpath{
    [controller st_showActionSheet:@[@"保存",@"取消"] andWithBlock:^(int tag) {
        if (tag == 0) {
                TMImageAutoChoseViewCollectionCell * item  =(id)[self.collectionView cellForItemAtIndexPath:curentIndexpath];
            [PHPhotoLibrary saveImageToAssetsLibrary:item.imageButton.currentImage libraryName:NSBundle.st_applictionDisplayName successHandle:^{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            } errorHandle:^(STSaveImageError error) {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }];
        }
    }];
}
@end


