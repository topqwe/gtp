//
//  CenterSpinView.m
//  PLLL
//
//  Created by TNM on 7/06/2020.
//  Copyright © 2020 PLLL. All rights reserved.
//

#import "CenterSpinView.h"
@interface CVRotateCell : UICollectionViewCell
@property (strong, nonatomic) UIButton *titleLab;
@end

@implementation CVRotateCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self ==[super initWithFrame:frame]){
        UIButton *titleLab = [[UIButton alloc]init];
                titleLab.tag = 7003;
        [self.contentView addSubview:titleLab];
        
        titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [titleLab setBackgroundColor:UIColor.clearColor];
        [titleLab.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLab.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLab setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        titleLab.titleLabel.numberOfLines = 0;
        [titleLab setBackgroundImage:[UIImage imageNamed:@"rotateBtn"] forState:UIControlStateNormal];
        self.titleLab = titleLab;
    }
    return self;
}

- (void)richElementsInCellWithModel:(NSString*)model{
    [self.titleLab setTitle:[NSString stringWithFormat:@"%@",model] forState:UIControlStateNormal];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.titleLab.alpha = highlighted ? 0.75f : 1.0f;
    
}

@end

#define kGridCellHeight   (MAINSCREEN_HEIGHT - [YBFrameTool safeAdjustTabBarHeight] - [YBFrameTool safeAdjustNavigationBarHeight] -60)
@interface CenterSpinView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSMutableArray *originDatas;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) ActionBlock block;
@end
//static CGFloat const kPadding            = 20;
@implementation CenterSpinView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        if(_collectionView)
        {
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, [CenterSpinView cellHeightWithModel]) collectionViewLayout:layout];
                [_collectionView registerClass:[CVRotateCell class] forCellWithReuseIdentifier:@"rCollectionViewCell"];
                
            [_collectionView setBackgroundColor:UIColor.clearColor];
            _collectionView.userInteractionEnabled = true;
//            _collectionView.scrollEnabled = YES;
            [self addSubview:_collectionView];
        
    }
    return self;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];



    }
    return _flowLayout;
}
+(CGFloat)cellHeightWithModel{
    return kGridCellHeight;
}
- (void)richElementsInCellWithModel:(NSDictionary*)model{
    NSInteger x =  [model[kIndexRow]intValue];
//    NSInteger y =  [model[kIndexSection]intValue];
    _originDatas = [NSMutableArray arrayWithArray:model[kArr]];
    _data = [NSMutableArray arrayWithArray:model[kArr]];
   
    
    CGFloat bigCVPadding = 20;
    CGFloat  kPadding  = (MAINSCREEN_WIDTH-bigCVPadding*(x+2))/(x+1);
    
    
    [self.collectionView setWidth:x*bigCVPadding+(x+1)*kPadding];
    [self.collectionView setHeight:self.collectionView.frame.size.width];
//    [self.collectionView setX:20];
//    [self.collectionView setY:20];
//    
    
    self.flowLayout.minimumLineSpacing = kPadding;
    self.flowLayout.minimumInteritemSpacing = kPadding;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
    self.flowLayout.itemSize = CGSizeMake(bigCVPadding, bigCVPadding);
    
    _collectionView.collectionViewLayout = self.flowLayout;
    
    
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView reloadData];
    
}
#pragma mark --UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVRotateCell *cell = (CVRotateCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"rCollectionViewCell" forIndexPath:indexPath];
    cell.userInteractionEnabled = true;
    NSDictionary* dic = _data[indexPath.row];
    [cell richElementsInCellWithModel:[NSString stringWithFormat:@"%@",dic[kTit]]];
    cell.tag = [dic[kTit]intValue];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.titleLab.tag = [dic[kTit]intValue];
    cell.titleLab.userInteractionEnabled = NO;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _data[indexPath.row];
    if (self.block) {
        self.block(dic);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

@end


