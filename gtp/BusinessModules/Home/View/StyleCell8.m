//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "StyleCell8.h"

#define kGridCellHeight   50*3
#define kTopMargin  50
#define bottomMargin  60
static NSString *headerViewIdentifier = @"hederview";
@interface StyleCell8()

@property (nonatomic, strong) SelVideoPlayer *bgPlayer;

@property(nonatomic,strong)NSURL *movieURL;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic)UIButton *sectionHBtn;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property (nonatomic, strong)HomeItem* selectedData;
@property(nonatomic, strong)NSMutableArray *data;
@property(nonatomic, strong)UIImageView* imgBg ;
@property(nonatomic, strong) UIView* vBgV;
@property(nonatomic, copy)NSArray *infos;
@end
static CGFloat const kLRPadding            = 8;
static CGFloat const kTBPadding            = 5;
@implementation StyleCell8
- (void)setupBigBgVideoPlayer:(HomeItem*)item
{
    
    
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = NO;
    configuration.shouldAutorotate = NO;
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateNever;
    configuration.muted = YES;
    configuration.isHideProgress = YES;
    if (item) {
    configuration.sourceUrl = [NSURL URLWithString:item.preview_hls_url];
    configuration.videoGravity =
//    SelVideoGravityResize;
//    SelVideoGravityResizeAspect;
    SelVideoGravityResizeAspectFill;
    }else{
//        configuration.sourceUrl = [NSURL URLWithString:item.preview_hls_url];
        configuration.assetSource =
        [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"local" ofType:@"mp4"]];
        
        configuration.videoGravity =
        SelVideoGravityResize;
    //    SelVideoGravityResizeAspect;
//        SelVideoGravityResizeAspectFill;
    }
    _bgPlayer = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, [[self class]cellHeightWithModel]) configuration:configuration];
    [self.vBgV addSubview:_bgPlayer];
    
}
//- (void)applicationDidBecomeActive:(NSNotification *)notification {
//
//    if (_bgPlayer == nil) {
//        [self setupBgVideoPlayer];
//    }
//    [_bgPlayer _playVideo];
//    [_player _playVideo];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //监听程序进入前台
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationDidBecomeActive:)
//                                                     name:UIApplicationDidBecomeActiveNotification
//                                                   object:nil];
       
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        
       UIImageView* imgBg = [UIImageView new];
       [self.contentView addSubview:imgBg];
       self.imgBg = imgBg;
       [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
           make.height.mas_equalTo([[self class]cellHeightWithModel]);
           make.center.mas_equalTo(self.contentView);
                }];
//       imgBg.backgroundColor = UIColor.redColor;
//       [imgBg setContentMode:UIViewContentModeScaleAspectFill];
//       [imgBg setClipsToBounds:YES];
        UIView* vBgV = [UIView new];
        vBgV.backgroundColor = kClearColor;
        [self.contentView addSubview:vBgV];
        self.vBgV = vBgV;
        self.vBgV.userInteractionEnabled = NO;
        self.vBgV.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, [[self class]cellHeightWithModel]);
//        [self setupBgVideoPlayer];
//        [vBgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                     make.top.mas_equalTo(0);
//                     make.left.mas_equalTo(0);
//            make.height.mas_equalTo([[self class]cellHeightWithModel]);
//            make.center.mas_equalTo(self.contentView);
//                 }];
        
        UIButton *sectionHBtn = [[UIButton alloc]init];
        self.sectionHBtn = sectionHBtn;
        sectionHBtn.userInteractionEnabled = true;
        sectionHBtn.adjustsImageWhenHighlighted = NO;
        sectionHBtn.tag = 9000;
        [sectionHBtn setBackgroundColor:kClearColor];
        [self.contentView addSubview:sectionHBtn];
        [sectionHBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10*3-(kGridCellHeight+bottomMargin));
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(20*3);
        }];
        sectionHBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        sectionHBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        sectionHBtn.titleLabel.numberOfLines = 0;
        sectionHBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self richEles];
        
    }
    return self;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
