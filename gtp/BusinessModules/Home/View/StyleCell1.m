//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "StyleCell1.h"
#define kGridCellHeight   80
#define bottomMargin  45
@interface StyleCell1()
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic, strong)NSMutableArray *data;
@property(nonatomic, strong)UIImageView* imgBg;
@property (nonatomic ,strong) UIImageView* line0;
@property (nonatomic ,strong)NSDictionary* model;
@end

@implementation StyleCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        
        
        UIImageView* imgBg = [UIImageView new];
        [self.contentView addSubview:imgBg];
        imgBg.backgroundColor = UIColor.clearColor;
        self.imgBg = imgBg;
        [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.bottom.mas_equalTo(0);
                     make.left.mas_equalTo(0);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(MAINSCREEN_WIDTH);
            make.height.mas_equalTo(33);
                 }];
        UIImageView* line0 = [[UIImageView alloc]init];
        self.line0 = line0;
        [self.contentView addSubview:line0];
        line0.backgroundColor = kClearColor;
        [self.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.bottom.mas_equalTo(0);
                     make.left.mas_equalTo(10);
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
                 }];

        if(_collectionView)
        {
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }
//        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _flowLayout = layout;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, kGridCellHeight) collectionViewLayout:self.flowLayout];
        //设置第一个cell和最后一个cell,与父控件之间的间距
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //设置cell行、列的间距
        [self.flowLayout setMinimumLineSpacing:10];//row5 -10
//        [self.flowLayout setMinimumInteritemSpacing:10];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
        [_collectionView registerClass:[SColCell class] forCellWithReuseIdentifier:@"SColCell"];
        
        [_collectionView setBackgroundColor:UIColor.clearColor];
        //如果row = 5
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:_collectionView];
        
    }
    return self;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    StyleCell1 *cell = (StyleCell1 *)[tabelView dequeueReusableCellWithIdentifier:@"StyleCell1"];
    if (!cell) {
        cell = [[StyleCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StyleCell1"];
    }
    return cell;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

+(CGFloat)cellHeightWithModel:(NSDictionary*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
//    return (model.count%4==0?model.count/4:model.count/4+1)*kGridCellHeight;
    NSArray* arr = model.allValues[0];
    if (arr.count==0||arr.count==1) {
        return  0.1f;
    }
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    switch (style) {
        case IndexSectionUIStyleOne:
            return 130+bottomMargin;
            break;
        case IndexSectionUIStyleTwo:
            return 160+bottomMargin;
            break;
        case IndexSectionUIStyleThree:
            return 110+bottomMargin;//80
            break;
        default:
            return kGridCellHeight;
            break;
    }
    return kGridCellHeight;
}

+(CGFloat)cellWidthWithModel:(NSDictionary*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
//    return (model.count%4==0?model.count/4:model.count/4+1)*kGridCellHeight;
    NSArray* arr = model.allValues[0];
    if (arr.count==0||arr.count==1) {
        return  0.1f;
    }
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    switch (style) {
        case IndexSectionUIStyleOne:
            return (130*88)/50;
            break;
        case IndexSectionUIStyleTwo:
            return (160*123)/69;
            break;
        case IndexSectionUIStyleThree:
            return (110*65)/37;//80
            break;
        default:
            return (110*65)/37;
            break;
    }
    return (110*65)/37;
}
- (void)richElementsInCellWithModel:(NSDictionary*)model{
    self.data = [NSMutableArray array];
    [self.data addObjectsFromArray: model.allValues[0]];
    if (self.data.count==0||self.data.count==1) {
        return;
    }
    self.model = model;
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    
    switch (style) {
            
        case IndexSectionUIStyleOne:
        {
//            _flowLayout = [[UICollectionViewFlowLayout alloc] init];//(60/35)*
//
            
            _flowLayout.itemSize = CGSizeMake([[self class] cellWidthWithModel:model], [[self class] cellHeightWithModel:model]);
            
        }
            break;
        case IndexSectionUIStyleTwo:
        {
//            _flowLayout = [[UICollectionViewFlowLayout alloc] init];//(78/50)*
            
            
            _flowLayout.itemSize = CGSizeMake([[self class] cellWidthWithModel:model], [[self class] cellHeightWithModel:model]);
            
        }
            break;
        case IndexSectionUIStyleThree:
        {
//            _flowLayout = [[UICollectionViewFlowLayout alloc] init];//(50/30)*
            
            _flowLayout.itemSize = CGSizeMake([[self class] cellWidthWithModel:model], [[self class] cellHeightWithModel:model]);
            
        }
            break;
            
        default:
        {
            _flowLayout = [[UICollectionViewFlowLayout alloc] init];
            _collectionView.collectionViewLayout = [UICollectionViewLayout new];
        }
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果是GridCell的话，要同步collectionView高度
        [self.collectionView setHeight:
         
         [[self class] cellHeightWithModel:model]
         
        ];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView reloadData];
    });
    self.imgBg.image = nil;
    if (style == IndexSectionUIStyleTwo) {
        NSString* bgStr = [NSString stringWithFormat:@"%@",@"M_StyleScCell1Bg"];
    //    [self.imgBg sd_setImageWithURL:[NSURL URLWithString:bgStr]];
        self.imgBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",bgStr]];
        self.line0.backgroundColor = kClearColor;
        
    }else{
        self.imgBg.image = nil;
        self.line0.backgroundColor = HEXCOLOR(0x8FAEB7);
    }
    
}

