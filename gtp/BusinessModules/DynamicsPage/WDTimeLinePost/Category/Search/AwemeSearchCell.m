//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "AwemeSearchCell.h"//s6
#define kGridCellHeight  (228*((MAINSCREEN_WIDTH-30) / 2)/172)+10
@interface AwemeSearchCell()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic, strong)NSMutableArray *data;

@property(nonatomic, strong)UIImageView* imgBg;
@end
@implementation AwemeSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
       
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        if(_collectionView)
        {
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }
        
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
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//水平2选Vertical
        layout.itemSize = CGSizeMake((MAINSCREEN_WIDTH-30) / 2, kGridCellHeight-10);
        //设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //设置cell行、列的间距
        [layout setMinimumLineSpacing:10];//row5 -10
        [layout setMinimumInteritemSpacing:5];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH-0, kGridCellHeight) collectionViewLayout:layout];

        [_collectionView registerClass:[SColCell class] forCellWithReuseIdentifier:@"SColCell"];
        [_collectionView setBackgroundColor:kClearColor];
        //如果row = 5
        _collectionView.scrollEnabled = NO;
//        _collectionView.alwaysBounceHorizontal = YES;
//        _collectionView.showsHorizontalScrollIndicator = YES;
//        _collectionView.contentSize = CGSizeMake(_collectionView.width*5 / 4, 0);
        
        [self.contentView addSubview:_collectionView];
        
    }
    return self;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    AwemeSearchCell *cell = (AwemeSearchCell *)[tabelView dequeueReusableCellWithIdentifier:@"AwemeSearchCell"];
    if (!cell) {
        cell = [[AwemeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AwemeSearchCell"];
    }
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSArray*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    return (model.count%2==0?model.count/2:model.count/2+1)*(kGridCellHeight+1);
}


- (void)richElementsInCellWithModel:(NSArray*)model{
    _data = [NSMutableArray array];
    [_data addObjectsFromArray: model];
    
    
    
    
    self.imgBg.image = nil;
    if (_style == IndexSectionUIStyleSix) {
        NSString* bgStr = [NSString stringWithFormat:@"%@",@"M_StyleScCell1Bg"];
    //    [self.imgBg sd_setImageWithURL:[NSURL URLWithString:bgStr]];
        self.imgBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",bgStr]];
        
    }else{
        self.imgBg.image = nil;
    }
    
    //多个tableView 需要收到数据后需要刷新CollectionView
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果是GridCell的话，要同步collectionView高度
        [self.collectionView setHeight:
         
         [[self class] cellHeightWithModel:model]
         
        ];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView reloadData];
    });
}
#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
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
//    if (![fourPalaceData.cover_img containsString:@"http"]) {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:fourPalaceData.cover_img]];
//        cell.backgroundView.layer.masksToBounds = YES;
//        cell.backgroundView.layer.cornerRadius = 10;
//    }
    
    [cell richElementsInCellWithModel:fourPalaceData];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    switch (self.awemeType) {
        case AwemeTargetPush:
        {
            [cell handleSSCell];
        }
            break;
        case AwemeKeywordPush:
        {
            [cell handleSRCell];
        }
            break;
        case AwemeLivi:
        {
            [cell handleEVCell];
        }
            break;
        default:
            break;
    }
    
    //    UIButton* icon = [cell.contentView viewWithTag:8000];
    //    icon.hidden = YES;
    //    icon.frame = CGRectMake(0, 0, (MAINSCREEN_WIDTH-30)/2, kGridCellHeight-10);
//    [icon mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//
////            make.center.mas_equalTo(cell.contentView);
//        make.centerX.mas_equalTo(cell.contentView);
////
//        make.bottom.mas_equalTo(cell.contentView).offset(0);
//    }];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setNumberOfTapsRequired:0];
    longPress.minimumPressDuration = .1;
    longPress.delegate = self;
//    [cell.vBgV addGestureRecognizer:longPress];
    return cell;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
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
////-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
////- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSIndexPath * indexPath = [_collectionView  indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + (MAINSCREEN_WIDTH-30) / 2, scrollView.contentOffset.y)];
//    [self basedOnIndexPath:indexPath];
//}
- (void)basedOnIndexPath:(NSIndexPath*)indexPath{
    HomeItem *fourPalaceData = [self.data objectAtIndexVerify:indexPath.row];
    SColCell * cell = (SColCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    [cell.vBgV addSubview:[self setupBgVideoPlayer:fourPalaceData]];
    [cell hideHorLabShowTitBut:false];
//
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
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, (MAINSCREEN_WIDTH-30) / 2, kGridCellHeight-10-30) configuration:configuration];
    return _player;
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeItem *object = [_data objectAtIndex:indexPath.row];

//    if (_selectedIndexPath) {
//        
//        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:_selectedIndexPath];
//        
//        UIButton* icon = [cell.contentView viewWithTag:8000];
//        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
//        icon.layer.shadowColor = [UIColor clearColor].CGColor;
//        
//    }
//    
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIButton* icon = [cell.contentView viewWithTag:8000];
//    [icon setTitleColor:[UIColor redColor] forState:0];
//    icon.layer.shadowColor = [UIColor blackColor].CGColor;
//    
//    if (indexPath.row !=0) {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//        
//        UIButton* icon = [cell.contentView viewWithTag:8000];
//        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
//        icon.layer.shadowColor = [UIColor clearColor].CGColor;
//    }
    
    
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

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((collectionView.width-10) / 2, kGridCellHeight-10);
//}
@end


