//
//  DraggableCView.m

#import "DraggableCView.h"
#import "DraggableCViewFlowLayout.h"
#import "DraggableCVModel.h"
@interface CVCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *titleLab;
@end

@implementation CVCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self ==[super initWithFrame:frame]){
        UILabel *titleLab = [[UILabel alloc]init];
                titleLab.tag = 7003;
                [self.contentView addSubview:titleLab];
        //        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(icon.mas_bottom).offset(5);
        //            make.centerX.mas_equalTo(cell.contentView);
        //            make.left.mas_equalTo(3);
        //            make.bottom.mas_equalTo(cell.contentView);
        //        }];
        titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [titleLab setBackgroundColor:UIColor.clearColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont systemFontOfSize:18]];
        [titleLab setTextColor:UIColor.whiteColor];
        titleLab.numberOfLines = 0;
        self.titleLab = titleLab;
    }
    return self;
}

- (void)richElementsInCellWithModel:(NSString*)model{
    self.titleLab.text = [NSString stringWithFormat:@"%@",model];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.titleLab.alpha = highlighted ? 0.75f : 1.0f;
    
}

@end

#define kGridCellHeight   (MAINSCREEN_HEIGHT - [YBFrameTool safeAdjustTabBarHeight] - [YBFrameTool safeAdjustNavigationBarHeight] -60)
@interface DraggableCView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSMutableArray *originDatas;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (strong,nonatomic) DraggableCViewFlowLayout *flowLayout;

@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, assign) NSUInteger currentIndex;
@property (strong,nonatomic) UIPageControl * pageControl;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, copy) NSDictionary* model;

@property (assign, nonatomic) BOOL isMultipleSelected;
@property (strong, nonatomic) NSMutableArray*selectArr;
@property (strong, nonatomic) NSMutableDictionary* selectedModel;
@property (assign, nonatomic) CGFloat padding;
@end
//static CGFloat const kPadding            = 3;
@implementation DraggableCView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
//                self.contentView.backgroundColor = UIColor.whiteColor;
//                self.backgroundView = [[UIView alloc] init];
                if(_collectionView)
                {
                    [_collectionView removeFromSuperview];
                    _collectionView = nil;
                }
                
                UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//                //设置第一个cell和最后一个cell,与父控件之间的间距
//                layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                //设置cell行、列的间距
//                [layout setMinimumLineSpacing:0];//row5 -10
//                [layout setMinimumInteritemSpacing:0];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, [DraggableCView cellHeightWithModel]) collectionViewLayout:layout];
                [_collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
                
                [_collectionView setBackgroundColor:UIColor.clearColor];
                //如果row = 5
                _collectionView.scrollEnabled = YES;
//                _collectionView.alwaysBounceHorizontal = YES;
//                _collectionView.showsHorizontalScrollIndicator = NO;
//                _collectionView.contentSize = CGSizeMake(_collectionView.width*2, 0);
                
                [self addSubview:_collectionView];
        
        [self addSubview:self.pageControl];
        self.pageControl.hidden = true;
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(3);
            make.centerX.mas_equalTo(self.collectionView);
            make.left.equalTo(self.collectionView.mas_left).offset(0);
            make.height.mas_equalTo(37);
        }];
    }
    return self;
}

- (DraggableCViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[DraggableCViewFlowLayout alloc] init];
//        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

//        _flowLayout.itemSize = CGSizeMake((MAINSCREEN_WIDTH-kPadding*7)/6, (MAINSCREEN_WIDTH-kPadding*7)/6);

        //(self.collectionView.frame.size.height-kPadding*7)/6

        //easyError
//        _flowLayout.columns = 6;
//        _flowLayout.rows = 7;
//        _flowLayout.edgeInsets = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
        _flowLayout.minimumLineSpacing = self.padding;
        _flowLayout.minimumInteritemSpacing = self.padding;
        _flowLayout.sectionInset = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);
