//
//  GridCell.m
//  PregnancyHelper
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "AvatarGridCell.h"
#define kGridCellHeight   115
#define XHHTuanNumViewWidth 306
@interface AvatarGridCell()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic, strong)NSMutableArray *data;
@end
@implementation AvatarGridCell

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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, XHHTuanNumViewWidth, kGridCellHeight) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
        
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
    AvatarGridCell *cell = (AvatarGridCell *)[tabelView dequeueReusableCellWithIdentifier:@"AvatarGridCell"];
    if (!cell) {
        cell = [[AvatarGridCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AvatarGridCell"];
    }
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSArray*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    return (model.count%3==0?model.count/3:model.count/3+1)*kGridCellHeight;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
    _data = [NSMutableArray array];
    [_data addObjectsFromArray: model];
    
    //如果是GridCell的话，要同步collectionView高度
    [_collectionView setHeight:[AvatarGridCell cellHeightWithModel:model]];
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
    static NSString *gCollectionViewCell = @"gCollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:gCollectionViewCell forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    if (cell) {
        UIButton *icon = [[UIButton alloc]init];
        icon.userInteractionEnabled = NO;
        icon.tag = 8000;
        [icon setBackgroundColor:kClearColor];
        [cell.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.center.mas_equalTo(cell.contentView);
        }];
        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        icon.titleLabel.font = kFontSize(12);
        [icon setTitleColor:RGBSAMECOLOR(91) forState:0];
        [icon setBackgroundImage:[UIImage new] forState:0];
    }
    
    NSDictionary *fourPalaceData = [_data objectAtIndex:indexPath.row];
    
    UIButton *icon=(UIButton *)[cell.contentView viewWithTag:8000];
//    [icon setContentMode:UIViewContentModeScaleAspectFill];
//    [icon setClipsToBounds:YES];
//    [icon setImageWithURL:URLFromString(@"icon") placeholderImage:kSQUARE_PLACEDHOLDER_IMG options:SDWebImageRetryFailed];
    [icon setImage:fourPalaceData.allValues[0] forState:0];
    [icon.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    [icon setTitle:fourPalaceData[kArr] forState:0];
    [icon layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:30];
//    [icon setBackgroundImage:[UIImage new] forState:0];
    
    if (_selectedIndexPath) {
        if (_selectedIndexPath == indexPath) {
            [icon setTitleColor:[UIColor redColor] forState:0];
            icon.layer.shadowColor = [UIColor blackColor].CGColor;
        }else{
            [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
            icon.layer.shadowColor = [UIColor clearColor].CGColor;
        }
    }else{
        if (cell.tag == 0) {
            [icon setTitleColor:[UIColor redColor] forState:0];
            icon.layer.shadowColor = [UIColor blackColor].CGColor;
            
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

    if (_selectedIndexPath) {
        
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:_selectedIndexPath];
        
        UIButton* icon = [cell.contentView viewWithTag:8000];
        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
        icon.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton* icon = [cell.contentView viewWithTag:8000];
    [icon setTitleColor:[UIColor redColor] forState:0];
    icon.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (indexPath.row !=0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        UIButton* icon = [cell.contentView viewWithTag:8000];
        [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
        icon.layer.shadowColor = [UIColor clearColor].CGColor;
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
    return CGSizeMake(collectionView.width / 3, kGridCellHeight);
}
@end


