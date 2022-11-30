//
//  AccountTagView.m


#import "AccountTagView.h"
#import "CollectionViewHorizontalLayout.h"
#import "RTPagedCollectionViewLayout.h"
#define kGridCellHeight   102
@interface AccountTagView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *data;

@property (strong,nonatomic) RTPagedCollectionViewLayout *flowLayout;

@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, assign) NSUInteger currentIndex;
@property (strong,nonatomic) UIPageControl * pageControl;
@property (nonatomic, copy) ActionBlock block;
@end
static CGFloat const kPadding            = 0;
@implementation AccountTagView
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, [AccountTagView cellHeightWithModel]-40) collectionViewLayout:layout];
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
                
                [_collectionView setBackgroundColor:UIColor.clearColor];
                //如果row = 5
                _collectionView.scrollEnabled = YES;
                _collectionView.alwaysBounceHorizontal = YES;
                _collectionView.showsHorizontalScrollIndicator = NO;
//                _collectionView.contentSize = CGSizeMake(_collectionView.width*2, 0);
                
                [self addSubview:_collectionView];
        
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(3);
            make.centerX.mas_equalTo(self.collectionView);
            make.left.equalTo(self.collectionView.mas_left).offset(0);
            make.height.mas_equalTo(37);
        }];
    }
    return self;
}

- (RTPagedCollectionViewLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[RTPagedCollectionViewLayout alloc] init];
//        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.rows = 3;
        _flowLayout.columns = 4;
        _flowLayout.itemSize = CGSizeMake((MAINSCREEN_WIDTH-kPadding*(_flowLayout.columns+1))/_flowLayout.columns, (self.collectionView.frame.size.height-kPadding*(_flowLayout.rows+1))/_flowLayout.rows);
        _flowLayout.edgeInsets = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
//        _flowLayout.minimumLineSpacing = kPadding;
//        _flowLayout.minimumInteritemSpacing = kPadding;
//        _flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    }
    return _flowLayout;
}
+(CGFloat)cellHeightWithModel{
    return 280;
}
- (void)richElementsInCellWithModel:(NSArray*)model{
    _data = model;
    _pageCount = _data.count;
    
    //一行显示4个,3行就是12个
    while (_pageCount % 12 != 0) {
        ++_pageCount;
    }
    self.pageControl.numberOfPages = _pageCount / 12.0;
    
    _collectionView.collectionViewLayout = self.flowLayout;
//    [_collectionView setHeight:[AccountTagView cellHeightWithModel:model]];
//    _collectionView.pagingEnabled = YES;
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView reloadData];
}

#pragma mark --UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count; //_pageCount;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gCollectionViewCell = @"gCollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:gCollectionViewCell forIndexPath:indexPath];
    
    if (cell) {
        UIImageView *icon = [[UIImageView alloc]init];
        icon.tag = 7001;
        [cell.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.centerX.mas_equalTo(cell.contentView);
            make.width.height.mas_equalTo(44);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.tag = 7003;
        [cell.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(icon.mas_bottom).offset(5);
            make.centerX.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(3);
            make.bottom.mas_equalTo(cell.contentView);
        }];
        [title setBackgroundColor:UIColor.clearColor];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:10]];
        [title setTextColor:RGBSAMECOLOR(183)];
        title.numberOfLines = 0;
        
    }
    
    NSDictionary *fourPalaceData = [_data objectAtIndex:indexPath.row];
    
    UIImageView *icon=(UIImageView *)[cell.contentView viewWithTag:7001];
    icon.backgroundColor = [UIColor whiteColor];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setClipsToBounds:YES];
//    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",fourPalaceData.imageUrl]]];
    [icon setImage:[UIImage imageNamed:fourPalaceData[kImg]]];
    
    UILabel *title =(UILabel *)[cell.contentView viewWithTag:7003];
    [title setText:[NSString stringWithFormat:@"%@",fourPalaceData[kSubTit]]];
    
    
    return cell;
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *object = [_data objectAtIndex:indexPath.row];
    if (![NSString isEmpty:object[kSubTit]]) {
        if (self.block) {
            self.block(object);
        }
        NSLog(@"点击了=====%ld",indexPath.row);
    }
//    if (indexPath.item >= _data.count) {//_pageCount用到
//        NSLog(@"点击了====空白");
//    } else {
//        NSLog(@"点击了=====%ld",indexPath.row);
        
//    }
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