- (void)richEles{
    if(_collectionView)
    {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
//        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _flowLayout = layout;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [[self class]cellHeightWithModel]-(kGridCellHeight+bottomMargin), MAINSCREEN_WIDTH, (kGridCellHeight+bottomMargin)) collectionViewLayout:self.flowLayout];
    //设置第一个cell和最后一个cell,与父控件之间的间距
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //设置cell行、列的间距
    [self.flowLayout setMinimumLineSpacing:10];//row5 -10
//        [self.flowLayout setMinimumInteritemSpacing:10];
    [_collectionView registerClass:[SColCell class] forCellWithReuseIdentifier:@"SColCell"];
    
    [_collectionView setBackgroundColor:UIColor.clearColor];
    //如果row = 5
    _collectionView.scrollEnabled = YES;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:_collectionView];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    StyleCell8 *cell = (StyleCell8 *)[tabelView dequeueReusableCellWithIdentifier:@"StyleCell8"];
    if (!cell) {
        cell = [[StyleCell8 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StyleCell8"];
    }
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSArray*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    return (model.count%4==0?model.count/4:model.count/4+1)*kGridCellHeight;
}

+(CGFloat)cellHeightWithModel{
    return kGETVALUE_HEIGHT(856, 1036, MAINSCREEN_WIDTH);
    //kTopMargin*3+20*3+10*3+50*3+30*3+bottomMargin;//= 222*3
}
 
- (void)richElementsInCellWithModel:(NSDictionary*)model withInfo:(NSArray*)infos{
    
    self.infos = infos;
    
    _data = [NSMutableArray array];
    [_data addObjectsFromArray:model.allValues[0]];
//    if (_data.count==0||_data.count==1) {
//        return;
//    }
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    
    
    self.imgBg.image = nil;
    NSString* bgStr = [NSString stringWithFormat:@"%@",infos[2]];
//    [self.imgBg sd_setImageWithURL:[NSURL URLWithString:bgStr]];
    if ([bgStr integerValue]>0) {
        self.imgBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"styleCell4_loc%@",bgStr]];
        [self.imgBg setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    
//    NSURL *url =
//    [NSURL URLWithString:@"http://data.vod.itc.cn/?rb=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/96/78/5AS9saYdoeJZUuUML8XozJ.mp4"];
//    [self.vBgV jp_playVideoMuteWithURL:url bufferingIndicator:nil progressView:nil configuration:nil];
    if (_bgPlayer == nil) {
//        [self setupBigBgVideoPlayer:nil];
        int r = arc4random() % [_data count];
        [self setupBigBgVideoPlayer:_data[r]];
    }
    [_bgPlayer _playVideo];
    
    
    [_sectionHBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@  ",infos.firstObject] stringColor:UIColor.whiteColor stringFont:[UIFont boldSystemFontOfSize:18] attachImage:kIMG(@"M_≥") subString:[NSString stringWithFormat:@"\n\n%@",infos.lastObject] subStringColor:UIColor.whiteColor subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentLeft] forState:0];
    
    [_sectionHBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _flowLayout.itemSize = CGSizeMake(85*3, (kGridCellHeight+bottomMargin)-50);
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果是GridCell的话，要同步collectionView高度
//        [self.collectionView setHeight:
//
//         [[self class] cellHeightWithModel:_data]
//
//        ];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView reloadData];
    });
    
//    [self.contentView layoutIfNeeded];
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
    cell.style = IndexSectionUIStyleEight;
    [cell richElementsInCellWithModel:fourPalaceData];
    
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = .2;
        [cell addGestureRecognizer:longPress];
    return cell;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer{
  
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
       
        CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];//点击cell的
        self.selectedIndexPath = indexPath;
        //在此添加你想要完成的功能
        if (@available(iOS 10.0, *)) {
            [self.collectionView setPrefetchingEnabled:NO];
        } else {
            // Fallback on earlier versions
        }
        [self basedOnIndexPath:indexPath];
    }
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //cell除collectionView以外还有其他UIView的情况： 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.contentView convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pInView];
    self.selectedIndexPath = indexPath;
    //整个cell就一个collectionView的情况：用这种方式
//    NSIndexPath * indexPath = [_collectionView  indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + 85*3, scrollView.contentOffset.y)];
    [self basedOnIndexPath:indexPath];
}
- (void)basedOnIndexPath:(NSIndexPath*)indexPath{
    HomeItem *fourPalaceData = [self.data objectAtIndexVerify:indexPath.row];
    SColCell * cell = (SColCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    [cell.vBgV addSubview:[self setupBgVideoPlayer:fourPalaceData]];
    [cell hideHorLabShowTitBut:false];
    [self setupBigBgVideoPlayer:fourPalaceData];
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
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, 85*3, (kGridCellHeight+bottomMargin)-50-30) configuration:configuration];
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
//
//
//    if (indexPath.row !=0) {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//
//        UIButton* icon = [cell.contentView viewWithTag:8000];
//        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
//        icon.layer.shadowColor = [UIColor clearColor].CGColor;
//    }
    
    
//    _selectedIndexPath = indexPath;
    if (self.block) {
        self.block(object);
    }
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)refreshTopic:(UIButton*)sender {
    if (self.block) {
        self.block(self.infos);
    }

}

@end