//        _flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    }
    return _flowLayout;
}
+(CGFloat)cellHeightWithModel{
    return kGridCellHeight;
}
- (void)richElementsInCellWithModel:(NSDictionary*)model{
    self.model = model;
    _selectedModel = [NSMutableDictionary dictionary];
    _selectArr = [NSMutableArray array];
    self.isMultipleSelected = true;
    
    NSInteger x =  [model[kIndexRow]intValue];
    NSInteger y =  [model[kIndexSection]intValue];
    _originDatas = [NSMutableArray array];
    for (NSDictionary* c in model[kArr]) {
        [_originDatas addObject:[NSString stringWithFormat:@"%@",c[kTit]]];
    }
    _data = [NSMutableArray arrayWithArray:model[kArr]];
    _pageCount = _data.count;
    
    //一行显示4个,3行就是12个
    while (_pageCount % 12 != 0) {
        ++_pageCount;
    }
    self.pageControl.numberOfPages = _pageCount / 12.0;
    
    
    if (x == y) {
        self.padding = 20;
        self.flowLayout.itemSize = CGSizeMake((self.collectionView.frame.size.width-self.padding*(x+1))/x, (self.collectionView.frame.size.width-self.padding*(y+1))/y);
    }else{
        self.padding = 3;
        self.flowLayout.itemSize = CGSizeMake((self.collectionView.frame.size.width-self.padding*(x+1))/x, (self.collectionView.frame.size.height-self.padding*(y+1))/y);
    }
    
    
    
    _collectionView.collectionViewLayout = self.flowLayout;
//    [_collectionView setHeight:[AccountTagView cellHeightWithModel:model]];
//    _collectionView.pagingEnabled = YES;
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSLog(@"visibleCells===%@",@([self.collectionView visibleCells].count));//60
//        });
    [[DraggableCVModel new] setDataIsForceInit:YES];
//    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
//    [_collectionView addGestureRecognizer:_longPress];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:_longPress.view]];
//                if (!selectIndexPath) {
//                    break;
//                }
                // 找到当前的cell
//                CVCell *cell = (CVCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
//                // 定义cell的时候btn是隐藏的, 在这里设置为NO
//                [cell.btnDelete setHidden:NO];
                [_collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
//            NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:_longPress.view]];
//            NSMutableArray *data2 = [_data objectAtIndex:toIndexPath.section];
//
//                NSString *toIndex = [data2 objectAtIndex:toIndexPath.item];
//                if ([toIndex isEqualToString: @"A 1"]
//            //        &&
//            //        [toIndex isEqualToString: @"A 1"]
//                    ) {
//                    break;
//                }
            
                [self.collectionView updateInteractiveMovementTargetPosition:[_longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
                [self.collectionView endInteractiveMovement];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}
#pragma mark --UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
//    return [[_data objectAtIndex:section] count]; //_pageCount;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
//    return _data.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
//          [collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:CellIdentifier];
//          CVCell *cell = (CVCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
          
    CVCell *cell = (CVCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"gCollectionViewCell" forIndexPath:indexPath];
    
//    NSMutableArray *fourPalaceData = [_data objectAtIndex:indexPath.section];
    NSDictionary* dic = _data[indexPath.row];
    [cell richElementsInCellWithModel:[NSString stringWithFormat:@"%@",dic[kTit]]];
    if ([self.model[kIndexRow]intValue]==[self.model[kIndexSection]intValue]) {
        cell.contentView.backgroundColor = dic[kColor];
    }else{
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        if ([dic[kIsOn]boolValue]) {
            cell.contentView.backgroundColor = [YBGeneralColor themeColor];
        }else{
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return cell;
}

- (void)rotateModel:(NSDictionary*)model{
    NSInteger i = [model[kSubTit]intValue];
    NSInteger x = [self.model[kIndexRow]intValue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"1  %@",[NSThread currentThread]);
            [self collectionView:self.collectionView itemAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0] willMoveToIndexPath:[NSIndexPath indexPathForRow:i+(x) inSection:0]];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2  %@",[NSThread currentThread]);
            [self collectionView:self.collectionView itemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] willMoveToIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
            
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3  %@",[NSThread currentThread]);
            [self collectionView:self.collectionView itemAtIndexPath:[NSIndexPath indexPathForRow:i+(x+1) inSection:0] willMoveToIndexPath:[NSIndexPath indexPathForRow:i+(x) inSection:0]];
        });
    });
    
