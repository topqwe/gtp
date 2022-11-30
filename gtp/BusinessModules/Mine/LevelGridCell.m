//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "LevelGridCell.h"
#define kGridCellHeight   102

@interface LevelGridCell()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic, strong)NSMutableArray *data;
@property (nonatomic, assign)NSInteger requestParams;
@end
@implementation LevelGridCell

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
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置cell行、列的间距
        [layout setMinimumLineSpacing:0];//row5 -10
        [layout setMinimumInteritemSpacing:0];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, kGridCellHeight) collectionViewLayout:layout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
        
        [_collectionView setBackgroundColor:kWhiteColor];
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
    LevelGridCell *cell = (LevelGridCell *)[tabelView dequeueReusableCellWithIdentifier:@"LevelGridCell"];
    if (!cell) {
        cell = [[LevelGridCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LevelGridCell"];
    }
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSArray*)model requestParams:(NSInteger)requestParams{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    return requestParams ==0? (model.count%4==0?model.count/4:model.count/4+1)*kGridCellHeight:
    (model.count%3==0?model.count/3:model.count/3+1)*kGridCellHeight;
}

- (void)richElementsInCellWithModel:(NSArray*)model requestParams:(NSInteger)requestParams{
    _requestParams = requestParams;
    _data = [NSMutableArray array];
    [_data addObjectsFromArray: model];
    
    //如果是GridCell的话，要同步collectionView高度
    [_collectionView setHeight:[LevelGridCell cellHeightWithModel:model requestParams:requestParams]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView reloadData];
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
//    static NSString *gCollectionViewCell = @"gCollectionViewCell";
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:gCollectionViewCell forIndexPath:indexPath];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]; //出列可重用的cell
    cell.tag = indexPath.row;
    
    if (cell) {
        UIButton *icon = [[UIButton alloc]init];
        icon.userInteractionEnabled = NO;
        icon.tag = 8000;
        [icon setBackgroundColor:kClearColor];
        [cell.contentView addSubview:icon];
        
        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [icon setBackgroundImage:[UIImage new] forState:0];
    }
    
    HomeItem *fourPalaceData = [_data objectAtIndex:indexPath.row];
    
    UIButton *icon=(UIButton *)[cell.contentView viewWithTag:8000];
//    [icon setContentMode:UIViewContentModeScaleAspectFill];
//    [icon setClipsToBounds:YES];
//    [icon setImageWithURL:URLFromString(@"icon") placeholderImage:kSQUARE_PLACEDHOLDER_IMG options:SDWebImageRetryFailed];
    
    
    if (self.requestParams == 0) {
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.center.mas_equalTo(cell.contentView);
            
        }];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"topup_icon%li",(long)fourPalaceData.icon]] forState:0];
        [icon.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        icon.titleLabel.font = kFontSize(12);
        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
        [icon setTitle:fourPalaceData.name forState:0];
        [icon layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:30];
    }else{
        [cell layoutIfNeeded];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(10);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
            make.center.mas_equalTo(cell.contentView);
            make.width.height.mas_equalTo(cell.contentView.bounds.size.height-20);
        }];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = cell.contentView.bounds.size.height/2-10;
        icon.backgroundColor = HEXCOLOR(0xECECEC);
        icon.titleLabel.font = kFontSize(25);
//        [icon setTitleColor:HEXCOLOR(0x000000) forState:0];
        [icon setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.money] forState:0];
    }
    
//    [icon setBackgroundImage:[UIImage new] forState:0];
    
    if (self.requestParams == 1) {
    if (_selectedIndexPath) {
        if (_selectedIndexPath == indexPath) {
            icon.layer.borderWidth = 2;
            icon.layer.borderColor = YBGeneralColor.themeColor.CGColor;
            [icon setTitleColor:kBlackColor forState:0];
            icon.layer.shadowColor = [UIColor clearColor].CGColor;
        }else{
            icon.layer.borderWidth = 2;
            icon.layer.borderColor = kClearColor.CGColor;
            [icon setTitleColor:HEXCOLOR(0x8EAEB6) forState:0];
            icon.layer.shadowColor = [UIColor clearColor].CGColor;
        }
    }else{
        if (cell.tag == 0) {
            icon.layer.borderWidth = 2;
            icon.layer.borderColor = YBGeneralColor.themeColor.CGColor;
            [icon setTitleColor:kBlackColor forState:0];
            icon.layer.shadowColor = [UIColor clearColor].CGColor;
            
        }else{
            icon.layer.borderWidth = 2;
            icon.layer.borderColor = kClearColor.CGColor;
            [icon setTitleColor:HEXCOLOR(0x8EAEB6) forState:0];
            icon.layer.shadowColor = [UIColor clearColor].CGColor;
        }
    }
    }
    
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
    if (self.requestParams == 1) {
    if (_selectedIndexPath) {
        
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:_selectedIndexPath];
        
        UIButton* icon = [cell.contentView viewWithTag:8000];
        icon.layer.borderWidth = 2;
        icon.layer.borderColor = kClearColor.CGColor;
        [icon setTitleColor:HEXCOLOR(0x8EAEB6) forState:0];
        icon.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton* icon = [cell.contentView viewWithTag:8000];
    icon.layer.borderWidth = 2;
    icon.layer.borderColor = YBGeneralColor.themeColor.CGColor;
    [icon setTitleColor:kBlackColor forState:0];
    icon.layer.shadowColor = [UIColor clearColor].CGColor;
    
    
    if (indexPath.row !=0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        UIButton* icon = [cell.contentView viewWithTag:8000];
        icon.layer.borderWidth = 2;
        icon.layer.borderColor = kClearColor.CGColor;
        [icon setTitleColor:HEXCOLOR(0x8EAEB6) forState:0];
        icon.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    }
    
    
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.requestParams == 0 ?
    CGSizeMake(collectionView.width / 4, kGridCellHeight):
    CGSizeMake(collectionView.width / 3, kGridCellHeight);
}
@end


