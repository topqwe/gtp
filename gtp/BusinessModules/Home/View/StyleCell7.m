//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "StyleCell7.h"
#define kSectionHBtnHeight 200
//(MAINSCREEN_WIDTH - 2*10)*(132/68)
#define kGridCellHeight   142
@interface StyleCell7()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic, strong)NSMutableArray *data;

@property (strong,nonatomic)UIButton *sectionHBtn;
@property (strong,nonatomic)UIButton * titBut;
@property (strong,nonatomic)HomeItem* item;
@property(nonatomic, strong)UIImageView* imgBg;
@end
@implementation StyleCell7
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
//        if(_collectionView)
//        {
//            [_collectionView removeFromSuperview];
//            _collectionView = nil;
//        }
//
        UIImageView* imgBg = [UIImageView new];
        [self.contentView addSubview:imgBg];
//        imgBg.backgroundColor = UIColor.clearColor;
        self.imgBg = imgBg;
        [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.bottom.mas_equalTo(0);
                     make.left.mas_equalTo(0);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(MAINSCREEN_WIDTH);
            make.height.mas_equalTo(33);
    //        make.height.mas_equalTo(self.width).multipliedBy(142/83);
                 }];
 //       imgBg.backgroundColor = UIColor.redColor;
 //       [imgBg setContentMode:UIViewContentModeScaleAspectFill];
 //       [imgBg setClipsToBounds:YES];
        
        UIView* view = [UIView new];
        view.frame = CGRectMake(10,  0,MAINSCREEN_WIDTH - 2*10,kSectionHBtnHeight);
        
        [self.contentView addSubview:view];
        
         
         UIButton *sectionHBtn = [[UIButton alloc]init];
         self.sectionHBtn = sectionHBtn;
         sectionHBtn.userInteractionEnabled = true;
         sectionHBtn.adjustsImageWhenHighlighted = NO;
         sectionHBtn.tag = 9000;
//         [sectionHBtn setBackgroundColor:kClearColor];
         [self.contentView addSubview:sectionHBtn];
         [sectionHBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(0);
             make.left.mas_equalTo(10);
             make.centerX.mas_equalTo(self.contentView);
             make.width.mas_equalTo(MAINSCREEN_WIDTH - 2*10);
             make.height.mas_equalTo(kSectionHBtnHeight-0.5);
         }];
         sectionHBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
         sectionHBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
         sectionHBtn.titleLabel.numberOfLines = 1;
         sectionHBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [view setCornerRadius:10 withShadow:YES withShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
//        [UIView putView:view andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
        sectionHBtn.layer.cornerRadius = 10;
        sectionHBtn.layer.masksToBounds = true;
        
        UIButton *levBut = [[UIButton alloc]init];
        levBut.userInteractionEnabled = NO;
        levBut.tag = 8002;
//        [levBut setBackgroundColor:kClearColor];
        [sectionHBtn addSubview:levBut];
        [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(30);
        }];
        levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        levBut.titleLabel.font = kFontSize(10);
        [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton *timeBut = [[UIButton alloc]init];
        timeBut.userInteractionEnabled = NO;
        timeBut.tag = 8003;
        [sectionHBtn addSubview:timeBut];
        [timeBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(sectionHBtn.mas_bottom).offset(-7);
            make.right.mas_equalTo(sectionHBtn.mas_right).offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
//            make.width.mas_equalTo(MAINSCREEN_WIDTH/3);
//            make.centerX.mas_equalTo(cell.contentView);
        }];
        timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        timeBut.titleLabel.font = kFontSize(11);
        [timeBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        
        timeBut.layer.masksToBounds = true;
        timeBut.layer.cornerRadius = 15/2;
        timeBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        UIButton *viewsBut = [[UIButton alloc]init];
        viewsBut.userInteractionEnabled = NO;
        viewsBut.tag = 8004;
        [sectionHBtn addSubview:viewsBut];
        [viewsBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(sectionHBtn.mas_bottom).offset(-7);
            make.left.mas_equalTo(sectionHBtn.mas_left).offset(10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
//            make.width.mas_equalTo(MAINSCREEN_WIDTH/3);
//            make.centerX.mas_equalTo(cell.contentView);
        }];
        viewsBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        viewsBut.titleLabel.font = kFontSize(11);
        [viewsBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        
        viewsBut.layer.masksToBounds = true;
        viewsBut.layer.cornerRadius = 15/2;
        viewsBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        
        
        UIButton *titBut = [[UIButton alloc]init];
        self.titBut = titBut;
        titBut.userInteractionEnabled = true;
        titBut.tag = 9001;
//        [titBut setBackgroundColor:kClearColor];
        [self.contentView addSubview:titBut];
        [titBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sectionHBtn.mas_bottom).offset(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(MAINSCREEN_WIDTH - 2*10);
            make.height.mas_equalTo(20);
        }];
        titBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        titBut.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        titBut.titleLabel.font = kFontSize(15);
        [titBut setTitleColor:HEXCOLOR(0x717171) forState:0];
        titBut.titleLabel.numberOfLines = 1;
        titBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
       
       
//        [self.contentView layoutIfNeeded];
//        [sectionHBtn layoutIfNeeded];
//CGRectGetMaxY(self.titBut.frame)+10
        self.vBgV = [[UIButton alloc]init];
//        self.vBgV.userInteractionEnabled = NO;
        self.vBgV.tag = 8005;
        [self.vBgV setBackgroundColor:kClearColor];
        [self.contentView addSubview:self.vBgV];
        [self.vBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.sectionHBtn);
        }];
        self.vBgV.contentMode = UIViewContentModeScaleAspectFill;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
            longPress.minimumPressDuration = .2;
        [self.vBgV addGestureRecognizer:longPress];
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//水平2选Vertical
        layout.itemSize = CGSizeMake((MAINSCREEN_WIDTH-30) / 2, kGridCellHeight-10);
        //设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //设置cell行、列的间距
        [layout setMinimumLineSpacing:10];//row5 -10
        [layout setMinimumInteritemSpacing:5];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,(kSectionHBtnHeight-0.5)+40, MAINSCREEN_WIDTH-0, kGridCellHeight) collectionViewLayout:layout];
        
        [_collectionView registerClass:[SColCell class] forCellWithReuseIdentifier:@"SColCell"];
        [_collectionView setBackgroundColor:kClearColor];
        //如果row = 5