#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SColCell * cell = [SColCell cellAtIndexPath:indexPath inView:collectionView];
    cell.tag = indexPath.row;
    HomeItem *fourPalaceData = [self.data objectAtIndexVerify:indexPath.row];
    [cell richElementsInCellWithModel:fourPalaceData];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = .1;
    [cell.vBgV addGestureRecognizer:longPress];
    return cell;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer{
  
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
       
        CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];//点击cell的
        
        //在此添加你想要完成的功能
        if (@available(iOS 10.0, *)) {
            [self.collectionView setPrefetchingEnabled:NO];
        } else {
            // Fallback on earlier versions
        }
        [self basedOnIndexPath:indexPath];
    }
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//
//    CGPoint pointTouch = [touch locationInView:self.collectionView];
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];//点击cell的
//
//    [self basedOnIndexPath:indexPath];
//}
#pragma mark - ScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [JRMenuView dismissAllJRMenu];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //cell除collectionView以外还有其他UIView的情况： 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.contentView convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pInView];
    //整个cell就一个collectionView的情况：用这种方式
//    NSIndexPath * indexPath = [_collectionView  indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + [[self class] cellWidthWithModel:self.model], scrollView.contentOffset.y)];
    [self basedOnIndexPath:indexPath];
}
- (void)basedOnIndexPath:(NSIndexPath*)indexPath{
    HomeItem *fourPalaceData = [self.data objectAtIndexVerify:indexPath.row];
    SColCell * cell = (SColCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    [cell.vBgV addSubview:[self setupBgVideoPlayer:fourPalaceData]];
    
    [cell hideHorLabShowTitBut:false];
}
- (SelVideoPlayer*)setupBgVideoPlayer:(HomeItem*)item
{
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = NO;
    configuration.shouldAutorotate = NO;
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateNever;
    configuration.muted = YES;
    configuration.isHideProgress = YES;
    configuration.sourceUrl = [NSURL URLWithString:item.preview_hls_url];
    
    configuration.videoGravity =
//    SelVideoGravityResize;
    SelVideoGravityResizeAspect;
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, [[self class] cellWidthWithModel:self.model], [[self class]cellHeightWithModel:self.model]-30) configuration:configuration];
    return _player;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *object = [_data objectAtIndex:indexPath.row];
    
    _selectedIndexPath = indexPath;
    if (self.block) {
        self.block(object);
    }
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end