// 0 1
//4 5
//对角线3步
//0  4
//1  5

// 0 4
// 5  1
    
// 4 0
// 5  1
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[DraggableCVModel new] setDataIsForceInit:NO];
    
    NSDictionary *model = self.data[indexPath.row];
    
    if (!self.isMultipleSelected) {
        if (![[self.selectedModel mutableCopy] isEqualToDictionary: model]) {
            [self.selectedModel setValue:@(0) forKey:kIsOn];
            for (NSDictionary* dic in self.data) {
                if (![[self.selectedModel mutableCopy] isEqualToDictionary: dic]) {
                    [dic setValue:@(0) forKey:kIsOn];
                }
            }
        }
    }
    
    [model setValue:@(![model[kIsOn]boolValue]) forKey:kIsOn];
    
    if (self.isMultipleSelected) {
        if ([model[kIsOn]boolValue]) {
            [self.selectArr addObject:model];
        }else{
            if ([self.selectArr indexOfObject:model]!= NSNotFound) {
                [self.selectArr removeObject:model];
            }
        }
    }
    self.selectedModel = [NSMutableDictionary dictionaryWithDictionary:model];
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.collectionView reloadSections:reloadSet];
    }];
    if (self.isMultipleSelected) {
        NSMutableArray* nums = [NSMutableArray array];
        if (self.selectArr.count>0) {
            for (NSDictionary* dic in self.selectArr) {
                [nums addObject:[NSString stringWithFormat:@"%@",dic[kTit]]];
            }
            if ([[DraggableCVModel new]compareOriginData:self.originDatas withNewData:nums]) {
                if ([UserInfoManager GetNSUserDefaults].recordedDate){
                    if (self.block) {
                        self.block(@(1));
                    }
                }
            }
        }
        NSLog(@"mult%@",nums);
    }
    else{
       if (self.selectedModel) {
           NSLog(@"gseges%@",self.selectedModel);
           for (NSDictionary* dic in self.data) {
               if (![[self.selectedModel mutableCopy] isEqualToDictionary: dic]) {
                   [dic setValue:@(0) forKey:kIsOn];
               }
           }
       }
    }
}
#pragma mark - LXReorderableCollectionViewDataSource methods
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Prevent item from being moved to index 0
//    if (indexPath.section == 0
//        &&indexPath.row == 0) {
//        return NO;
//    }
    
//    NSMutableArray *data1 = [_data objectAtIndex:indexPath.section];
//
//    NSString *index = [data1 objectAtIndex:indexPath.item];
//    if ([index isEqualToString: @"A 1"]
////        &&
////        [toIndex isEqualToString: @"A 1"]
//        ) {
//        return NO;
//    }
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
//    NSMutableArray *data1 = [_data objectAtIndex:fromIndexPath.section];
//
//    NSString *fromIndex = [data1 objectAtIndex:fromIndexPath.item];
//
//    NSMutableArray *data2 = [_data objectAtIndex:toIndexPath.section];
//
//        NSString *toIndex = [data2 objectAtIndex:toIndexPath.item];
//        if ([toIndex isEqualToString: @"A 1"]
//            &&
//            [fromIndex isEqualToString: @"A 0"]
//            ) {
//            return NO;
//        }
        
        return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[DraggableCVModel new] setDataIsForceInit:NO];
    