//        _collectionView.scrollEnabled = NO;
//        _collectionView.alwaysBounceHorizontal = YES;
//        _collectionView.showsHorizontalScrollIndicator = YES;
//        _collectionView.contentSize = CGSizeMake(_collectionView.width*5 / 4, 0);
        
        [self.contentView addSubview:_collectionView];
        
    }
    return self;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    StyleCell7 *cell = (StyleCell7 *)[tabelView dequeueReusableCellWithIdentifier:@"StyleCell7"];
    if (!cell) {
        cell = [[StyleCell7 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StyleCell7"];
    }
    return cell;
}

// 判断点击的point是否在cell的Button之上
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL isInside = [super pointInside:point withEvent:event];
    for (UIView *subView in self.subviews.reverseObjectEnumerator) {
        // 获取Cell中的ContentView
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
            for (UIView *sSubView in subView.subviews.reverseObjectEnumerator) {
                // 获取ContentView中的Button子视图
                if ([sSubView isKindOfClass:[UIButton class]]) {
                    // point是否在子视图Button之上
                    BOOL isInSubBtnView = CGRectContainsPoint(sSubView.frame, point);
                    if (isInSubBtnView) {
                        return self.vBgV.userInteractionEnabled;
                    }
                }
            }
        }
    }
    return isInside;
}
+(CGFloat)cellHeightWithModel:(NSDictionary*)dic{
    NSArray* model =  dic.allValues[0];
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    NSMutableArray* data = [NSMutableArray array];
    
    NSArray* subArr = @[];
    if (model.count>1) {
        subArr = [model subarrayWithRange:NSMakeRange(1, model.count-1)];
        if (subArr>0) {
            [data addObjectsFromArray: subArr];
            return 0+kSectionHBtnHeight+10+20+10+ (data.count%2==0?data.count/2:data.count/2+1)*kGridCellHeight+5;
        }else{
            return 0.1;
        }
    }
    else if (model.count == 1){
        return 0.1;
//        subArr = [model mutableCopy];
    }
    else{
        return 0.1;
//        subArr = [model mutableCopy];
    }
    
}