//    NSMutableArray *data1 = [_data objectAtIndex:sourceIndexPath.section];
//    NSMutableArray *data2 = [_data objectAtIndex:destinationIndexPath.section];
//    NSString *index = [data1 objectAtIndex:sourceIndexPath.item];
//
//    [data1 removeObjectAtIndex:sourceIndexPath.item];
//    [data2 insertObject:index atIndex:destinationIndexPath.item];
    
    if ([self.model[kIndexRow]intValue]==[self.model[kIndexSection]intValue]) {
        [self.data exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [self.collectionView reloadData];

        if (self.data.count>0) {
            if([[DraggableCVModel new]isEqualFinalElementInArray:self.data byX:[self.model[kIndexRow]intValue]]){
                if ([UserInfoManager GetNSUserDefaults].recordedDate){
                    if (self.block) {
                        self.block(@(1));
                    }
                }
            }

        }
        return;
    }
    NSArray *selectModel = self.data[sourceIndexPath.item];
    [self.data removeObjectAtIndex:sourceIndexPath.item];
    [self.data insertObject:selectModel atIndex:destinationIndexPath.item];
    
//    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:_longPress.view]];
    // 找到当前的cell
//    CVCell *cell = (CVCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
//    [cell.btnDelete setHidden:YES];

    
//    NSLog(@"mmml===%@\n%lu",self.data,(unsigned long)self.data.count);
    NSMutableArray* nums = [NSMutableArray array];
    if (self.data.count>0) {
        for (NSDictionary* dic in self.data) {
            [nums addObject:[NSString stringWithFormat:@"%@",dic[kTit]]];
        }
        if ([[DraggableCVModel new]compareOriginData:_originDatas withNewData:nums]) {
            if ([UserInfoManager GetNSUserDefaults].recordedDate){
                if (self.block) {
                    self.block(@(1));
                }
            }
        }
    }
    NSLog(@"mult%@",nums);
    
//    [self.collectionView reloadData];

}
#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//     NSLog(@"will end drag");
   
//    [self.collectionView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"visibleCells===%@",@([self.collectionView visibleCells].count));//60
//    });
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    //获得页码
    CGFloat doublePage = scrollView.contentOffset.x/MAINSCREEN_WIDTH;
    int intPage = (int)(doublePage +0.5);
    //设置页码
    self.pageControl.currentPage= intPage;
    
//    //更新pageControl的值
//    self.pageControl.currentPage = self.currentIndex;
//    //计算每次偏移的x值
//    CGFloat x = MAINSCREEN_WIDTH * self.currentIndex++;
//    [self.collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
//    //重新更新index的值
//    if (self.currentIndex == _pageCount) self.currentIndex = 0;
    
}

- (UIPageControl *)pageControl{
    if(_pageControl==nil){
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.currentPage=0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor= YBGeneralColor.themeColor;
        [_pageControl addTarget:self action:@selector(clickPageControl) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
-(void)clickPageControl{
    //*********
    //根据点击的pageControl的值，来更新scrollview的contentoffset
    CGFloat x = MAINSCREEN_WIDTH * self.pageControl.currentPage;
    [self.collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
    //更新一下currentImageIndex的值
    self.currentIndex = self.pageControl.currentPage;
}

- (void)showInView:(UIView *)contentView {
    //    if (self.accountTagView){
    //        return;
    //    }
    [contentView setNeedsUpdateConstraints];
    [contentView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView).offset(0);
            
        }];
        [contentView layoutIfNeeded];
    } completion:^(BOOL finished){
        self.alpha = 1.0;
    }];
}

- (void)disMissView {
    
    [self.superview setNeedsUpdateConstraints];
    [self.superview updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3f
                     animations:^{
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.superview).offset(-MAINSCREEN_WIDTH);
            
        }];
        [self.superview  layoutIfNeeded];
                     }
     
         completion:^(BOOL finished){
             self.alpha = 0.0;
//            [self.accountTagView removeFromSuperview];
//            self.accountTagView = nil;
         }];
}
@end