- (void)richElementsInCellWithModel:(NSDictionary*)dic{
    NSArray* model =  dic.allValues[0];
    _data = [NSMutableArray array];
    
    NSArray* subArr = @[];
    if (model.count>1) {
        subArr = [model subarrayWithRange:NSMakeRange(1, model.count-1)];
        if (subArr>0) {
            [_data addObjectsFromArray:subArr];
        }else{
            return;
        }
    }
    else if (model.count == 1){
        return;
    }
    else{
        return;
//        subArr = [model mutableCopy];
    }
    
    
    
    
    
    self.imgBg.image = nil;
    NSString* bgStr = [NSString stringWithFormat:@"%@",@"M_StyleScCell1Bg"];
//    [self.imgBg sd_setImageWithURL:[NSURL URLWithString:bgStr]];
    self.imgBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",bgStr]];
    
    HomeItem* fourPalaceData  = model.firstObject;
    self.item = fourPalaceData;
    [self.sectionHBtn sd_setImageWithURL:[NSURL URLWithString:fourPalaceData.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [UIView putView:self.sectionHBtn andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
    }];
    [self.sectionHBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    [UIView addShadowToView:self.sectionHBtn withOpacity:0.3 shadowRadius:3 andCornerRadius:10];
//    [UIView putView:self.sectionHBtn andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
    UIButton *levBut=(UIButton *)[self.sectionHBtn viewWithTag:8002];
    
    if ([fourPalaceData getLevImg]!=nil) {
        if (fourPalaceData.restricted == 2) {
            [levBut setTitle:[NSString stringWithFormat:@"    %@",fourPalaceData.gold] forState:0];
            
        }else{
            [levBut setTitle:[NSString stringWithFormat:@"%@",@""] forState:0];
        }
        [levBut setBackgroundImage:[fourPalaceData getLevImg] forState:0];
    }else{
        [levBut setBackgroundImage:nil forState:0];
        [levBut setTitle:[NSString stringWithFormat:@"%@",@""] forState:0];
    }

    
    UIButton *timeBut=(UIButton *)[self.sectionHBtn viewWithTag:8003];
    [timeBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.duration] forState:0];
    [timeBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    
    UIButton *viewsBut=(UIButton *)[self.sectionHBtn viewWithTag:8004];
    [viewsBut setImage:kIMG(@"m_eye") forState:0];
    [viewsBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.views] forState:0];
    [viewsBut layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
    
    [viewsBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    
    
    [self.titBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.name] forState:0];
    [self.sectionHBtn addTarget:self action:@selector(refreshTopic) forControlEvents:UIControlEventTouchUpInside];
//    for(UIView *mylabelview in [self.sectionHBtn subviews])
//    {
//        if ([mylabelview isEqual:_player]) {
//            [mylabelview removeFromSuperview];
//        }
//    }
    [self.vBgV removeAllSubviews];
    [self.vBgV addTarget:self action:@selector(refreshTopic) forControlEvents:UIControlEventTouchUpInside];
    //多个tableView 需要收到数据后需要刷新CollectionView
    dispatch_async(dispatch_get_main_queue(), ^{
//        //如果是GridCell的话，要同步collectionView高度
//        [self.collectionView setHeight:[StyleCell7 cellHeightWithModel:dic] -
//         (0+kSectionHBtnHeight+10+20+10)];
//        [self.collectionView reloadData];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView setHeight:[[self class] cellHeightWithModel:dic] -
         (0+kSectionHBtnHeight+10+20+10)];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView reloadData];
        });
      
    
}

- (void)refreshTopic {
    if (self.block) {
        self.block(self.item);
    }
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
    [cell richElementsInCellWithModel:fourPalaceData];
    [cell.vBgV removeAllSubviews];
    [cell hideHorLabShowTitBut:true];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = .2;
    [cell addGestureRecognizer:longPress];
    return cell;
}
//- (void)funAdsButtonClickItem:(UITapGestureRecognizer*)btn{
//    if (self.block) {
//        self.block(@(btn.view.tag));
//    }
//    [self disMissView];
//}

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
       
        if ([gestureRecognizer.view isEqual:self.vBgV]) {
            [self.vBgV removeAllSubviews];
            [gestureRecognizer.view addSubview:[self setupBgVideoPlayer:self.item isCell:NO]];
            UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
            [self.vBgV addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(refreshTopic)];
            UIButton *vBgV = [[UIButton alloc]init];
            vBgV.tag = 8007;
            [vBgV setBackgroundColor:UIColor.clearColor];
            [vBgV addTarget:self action:@selector(refreshTopic) forControlEvents:UIControlEventTouchUpInside];
            [self.player addSubview:vBgV];
            [vBgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.player);
            }];
            vBgV.contentMode = UIViewContentModeScaleAspectFill;
        }else{
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
    [cell.vBgV addSubview:[self setupBgVideoPlayer:fourPalaceData isCell:YES]];
    [cell hideHorLabShowTitBut:false];
}
- (SelVideoPlayer*)setupBgVideoPlayer:(HomeItem*)item isCell:(BOOL)isCell
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
    if (isCell) {
        _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, (MAINSCREEN_WIDTH-30) / 2, kGridCellHeight-10-30) configuration:configuration];
    }else{
        _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, (MAINSCREEN_WIDTH-20) / 1, kSectionHBtnHeight) configuration:configuration];
    }
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

@end


